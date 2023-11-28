import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_native_splash/cli_commands.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/features/kyc/kyc_service.dart';
import 'package:jetwallet/features/simple_card/store/simple_card_store.dart';
import 'package:jetwallet/features/wallet/ui/widgets/wallet_header.dart';
import 'package:jetwallet/utils/formatting/base/volume_format.dart';
import 'package:jetwallet/utils/helpers/check_kyc_status.dart';
import 'package:jetwallet/utils/helpers/non_indices_with_balance_from.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/modules/icons/24x24/public/bank_medium/bank_medium_icon.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';
import 'package:simple_networking/modules/signal_r/models/banking_profile_model.dart';
import 'package:simple_networking/modules/wallet_api/models/simple_card/simple_card_create_response.dart';

import '../../../../../core/services/user_info/user_info_service.dart';
import '../../../../simple_card/ui/widgets/card_options.dart';

class EurWalletBody extends StatefulObserverWidget {
  const EurWalletBody({
    super.key,
    required this.pageController,
    required this.pageCount,
    required this.indexNow,
  });

  final PageController pageController;
  final int pageCount;
  final int indexNow;

  @override
  State<EurWalletBody> createState() => _EurWalletBodyState();
}

class _EurWalletBodyState extends State<EurWalletBody> {
  final _controller = ScrollController();
  bool isTopPosition = true;

  @override
  void initState() {
    sAnalytics.eurWalletAccountScreen(
      (sSignalRModules.bankingProfileData?.banking?.accounts ?? <SimpleBankingAccount>[]).length,
    );
    final simpleCardStore = getIt.get<SimpleCardStore>();
    final userInfo = getIt.get<UserInfoService>();

    if (userInfo.isSimpleCardAvailable) {
      simpleCardStore.initStore();
    }
    _controller.addListener(() {
      if (_controller.position.pixels <= 0) {
        if (!isTopPosition) {
          setState(() {
            isTopPosition = true;
          });
        }
      } else {
        if (isTopPosition) {
          setState(() {
            isTopPosition = false;
          });
        }
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final eurCurrency = nonIndicesWithBalanceFrom(
      sSignalRModules.currenciesList,
    ).where((element) => element.symbol == 'EUR').first;

    final bankAccounts = sSignalRModules.bankingProfileData?.banking?.accounts ?? <SimpleBankingAccount>[];
    final simpleAccount = sSignalRModules.bankingProfileData?.simple?.account;

    final userInfo = getIt.get<UserInfoService>();
    final simpleCardStore = getIt.get<SimpleCardStore>();

    final kycState = getIt.get<KycService>();
    final kycBlocked = checkKycBlocked(
      kycState.depositStatus,
      kycState.tradeStatus,
      kycState.withdrawalStatus,
    );
    final anyBlock = sSignalRModules.clientDetail.clientBlockers.isNotEmpty;

    final isAddButtonDisabled = anyBlock || kycBlocked;

    return Column(
      children: [
        CollapsedWalletAppbar(
          scrollController: _controller,
          assetIcon: SNetworkSvg24(
            url: eurCurrency.iconUrl,
          ),
          ticker: eurCurrency.symbol,
          mainTitle: volumeFormat(
            decimal: sSignalRModules.totalEurWalletBalance,
            accuracy: eurCurrency.accuracy,
            symbol: eurCurrency.symbol,
          ),
          mainSubtitle: eurCurrency.volumeBaseBalance(sSignalRModules.baseCurrency),
          mainHeaderTitle: eurCurrency.symbol,
          mainHeaderSubtitle: intl.eur_wallet,
          mainHeaderCollapsedTitle: volumeFormat(
            decimal: sSignalRModules.totalEurWalletBalance,
            accuracy: eurCurrency.accuracy,
            symbol: eurCurrency.symbol,
          ),
          mainHeaderCollapsedSubtitle: eurCurrency.symbol,
          carouselItemsCount: widget.pageCount,
          carouselPageIndex: widget.indexNow,
        ),
        Expanded(
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            controller: _controller,
            slivers: [
              const SliverPadding(padding: EdgeInsets.only(top: 16)),
              SliverToBoxAdapter(
                child: STableHeader(
                  size: SHeaderSize.m,
                  title: intl.eur_wallet_cards,
                ),
              ),
              if (simpleCardStore.allCards == null ||
                  simpleCardStore.allCards!.isEmpty ||
                  !userInfo.isSimpleCardAvailable) ...[
                SliverToBoxAdapter(
                  child: SimpleTableAsset(
                    isCard: true,
                    hasRightValue: false,
                    label: intl.eur_wallet_simple_card,
                    supplement: !userInfo.isSimpleCardAvailable ? intl.eur_wallet_coming_soon : '',
                  ),
                ),
              ],
              if (userInfo.isSimpleCardAvailable) ...[
                for (final el in simpleCardStore.allCards ?? <CardDataModel>[])
                  SliverToBoxAdapter(
                    child: SCardRow(
                      maxWidth: MediaQuery.of(context).size.width * .35,
                      frozenIcon: (userInfo.isSimpleCardAvailable && el.status == AccountStatusCard.frozen)
                          ? const SFrozenIcon(
                              width: 16,
                              height: 16,
                            )
                          : null,
                      icon: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SpaceH6(),
                          if (el.status == AccountStatusCard.frozen)
                            const SFrozenCardIcon(
                              width: 24,
                              height: 16,
                            )
                          else
                            const SCardIcon(
                              width: 24,
                              height: 16,
                            ),
                        ],
                      ),
                      name: intl.eur_wallet_simple_card,
                      helper: el.status == AccountStatusCard.inCreation ? intl.creating : intl.simple_card_type_virtual,
                      onTap: () {
                        if (el.status == AccountStatusCard.active || el.status == AccountStatusCard.frozen) {
                          simpleCardStore.initFullCardIn(el.cardId ?? '');
                          sRouter.push(const SimpleCardRouter());
                        }
                      },
                      description: '',
                      amount: '',
                      needSpacer: true,
                      rightIcon: el.status == AccountStatusCard.active
                          ? Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              decoration: ShapeDecoration(
                                shape: RoundedRectangleBorder(
                                  side: const BorderSide(color: Color(0xFFF1F4F8)),
                                  borderRadius: BorderRadius.circular(22),
                                ),
                              ),
                              child: Text(
                                volumeFormat(
                                  decimal: simpleCardStore.card?.balance ?? Decimal.zero,
                                  accuracy: eurCurrency.accuracy,
                                  symbol: eurCurrency.symbol,
                                ),
                                style: sSubtitle1Style.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            )
                          : null,
                    ),
                  ),
              ],
              if (userInfo.isSimpleCardAvailable &&
                  (simpleCardStore.allCards == null ||
                      simpleCardStore.allCards!.isEmpty ||
                      simpleCardStore.allCards![0].status == AccountStatusCard.inCreation)) ...[
                SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SpaceH8(),
                      SPaddingH24(
                        child: Padding(
                          padding: const EdgeInsets.only(
                            left: 36,
                          ),
                          child: SIconTextButton(
                            onTap: () {
                              if (simpleCardStore.allCards == null || simpleCardStore.allCards!.isEmpty) {
                                showCardOptions(context);
                              }
                            },
                            text: intl.simple_card_get_card.capitalize(),
                            textStyle: sTextButtonStyle.copyWith(
                              color: simpleCardStore.allCards != null &&
                                      simpleCardStore.allCards!.isNotEmpty &&
                                      simpleCardStore.allCards![0].status == AccountStatusCard.inCreation
                                  ? sKit.colors.grey2
                                  : sKit.colors.blue,
                            ),
                            icon: SActionDepositIcon(
                              color: simpleCardStore.allCards != null &&
                                      simpleCardStore.allCards!.isNotEmpty &&
                                      simpleCardStore.allCards![0].status == AccountStatusCard.inCreation
                                  ? sKit.colors.grey2
                                  : sKit.colors.blue,
                            ),
                            disabled: simpleCardStore.allCards != null &&
                                simpleCardStore.allCards!.isNotEmpty &&
                                simpleCardStore.allCards![0].status == AccountStatusCard.inCreation,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              SliverToBoxAdapter(
                child: STableHeader(
                  size: SHeaderSize.m,
                  title: intl.eur_wallet_accounts,
                ),
              ),
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (simpleAccount != null)
                      SimpleTableAsset(
                        isCard: false,
                        onTableAssetTap: () {
                          sRouter
                              .push(
                                CJAccountRouter(
                                  bankingAccount: simpleAccount,
                                  isCJAccount: true,
                                ),
                              )
                              .then(
                                (value) => sAnalytics.eurWalletTapBackOnAccountWalletScreen(
                                  isCJ: true,
                                  eurAccountLabel: simpleAccount.label ?? '',
                                  isHasTransaction: false,
                                ),
                              );
                        },
                        assetIcon: const BlueBankIcon(),
                        label: simpleAccount!.label ?? 'Account 1',
                        supplement: simpleAccount.status == AccountStatus.active
                            ? intl.eur_wallet_simple_account
                            : intl.create_simple_creating,
                        hasRightValue: simpleAccount.status == AccountStatus.active,
                        rightValue: volumeFormat(
                          decimal: simpleAccount.balance ?? Decimal.zero,
                          accuracy: eurCurrency.accuracy,
                          symbol: eurCurrency.symbol,
                        ),
                      ),
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: bankAccounts.length,
                      padding: EdgeInsets.zero,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return SimpleTableAsset(
                          onTableAssetTap: () {
                            if (bankAccounts[index].status == AccountStatus.active) {
                              sRouter
                                  .push(
                                    CJAccountRouter(
                                      bankingAccount: bankAccounts[index],
                                      isCJAccount: false,
                                    ),
                                  )
                                  .then(
                                    (value) => sAnalytics.eurWalletTapBackOnAccountWalletScreen(
                                      isCJ: false,
                                      eurAccountLabel: bankAccounts[index].label ?? '',
                                      isHasTransaction: false,
                                    ),
                                  );
                            }
                          },
                          assetIcon: const BlueBankIcon(),
                          label: bankAccounts[index].label ?? 'Account',
                          supplement: bankAccounts[index].status == AccountStatus.active
                              ? intl.eur_wallet_personal_account
                              : intl.create_personal_creating,
                          hasRightValue: bankAccounts[index].status == AccountStatus.active,
                          rightValue: volumeFormat(
                            decimal: bankAccounts[index].balance ?? Decimal.zero,
                            accuracy: eurCurrency.accuracy,
                            symbol: eurCurrency.symbol,
                          ),
                          isCard: false,
                        );
                      },
                    ),
                    if (bankAccounts.isEmpty)
                      SPaddingH24(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: SIconTextButton(
                            onTap: () {
                              if (isAddButtonDisabled) return;
                              if (bankAccounts.length > 1) return;

                              sAnalytics.eurWalletAddAccountEur();
                              sAnalytics.eurWalletPersonalEURAccount();

                              sRouter
                                  .push(const CreateBankingRoute())
                                  .then((value) => sAnalytics.eurWalletBackOnPersonalAccount());
                            },
                            text: intl.eur_wallet_add_account,
                            textStyle: sTextButtonStyle.copyWith(
                              color: isAddButtonDisabled
                                  ? sKit.colors.grey2
                                  : bankAccounts.length > 1
                                      ? sKit.colors.grey2
                                      : sKit.colors.blue,
                            ),
                            icon: SPlusIcon(
                              color: isAddButtonDisabled
                                  ? sKit.colors.grey2
                                  : bankAccounts.length > 1
                                      ? sKit.colors.grey2
                                      : sKit.colors.blue,
                            ),
                          ),
                        ),
                      ),
                    const SpaceH30(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );

    return Stack(
      children: [
        CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          controller: _controller,
          slivers: [
            SliverAppBar(
              expandedHeight: 226,
              collapsedHeight: 64,
              pinned: true,
              stretch: true,
              backgroundColor: sKit.colors.white,
              elevation: 0.0,
              automaticallyImplyLeading: false,
              leadingWidth: 48,
              centerTitle: true,
              flexibleSpace: WalletHeader(
                curr: eurCurrency,
                pageController: widget.pageController,
                pageCount: widget.pageCount,
                isEurWallet: true,
              ),
            ),
            const SliverPadding(padding: EdgeInsets.only(top: 24)),
            SliverToBoxAdapter(
              child: SPaddingH24(
                child: Text(
                  intl.eur_wallet_cards,
                  style: sTextH4Style,
                ),
              ),
            ),
            if (simpleCardStore.allCards == null ||
                simpleCardStore.allCards!.isEmpty ||
                !userInfo.isSimpleCardAvailable) ...[
              const SliverPadding(padding: EdgeInsets.only(top: 7)),
              SliverToBoxAdapter(
                child: SCardRow(
                  maxWidth: MediaQuery.of(context).size.width * .35,
                  icon: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SpaceH6(),
                      SizedBox(
                        width: 24,
                        height: 16,
                        child: SCardIcon(
                          width: 24,
                          height: 16,
                        ),
                      ),
                    ],
                  ),
                  name: intl.eur_wallet_simple_card,
                  helper: !userInfo.isSimpleCardAvailable ? intl.eur_wallet_coming_soon : '',
                  onTap: () {},
                  description: '',
                  amount: '',
                  needSpacer: true,
                ),
              ),
            ],
            if (userInfo.isSimpleCardAvailable) ...[
              for (final el in simpleCardStore.allCards ?? <CardDataModel>[])
                SliverToBoxAdapter(
                  child: SCardRow(
                    maxWidth: MediaQuery.of(context).size.width * .35,
                    frozenIcon: (userInfo.isSimpleCardAvailable && el.status == AccountStatusCard.frozen)
                        ? const SFrozenIcon(
                            width: 16,
                            height: 16,
                          )
                        : null,
                    icon: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SpaceH6(),
                        if (el.status == AccountStatusCard.frozen)
                          const SFrozenCardIcon(
                            width: 24,
                            height: 16,
                          )
                        else
                          const SCardIcon(
                            width: 24,
                            height: 16,
                          ),
                      ],
                    ),
                    name: intl.eur_wallet_simple_card,
                    helper: el.status == AccountStatusCard.inCreation ? intl.creating : intl.simple_card_type_virtual,
                    onTap: () {
                      if (el.status == AccountStatusCard.active || el.status == AccountStatusCard.frozen) {
                        simpleCardStore.initFullCardIn(el.cardId ?? '');
                        sRouter.push(const SimpleCardRouter());
                      }
                    },
                    description: '',
                    amount: '',
                    needSpacer: true,
                    rightIcon: el.status == AccountStatusCard.active
                        ? Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            decoration: ShapeDecoration(
                              shape: RoundedRectangleBorder(
                                side: const BorderSide(color: Color(0xFFF1F4F8)),
                                borderRadius: BorderRadius.circular(22),
                              ),
                            ),
                            child: Text(
                              volumeFormat(
                                decimal: simpleCardStore.card?.balance ?? Decimal.zero,
                                accuracy: eurCurrency.accuracy,
                                symbol: eurCurrency.symbol,
                              ),
                              style: sSubtitle1Style.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          )
                        : null,
                  ),
                ),
            ],
            if (userInfo.isSimpleCardAvailable &&
                (simpleCardStore.allCards == null ||
                    simpleCardStore.allCards!.isEmpty ||
                    simpleCardStore.allCards![0].status == AccountStatusCard.inCreation)) ...[
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SpaceH8(),
                    SPaddingH24(
                      child: Padding(
                        padding: const EdgeInsets.only(
                          left: 36,
                        ),
                        child: SIconTextButton(
                          onTap: () {
                            if (simpleCardStore.allCards == null || simpleCardStore.allCards!.isEmpty) {
                              showCardOptions(context);
                            }
                          },
                          text: intl.simple_card_get_card.capitalize(),
                          textStyle: sTextButtonStyle.copyWith(
                            color: simpleCardStore.allCards != null &&
                                    simpleCardStore.allCards!.isNotEmpty &&
                                    simpleCardStore.allCards![0].status == AccountStatusCard.inCreation
                                ? sKit.colors.grey2
                                : sKit.colors.blue,
                          ),
                          icon: SActionDepositIcon(
                            color: simpleCardStore.allCards != null &&
                                    simpleCardStore.allCards!.isNotEmpty &&
                                    simpleCardStore.allCards![0].status == AccountStatusCard.inCreation
                                ? sKit.colors.grey2
                                : sKit.colors.blue,
                          ),
                          disabled: simpleCardStore.allCards != null &&
                              simpleCardStore.allCards!.isNotEmpty &&
                              simpleCardStore.allCards![0].status == AccountStatusCard.inCreation,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            const SliverPadding(padding: EdgeInsets.only(top: 24)),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24.0,
                  vertical: 8,
                ),
                child: Text(
                  intl.eur_wallet_accounts,
                  style: sTextH4Style,
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (simpleAccount != null)
                    SCardRow(
                      maxWidth: MediaQuery.of(context).size.width * .35,
                      icon: Container(
                        margin: const EdgeInsets.only(top: 3),
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: sKit.colors.blue,
                          shape: BoxShape.circle,
                        ),
                        child: SizedBox(
                          width: 16,
                          height: 16,
                          child: SBankMediumIcon(
                            color: sKit.colors.white,
                          ),
                        ),
                      ),
                      name: simpleAccount.label ?? 'Account 1',
                      helper: simpleAccount.status == AccountStatus.active
                          ? intl.eur_wallet_simple_account
                          : intl.create_simple_creating,
                      onTap: () {
                        sRouter
                            .push(
                              CJAccountRouter(
                                bankingAccount: simpleAccount,
                                isCJAccount: true,
                              ),
                            )
                            .then(
                              (value) => sAnalytics.eurWalletTapBackOnAccountWalletScreen(
                                isCJ: true,
                                eurAccountLabel: simpleAccount.label ?? '',
                                isHasTransaction: false,
                              ),
                            );
                      },
                      description: '',
                      amount: '',
                      needSpacer: true,
                      rightIcon: simpleAccount.status == AccountStatus.active
                          ? Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              decoration: ShapeDecoration(
                                shape: RoundedRectangleBorder(
                                  side: const BorderSide(color: Color(0xFFF1F4F8)),
                                  borderRadius: BorderRadius.circular(22),
                                ),
                              ),
                              child: Text(
                                volumeFormat(
                                  decimal: simpleAccount.balance ?? Decimal.zero,
                                  accuracy: eurCurrency.accuracy,
                                  symbol: eurCurrency.symbol,
                                ),
                                style: sSubtitle1Style.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            )
                          : null,
                    ),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: bankAccounts.length,
                    padding: EdgeInsets.zero,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return SCardRow(
                        maxWidth: bankAccounts[index].status == AccountStatus.active
                            ? MediaQuery.of(context).size.width * .35
                            : MediaQuery.of(context).size.width * .5,
                        icon: Container(
                          margin: const EdgeInsets.only(top: 3),
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: sKit.colors.blue,
                            shape: BoxShape.circle,
                          ),
                          child: SizedBox(
                            width: 16,
                            height: 16,
                            child: SBankMediumIcon(
                              color: sKit.colors.white,
                            ),
                          ),
                        ),
                        name: bankAccounts[index].label ?? 'Account',
                        helper: bankAccounts[index].status == AccountStatus.active
                            ? intl.eur_wallet_personal_account
                            : intl.create_personal_creating,
                        onTap: () {
                          if (bankAccounts[index].status == AccountStatus.active) {
                            sRouter
                                .push(
                                  CJAccountRouter(
                                    bankingAccount: bankAccounts[index],
                                    isCJAccount: false,
                                  ),
                                )
                                .then(
                                  (value) => sAnalytics.eurWalletTapBackOnAccountWalletScreen(
                                    isCJ: false,
                                    eurAccountLabel: bankAccounts[index].label ?? '',
                                    isHasTransaction: false,
                                  ),
                                );
                          }
                        },
                        description: '',
                        amount: '',
                        needSpacer: true,
                        rightIcon: bankAccounts[index].status == AccountStatus.active
                            ? Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                decoration: ShapeDecoration(
                                  shape: RoundedRectangleBorder(
                                    side: const BorderSide(color: Color(0xFFF1F4F8)),
                                    borderRadius: BorderRadius.circular(22),
                                  ),
                                ),
                                child: Text(
                                  volumeFormat(
                                    decimal: bankAccounts[index].balance ?? Decimal.zero,
                                    accuracy: eurCurrency.accuracy,
                                    symbol: eurCurrency.symbol,
                                  ),
                                  style: sSubtitle1Style.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              )
                            : null,
                      );
                    },
                  ),
                  if (bankAccounts.isEmpty)
                    SPaddingH24(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: SIconTextButton(
                          onTap: () {
                            if (isAddButtonDisabled) return;
                            if (bankAccounts.length > 1) return;

                            sAnalytics.eurWalletAddAccountEur();
                            sAnalytics.eurWalletPersonalEURAccount();

                            sRouter
                                .push(const CreateBankingRoute())
                                .then((value) => sAnalytics.eurWalletBackOnPersonalAccount());
                          },
                          text: intl.eur_wallet_add_account,
                          textStyle: sTextButtonStyle.copyWith(
                            color: isAddButtonDisabled
                                ? sKit.colors.grey2
                                : bankAccounts.length > 1
                                    ? sKit.colors.grey2
                                    : sKit.colors.blue,
                          ),
                          icon: SPlusIcon(
                            color: isAddButtonDisabled
                                ? sKit.colors.grey2
                                : bankAccounts.length > 1
                                    ? sKit.colors.grey2
                                    : sKit.colors.blue,
                          ),
                        ),
                      ),
                    ),
                  const SpaceH30(),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

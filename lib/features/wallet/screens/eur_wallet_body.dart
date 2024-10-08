import 'dart:async';

import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/format_service.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/features/kyc/kyc_service.dart';
import 'package:jetwallet/features/simple_card/store/simple_card_store.dart';
import 'package:jetwallet/utils/extension/string_extension.dart';
import 'package:jetwallet/utils/formatting/formatting.dart';
import 'package:jetwallet/utils/helpers/check_kyc_status.dart';
import 'package:jetwallet/widgets/network_icon_widget.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';
import 'package:simple_networking/modules/signal_r/models/banking_profile_model.dart';
import 'package:simple_networking/modules/wallet_api/models/simple_card/simple_card_create_response.dart';

import '../../../core/services/user_info/user_info_service.dart';
import '../../../utils/models/currency_model.dart';
import '../../app/store/app_store.dart';
import '../../simple_card/ui/widgets/card_options.dart';

class EurWalletBody extends StatefulObserverWidget {
  const EurWalletBody({
    super.key,
    this.pageController,
    this.pageCount,
    this.indexNow,
    required this.eurCurrency,
    this.isSinglePage = false,
  });

  final CurrencyModel eurCurrency;
  final PageController? pageController;
  final int? pageCount;
  final int? indexNow;
  final bool isSinglePage;

  @override
  State<EurWalletBody> createState() => _EurWalletBodyState();
}

class _EurWalletBodyState extends State<EurWalletBody> {
  final _controller = ScrollController();
  bool isTopPosition = true;

  @override
  void initState() {
    final bankAccountsCount = (sSignalRModules.bankingProfileData?.banking?.accounts ?? [])
        .where((element) => element.status == AccountStatus.active)
        .length;

    var allAccountsCount = bankAccountsCount;
    if (sSignalRModules.bankingProfileData?.simple != null) {
      if (sSignalRModules.bankingProfileData?.simple?.account?.status == AccountStatus.active) {
        allAccountsCount++;
      }
    }
    sAnalytics.eurWalletAccountScreen(allAccountsCount);
    final simpleCardStore = getIt.get<SimpleCardStore>();
    final userInfo = getIt.get<UserInfoService>();

    if (userInfo.isSimpleCardAvailable) {
      simpleCardStore.initStore();
    }

    Timer(
      const Duration(seconds: 2),
      () {
        final userInfo = getIt.get<UserInfoService>();
        final kycState = getIt.get<KycService>();
        final kycBlocked = checkKycBlocked(
          kycState.depositStatus,
          kycState.tradeStatus,
          kycState.withdrawalStatus,
        );
        if (userInfo.isSimpleCardAvailable &&
            (sSignalRModules.bankingProfileData?.availableCardsCount ?? 0) > 0 &&
            !kycBlocked) {
          sAnalytics.viewEURWalletWithButton();
        } else {
          sAnalytics.viewEURWalletWithoutButton();
        }
      },
    );
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
    final colors = sKit.colors;

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

    final isAddButtonDisabled = kycBlocked;

    return SPageFrame(
      color: colors.white,
      loaderText: intl.loader_please_wait,
      loading: simpleCardStore.loader,
      child: Column(
        children: [
          CollapsedWalletAppbar(
            scrollController: _controller,
            assetIcon: NetworkIconWidget(
              widget.eurCurrency.iconUrl,
            ),
            ticker: widget.eurCurrency.symbol,
            mainTitle: getIt<AppStore>().isBalanceHide
                ? '**** ${widget.eurCurrency.symbol}'
                : sSignalRModules.totalEurWalletBalance.toFormatSum(
                    accuracy: widget.eurCurrency.accuracy,
                    symbol: widget.eurCurrency.symbol,
                  ),
            mainSubtitle: getIt.get<FormatService>().baseCurrency.symbol != widget.eurCurrency.symbol
                ? getIt<AppStore>().isBalanceHide
                    ? '******* ${sSignalRModules.baseCurrency.symbol}'
                    : widget.eurCurrency.volumeBaseBalance(sSignalRModules.baseCurrency)
                : null,
            mainHeaderTitle: widget.eurCurrency.description,
            mainHeaderSubtitle: intl.eur_wallet,
            mainHeaderCollapsedTitle: getIt<AppStore>().isBalanceHide
                ? '**** ${widget.eurCurrency.symbol}'
                : sSignalRModules.totalEurWalletBalance.toFormatSum(
                    accuracy: widget.eurCurrency.accuracy,
                    symbol: widget.eurCurrency.symbol,
                  ),
            mainHeaderCollapsedSubtitle: widget.eurCurrency.description,
            carouselItemsCount: widget.pageCount,
            carouselPageIndex: widget.indexNow,
            needCarousel: !widget.isSinglePage,
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
                const SliverToBoxAdapter(child: SpaceH10()),
                if (simpleCardStore.allCards == null ||
                    simpleCardStore.allCards!.isEmpty ||
                    !userInfo.isSimpleCardAvailable) ...[
                  SliverToBoxAdapter(
                    child: SimpleTableAsset(
                      isCard: true,
                      hasRightValue: false,
                      label: intl.eur_wallet_simple_card,
                      supplement: !userInfo.isSimpleCardAvailable ? intl.eur_wallet_coming_soon : null,
                    ),
                  ),
                ],
                if (userInfo.isSimpleCardAvailable) ...[
                  for (final el in (simpleCardStore.allCards ?? <CardDataModel>[]).where(
                    (element) => element.status != AccountStatusCard.unsupported,
                  ))
                    SliverToBoxAdapter(
                      child: SimpleTableAsset(
                        label: el.label ?? intl.eur_wallet_simple_card,
                        supplement:
                            el.status == AccountStatusCard.inCreation ? intl.creating : intl.simple_card_type_virtual,
                        rightValue: getIt<AppStore>().isBalanceHide
                            ? '**** ${widget.eurCurrency.symbol}'
                            : (el.balance ?? Decimal.zero).toFormatSum(
                                accuracy: widget.eurCurrency.accuracy,
                                symbol: widget.eurCurrency.symbol,
                              ),
                        isCardWallet: true,
                        hasLabelIcon: userInfo.isSimpleCardAvailable && el.status == AccountStatusCard.frozen,
                        onTableAssetTap: () {
                          if (el.status == AccountStatusCard.active || el.status == AccountStatusCard.frozen) {
                            if (simpleCardStore.canTap) {
                              simpleCardStore.setCanTap(false);
                              Timer(
                                const Duration(
                                  seconds: 1,
                                ),
                                () => simpleCardStore.setCanTap(true),
                              );
                              sAnalytics.tapOnSimpleCard();
                              simpleCardStore.initFullCardIn(el.cardId ?? '');
                              sRouter.push(
                                SimpleCardRouter(
                                  isAddCashAvailable: sSignalRModules.currenciesList
                                      .where((currency) {
                                        return currency.assetBalance != Decimal.zero;
                                      })
                                      .toList()
                                      .isNotEmpty,
                                ),
                              );
                            }
                          }
                        },
                        assetIcon: userInfo.isSimpleCardAvailable && el.status == AccountStatusCard.frozen
                            ? Assets.svg.paymentMethodsCards.simple.frozenCard.simpleSvg(
                                width: 24,
                              )
                            : Assets.svg.paymentMethodsCards.simple.defaultCard.simpleSvg(
                                width: 24,
                              ),
                      ),
                    ),
                ],
                if (userInfo.isSimpleCardAvailable &&
                    (sSignalRModules.bankingProfileData?.availableCardsCount ?? 0) > 0 &&
                    !kycBlocked) ...[
                  SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SPaddingH24(
                          child: Padding(
                            padding: const EdgeInsets.only(
                              left: 36,
                            ),
                            child: SButtonContext(
                              type: SButtonContextType.iconedSmall,
                              onTap: () {
                                sAnalytics.tapOnGetSimpleCard(
                                  source: 'eur wallet',
                                );
                                showGetSimpleCardModal(context: context);
                              },
                              text: intl.simple_card_get_card.capitalize(),
                              icon: Assets.svg.medium.card,
                              isDisabled: (simpleCardStore.allCards != null &&
                                      simpleCardStore.allCards!.isNotEmpty &&
                                      simpleCardStore.allCards![0].status == AccountStatusCard.inCreation) ||
                                  isAddButtonDisabled,
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
                          onTableAssetTap: () {
                            sRouter.push(
                              CJAccountRouter(
                                bankingAccount: simpleAccount,
                                isCJAccount: true,
                                eurCurrency: widget.eurCurrency,
                              ),
                            );
                          },
                          assetIcon: const BlueBankIcon(
                            size: 24.0,
                          ),
                          label: simpleAccount.label ?? 'Account 1',
                          supplement: simpleAccount.status == AccountStatus.active
                              ? intl.eur_wallet_simple_account
                              : intl.create_simple_creating,
                          hasRightValue: simpleAccount.status == AccountStatus.active,
                          rightValue: getIt<AppStore>().isBalanceHide
                              ? '**** ${widget.eurCurrency.symbol}'
                              : (simpleAccount.balance ?? Decimal.zero).toFormatSum(
                                  accuracy: widget.eurCurrency.accuracy,
                                  symbol: widget.eurCurrency.symbol,
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
                                sRouter.push(
                                  CJAccountRouter(
                                    bankingAccount: bankAccounts[index],
                                    isCJAccount: false,
                                    eurCurrency: widget.eurCurrency,
                                  ),
                                );
                              }
                            },
                            assetIcon: const BlueBankIcon(
                              size: 24.0,
                            ),
                            label: bankAccounts[index].label ?? 'Account',
                            supplement: bankAccounts[index].status == AccountStatus.active
                                ? intl.eur_wallet_personal_account
                                : intl.create_personal_creating,
                            hasRightValue: bankAccounts[index].status == AccountStatus.active,
                            rightValue: getIt<AppStore>().isBalanceHide
                                ? '**** ${widget.eurCurrency.symbol}'
                                : (bankAccounts[index].balance ?? Decimal.zero).toFormatSum(
                                    accuracy: widget.eurCurrency.accuracy,
                                    symbol: widget.eurCurrency.symbol,
                                  ),
                          );
                        },
                      ),
                      if ((sSignalRModules.bankingProfileData?.availableAccountsCount ?? 0) != 0)
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 16,
                            top: 16,
                            bottom: 32,
                          ),
                          child: Row(
                            children: [
                              SButtonContext(
                                type: SButtonContextType.iconedSmall,
                                text: intl.eur_wallet_add_account,
                                isDisabled: isAddButtonDisabled,
                                onTap: () {
                                  sAnalytics.eurWalletAddAccountEur();
                                  sAnalytics.eurWalletPersonalEURAccount();

                                  sRouter.push(const CreateBankingRoute()).then(
                                        (value) => sAnalytics.eurWalletBackOnPersonalAccount(),
                                      );
                                },
                              ),
                            ],
                          ),
                        ),
                      const SpaceH300(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

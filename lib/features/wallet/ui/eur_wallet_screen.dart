import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/features/wallet/ui/widgets/wallet_header.dart';
import 'package:jetwallet/utils/helpers/currencies_with_balance_from.dart';
import 'package:jetwallet/utils/helpers/non_indices_with_balance_from.dart';
import 'package:simple_kit/modules/icons/24x24/public/bank_medium/bank_medium_icon.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/modules/signal_r/models/banking_profile_model.dart';

@RoutePage(name: 'EurWalletRouter')
class EurWallet extends StatelessObserverWidget {
  const EurWallet({super.key});

  @override
  Widget build(BuildContext context) {
    final eurCurrency = nonIndicesWithBalanceFrom(
      currenciesWithBalanceFrom(sSignalRModules.currenciesList),
    ).where((element) => element.symbol == 'EUR').first;

    return SPageFrame(
      loaderText: '',
      child: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 226,
            collapsedHeight: 226,
            pinned: true,
            stretch: true,
            backgroundColor: sKit.colors.white,
            elevation: 0.0,
            automaticallyImplyLeading: false,
            leadingWidth: 48,
            leading: Padding(
              padding: const EdgeInsets.only(left: 24),
              child: SIconButton(
                onTap: () => Navigator.pop(context),
                defaultIcon: const SBackIcon(),
                pressedIcon: const SBackPressedIcon(),
              ),
            ),
            title: Column(
              children: [
                Text(
                  eurCurrency.description,
                  style: sTextH5Style.copyWith(
                    color: sKit.colors.black,
                  ),
                ),
                Text(
                  intl.eur_wallet,
                  style: sBodyText2Style.copyWith(
                    color: sKit.colors.grey1,
                  ),
                ),
              ],
            ),
            flexibleSpace: WalletHeader(
              curr: eurCurrency,
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
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 16,
              ),
              child: Row(
                children: [
                  const SCardIcon(),
                  const SpaceW12(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        intl.eur_wallet_simple_card,
                        style: sSubtitle1Style,
                      ),
                      Text(
                        intl.eur_wallet_coming_soon,
                        style: sBodyText2Style.copyWith(
                          color: sKit.colors.grey1,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
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
                SCardRow(
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
                  name: sSignalRModules.bankingProfileData?.simple?.account?.label ?? 'Account 1',
                  helper: intl.eur_wallet_simple_account,
                  onTap: () {
                    sRouter.push(
                      const CJAccountRouter(),
                    );
                  },
                  description: '',
                  amount: '',
                  needSpacer: true,
                  rightIcon: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(color: Color(0xFFF1F4F8)),
                        borderRadius: BorderRadius.circular(22),
                      ),
                    ),
                    child: Text(
                      '1 545 EUR',
                      style: sSubtitle1Style.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                for (final el in sSignalRModules.bankingProfileData?.banking?.accounts ?? <SimpleBankingAccount>[])
                  SCardRow(
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
                    name: el.label ?? '',
                    helper: el.status == AccountStatus.active
                        ? intl.eur_wallet_personal_account
                        : intl.create_personal_creating,
                    onTap: () {
                      sRouter.push(
                        const CJAccountRouter(),
                      );
                    },
                    description: '',
                    amount: '',
                    needSpacer: true,
                    rightIcon: el.status == AccountStatus.active
                        ? Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            decoration: ShapeDecoration(
                              shape: RoundedRectangleBorder(
                                side: const BorderSide(color: Color(0xFFF1F4F8)),
                                borderRadius: BorderRadius.circular(22),
                              ),
                            ),
                            child: Text(
                              '1 545 EUR',
                              style: sSubtitle1Style.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          )
                        : null,
                  ),
                SPaddingH24(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: SIconTextButton(
                      onTap: () {
                        sRouter.push(const CreateBankingRoute());
                      },
                      text: intl.eur_wallet_add_account,
                      icon: SPlusIcon(
                        color: sKit.colors.blue,
                      ),
                    ),
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

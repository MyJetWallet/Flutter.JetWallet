import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/features/my_wallets/helper/show_deposit_details_popup.dart';
import 'package:jetwallet/features/my_wallets/widgets/cj_header_widget.dart';
import 'package:jetwallet/features/wallet/ui/widgets/wallet_body/widgets/transactions_list/transactions_list.dart';
import 'package:jetwallet/utils/constants.dart';
import 'package:jetwallet/utils/helpers/non_indices_with_balance_from.dart';
import 'package:jetwallet/widgets/circle_action_buttons/circle_action_button.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/modules/signal_r/models/banking_profile_model.dart';

const double _appBarBottomPosition = 120.0;

@RoutePage(name: 'CJAccountRouter')
class CJAccountScreen extends StatefulObserverWidget {
  const CJAccountScreen({
    super.key,
    required this.bankingAccount,
    required this.isCJAccount,
  });

  final SimpleBankingAccount bankingAccount;
  final bool isCJAccount;

  @override
  State<CJAccountScreen> createState() => _CJAccountScreenState();
}

class _CJAccountScreenState extends State<CJAccountScreen> {
  late ScrollController _controller;
  final ScrollController _transactionScrollController = ScrollController();
  bool silverCollapsed = false;

  @override
  void initState() {
    super.initState();

    _controller = ScrollController();

    _controller.addListener(() {
      if (_controller.offset > 170 && !_controller.position.outOfRange) {
        if (!silverCollapsed) {
          silverCollapsed = true;
          setState(() {});
        }
      }
      if (_controller.offset <= 170 && !_controller.position.outOfRange) {
        if (silverCollapsed) {
          silverCollapsed = false;
          setState(() {});
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final eurCurrency = nonIndicesWithBalanceFrom(
      sSignalRModules.currenciesList,
    ).where((element) => element.symbol == 'EUR').first;

    return SPageFrame(
      loaderText: '',
      child: CustomScrollView(
        controller: _controller,
        slivers: [
          SliverAppBar(
            expandedHeight: 226,
            floating: true,
            pinned: true,
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
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 24),
                child: SIconButton(
                  onTap: () {
                    sRouter.push(const CJAccountLabelRouter());
                  },
                  defaultIcon: const SEditIcon(),
                  pressedIcon: SEditIcon(color: sKit.colors.grey1),
                ),
              ),
            ],
            centerTitle: true,
            title: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (silverCollapsed) const SizedBox(height: 10),
                if (!silverCollapsed)
                  Text(
                    widget.bankingAccount.label ?? 'Account',
                    style: sTextH5Style.copyWith(
                      color: sKit.colors.black,
                    ),
                  ),
                Text(
                  widget.isCJAccount ? intl.wallet_simple_account : intl.eur_wallet_personal_account,
                  style: sBodyText2Style.copyWith(
                    color: sKit.colors.grey1,
                  ),
                ),
              ],
            ),
            flexibleSpace: CJHeaderWidget(
              eurCurr: eurCurrency,
              bankingAccount: widget.bankingAccount,
            ),
          ),
          if (!silverCollapsed)
            SliverToBoxAdapter(
              child: Container(
                padding: const EdgeInsets.only(
                  left: 24,
                  right: 24,
                  top: 24,
                  bottom: 28,
                ),
                child: Wrap(
                  spacing: 9.0,
                  alignment: WrapAlignment.center,
                  children: [
                    CircleActionButton(
                      text: intl.wallet_add_cash,
                      type: CircleButtonType.addCash,
                      onTap: () {
                        showDepositDetails(context);
                      },
                    ),
                    CircleActionButton(
                      text: intl.wallet_withdraw,
                      type: CircleButtonType.withdraw,
                      isDisabled: true,
                      onTap: () {},
                    ),
                  ],
                ),
              ),
            ),
          SliverToBoxAdapter(
            child: SPaddingH24(
              child: Text(
                intl.wallet_transactions,
                style: sTextH4Style,
              ),
            ),
          ),
          if (eurCurrency.isAssetBalanceNotEmpty) ...[
            TransactionsList(
              scrollController: _transactionScrollController,
              symbol: 'EUR',
            ),
          ] else ...[
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 80,
                  vertical: 40,
                ),
                child: Column(
                  children: [
                    Image.asset(
                      smileAsset,
                      width: 48,
                      height: 48,
                    ),
                    Text(
                      intl.wallet_simple_account_empty,
                      textAlign: TextAlign.center,
                      maxLines: 3,
                      style: sSubtitle2Style.copyWith(
                        color: sKit.colors.grey2,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/services/currencies_service/currencies_service.dart';
import 'package:jetwallet/features/app/store/app_store.dart';
import 'package:jetwallet/features/market/market_details/helper/currency_from.dart';
import 'package:jetwallet/features/wallet/ui/widgets/action_button/action_button.dart';
import 'package:jetwallet/features/wallet/ui/widgets/wallet_body/empty_earn_wallet_body.dart';
import 'package:jetwallet/features/wallet/ui/widgets/wallet_body/empty_wallet_body.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:simple_kit/simple_kit.dart';

class EmptyWallet extends StatefulObserverWidget {
  const EmptyWallet({
    Key? key,
    required this.currency,
  }) : super(key: key);

  final CurrencyModel currency;

  @override
  State<EmptyWallet> createState() => _EmptyWalletState();
}

class _EmptyWalletState extends State<EmptyWallet>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;

  @override
  void initState() {
    // animationController intentionally is not disposed,
    // because bottomSheet will dispose it on its own
    animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final currentAsset =
        currencyFrom(sCurrencies.currencies, widget.currency.symbol);

    return Scaffold(
      bottomNavigationBar: ActionButton(
        transitionAnimationController: animationController,
        currency: currentAsset,
      ),
      body: Observer(
        builder: (context) {
          return SShadeAnimationStack(
            showShade: getIt.get<AppStore>().actionMenuActive,
            //controller: animationController,
            child: SPageFrameWithPadding(
              header: SSmallHeader(
                title: '${widget.currency.description} '
                    '${intl.emptyWallet_wallet}',
              ),
              child: (widget.currency.apy.toDouble() == 0.0)
                  ? EmptyWalletBody(
                assetName: widget.currency.description,
              )
                  : EmptyEarnWalletBody(
                assetName: widget.currency.description,
                apy: widget.currency.apy,
              ),
            ),
          );
        },
      ),
    );
  }
}

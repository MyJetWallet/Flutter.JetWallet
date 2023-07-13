import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/features/buy_flow/store/payment_method_store.dart';
import 'package:jetwallet/features/buy_flow/ui/widgets/payment_methods_widgets/payment_method_cards_widget.dart';
import 'package:jetwallet/features/market/ui/widgets/market_tab_bar_views/components/market_separator.dart';
import 'package:jetwallet/features/wallet/ui/widgets/wallet_body/widgets/transaction_month_separator.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:provider/provider.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/modules/signal_r/models/asset_payment_methods_new.dart';

@RoutePage()
class BuyPaymentMethodScreen extends StatelessWidget {
  const BuyPaymentMethodScreen({
    super.key,
    required this.asset,
    required this.currency,
  });

  final CurrencyModel asset;
  final PaymentAsset currency;

  @override
  Widget build(BuildContext context) {
    return Provider<PaymentMethodStore>(
      create: (context) => PaymentMethodStore()..init(asset, currency),
      builder: (context, child) => _PaymentMethodScreenBody(),
    );
  }
}

class _PaymentMethodScreenBody extends StatelessObserverWidget {
  const _PaymentMethodScreenBody({super.key});

  @override
  Widget build(BuildContext context) {
    final store = PaymentMethodStore.of(context);

    return SPageFrame(
      header: SPaddingH24(
        child: SSmallHeader(
          title: intl.buy_flow_payment_method,
          onBackButtonTap: () => sRouter.pop(),
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            if (store.showSearch) ...[
              SPaddingH24(
                child: SStandardField(
                  controller: store.searchController,
                  labelText: intl.actionBottomSheetHeader_search,
                  onChanged: (String value) => store.search(value),
                ),
              ),
              const SDivider(),
            ],
            if (store.cardsMethods.isNotEmpty) ...[
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: PaymentMethodWidget(
                  title: intl.payment_method_cards,
                ),
              ),
            ],
            if (store.localMethods.isNotEmpty) ...[
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: PaymentMethodWidget(
                  title: intl.payment_method_local,
                ),
              ),
            ],
            if (store.p2pMethods.isNotEmpty) ...[
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: PaymentMethodWidget(
                  title: intl.payment_method_p2p,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

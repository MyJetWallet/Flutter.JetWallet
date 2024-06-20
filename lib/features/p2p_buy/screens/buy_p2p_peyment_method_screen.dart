import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/simple_networking/simple_networking.dart';
import 'package:jetwallet/features/app/store/global_loader.dart';
import 'package:jetwallet/features/withdrawal/send_card_detail/widgets/payment_method_card.dart';
import 'package:jetwallet/utils/helpers/icon_url_from.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/modules/signal_r/models/asset_payment_methods_new.dart';
import 'package:simple_networking/modules/wallet_api/models/p2p_methods/p2p_methods_responce_model.dart';

@RoutePage(name: 'BuyP2pPeymentMethodRouter')
class BuyP2pPeymentMethodScreen extends StatefulWidget {
  const BuyP2pPeymentMethodScreen({
    super.key,
    required this.currency,
    required this.paymentCurrecy,
  });

  final CurrencyModel currency;
  final PaymentAsset paymentCurrecy;

  @override
  State<BuyP2pPeymentMethodScreen> createState() => _BuyP2pPeymentMethodScreenState();
}

class _BuyP2pPeymentMethodScreenState extends State<BuyP2pPeymentMethodScreen> {
  List<P2PMethodModel> methods = [];

  @override
  void initState() {
    super.initState();
    loadP2PMethods();
  }

  Future<void> loadP2PMethods() async {
    try {
      getIt.get<GlobalLoader>().setLoading(true);
      final responce = await sNetwork.getWalletModule().getP2PMethods();

      setState(() {
        methods = responce.data?.methods ?? [];
      });
    } catch (e) {
      getIt.get<GlobalLoader>().setLoading(false);
    } finally {
      getIt.get<GlobalLoader>().setLoading(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SPageFrame(
      loaderText: '',
      header: SPaddingH24(
        child: SSmallHeader(
          title: intl.buy_flow_payment_method,
        ),
      ),
      child: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            sliver: SliverGrid.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 8,
                crossAxisSpacing: 12,
                childAspectRatio: 1 / .59,
              ),
              itemCount: methods.length,
              itemBuilder: (context, i) => PaymentMethodCard.card(
                name: methods[i].name,
                url: iconForPaymentMethod(
                  methodId: methods[i].methodId,
                ),
                onTap: () {
                  sRouter.push(
                    P2PBuyAmountRouter(
                      currency: widget.currency,
                      p2pMethod: methods[i],
                      paymentCurrecy: widget.paymentCurrecy,
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

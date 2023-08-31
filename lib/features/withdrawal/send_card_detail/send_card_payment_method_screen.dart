import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/features/withdrawal/send_card_detail/store/send_card_payment_method_store.dart';
import 'package:jetwallet/features/withdrawal/send_card_detail/widgets/payment_method_card.dart';
import 'package:jetwallet/utils/helpers/icon_url_from.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:provider/provider.dart';
import 'package:simple_kit/modules/shared/page_frames/simple_page_frame.dart';
import 'package:simple_kit/simple_kit.dart';

@RoutePage(name: 'SendCardPaymentMethodRouter')
class SendCardPaymentMethodScreen extends StatelessWidget {
  const SendCardPaymentMethodScreen({
    super.key,
    required this.countryCode,
    required this.currency,
  });

  final String countryCode;
  final CurrencyModel currency;

  @override
  Widget build(BuildContext context) {
    return Provider<SendCardPaymentMethodStore>(
      create: (context) => SendCardPaymentMethodStore()..init(countryCode),
      builder: (context, child) => SendCardPaymentMethodBody(
        countryCode: countryCode,
        currency: currency,
      ),
    );
  }
}

class SendCardPaymentMethodBody extends StatelessObserverWidget {
  const SendCardPaymentMethodBody({
    super.key,
    required this.countryCode,
    required this.currency,
  });

  final String countryCode;
  final CurrencyModel currency;

  @override
  Widget build(BuildContext context) {
    final store = SendCardPaymentMethodStore.of(context);

    return SPageFrame(
      header: SPaddingH24(
        child: SSmallHeader(
          title: intl.global_send_payment_method_title,
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
              const SizedBox(height: 24),
            ],
            SPaddingH24(
              child: GridView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 12,
                  childAspectRatio: 1 / .59,
                ),
                itemCount: store.filtedGlobalSendMethods.length,
                itemBuilder: (context, i) => PaymentMethodCard.card(
                  name: store.filtedGlobalSendMethods[i].name ?? '',
                  url: iconForPaymentMethod(
                    methodId: store.filtedGlobalSendMethods[i].methodId ?? '',
                  ),
                  onTap: () {
                    sRouter.push(
                      SendCardDetailRouter(
                        countryCode: countryCode,
                        currency: currency,
                        method: store.filtedGlobalSendMethods[i],
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

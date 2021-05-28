import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../../../../../../service/services/swap/model/get_quote/get_quote_response_model.dart';
import '../../../../../../../../../shared/components/loader.dart';
import '../../../../../../../../../shared/components/spacers.dart';
import '../../../../../notifier/convert_notifier.dart';
import '../../../../../provider/quote_timer_spod.dart';
import 'components/quote_rich_text.dart';

class ResponseQuoteInfo extends HookWidget {
  const ResponseQuoteInfo({
    required this.quote,
    required this.notifier,
  });

  final GetQuoteResponseModel quote;
  final ConvertNotifier notifier;

  @override
  Widget build(BuildContext context) {
    final stream = useProvider(quoteTimerSpod(quote.expirationTime));

    return ProviderListener<AsyncValue<int>>(
      provider: quoteTimerSpod(quote.expirationTime),
      onChange: (context, data) {
        data.whenData((value) {
          if (value == 0) notifier.toRequestQuote();
        });
      },
      child: stream.when(
        data: (timerValue) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  QuoteRichText(
                    boldText: 'Price of ${quote.fromAsset}: ',
                    plainText: '${quote.price} ${quote.toAsset}',
                  ),
                  const SpaceH5(),
                  QuoteRichText(
                    boldText: 'You give: ',
                    plainText: '${quote.fromAssetAmount} ${quote.fromAsset}',
                  ),
                  const SpaceH5(),
                  QuoteRichText(
                    boldText: 'You recive: ',
                    plainText: '${quote.toAssetAmount} ${quote.toAsset}',
                  ),
                  const SpaceH5(),
                  QuoteRichText(
                    boldText: 'Expiration: ',
                    plainText: '$timerValue',
                  ),
                ],
              ),
            ),
          );
        },
        loading: () => Loader(),
        error: (e, _) => Text(e.toString()),
      ),
    );
  }
}

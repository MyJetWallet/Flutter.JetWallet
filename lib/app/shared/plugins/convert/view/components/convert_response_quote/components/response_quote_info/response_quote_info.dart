import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../../../../../../../../service/services/swap/model/get_quote/get_quote_response_model.dart';
import '../../../../../../../../../shared/components/spacers.dart';
import 'components/quote_rich_text.dart';

class ResponseQuoteInfo extends HookWidget {
  const ResponseQuoteInfo({
    required this.quote,
    required this.quoteTime,
  });

  final GetQuoteResponseModel quote;
  final Stream<int> quoteTime;

  @override
  Widget build(BuildContext context) {
    // TODO fix hardcoded initial data
    final timer = useStream(quoteTime, initialData: 28);

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
              plainText: '${timer.data}',
            ),
          ],
        ),
      ),
    );
  }
}

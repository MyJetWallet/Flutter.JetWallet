import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../../../../service/services/swap/model/get_quote/get_quote_response_model.dart';
import '../../../../../../../../../shared/components/spacers.dart';
import '../../../../../../../../../shared/providers/other/timer_notipod.dart';
import '../../../../../notifier/convert_notifier.dart';
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
    final timer = useProvider(timerNotipod(quote.expirationTime));

    return ProviderListener<int>(
      provider: timerNotipod(quote.expirationTime),
      onChange: (context, value) {
        if (value == 0) notifier.toRequestQuote();
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 10.w,
            vertical: 10.h,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              QuoteRichText(
                boldText: 'Price of ${quote.fromAsset}: ',
                plainText: '${quote.price} ${quote.toAsset}',
              ),
              const SpaceH4(),
              QuoteRichText(
                boldText: 'You give: ',
                plainText: '${quote.fromAssetAmount} ${quote.fromAsset}',
              ),
              const SpaceH4(),
              QuoteRichText(
                boldText: 'You recive: ',
                plainText: '${quote.toAssetAmount} ${quote.toAsset}',
              ),
              const SpaceH4(),
              QuoteRichText(
                boldText: 'Expiration: ',
                plainText: '$timer',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../../../../../../../service/services/swap/model/get_quote/get_quote_response_model.dart';
import '../../../../../../../shared/components/spacers.dart';
import '../../../../../helpers/show_plain_snackbar.dart';
import '../../../notifier/convert_notifier.dart';
import '../convert_button.dart';
import 'components/response_quote_info/response_quote_info.dart';

class ConvertResposneQuote extends StatelessWidget {
  const ConvertResposneQuote({
    required this.quote,
    required this.notifier,
    required this.quoteTime,
  });

  final GetQuoteResponseModel quote;
  final ConvertNotifier notifier;
  final Stream<int> quoteTime;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ResponseQuoteInfo(
          quote: quote,
          quoteTime: quoteTime,
        ),
        const SpaceH10(),
        Row(
          children: [
            ConvertButton(
              name: 'Cancel',
              onPressed: () => notifier.toRequestQuote(),
            ),
            const SpaceW10(),
            ConvertButton(
              name: 'Confirm',
              onPressed: () async {
                // TODO add loader onPressed
                final result = await notifier.executeQuote();

                showPlainSnackbar(context, result);
              },
            ),
          ],
        ),
      ],
    );
  }
}

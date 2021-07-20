import 'package:flutter/material.dart';

import '../../../../../../../shared/components/loader.dart';
import '../../../../../../../shared/components/spacers.dart';
import '../../../../../../../shared/helpers/show_plain_snackbar.dart';
import '../../../notifier/convert_notifier.dart';
import '../../../notifier/convert_state.dart';
import '../convert_button.dart';
import 'components/response_quote_info/response_quote_info.dart';

class ConvertResposneQuote extends StatelessWidget {
  const ConvertResposneQuote({
    required this.state,
    required this.notifier,
  });

  final ConvertState state;
  final ConvertNotifier notifier;

  @override
  Widget build(BuildContext context) {
    if (state.isConfirmLoading) {
      return const Loader();
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ResponseQuoteInfo(
            quote: state.quoteResponse!,
            notifier: notifier,
          ),
          const SpaceH8(),
          Row(
            children: [
              ConvertButton(
                name: 'Cancel',
                onPressed: () => notifier.toRequestQuote(),
              ),
              const SpaceW8(),
              ConvertButton(
                name: 'Confirm',
                onPressed: () async {
                  final result = await notifier.executeQuote();

                  showPlainSnackbar(context, result);

                  Navigator.popUntil(context, (route) => route.isFirst == true);
                },
              ),
            ],
          ),
        ],
      );
    }
  }
}

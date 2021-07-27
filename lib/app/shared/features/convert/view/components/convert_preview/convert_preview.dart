import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../../../../../shared/components/buttons/app_button_solid.dart';
import '../../../../../../../../shared/components/loader.dart';
import '../../../../../../../../shared/components/page_frame/page_frame.dart';
import '../../../../../../../../shared/components/spacers.dart';
import '../../../../../../../../shared/helpers/show_plain_snackbar.dart';
import '../../../notifier/convert_notifier/convert_notipod.dart';
import '../../../notifier/convert_notifier/convert_state.dart';
import '../../../notifier/convert_notifier/convert_union.dart';
import 'components/content_preview_error.dart';
import 'components/convert_preview_divider.dart';
import 'components/convert_preview_row/convert_preview_row.dart';

class ConvertPreview extends HookWidget {
  const ConvertPreview({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final convert = useProvider(convertNotipod);
    final convertN = useProvider(convertNotipod.notifier);

    final quote = convert.responseQuote;

    return ProviderListener<ConvertState>(
      provider: convertNotipod,
      onChange: (context, state) {
        if (state.union is ExecuteSuccess) {
          // TODO Go to Success Screen
        } else if (state.union is ExecuteError) {
          showPlainSnackbar(context, convert.error!);
          convertN.emitQuoteUnion();
        }
      },
      child: WillPopScope(
        onWillPop: () {
          convertN.cancelTimer();
          return Future.value(true);
        },
        child: PageFrame(
          header: 'Convert BTC to ETH',
          onBackButton: () {
            convertN.cancelTimer();
            Navigator.pop(context);
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (convert.union is QuoteLoading ||
                  convert.union is ExecuteLoading)
                const Loader()
              else if (convert.union is QuoteError)
                ConvertPreviewError(text: convert.error!)
              else ...[
                if (convert.union is QuoteRefresh)
                  const Loader()
                else
                  Text(
                    convert.timer.toString(),
                    style: const TextStyle(
                      fontSize: 50.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                const SpaceH40(),
                const ConvertPreviewDivider(),
                ConvertPreviewRow(
                  description: 'From',
                  value: '${quote?.fromAssetAmount} ${quote?.fromAsset}',
                ),
                const ConvertPreviewDivider(),
                ConvertPreviewRow(
                  description: 'To',
                  value: '${quote?.toAssetAmount} ${quote?.toAsset}',
                ),
                const ConvertPreviewDivider(),
                ConvertPreviewRow(
                  description: 'Exchange Rate',
                  value: '1 ${quote?.fromAsset} = '
                      '${quote?.price} ${quote?.toAsset}',
                ),
                const SpaceH20(),
                AppButtonSolid(
                  active: convert.union is QuoteSuccess,
                  name: 'Confirm',
                  onTap: () {
                    if (convert.union is QuoteSuccess) {
                      convertN.executeQuote();
                    }
                  },
                )
              ]
            ],
          ),
        ),
      ),
    );
  }
}

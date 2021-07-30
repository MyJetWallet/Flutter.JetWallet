import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../../../../../shared/components/buttons/app_button_solid.dart';
import '../../../../../../../../shared/components/loader.dart';
import '../../../../../../../../shared/components/page_frame/page_frame.dart';
import '../../../../../../../../shared/components/spacers.dart';
import '../../../../../../../../shared/helpers/show_plain_snackbar.dart';
import '../../../../../../../shared/components/success_screen/success_screen.dart';
import '../../../../../../../shared/helpers/navigator_push.dart';
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

    return ProviderListener<ConvertState>(
      provider: convertNotipod,
      onChange: (context, state) {
        if (state.union is ExecuteSuccess) {
          convertN.cancelTimer();
          navigatorPush(
            context,
            SuccessScreen(
              header: 'Convert ${state.fromAssetSymbol} '
                  'to ${state.toAssetSymbol}',
              description: 'Order filled',
            ),
          );
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
          header: 'Convert ${convert.fromAssetSymbol} '
              'to ${convert.toAssetSymbol}',
          onBackButton: () {
            convertN.cancelTimer();
            Navigator.pop(context);
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (convert.union is ExecuteLoading)
                const Loader()
              else if (convert.union is QuoteError)
                ConvertPreviewError(text: convert.error!)
              else ...[
                if (convert.union is QuoteRefresh ||
                    convert.union is QuoteLoading)
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
                  value: '${convert.fromAssetAmount} '
                      '${convert.fromAssetSymbol}',
                ),
                const ConvertPreviewDivider(),
                ConvertPreviewRow(
                  description: 'To',
                  value: '${convert.toAssetAmount} ${convert.toAssetSymbol}',
                  loading: convert.union is QuoteLoading,
                ),
                const ConvertPreviewDivider(),
                ConvertPreviewRow(
                  description: 'Exchange Rate',
                  value: '1 ${convert.fromAssetSymbol} = '
                      '${convert.price} ${convert.toAssetSymbol}',
                  loading: convert.union is QuoteLoading,
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

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../../../../../shared/components/buttons/app_button_solid.dart';
import '../../../../../../../../shared/components/loader.dart';
import '../../../../../../../../shared/components/page_frame/page_frame.dart';
import '../../../../../../../../shared/components/spacers.dart';
import '../../../helpers/format_asset_price_value.dart';
import '../../action_preview/action_preview_divider.dart';
import '../../action_preview/action_preview_row.dart';
import '../model/convert_preview_input.dart';
import '../notifier/convert_notipod.dart';
import '../notifier/convert_union.dart';
import 'components/quote_error_text.dart';

class ConvertPreview extends HookWidget {
  const ConvertPreview(this.input);

  final ConvertPreviewInput input;

  @override
  Widget build(BuildContext context) {
    final convert = useProvider(convertNotipod(input));
    final convertN = useProvider(convertNotipod(input).notifier);

    return WillPopScope(
      onWillPop: () {
        convertN.cancelTimer();
        return Future.value(true);
      },
      child: PageFrame(
        header: convertN.previewHeader,
        onBackButton: () {
          convertN.cancelTimer();
          Navigator.pop(context);
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            if (convert.union is ExecuteLoading)
              const Loader()
            else ...[
              if (convert.union is QuoteLoading)
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
              const ActionPreviewDivider(),
              ActionPreviewRow(
                description: 'From',
                value: formatPriceValue(
                  prefix: convert.fromAssetSymbol,
                  value: convert.fromAssetAmount,
                ),
              ),
              const ActionPreviewDivider(),
              ActionPreviewRow(
                description: 'To',
                value: formatPriceValue(
                  prefix: convert.toAssetSymbol,
                  value: convert.toAssetAmount,
                ),
                loading: convert.union is QuoteLoading,
              ),
              const ActionPreviewDivider(),
              ActionPreviewRow(
                description: 'Rate',
                value: '1 ${convert.fromAssetSymbol} = ${formatPriceValue(
                      prefix: convert.toAssetSymbol,
                      value: convert.price,
                    )}',
                loading: convert.union is QuoteLoading,
              ),
              if (convert.connectingToServer) QuoteErrorText(),
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
    );
  }
}

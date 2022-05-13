import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../../../shared/providers/device_size/device_size_pod.dart';
import '../../../../../../../shared/providers/service_providers.dart';
import '../../../../../../screens/portfolio/view/components/empty_portfolio/components/earn_bottom_sheet/earn_bottom_sheet.dart';
import '../../../../../components/show_start_earn_options.dart';
import '../../../../../models/currency_model.dart';
import 'components/empty_wallet_balance_text.dart';

class EmptyEarnWalletBody extends HookWidget {
  const EmptyEarnWalletBody({
    Key? key,
    required this.assetName,
    required this.apy,
  }) : super(key: key);

  final String assetName;
  final Decimal apy;

  @override
  Widget build(BuildContext context) {
    final intl = useProvider(intlPod);
    final colors = useProvider(sColorPod);
    final deviceSize = useProvider(deviceSizePod);

    return Column(
      children: [
        deviceSize.when(
          small: () {
            return EmptyWalletBalanceText(
              height: 128,
              baseline: 115,
              color: colors.grey2,
            );
          },
          medium: () {
            return EmptyWalletBalanceText(
              height: 184,
              baseline: 171,
              color: colors.grey2,
            );
          },
        ),
        const Spacer(),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: '${intl.earn} ',
                style: sTextH3Style.copyWith(
                  color: colors.black,
                ),
              ),
              TextSpan(
                text: '${apy.toStringAsFixed(0)}%'
                    ' ${intl.interest}',
                style: sTextH3Style.copyWith(
                  color: colors.green,
                ),
              ),
              const WidgetSpan(
                child: SpaceW10(),
              ),
              WidgetSpan(
                child: InkWell(
                  onTap: () {
                    showStartEarnBottomSheet(
                      context: context,
                      onTap: (CurrencyModel currency) {
                        Navigator.pop(context);
                        sAnalytics.earnDetailsView(currency.description);
                        showStartEarnOptions(
                          currency: currency,
                          read: context.read,
                        );
                      },
                    );
                    sAnalytics.earnProgramView(Source.emptyWalletScreen);
                  },
                  child: const SInfoIcon(),
                ),
              ),
            ],
          ),
        ),
        const SpaceH13(),
        Text(
          intl.emptyEarnWalletBody_text,
          textAlign: TextAlign.center,
          maxLines: 2,
          style: sBodyText1Style.copyWith(
            color: colors.grey1,
          ),
        ),
        const Spacer(),
      ],
    );
  }
}

import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/services/device_size/device_size.dart';
import 'package:jetwallet/features/portfolio/widgets/empty_apy_portfolio/components/earn_bottom_sheet/earn_bottom_sheet.dart';
import 'package:jetwallet/features/wallet/ui/widgets/wallet_body/widgets/empty_wallet_balance_text.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:jetwallet/widgets/show_start_earn_options.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart';

class EmptyEarnWalletBody extends StatelessObserverWidget {
  const EmptyEarnWalletBody({
    Key? key,
    required this.assetName,
    required this.apy,
  }) : super(key: key);

  final String assetName;
  final Decimal apy;

  @override
  Widget build(BuildContext context) {
    final colors = sKit.colors;
    final deviceSize = getIt.get<DeviceSize>().size;

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
                text: '${intl.emptyEarnWalletBody_earn} ',
                style: sTextH3Style.copyWith(
                  color: colors.black,
                ),
              ),
              TextSpan(
                text: '${apy.toStringAsFixed(0)}%'
                    ' ${intl.emptyEarnWalletBody_interest}',
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
                        showStartEarnOptions(
                          currency: currency,
                        );
                      },
                    );
                  },
                  child: const SInfoIcon(),
                ),
              ),
            ],
          ),
        ),
        const SpaceH13(),
        Text(
          '${intl.emptyEarnWalletBody_investIn} $assetName'
          ' ${intl.emptyEarnWalletBody_startEarningDaily}',
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

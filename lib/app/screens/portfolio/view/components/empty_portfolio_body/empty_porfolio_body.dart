import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../shared/components/show_start_earn_options.dart';
import '../../../../../shared/helpers/format_currency_string_amount.dart';
import '../../../../../shared/models/currency_model.dart';
import '../../../../../shared/providers/base_currency_pod/base_currency_pod.dart';
import 'components/earn_bottom_sheet/earn_bottom_sheet.dart';
import 'components/empty_portfolio_body_image.dart';
import 'components/empty_portfolio_body_title.dart';

class EmptyPortfolioBody extends HookWidget {
  const EmptyPortfolioBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colors = useProvider(sColorPod);
    final baseCurrency = useProvider(baseCurrencyPod);

    return SPaddingH24(
      child: Stack(
        children: [
          Positioned(
            left: 0,
            top: 0,
            child: Text(
              formatCurrencyStringAmount(
                value: '0',
                symbol: baseCurrency.symbol,
                prefix: baseCurrency.prefix,
              ),
              style: sTextH1Style,
            ),
          ),
          Column(
            children: [
              const SpaceH36(),
              const EmptyPortfolioBodyImage(),
              const SpaceH56(),
              const EmptyPortfolioBodyTitle(),
              const SpaceH17(),
              Text(
                'Let you crypto work for you!\nEarn, Trade and Withdraw with'
                ' no limits.',
                maxLines: 2,
                textAlign: TextAlign.center,
                style: sBodyText1Style.copyWith(
                  color: colors.grey1,
                ),
              ),
              const Spacer(),
              SPrimaryButton1(
                active: true,
                name: 'Start earning',
                onTap: () {
                  showStartEarnBottomSheet(
                    context: context,
                    onTap: (CurrencyModel currency) {
                      Navigator.pop(context);

                      showStartEarnOptions(
                        currency: currency,
                        read: context.read,
                      );
                    },
                  );
                },
              ),
              const SpaceH24(),
            ],
          ),
        ],
      ),
    );
  }
}

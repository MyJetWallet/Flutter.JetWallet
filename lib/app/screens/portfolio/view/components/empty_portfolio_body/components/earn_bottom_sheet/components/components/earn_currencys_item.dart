import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../../../../../shared/models/currency_model.dart';

class EarnCurrencysItem extends HookWidget {
  const EarnCurrencysItem({
    Key? key,
    required this.element,
  }) : super(key: key);

  final CurrencyModel element;
  @override
  Widget build(BuildContext context) {
    final colors = useProvider(sColorPod);

    return SizedBox(
      height: 88.0,
      child: Column(
        children: [
          const SpaceH22(),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SNetworkSvg24(
                url: element.iconUrl,
              ),
              const SpaceW10(),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Baseline(
                      baseline: 18.0,
                      baselineType: TextBaseline.alphabetic,
                      child: Text(
                        element.description,
                        style: sSubtitle2Style,
                      ),
                    ),
                    Baseline(
                      baseline: 18.0,
                      baselineType: TextBaseline.alphabetic,
                      child: Text(
                        element.assetId,
                        style: sBodyText2Style.copyWith(
                          color: colors.grey2,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SpaceW10(),
              SizedBox(
                width: 158.0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Baseline(
                      baseline: 18.0,
                      baselineType: TextBaseline.alphabetic,
                      child: Text(
                        '${element.apy.toStringAsFixed(0)}% APY',
                        style: sSubtitle2Style.copyWith(
                          color: colors.green,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Spacer(),
          const SDivider(
            width: double.infinity,
          )
        ],
      ),
    );
  }
}

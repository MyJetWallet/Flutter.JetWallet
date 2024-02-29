import 'dart:math';

import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/features/invest/ui/widgets/slider_thumb_shape.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_kit_updated/widgets/typography/simple_typography.dart';

class InvestSliderInput extends StatelessObserverWidget {
  const InvestSliderInput({
    super.key,
    required this.currentValue,
    required this.minValue,
    required this.maxValue,
    this.divisions = 5,
    this.prefix = '',
    this.withArray = false,
    this.fullScale = false,
    this.isLog = false,
    required this.arrayOfValues,
    required this.onChange,
  });

  final Decimal currentValue;
  final Decimal minValue;
  final Decimal maxValue;
  final String prefix;
  final int divisions;
  final bool withArray;
  final bool fullScale;
  final bool isLog;
  final List<Decimal> arrayOfValues;
  final Function(double) onChange;

  @override
  Widget build(BuildContext context) {
    final colors = sKit.colors;
    var currentNewValue = currentValue > maxValue
        ? maxValue
        : currentValue < minValue
        ? minValue
        : currentValue;


    if (withArray && !fullScale && !isLog) {
      var minValue = Decimal.fromInt(100000000);
      var valueToChange = 0;
      for (var i = 0; i <= divisions; i++) {
        final value = (arrayOfValues[i] ?? Decimal.zero) - currentValue;
        if (value.abs() < minValue) {
          minValue = value.abs();
          valueToChange = i;
        }
      }
      currentNewValue = Decimal.fromInt(valueToChange);
    }

    return Column(
      children: [
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: colors.black,
            inactiveTrackColor: colors.grey5,
            trackShape: const RoundedRectSliderTrackShape(),
            trackHeight: 6.0,
            thumbShape: const SliderThumbShape(disabledThumbRadius: 8),
            thumbColor: colors.black,
            overlayColor: Colors.transparent,
            overlayShape: const RoundSliderOverlayShape(overlayRadius: 0),
            tickMarkShape: const RoundSliderTickMarkShape(tickMarkRadius: 2),
            activeTickMarkColor: colors.black,
            inactiveTickMarkColor: colors.grey4,
            valueIndicatorShape: const PaddleSliderValueIndicatorShape(),
            valueIndicatorColor: colors.blue,
            valueIndicatorTextStyle: TextStyle(
              color: colors.brown,
            ),
          ),
          child: Slider(
            value: currentNewValue.toDouble(),
            min: fullScale
              ? minValue.toDouble()
              : withArray
                ? 0
                : minValue.toDouble(),
            max: fullScale
              ? maxValue.toDouble()
              : withArray
                ? divisions.toDouble()
                : maxValue.toDouble(),
            divisions: fullScale ? (maxValue - minValue).toDouble().floor() : divisions,
            onChanged: (double value) {
              if (withArray) {
                onChange(arrayOfValues[value.toInt()].toDouble() ?? 0);
              } else if (isLog) {
                onChange(exp(value).floorToDouble());
              } else {
                onChange(value);
              }
            },
          ),
        ),
        const SpaceH4(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            for (var i = 0; i < arrayOfValues.length; i++)
              InkWell(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                hoverColor: Colors.transparent,
                onTap: () {
                  onChange(arrayOfValues[i].toDouble());
                },
                child: Text(
                  '$prefix${arrayOfValues[i]}',
                  style: STStyles.body3InvestM.copyWith(
                    color: colors.grey1,
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}

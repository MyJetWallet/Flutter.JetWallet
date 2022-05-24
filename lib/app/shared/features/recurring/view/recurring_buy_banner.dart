import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/services/signal_r/model/recurring_buys_model.dart';

import '../helper/recurring_buys_image.dart';

class RecurringBuyBanner extends HookWidget {
  const RecurringBuyBanner({
    Key? key,
    required this.type,
    required this.title,
    required this.onTap,
    this.topMargin = 24.0,
  }) : super(key: key);

  final String title;
  final RecurringBuysStatus type;
  final Function() onTap;
  final double topMargin;

  @override
  Widget build(BuildContext context) {
    final colors = useProvider(sColorPod);

    return SPaddingH24(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          margin: EdgeInsets.only(top: topMargin),
          height: 68,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.0),
            color: _color(type, colors),
            border: Border.all(
              width: 3.0,
              color: _borderColor(type, colors),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SpaceW8(),
              Container(
                height: 48,
                width: 48,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24.0),
                  color: colors.grey5,
                ),
                padding: _padding(type),
                child: recurringBuysImage(type),
              ),
              const SpaceW20(),
              Flexible(
                child: Container(
                  margin: const EdgeInsets.only(
                    bottom: 4.0,
                    right: 7.0,
                  ),
                  child: Text(
                    title,
                    maxLines: 2,
                    style: sSubtitle3Style.copyWith(
                      color: _textColor(type, colors),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _color(RecurringBuysStatus type, SimpleColors colors) {
    if (type == RecurringBuysStatus.active) {
      return colors.blueLight;
    }

    if (type == RecurringBuysStatus.paused) {
      return colors.grey5;
    }

    return colors.white;
  }

  Color _borderColor(RecurringBuysStatus type, SimpleColors colors) {
    if (type == RecurringBuysStatus.active) {
      return colors.blueLight;
    }

    return colors.grey5;
  }

  EdgeInsets _padding(RecurringBuysStatus type) {
    if (type == RecurringBuysStatus.empty) {
      return const EdgeInsets.all(10.0);
    }

    return EdgeInsets.zero;
  }

  Color _textColor(RecurringBuysStatus type, SimpleColors colors) {
    if (type == RecurringBuysStatus.paused) {
      return colors.grey2;
    }

    return colors.black;
  }
}

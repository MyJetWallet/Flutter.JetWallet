import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../../service/services/signal_r/model/earn_offers_model.dart';

class EarnItemProgress extends HookWidget {
  const EarnItemProgress({
    Key? key,
    required this.offer,
  }) : super(key: key);

  final EarnOfferModel offer;

  @override
  Widget build(BuildContext context) {
    final colors = useProvider(sColorPod);
    final width = (offer.amount.toDouble() / offer.maxAmount.toDouble()) * 24;

    return Stack(
      children: [
        Container(
          width: 24,
          height: 4,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(
              Radius.circular(2),
            ),
            color: colors.black,
          ),
        ),
        Positioned(
          child: Container(
            width: width,
            height: 4,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(
                Radius.circular(2),
              ),
              color: colors.seaGreen,
            ),
          ),
        ),
      ],
    );
  }
}

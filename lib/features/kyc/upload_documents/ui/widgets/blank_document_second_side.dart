import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:simple_kit/simple_kit.dart';

class BlankDocumentSecondSide extends StatelessObserverWidget {
  const BlankDocumentSecondSide({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = sKit.colors;

    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.0),
        color: colors.grey4,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
                  height: 20.0,
                  decoration: BoxDecoration(
                    color: colors.grey5,
                    borderRadius: const BorderRadius.all(
                      Radius.circular(16.0),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SpaceH10(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: 20.0,
                width: 95.0,
                decoration: BoxDecoration(
                  color: colors.grey5,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(16.0),
                  ),
                ),
              ),
              Container(
                height: 4.0,
                width: 95.0,
                decoration: BoxDecoration(
                  color: colors.grey5,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(16.0),
                  ),
                ),
              ),
            ],
          ),
          const Spacer(),
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 4.0,
                  color: colors.grey5,
                ),
              ),
            ],
          ),
          const SpaceH20(),
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 4.0,
                  color: colors.grey5,
                ),
              ),
            ],
          ),
          const SpaceH20(),
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 4.0,
                  color: colors.grey5,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:simple_kit/simple_kit.dart';

class BlankDocumentFirstSide extends StatelessObserverWidget {
  const BlankDocumentFirstSide({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = sKit.colors;

    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.0),
            color: colors.grey4,
          ),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 80.0,
                    width: 80.0,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24.0,
                      vertical: 22.0,
                    ),
                    decoration: BoxDecoration(
                      color: colors.grey5,
                      borderRadius: const BorderRadius.all(
                        Radius.circular(16.0),
                      ),
                    ),
                    child: SSelfieIcon(
                      color: colors.grey4,
                    ),
                  ),
                  const SpaceW20(),
                  Expanded(
                    child: Container(
                      height: 20,
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
        ),
        Positioned(
          top: 50,
          left: 120,
          child: Container(
            height: 20.0,
            width: 95.0,
            decoration: BoxDecoration(
              color: colors.grey5,
              borderRadius: const BorderRadius.all(
                Radius.circular(16.0),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

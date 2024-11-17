import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';

class InvestEmptyScreen extends StatelessWidget {
  const InvestEmptyScreen({
    super.key,
    required this.height,
    required this.width,
    required this.title,
    required this.onButtonTap,
    required this.buttonName,
  });

  final Function() onButtonTap;
  final String buttonName;
  final String title;
  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {
    final colors = sKit.colors;

    return DottedBorder(
      color: colors.grey4,
      borderType: BorderType.RRect,
      radius: const Radius.circular(12),
      padding: EdgeInsets.zero,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: colors.grey5,
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(24),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: STStyles.body1InvestSM.copyWith(
                  color: colors.black,
                ),
                maxLines: 6,
                textAlign: TextAlign.center,
              ),
              const SpaceH12(),
              DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: colors.black),
                ),
                child: SIButton(
                  activeColor: Colors.transparent,
                  activeNameColor: colors.black,
                  inactiveColor: Colors.transparent,
                  inactiveNameColor: colors.grey4,
                  active: true,
                  isSecondary: true,
                  name: buttonName,
                  onTap: onButtonTap,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

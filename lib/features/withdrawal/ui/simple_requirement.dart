import 'package:flutter/material.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';

class SRequirement extends StatelessWidget {
  const SRequirement({
    super.key,
    this.isError = false,
    this.loading = false,
    required this.passed,
    required this.description,
  });

  final bool isError;
  final bool loading;
  final bool passed;
  final String description;

  @override
  Widget build(BuildContext context) {
    var color = SColorsLight().black;
    late Widget icon;

    if (isError) {
      icon = const SCrossIcon();
    } else if (loading) {
      icon = const _RequirementLoading();
    } else if (passed) {
      icon = const STickSelectedIcon();
    } else {
      icon = const STickIcon();
      color = SColorsLight().gray8;
    }

    return SizedBox(
      height: 24.0,
      child: Row(
        children: [
          icon,
          const SpaceW10(),
          Text(
            description,
            style: STStyles.captionMedium.copyWith(
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class _RequirementLoading extends StatelessWidget {
  const _RequirementLoading();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 16.0,
      height: 16.0,
      child: CircularProgressIndicator(
        color: SColorsLight().black,
        strokeWidth: 2.0,
      ),
    );
  }
}

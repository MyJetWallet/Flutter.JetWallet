import 'package:flutter/cupertino.dart';
import 'package:simple_kit_updated/widgets/badge/simple_badge_large.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(
  name: 'Neutral badge',
  type: SBadgeLarge,
)
SBadgeLarge neutralBadge(BuildContext context) {
  return const SBadgeLarge(status: BadgeStatus.neutral, text: 'Example text');
}

@widgetbook.UseCase(
  name: 'Positive badge',
  type: SBadgeLarge,
)
SBadgeLarge positiveBadge(BuildContext context) {
  return const SBadgeLarge(status: BadgeStatus.positive, text: 'Example text');
}

@widgetbook.UseCase(
  name: 'Negative badge',
  type: SBadgeLarge,
)
SBadgeLarge negativeBadge(BuildContext context) {
  return const SBadgeLarge(status: BadgeStatus.negative, text: 'Example text');
}

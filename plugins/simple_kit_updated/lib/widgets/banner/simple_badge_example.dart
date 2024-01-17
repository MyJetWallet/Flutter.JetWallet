import 'package:flutter/cupertino.dart';
import 'package:simple_kit_updated/widgets/banner/simple_badge.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(
  name: 'Neutral badge',
  type: SBadge,
)
SBadge neutralBadge(BuildContext context) {
  return const SBadge(status: SBadgeStatus.neutral, text: 'Example text');
}

@widgetbook.UseCase(
  name: 'Positive badge',
  type: SBadge,
)
SBadge positiveBadge(BuildContext context) {
  return const SBadge(status: SBadgeStatus.positive, text: 'Example text');
}

@widgetbook.UseCase(
  name: 'Negative badge',
  type: SBadge,
)
SBadge negativeBadge(BuildContext context) {
  return const SBadge(status: SBadgeStatus.negative, text: 'Example text');
}

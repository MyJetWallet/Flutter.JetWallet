import 'package:flutter/cupertino.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(
  name: 'Neutral badge',
  type: SBadgeType,
)
SBadge neutralBadge(BuildContext context) {
  return const SBadge(type: SBadgeType.neutral, lable: 'Example text');
}

@widgetbook.UseCase(
  name: 'Positive badge',
  type: SBadgeType,
)
SBadge positiveBadge(BuildContext context) {
  return const SBadge(type: SBadgeType.positive, lable: 'Example text');
}

@widgetbook.UseCase(
  name: 'Negative badge',
  type: SBadgeType,
)
SBadge negativeBadge(BuildContext context) {
  return const SBadge(type: SBadgeType.negative, lable: 'Example text');
}

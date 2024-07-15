import 'package:simple_kit_updated/gen/assets.gen.dart';

enum BottomItemType {
  home,
  market,
  invest,
  card,
  rewards,
  earn,
}

class SBottomItemModel {
  SBottomItemModel({
    required this.type,
    required this.icon,
    required this.text,
    this.notification,
  });

  final BottomItemType type;
  final SvgGenImage icon;
  final String text;

  final int? notification;
}

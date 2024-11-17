import 'package:flutter/material.dart';

const _basicTextStyle = TextStyle(
  overflow: TextOverflow.ellipsis,
  fontFamily: 'Gilroy',
);

@Deprecated('This is a widget from the old ui kit, please use the widget from the new ui kit')
final sBodyText2Style = _basicTextStyle.copyWith(
  fontSize: 14.0,
  fontWeight: FontWeight.w500,
  height: 1.50,
);

@Deprecated('This is a widget from the old ui kit, please use the widget from the new ui kit')
final sCaptionTextStyle = _basicTextStyle.copyWith(
  fontSize: 12.0,
  fontWeight: FontWeight.w500,
  height: 1.50,
);

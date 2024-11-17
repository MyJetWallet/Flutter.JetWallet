import 'package:flutter/material.dart';

const _basicTextStyle = TextStyle(
  overflow: TextOverflow.ellipsis,
  fontFamily: 'Gilroy',
);

@Deprecated('This is a widget from the old ui kit, please use the widget from the new ui kit')
final sCaptionTextStyle = _basicTextStyle.copyWith(
  fontSize: 12.0,
  fontWeight: FontWeight.w500,
  height: 1.50,
);

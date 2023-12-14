import 'package:flutter/material.dart';

class STStyles {
  static const _basicTextStyle = TextStyle(
    overflow: TextOverflow.ellipsis,
    fontFamily: 'Gilroy',
  );

  static final header1 = _basicTextStyle.copyWith(
    fontSize: 56.0,
    fontWeight: FontWeight.w600,
    height: 1.14,
  );

  static final header2 = _basicTextStyle.copyWith(
    fontSize: 40.0,
    fontWeight: FontWeight.w600,
    height: 1.2,
  );

  static final header3 = _basicTextStyle.copyWith(
    fontSize: 32.0,
    fontWeight: FontWeight.w600,
    height: 1.25,
  );

  static final header4 = _basicTextStyle.copyWith(
    fontSize: 28.0,
    fontWeight: FontWeight.w600,
    height: 1.28,
  );

  static final header5 = _basicTextStyle.copyWith(
    fontSize: 24.0,
    fontWeight: FontWeight.w600,
    height: 1.28,
  );

  static final header6 = _basicTextStyle.copyWith(
    fontSize: 20.0,
    fontWeight: FontWeight.w600,
    height: 1.28,
  );

  static final button = _basicTextStyle.copyWith(
    fontSize: 18.0,
    fontWeight: FontWeight.w700,
    height: 1.33,
  );

  static final subtitle1 = _basicTextStyle.copyWith(
    fontSize: 18.0,
    fontWeight: FontWeight.w600,
    height: 1.55,
  );

  static final subtitle2 = _basicTextStyle.copyWith(
    fontSize: 16.0,
    fontWeight: FontWeight.w600,
    height: 1.5,
  );

  static final body1Medium = _basicTextStyle.copyWith(
    fontSize: 16.0,
    fontWeight: FontWeight.w500,
    height: 1.5,
  );

  static final body1Semibold = _basicTextStyle.copyWith(
    fontSize: 16.0,
    fontWeight: FontWeight.w600,
    height: 1.5,
  );

  static final body1Bold = _basicTextStyle.copyWith(
    fontSize: 16.0,
    fontWeight: FontWeight.w700,
    height: 1.5,
  );

  static final body2Medium = _basicTextStyle.copyWith(
    fontSize: 14.0,
    fontWeight: FontWeight.w500,
    height: 1.42,
  );

  static final body2Semibold = _basicTextStyle.copyWith(
    fontSize: 14.0,
    fontWeight: FontWeight.w600,
    height: 1.42,
  );

  static final body2Bold = _basicTextStyle.copyWith(
    fontSize: 14.0,
    fontWeight: FontWeight.w700,
    height: 1.42,
  );

  static final captionMedium = _basicTextStyle.copyWith(
    fontSize: 12.0,
    fontWeight: FontWeight.w500,
    height: 1.33,
  );

  static final captionSemibold = _basicTextStyle.copyWith(
    fontSize: 12.0,
    fontWeight: FontWeight.w600,
    height: 1.33,
  );

  static final captionBold = _basicTextStyle.copyWith(
    fontSize: 12.0,
    fontWeight: FontWeight.w700,
    height: 1.33,
  );

  static final callout = _basicTextStyle.copyWith(
    fontSize: 9.0,
    fontWeight: FontWeight.w700,
    height: 1.33,
  );
}

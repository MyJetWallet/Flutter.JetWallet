import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(
  name: 'Typegraphy',
  type: ListView,
)
ListView kitTypography(BuildContext context) {
  return ListView(
    children: [
      const Gap(20),
      Text(
        'Header 1',
        style: STStyles.header1,
      ),
      const Gap(12),
      Text(
        'Header 2',
        style: STStyles.header2,
      ),
      const Gap(12),
      Text(
        'Header 3',
        style: STStyles.header3,
      ),
      const Gap(12),
      Text(
        'Header 4',
        style: STStyles.header4,
      ),
      const Gap(12),
      Text(
        'Header 5',
        style: STStyles.header5,
      ),
      const Gap(12),
      Text(
        'Header 6',
        style: STStyles.header6,
      ),
      const Gap(20),
      Text(
        'Button',
        style: STStyles.button,
      ),
      const Gap(20),
      Text(
        'Subtitle 1',
        style: STStyles.subtitle1,
      ),
      const Gap(12),
      Text(
        'Subtitle 2',
        style: STStyles.subtitle2,
      ),
      const Gap(20),
      Text(
        'Body 1 Medium',
        style: STStyles.body1Medium,
      ),
      const Gap(12),
      Text(
        'Body 1 Semibold',
        style: STStyles.body1Semibold,
      ),
      const Gap(12),
      Text(
        'Body 1 Bold',
        style: STStyles.body1Bold,
      ),
      const Gap(20),
      Text(
        'Body 2 Medium',
        style: STStyles.body2Medium,
      ),
      const Gap(12),
      Text(
        'Body 2 Semibold',
        style: STStyles.body2Semibold,
      ),
      const Gap(12),
      Text(
        'Body 2 Bold',
        style: STStyles.body2Bold,
      ),
      const Gap(20),
      Text(
        'Caption Medium',
        style: STStyles.captionMedium,
      ),
      const Gap(12),
      Text(
        'Caption Semibold',
        style: STStyles.captionSemibold,
      ),
      const Gap(12),
      Text(
        'Caption Bold',
        style: STStyles.captionBold,
      ),
      const Gap(20),
      Text(
        'Callout',
        style: STStyles.callout,
      ),
    ],
  );
}

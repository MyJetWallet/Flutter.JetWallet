import 'package:flutter/material.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../../../shared/helpers/navigator_push.dart';

class ChooseDocuments extends StatelessWidget {
  const ChooseDocuments({
    Key? key,
    required this.headerTitle,
  }) : super(key: key);

  final String headerTitle;

  static void push({
    required BuildContext context,
    required String headerTitle,
  }) {
    navigatorPush(
      context,
      ChooseDocuments(
          headerTitle: headerTitle,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SPageFrameWithPadding(
      header: SSmallHeader(
        title: headerTitle,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

        ],
      ),
    );
  }
}

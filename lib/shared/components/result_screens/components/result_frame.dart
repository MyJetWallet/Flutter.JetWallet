import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../page_frame/page_frame.dart';
import '../../spacers.dart';
import 'result_description_text.dart';
import 'result_icon.dart';
import 'result_text.dart';

class ResultFrame extends StatelessWidget {
  const ResultFrame({
    Key? key,
    required this.header,
    required this.resultIcon,
    required this.title,
    required this.description,
    this.children = const [],
  }) : super(key: key);

  final String header;
  final ResultIcon resultIcon;
  final String title;
  final String description;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return PageFrame(
      header: header,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
          resultIcon,
          const SpaceH30(),
          ResultText(
            text: title,
          ),
          const SpaceH15(),
          ResultDescriptionText(
            text: description,
          ),
          const Spacer(),
          Column(
            children: children,
          ),
        ],
      ),
    );
  }
}

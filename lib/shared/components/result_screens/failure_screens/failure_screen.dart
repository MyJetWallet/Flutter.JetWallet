import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../buttons/app_button_outlined.dart';
import '../../buttons/app_button_solid.dart';
import '../../spacers.dart';
import '../components/result_frame.dart';
import '../components/result_icon.dart';

class FailureScreen extends StatelessWidget {
  const FailureScreen({
    Key? key,
    required this.header,
    required this.description,
    required this.firstButtonName,
    required this.secondButtonName,
    required this.onFirstButton,
    required this.onSecondButton,
  }) : super(key: key);

  final String header;
  final String description;
  final String firstButtonName;
  final String secondButtonName;
  final Function() onFirstButton;
  final Function() onSecondButton;

  @override
  Widget build(BuildContext context) {
    return ResultFrame(
      header: header,
      resultIcon: const ResultIcon(
        FontAwesomeIcons.exclamationCircle,
        color: Colors.redAccent,
      ),
      title: 'Failed',
      description: description,
      children: [
        AppButtonSolid(
          name: firstButtonName,
          onTap: onFirstButton,
        ),
        const SpaceH10(),
        AppButtonOutlined(
          name: secondButtonName,
          onTap: onSecondButton,
        ),
      ],
    );
  }
}

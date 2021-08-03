import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../buttons/app_button_solid.dart';
import '../components/result_frame.dart';
import '../components/result_icon.dart';

class NoResponseFromServer extends StatelessWidget {
  const NoResponseFromServer({
    Key? key,
    required this.header,
    required this.description,
    required this.onOk,
  }) : super(key: key);

  final String header;
  final String description;
  final Function() onOk;

  @override
  Widget build(BuildContext context) {
    return ResultFrame(
      header: header,
      resultIcon: const ResultIcon(
        FontAwesomeIcons.exclamationCircle,
        color: Colors.redAccent,
      ),
      title: 'No response from server',
      description: description,
      children: [
        AppButtonSolid(
          name: 'OK',
          onTap: onOk,
        ),
      ],
    );
  }
}

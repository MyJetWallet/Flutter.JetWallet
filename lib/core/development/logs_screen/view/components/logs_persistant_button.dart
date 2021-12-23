import 'package:flutter/material.dart';

import '../../../../../shared/helpers/navigator_push.dart';
import '../logs_screen.dart';

class LogsPersistantButton extends StatelessWidget {
  const LogsPersistantButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      child: SafeArea(
        child: GestureDetector(
          onLongPress: () => navigatorPush(context, const LogsScreen()),
          child: Container(
            color: Colors.green,
            height: 20.0,
            width: 20.0,
          ),
        ),
      ),
    );
  }
}

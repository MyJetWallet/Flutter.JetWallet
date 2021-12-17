import 'package:flutter/material.dart';

import '../../colors/view/simple_colors_light.dart';

class NotificationBox extends StatelessWidget {
  const NotificationBox({
    Key? key,
    required this.notifications,
  }) : super(key: key);

  final int notifications;

  @override
  Widget build(BuildContext context) {
    var text = '$notifications';

    if (notifications >= 100) text = '99+';

    if (notifications == 0) {
      return const SizedBox();
    } else {
      return Positioned(
        right: 0,
        child: Container(
          margin: const EdgeInsets.only(
            top: 6.0,
            right: 6.0,
          ),
          child: Container(
            padding: const EdgeInsets.all(2.0),
            decoration: BoxDecoration(
              color: SColorsLight().white,
              borderRadius: BorderRadius.circular(18.0),
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                minWidth: 18.0,
                minHeight: 18.0,
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: SColorsLight().blue,
                  borderRadius: BorderRadius.circular(18.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 3.4,
                  ),
                  child: Center(
                    child: Text(
                      text,
                      style: TextStyle(
                        fontSize: 9.0,
                        color: SColorsLight().white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }
  }
}

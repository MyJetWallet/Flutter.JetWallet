import 'package:flutter/material.dart';
import 'package:simple_kit/modules/colors/simple_colors_light.dart';

class NotificationBox extends StatelessWidget {
  const NotificationBox({
    super.key,
    required this.notifications,
    this.cardsFailed = false,
  });

  final int notifications;
  final bool cardsFailed;

  @override
  Widget build(BuildContext context) {
    var text = cardsFailed ? ' ! ' : '$notifications';

    if (notifications >= 100 && !cardsFailed) text = '99+';

    return notifications == 0 && !cardsFailed
        ? const SizedBox()
        : Container(
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
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: cardsFailed ? SColorsLight().red : SColorsLight().blue,
                  borderRadius: BorderRadius.circular(18.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 3.4,
                    right: 3.4,
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
        );
  }
}

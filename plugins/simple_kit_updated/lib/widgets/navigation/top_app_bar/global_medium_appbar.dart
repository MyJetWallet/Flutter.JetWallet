import 'package:flutter/material.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';

class SimpleAccountCategoryHeader extends StatelessWidget {
  const SimpleAccountCategoryHeader({
    super.key,
    required this.userEmail,
    required this.userFirstName,
    required this.userLastName,
    required this.showUserName,
    required this.isVerified,
    required this.onIconTap,
    required this.icon,
    required this.iconText,
  });

  final String userEmail;
  final String userFirstName;
  final String userLastName;
  final bool showUserName;
  final bool isVerified;
  final Function() onIconTap;
  final Widget icon;
  final String iconText;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: EdgeInsets.only(
          top: (MediaQuery.of(context).padding.top <= 24 ? 16 : 0) + 12, //отступ шторки + отступ аппбара (12)
          bottom: 16,
          left: 24,
          right: 24,
        ),
        child: Row(
          children: <Widget>[
            SafeGesture(
              onTap: () {
                Navigator.pop(context);
              },
              child: Assets.svg.medium.arrowLeft.simpleSvg(),
            ),
            SizedBox(width: 16),
            GestureDetector(
              onTap: onIconTap,
              child: Stack(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: const ShapeDecoration(
                      gradient: LinearGradient(
                        end: Alignment(0.90, -0.44),
                        begin: Alignment(-0.9, 0.44),
                        colors: [Color(0xFFCBB9FF), Color(0xFF9575F3)],
                      ),
                      shape: OvalBorder(),
                    ),
                  ),
                  Positioned.fill(
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        userEmail.isNotEmpty
                            ? showUserName
                                ? '${userFirstName.substring(0, 1).toUpperCase()}'
                                    '${userLastName.substring(0, 1).toUpperCase()}'
                                : userEmail.substring(0, 1).toUpperCase()
                            : '',
                        style: STStyles.button.copyWith(
                          color: SColorsLight().white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: 2),
                  if (showUserName)
                    Text(
                      '$userFirstName $userLastName',
                      style: STStyles.header6,
                    ),
                  SizedBox(height: 2),
                  if (isVerified)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        icon,
                        SizedBox(width: 4),
                        Column(
                          children: [
                            SizedBox(height: 2),
                            Text(
                              iconText,
                              style: STStyles.body2Medium.copyWith(
                                color: SColorsLight().green,
                                height: 1,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

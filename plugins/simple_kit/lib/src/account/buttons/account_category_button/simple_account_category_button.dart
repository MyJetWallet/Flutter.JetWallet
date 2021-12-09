import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../simple_kit.dart';


class SimpleAccountCategoryButton extends StatelessWidget {
  const SimpleAccountCategoryButton({
    Key? key,
    this.onTap,
    required this.icon,
    required this.title,
    required this.isSDivider,
    this.onSwitchChanged,
    this.switchValue = false,
  }) : super(key: key);

  final Widget icon;
  final Function()? onTap;
  final String title;
  final bool isSDivider;
  final Function(bool)? onSwitchChanged;
  final bool switchValue;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: SPaddingH24(
        child: Column(
          children: <Widget>[
            Container(
              height: 30.0,
              margin: const EdgeInsets.symmetric(
                vertical: 18.0,
              ),
              child: Row(
                children: <Widget>[
                  icon,
                  const SpaceW20(),
                  Expanded(
                    child: Text(
                      title,
                      style: sSubtitle1Style,
                    ),
                  ),
                  if (onSwitchChanged != null)
                    Container(
                      width: 40.0,
                      height: 22.0,
                      decoration: BoxDecoration(
                        color: switchValue ? Colors.black : Colors.grey,
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: Switch(
                        value: switchValue,
                        onChanged: onSwitchChanged,
                        activeColor: Colors.white,
                        activeTrackColor: Colors.black,
                        inactiveThumbColor: Colors.white,
                        inactiveTrackColor: Colors.grey,
                      ),
                    )
                ],
              ),
            ),
            if (isSDivider)
              const SDivider(),
          ],
        ),
      ),
    );
  }
}

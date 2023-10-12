import 'package:flutter/material.dart';
import 'package:simple_kit/simple_kit.dart';

class BuyOptionWidget extends StatelessWidget {
  const BuyOptionWidget({
    super.key,
    required this.icon,
    required this.title,
    required this.subTitle,
    this.trailing,
    required this.onTap,
  });

  final Widget icon;
  final String title;
  final String subTitle;
  final String? trailing;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    final colors = sKit.colors;

    return Container(
      width: double.infinity,
      height: 56,
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsetsDirectional.symmetric(horizontal: 24),
      padding: const EdgeInsetsDirectional.symmetric(horizontal: 12, vertical: 8),
      decoration: ShapeDecoration(
        color: colors.grey5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: InkWell(
        onTap: onTap,
        child: Row(
          children: [
            icon,
            const SpaceW8(),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  subTitle,
                  style: const TextStyle(
                    color: Color(0xFF777C85),
                    fontSize: 14,
                    fontFamily: 'Gilroy',
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontFamily: 'Gilroy',
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const Spacer(),
            Text(
              trailing ?? '',
              textAlign: TextAlign.right,
              style: const TextStyle(
                color: Color(0xFF777C85),
                fontSize: 14,
                fontFamily: 'Gilroy',
                fontWeight: FontWeight.w600,
              ),
            ),
            const SpaceW8(),
            SizedBox(
              width: 20,
              height: 20,
              child: SBlueRightArrowIcon(
                color: colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

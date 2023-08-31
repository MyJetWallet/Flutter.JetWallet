import 'package:flutter/material.dart';
import 'package:simple_kit/simple_kit.dart';

class PortfolioNftEmptyItem extends StatelessWidget {
  const PortfolioNftEmptyItem({
    super.key,
    required this.text,
    required this.icon,
    required this.onTap,
  });

  final String text;
  final Widget icon;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    final colors = sKit.colors;

    return InkWell(
      onTap: onTap,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.4,
        padding: const EdgeInsets.symmetric(vertical: 23, horizontal: 15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(width: 3, color: colors.grey5),
        ),
        child: Column(
          children: [
            icon,
            const SpaceH15(),
            Text(text, style: sBodyText2Style),
          ],
        ),
      ),
    );
  }
}

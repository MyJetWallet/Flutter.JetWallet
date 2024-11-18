import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';

class SectorsBlock extends StatelessObserverWidget {
  const SectorsBlock({
    super.key,
    required this.title,
    required this.onTap,
    required this.inageUrl,
    this.description,
    this.isAllCoins = false,
  });

  final bool isAllCoins;
  final String title;
  final String inageUrl;
  final String? description;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    final colors = SColorsLight();

    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      hoverColor: Colors.transparent,
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        width: 64,
        child: Column(
          children: [
            CircleAvatar(
              radius: 32,
              child: Image.network(inageUrl),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: STStyles.body1InvestSM.copyWith(
                color: colors.black,
              ),
              maxLines: 2,
              textAlign: TextAlign.center,
            ),
            if (!isAllCoins)
              Text(
                description ?? '',
                style: STStyles.body2InvestM.copyWith(
                  color: colors.black,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

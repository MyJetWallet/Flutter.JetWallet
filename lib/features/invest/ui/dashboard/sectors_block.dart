import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:simple_kit/core/simple_kit.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';

class SectorsBlock extends StatelessObserverWidget {
  const SectorsBlock({
    super.key,
    required this.title,
    required this.onTap,
    this.description,
    this.isAllCoins = false,
  });

  final bool isAllCoins;
  final String title;
  final String? description;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {

    final colors = sKit.colors;

    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      hoverColor: Colors.transparent,
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        height: 60,
        width: isAllCoins ? MediaQuery.of(context).size.width - 48 : 130,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: isAllCoins ? colors.grey4 : colors.grey5,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: STStyles.body1InvestSM.copyWith(
                color: colors.black,
              ),
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

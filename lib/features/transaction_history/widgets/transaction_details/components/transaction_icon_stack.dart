import 'package:flutter/material.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';

class TransactionIconStack extends StatelessWidget {
  const TransactionIconStack({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 42,
      width: 46,
      child: Stack(
        fit: StackFit.expand,
        children: [
           Expanded(
            child: Assets.svg.categories.icons.deposit.simpleSvg(
              width: 40,
              height: 40,
            ),
          ),
        ],
      ),
    );
  }
}
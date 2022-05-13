import 'package:flutter/material.dart';
import 'package:simple_kit/simple_kit.dart';
import '../../../../../../../../../shared/constants.dart';

class EarnPagePinned extends StatelessWidget {
  const EarnPagePinned({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 180,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24.0),
              topRight: Radius.circular(24.0),
            ),
            image: DecorationImage(
              image: AssetImage(
                earnGroupImageAsset,
              ),
              fit: BoxFit.fill,
            ),
          ),
        ),
        Positioned(
          top: 26.0,
          right: 26.0,
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const SEraseMarketIcon(),
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:jetwallet/utils/constants.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart';

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
          width: MediaQuery.of(context).size.width,
          top: 8,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 35.0,
                height: 4.0,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(
                    Radius.circular(4.0),
                  ),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          top: 26.0,
          right: 26.0,
          child: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: const SEraseMarketIcon(),
          ),
        ),
      ],
    );
  }
}

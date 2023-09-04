import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:simple_kit/simple_kit.dart';

class CountryName extends StatelessObserverWidget {
  const CountryName({
    super.key,
    required this.countryName,
  });

  final String countryName;

  @override
  Widget build(BuildContext context) {
    final colors = sKit.colors;
    final size = MediaQuery.of(context).size;

    return Baseline(
      baseline: 38.0,
      baselineType: TextBaseline.alphabetic,
      child: Row(
        children: [
          const SpaceW10(),
          SizedBox(
            width: size.width - 140.0,
            child: Text(
              countryName,
              style: sSubtitle2Style.copyWith(
                color: colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

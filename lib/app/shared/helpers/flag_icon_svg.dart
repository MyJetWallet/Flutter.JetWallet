import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'flag_asset_name.dart';

class FlagIconSvg extends StatelessWidget {
  const FlagIconSvg({
    Key? key,
    required this.countryCode,
  }) : super(key: key);

  final String countryCode;

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
      ),
      height: 24,
      width: 24,
      child: SvgPicture.asset(
        flagAssetName(countryCode),
        fit: BoxFit.fill,
        height: 24,
        width: 24,
      ),
    );
  }
}

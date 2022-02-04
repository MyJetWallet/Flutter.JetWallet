import 'package:flutter/material.dart';

import '../../../../../../../shared/constants.dart';

class EmptyPortfolioBodyImage extends StatelessWidget {
  const EmptyPortfolioBodyImage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      earnImageAsset,
      width: 280,
      height: 280,
    );
  }
}

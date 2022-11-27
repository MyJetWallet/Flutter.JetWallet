import 'package:flutter/material.dart';
import 'package:simple_kit/modules/colors/simple_colors_light.dart';
import 'components/simple_document_recommendation.dart';

class SDocumentsRecommendations extends StatelessWidget {
  const SDocumentsRecommendations({
    Key? key,
    required this.primaryText1,
    required this.primaryText2,
    required this.primaryText3,
    required this.primaryText4,
    required this.primaryText5,
    required this.primaryText6,
  }) : super(key: key);

  final String primaryText1;
  final String primaryText2;
  final String primaryText3;
  final String primaryText4;
  final String primaryText5;
  final String primaryText6;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SDocumentRecommendation(
          primaryText: '$primaryText1:',
        ),
        SDocumentRecommendation(
          primaryText: ' $primaryText2',
          primaryTextColor: SColorsLight().grey1,
        ),
        SDocumentRecommendation(
          primaryText: ' $primaryText3',
          primaryTextColor: SColorsLight().grey1,
        ),
        SDocumentRecommendation(
          primaryText: ' $primaryText4',
          primaryTextColor: SColorsLight().grey1,
        ),
        SDocumentRecommendation(
          primaryText: ' $primaryText5',
          primaryTextColor: SColorsLight().grey1,
        ),
        SDocumentRecommendation(
          primaryText: ' $primaryText6',
          primaryTextColor: SColorsLight().grey1,
        ),
      ],
    );
  }
}

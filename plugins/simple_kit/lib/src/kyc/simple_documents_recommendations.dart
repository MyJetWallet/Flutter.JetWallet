import 'package:flutter/material.dart';
import '../colors/view/simple_colors_light.dart';
import 'components/simple_document_recommendation.dart';

class SDocumentsRecommendations extends StatelessWidget {
  const SDocumentsRecommendations({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SDocumentRecommendation(
          primaryText: 'The document should clearly show:',
        ),
        SDocumentRecommendation(
          primaryText: ' Your Full Name',
          primaryTextColor: SColorsLight().grey1,
        ),
        SDocumentRecommendation(
          primaryText: ' Your Photo',
          primaryTextColor: SColorsLight().grey1,
        ),
        SDocumentRecommendation(
          primaryText: ' Date of Birth',
          primaryTextColor: SColorsLight().grey1,
        ),
        SDocumentRecommendation(
          primaryText: ' Expiry Date',
          primaryTextColor: SColorsLight().grey1,
        ),
        SDocumentRecommendation(
          primaryText: ' Document Number',
          primaryTextColor: SColorsLight().grey1,
        ),
      ],
    );
  }
}

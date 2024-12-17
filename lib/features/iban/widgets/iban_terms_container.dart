import 'package:flutter/material.dart';
import 'package:flutter_ui_kit/flutter_ui_kit.dart';
import 'package:simple_kit/simple_kit.dart';

class IbanTermsContainer extends StatelessWidget {
  const IbanTermsContainer({
    super.key,
    required this.text1,
    required this.text2,
    this.addAccount = false,
  });

  final String text1;
  final String text2;
  final bool addAccount;

  @override
  Widget build(BuildContext context) {
    final colors = SColorsLight();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 24,
        vertical: 20,
      ),
      decoration: BoxDecoration(
        color: colors.yellowLight,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SBankIcon(),
              const SpaceW14(),
              Text(
                text1,
                style: STStyles.body2Medium,
              ),
            ],
          ),
          const SpaceH12(),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: SUserIcon(
                  color: colors.black,
                ),
              ),
              const SpaceW14(),
              SizedBox(
                width: MediaQuery.of(context).size.width - 88,
                child: Text(
                  text2,
                  style: STStyles.body2Medium,
                  maxLines: 15,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

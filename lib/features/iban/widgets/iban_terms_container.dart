import 'package:flutter/material.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:simple_kit/simple_kit.dart';

class IbanTermsContainer extends StatelessWidget {
  const IbanTermsContainer({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = sKit.colors;

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
                intl.iban_terms_1,
                style: sBodyText2Style,
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
                  intl.iban_terms_3,
                  style: sBodyText2Style,
                  maxLines: 3,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

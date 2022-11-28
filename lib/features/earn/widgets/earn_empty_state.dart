import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/utils/constants.dart';
import 'package:simple_kit/simple_kit.dart';

class EarnEmptyState extends StatelessObserverWidget {
  const EarnEmptyState({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final colors = sKit.colors;

    return SliverToBoxAdapter(
      child: SizedBox(
        height: screenHeight - 216,
        child: SPaddingH24(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                earnEmptyStateImage,
                width: 80,
                height: 80,
              ),
              const SpaceH32(),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  text: intl.earn_empty,
                  style: sTextH3Style.copyWith(
                    color: colors.black,
                  ),
                ),
              ),
              const SpaceH13(),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  text: intl.earn_empty_description,
                  style: sBodyText1Style.copyWith(
                    color: colors.grey1,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

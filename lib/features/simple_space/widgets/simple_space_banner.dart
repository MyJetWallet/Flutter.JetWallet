import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/utils/constants.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';

// TODO (Yaroslav): this widget isn't using
class SimpleSpaceBanner extends StatelessWidget {
  const SimpleSpaceBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = SColorsLight();
    return Observer(
      builder: (context) {
        return SafeGesture(
          onTap: () {
            sRouter.push(const SimpleSpaceRouter());
          },
          child: Container(
            padding: const EdgeInsets.only(
              top: 16,
              left: 20,
              right: 20,
              bottom: 20,
            ),
            decoration: ShapeDecoration(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              color: colors.gray2,
            ),
            child: Row(
              children: [
                Image.asset(
                  simpleSpaceLogo,
                  width: 48,
                  height: 48,
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      intl.simplecoin_simple_space,
                      style: STStyles.body1Bold,
                    ),
                    Text(
                      intl.simplecoin_beta,
                      style: STStyles.body2Medium.copyWith(
                        color: colors.gray8,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Assets.svg.medium.shevronRight.simpleSvg(
                  width: 20,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

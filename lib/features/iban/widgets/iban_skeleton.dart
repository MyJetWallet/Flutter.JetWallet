import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:simple_kit/core/simple_kit.dart';
import 'package:simple_kit/modules/icons/24x24/public/info/simple_info_icon.dart';
import 'package:simple_kit/modules/shared/simple_paddings.dart';
import 'package:simple_kit/modules/shared/simple_skeleton_text_loader.dart';
import 'package:simple_kit/modules/shared/simple_spacers.dart';
import 'package:simple_kit/modules/texts/simple_text_styles.dart';

import '../../../core/l10n/i10n.dart';
import 'iban_item_skeleton.dart';

class IBanSkeleton extends StatelessObserverWidget {
  const IBanSkeleton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colors = sKit.colors;

    return SingleChildScrollView(
      child: Column(
        children: [
          const SpaceH30(),
          SPaddingH24(
            child: SSkeletonTextLoader(
              height: 128,
              width: MediaQuery.of(context).size.width - 48,
            ),
          ),
          const SpaceH16(),
          IBanItemSkeleton(
            name: intl.iban_benificiary,
          ),
          IBanItemSkeleton(
            name: intl.iban_iban,
          ),
          IBanItemSkeleton(
            name: intl.iban_bic,
          ),
          const SpaceH20(),

          SPaddingH24(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SInfoIcon(
                  color: colors.black,
                ),
                const SpaceW16(),
                SizedBox(
                  width: MediaQuery.of(context).size.width - 88,
                  child: Text(
                    intl.iban_terms,
                    style: sBodyText2Style,
                    maxLines: 5,
                  ),
                ),
              ],
            ),
          ),
          const SpaceH42(),
        ],
      ),
    );
  }

}

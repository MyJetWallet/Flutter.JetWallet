import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/remote_config/remote_config_values.dart';
import 'package:jetwallet/features/market/market_details/ui/widgets/about_block/components/clickable_underlined_text.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart';

import 'components/earn_page_advantages.dart';
import 'components/earn_page_body_header.dart';

class EarnPageBody extends StatelessObserverWidget {
  const EarnPageBody({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colors = sKit.colors;

    return Column(
      children: [
        const SpaceH33(),
        SPaddingH24(
          child: EarnPageBodyHeader(
            colors: colors,
          ),
        ),
        const SpaceH32(),
        const SPaddingH24(
          child: EarnPageAdvantages(),
        ),
        if (infoEarnLink.isNotEmpty) ...[
          const SpaceH32(),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SPaddingH24(
                child: ClickableUnderlinedText(
                  text: intl.earn_learn_more,
                  onTap: () {

                    sRouter.push(
                      InfoWebViewRouter(
                        link: infoEarnLink,
                        title: intl.earn_program,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
        const SpaceH72(),
      ],
    );
  }
}

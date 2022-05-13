import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../../shared/helpers/navigator_push.dart';
import '../../../../../../shared/providers/service_providers.dart';
import '../../../../../../shared/services/remote_config_service/remote_config_values.dart';
import '../../../../../shared/components/info_web_view.dart';
import '../../../../../shared/features/market_details/view/components/about_block/components/clickable_underlined_text.dart';
import 'components/earn_page_advantages.dart';
import 'components/earn_page_body_header.dart';

class EarnPageBody extends HookWidget {
  const EarnPageBody({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colors = useProvider(sColorPod);
    final intl = useProvider(intlPod);

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
                    navigatorPush(
                      context,
                      InfoWebView(
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

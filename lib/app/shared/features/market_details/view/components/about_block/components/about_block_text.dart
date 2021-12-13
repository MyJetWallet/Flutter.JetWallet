import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../../../../service/services/market_info/model/market_info_response_model.dart';
import '../../../../../../../../shared/helpers/launch_url.dart';
import 'clickable_underlined_text.dart';

class AboutBlockText extends HookWidget {
  const AboutBlockText({
    Key? key,
    required this.marketInfo,
  }) : super(key: key);

  final MarketInfoResponseModel marketInfo;

  @override
  Widget build(BuildContext context) {
    final expandText = useState(false);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          expandText.value ? marketInfo.aboutMore : marketInfo.aboutLess,
          maxLines: expandText.value ? 10 : 4,
          style: sBodyText1Style.copyWith(color: Colors.black),
        ),
        const SpaceH18(),
        ClickableUnderlinedText(
          text: expandText.value ? 'Read less' : 'Read more',
          onTap: () => expandText.value = !expandText.value,
        ),
        if (_urlValid(marketInfo.whitepaperUrl)) ...[
          const SpaceH15(),
          ClickableUnderlinedText(
            text: 'Whitepaper',
            onTap: () => launchURL(context, marketInfo.whitepaperUrl!),
          ),
        ],
        if (_urlValid(marketInfo.officialWebsiteUrl)) ...[
          const SpaceH15(),
          ClickableUnderlinedText(
            text: 'Official website',
            onTap: () => launchURL(context, marketInfo.officialWebsiteUrl!),
          ),
        ],
        const SpaceH33(),
        const SDivider(),
      ],
    );
  }

  bool _urlValid(String? url) => url != null && url.isNotEmpty;
}

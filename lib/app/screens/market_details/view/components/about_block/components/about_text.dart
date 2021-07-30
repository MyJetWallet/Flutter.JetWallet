import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import '../../../../../../../service/services/wallet/model/market_info/market_info_response_model.dart';
import '../../../../../../../shared/components/spacers.dart';
import '../../../../../../../shared/helpers/launch_url.dart';

import 'clickable_underlined_text.dart';

class AboutTextBlock extends HookWidget {
  const AboutTextBlock({
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
          style: const TextStyle(
            color: Colors.grey,
          ),
        ),
        const SpaceH8(),
        ClickableUnderlinedText(
          text: expandText.value ? 'Read less' : 'Read more',
          onTap: () => expandText.value = !expandText.value,
        ),
        const SpaceH4(),
        const Divider(),
        ClickableUnderlinedText(
          text: 'Whitepaper',
          onTap: () => launchURL(context, marketInfo.whitepaperUrl)
        ),
        const SpaceH4(),
        const Divider(),
        ClickableUnderlinedText(
            text: 'Official website',
            onTap: () => launchURL(context, marketInfo.officialWebsiteUrl)
        ),
      ],
    );
  }
}

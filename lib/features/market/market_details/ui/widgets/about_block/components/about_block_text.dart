import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/utils/helpers/launch_url.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/modules/wallet_api/models/market_info/market_info_response_model.dart';
import 'clickable_underlined_text.dart';

class AboutBlockText extends StatefulObserverWidget {
  const AboutBlockText({
    Key? key,
    required this.marketInfo,
    required this.showDivider,
  }) : super(key: key);

  final MarketInfoResponseModel marketInfo;
  final bool showDivider;

  @override
  State<AboutBlockText> createState() => _AboutBlockTextState();
}

class _AboutBlockTextState extends State<AboutBlockText>
    with WidgetsBindingObserver {
  bool canTapOnLink = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      setState(() {
        canTapOnLink = true;
      });
    }
  }

  bool expandText = false;

  @override
  Widget build(BuildContext context) {
    print(widget.marketInfo);

    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.marketInfo.aboutLess.isNotEmpty)
            Text(
              expandText
                  ? widget.marketInfo.aboutMore
                  : widget.marketInfo.aboutLess,
              maxLines: expandText ? 10 : 4,
              style: sBodyText1Style.copyWith(color: Colors.black),
            ),
          if (!expandText && widget.marketInfo.aboutLess.isNotEmpty) ...[
            const SpaceH18(),
            ClickableUnderlinedText(
              text: intl.aboutBlockText_readMore,
              onTap: () => expandText = !expandText,
            ),
          ],
          if (_urlValid(widget.marketInfo.whitepaperUrl)) ...[
            if (widget.marketInfo.aboutLess.isNotEmpty) const SpaceH13(),
            ClickableUnderlinedText(
              text: intl.aboutBlockText_whitepaper,
              onTap: () {
                _openUrl(widget.marketInfo.whitepaperUrl!);
              },
            ),
          ],
          if (_urlValid(widget.marketInfo.officialWebsiteUrl)) ...[
            const SpaceH13(),
            ClickableUnderlinedText(
              text: intl.aboutBlockText_officialWebsite,
              onTap: () {
                if (canTapOnLink) {
                  setState(() {
                    canTapOnLink = false;
                  });
                  launchURL(context, widget.marketInfo.officialWebsiteUrl!);
                }
              },
            ),
          ],
          const SpaceH33(),
          if (widget.showDivider) const SDivider(),
        ],
      ),
    );
  }

  bool _urlValid(String? url) => url != null && url.isNotEmpty;

  void _openUrl(String url) {
    if (url.contains('.pdf')) {
      sRouter.push(
        PDFViewScreenRouter(url: url),
      );

      return;
    }

    if (canTapOnLink) {
      setState(() {
        canTapOnLink = false;
      });
      launchURL(context, url);
    }
  }
}

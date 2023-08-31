import 'package:flutter/material.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/utils/constants.dart';
import 'package:jetwallet/utils/helpers/launch_url.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/modules/wallet_api/models/market_info/market_info_response_model.dart';
import 'clickable_underlined_text.dart';

class AboutBlockText extends StatefulWidget {
  const AboutBlockText({
    super.key,
    required this.marketInfo,
    required this.showDivider,
    required this.isCpower,
  });

  final MarketInfoResponseModel marketInfo;
  final bool showDivider;
  final bool isCpower;

  @override
  State<AboutBlockText> createState() => _AboutBlockTextState();
}

class _AboutBlockTextState extends State<AboutBlockText>
    with WidgetsBindingObserver {
  bool canTapOnLink = true;
  bool expandText = false;

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

  @override
  Widget build(BuildContext context) {
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
              maxLines: expandText ? 20 : 4,
              style: sBodyText1Style.copyWith(color: Colors.black),
            ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (!expandText &&
                      widget.marketInfo.aboutLess.isNotEmpty) ...[
                    const SpaceH18(),
                    ClickableUnderlinedText(
                      text: intl.aboutBlockText_readMore,
                      onTap: () {
                        setState(() {
                          expandText = !expandText;
                        });
                      },
                    ),
                  ],
                  if (_urlValid(widget.marketInfo.whitepaperUrl)) ...[
                    if (widget.marketInfo.aboutLess.isNotEmpty)
                      const SpaceH15(),
                    ClickableUnderlinedText(
                      text: intl.aboutBlockText_whitepaper,
                      onTap: () {
                        _openUrl(widget.marketInfo.whitepaperUrl!);
                      },
                    ),
                  ],
                  if (_urlValid(widget.marketInfo.officialWebsiteUrl)) ...[
                    const SpaceH15(),
                    ClickableUnderlinedText(
                      text: intl.aboutBlockText_officialWebsite,
                      onTap: () {
                        if (canTapOnLink) {
                          setState(() {
                            canTapOnLink = false;
                          });
                          launchURL(
                              context, widget.marketInfo.officialWebsiteUrl!);
                        }
                      },
                    ),
                  ],
                ],
              ),
              if (widget.isCpower) ...[
                Column(
                  children: [
                    const SpaceH13(),
                    Image.asset(
                      cPowerAsset,
                      width: 100,
                      height: 100,
                    ),
                  ],
                ),
              ],
            ],
          ),
          const SpaceH33(),
          if (widget.showDivider || widget.isCpower) const SDivider(),
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

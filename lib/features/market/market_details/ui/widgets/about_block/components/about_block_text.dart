import 'package:flutter/material.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/utils/constants.dart';
import 'package:jetwallet/utils/helpers/launch_url.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';
import 'package:simple_networking/modules/wallet_api/models/market_info/market_info_response_model.dart';

class AboutBlockText extends StatefulWidget {
  const AboutBlockText({
    super.key,
    required this.marketInfo,
    required this.isCpower,
  });

  final MarketInfoResponseModel marketInfo;
  final bool isCpower;

  @override
  State<AboutBlockText> createState() => _AboutBlockTextState();
}

class _AboutBlockTextState extends State<AboutBlockText> with WidgetsBindingObserver {
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
    final colors = SColorsLight();
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.marketInfo.aboutLess.isNotEmpty)
            Text(
              expandText ? widget.marketInfo.aboutMore : widget.marketInfo.aboutLess,
              maxLines: expandText ? 20 : 4,
              style: STStyles.body1Medium.copyWith(color: colors.gray10),
            ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Wrap(
                  spacing: 24,
                  runSpacing: 24,
                  children: [
                    if (!expandText && widget.marketInfo.aboutLess.isNotEmpty) ...[
                      SHyperlink(
                        text: intl.aboutBlockText_readMore,
                        onTap: () {
                          setState(() {
                            expandText = !expandText;
                          });
                        },
                      ),
                    ],
                    if (_urlValid(widget.marketInfo.whitepaperUrl)) ...[
                      SHyperlink(
                        text: intl.aboutBlockText_whitepaper,
                        onTap: () {
                          _openUrl(widget.marketInfo.whitepaperUrl!);
                        },
                      ),
                    ],
                    if (_urlValid(widget.marketInfo.officialWebsiteUrl)) ...[
                      SHyperlink(
                        text: intl.aboutBlockText_officialWebsite,
                        onTap: () {
                          if (canTapOnLink) {
                            setState(() {
                              canTapOnLink = false;
                            });
                            launchURL(
                              context,
                              widget.marketInfo.officialWebsiteUrl!,
                            ).then((_) {
                              setState(() {
                                canTapOnLink = true;
                              });
                            });
                          }
                        },
                      ),
                    ],
                  ],
                ),
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
      launchURL(context, url).then((_) {
        setState(() {
          canTapOnLink = true;
        });
      });
    }
  }
}

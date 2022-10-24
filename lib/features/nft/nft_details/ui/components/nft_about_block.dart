import 'package:flutter/material.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/features/market/market_details/ui/widgets/about_block/components/clickable_underlined_text.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/modules/wallet_api/models/market_info/market_info_response_model.dart';

class NFTAboutBlock extends StatelessWidget {
  const NFTAboutBlock({
    Key? key,
    required this.description,
    required this.shortDescription,
  }) : super(key: key);

  final String description;
  final String shortDescription;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SpaceH6(),
        Text(
          intl.nft_detail_about,
          style: sTextH4Style,
        ),
        const SpaceH20(),
        NFTAboutBlockText(
          description: description,
          shortDescription: shortDescription,
        ),
      ],
    );
  }
}

class NFTAboutBlockText extends StatefulWidget {
  const NFTAboutBlockText({
    super.key,
    required this.description,
    required this.shortDescription,
  });

  final String description;
  final String shortDescription;

  @override
  State<NFTAboutBlockText> createState() => _NFTAboutBlockTextState();
}

class _NFTAboutBlockTextState extends State<NFTAboutBlockText>
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
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.shortDescription.isNotEmpty) ...[
            Text(
              expandText ? widget.description : widget.shortDescription,
              maxLines: expandText ? 10 : 4,
              style: sBodyText1Style.copyWith(color: Colors.black),
            ),
          ] else ...[
            Text(
              widget.description,
              maxLines: 4,
              style: sBodyText1Style,
            ),
          ],
          if (!expandText && widget.shortDescription.isNotEmpty) ...[
            const SpaceH18(),
            ClickableUnderlinedText(
              text: intl.nft_detail_readMore,
              onTap: () => expandText = !expandText,
            ),
          ],
        ],
      ),
    );
  }
}

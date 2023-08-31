import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:simple_kit/modules/buttons/simple_icon_button.dart';
import 'package:simple_kit/modules/colors/simple_colors_light.dart';
import 'package:simple_kit/modules/icons/24x24/public/copy/simple_copy_icon.dart';
import 'package:simple_kit/modules/icons/24x24/public/copy/simple_copy_pressed_icon.dart';
import 'package:simple_kit/modules/shared/simple_paddings.dart';
import 'package:simple_kit/modules/shared/simple_skeleton_text_loader.dart';
import 'package:simple_kit/modules/shared/simple_spacers.dart';
import 'package:simple_kit/modules/texts/simple_text_styles.dart';

class SAddressFieldWithCopy extends StatefulObserverWidget {
  const SAddressFieldWithCopy({
    Key? key,
    this.realValue,
    this.onTap,
    this.then,
    this.actionIcon,
    this.valueLoading = false,
    this.needPadding = true,
    this.needFormatURL = true,
    this.needInnerPadding = false,
    this.longString = false,
    this.expanded = false,
    required this.header,
    required this.value,
    required this.afterCopyText,
  }) : super(key: key);

  final String? realValue;
  final Function()? onTap;
  final Function()? then;
  final Widget? actionIcon;
  final bool valueLoading;
  final bool needPadding;
  final bool needFormatURL;
  final bool needInnerPadding;
  final bool expanded;
  final String header;
  final String value;
  final String afterCopyText;
  final bool longString;

  @override
  State<SAddressFieldWithCopy> createState() => _SAddressFieldWithCopyState();
}

class _SAddressFieldWithCopyState extends State<SAddressFieldWithCopy>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<Offset> scaleAnimation;
  String copiedText = '';

  @override
  void initState() {
    // animationController intentionally is not disposed,
    // because bottomSheet will dispose it on its own
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
      reverseDuration: const Duration(milliseconds: 200),
    );
    scaleAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.0),
      end: widget.expanded ? Offset(0.0, -112.0) : Offset(0.0, -64.0),
    ).animate(
      CurvedAnimation(
        parent: animationController,
        curve: Curves.easeOut,
        reverseCurve: Curves.easeIn,
      ),
    );
    scaleAnimation.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final realValue = widget.realValue;
    final onTap = widget.onTap;
    final then = widget.then;
    final actionIcon = widget.actionIcon;
    final valueLoading = widget.valueLoading;
    final header = widget.header;
    final value = widget.value;
    final afterCopyText = widget.afterCopyText;

    void _onCopyAction() {
      Clipboard.setData(
        ClipboardData(
          text: realValue ?? value,
        ),
      );

      then?.call();
    }

    @override
    void dispose() {
      animationController.dispose();
      super.dispose();
    }

    return Stack(
      children: [
        Transform.translate(
          offset: scaleAnimation.value,
          child: Container(
            color: SColorsLight().greenLight,
            height: widget.expanded ? 116.0 : 64,
            width: double.infinity,
            child: Center(
              child: SPaddingH24(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      afterCopyText,
                      style: sBodyText1Style.copyWith(
                        color: SColorsLight().green,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    if (realValue != null)
                      Text(
                        realValue ?? '',
                        style: sBodyText1Style.copyWith(
                          color: SColorsLight().green,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 3,
                        textAlign: TextAlign.center,
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Material(
          color: SColorsLight().white,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: widget.needInnerPadding ? 24.0 : 0,
            ),
            child: InkWell(
              highlightColor: SColorsLight().grey4,
              splashColor: Colors.transparent,
              onTap: valueLoading ? null : onTap,
              onLongPress: valueLoading ? null : () => _onCopyAction(),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: widget.needPadding ? 24.0 : 0,
                ),
                child: SizedBox(
                  height: widget.longString ? 116 : 88.0,
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SpaceH22(),
                            Text(
                              header,
                              style: sCaptionTextStyle.copyWith(
                                color: SColorsLight().grey2,
                              ),
                            ),
                            const SpaceH4(),
                            if (valueLoading)
                              const SSkeletonTextLoader(
                                height: 16,
                                width: 80,
                              )
                            else
                              Baseline(
                                baseline: 16.0,
                                baselineType: TextBaseline.alphabetic,
                                child: AutoSizeText(
                                  widget.needFormatURL
                                    ? _shortReferralLink(value)
                                    : value,
                                  textAlign: TextAlign.start,
                                  minFontSize: 4.0,
                                  maxLines: widget.longString ? 2 : 1,
                                  strutStyle: const StrutStyle(
                                    height: 1.56,
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'Gilroy',
                                  ),
                                  style: TextStyle(
                                    height: 1.56,
                                    fontSize: 18.0,
                                    fontFamily: 'Gilroy',
                                    fontWeight: FontWeight.w600,
                                    color: SColorsLight().black,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                      const SpaceW10(),
                      SIconButton(
                        onTap: valueLoading ? null : () => _onCopyAction(),
                        defaultIcon: const SCopyIcon(),
                        pressedIcon: const SCopyPressedIcon(),
                      ),
                      if (actionIcon != null) ...[
                        const SpaceW20(),
                        SIconButton(
                          onTap: valueLoading ? null : onTap,
                          defaultIcon: actionIcon,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  String _shortReferralLink(String referralLink) {
    return referralLink.split('https://').last;
  }
}

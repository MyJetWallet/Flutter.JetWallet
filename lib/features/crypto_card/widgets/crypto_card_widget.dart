import 'dart:ui';

import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_flip_card/flutter_flip_card.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_ui_kit/flutter_ui_kit.dart';
import 'package:intl/intl.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/features/crypto_card/store/main_crypto_card_store.dart';
import 'package:jetwallet/utils/event_bus_events.dart';
import 'package:provider/provider.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/modules/icons/custom/public/cards/simple_mastercard_big_icon.dart';

import '../../../../core/l10n/i10n.dart';
import '../../../../core/services/notification_service.dart';
import '../../../../utils/constants.dart';

class CryptoCardWidget extends StatefulWidget {
  const CryptoCardWidget({
    super.key,
    this.isFrozen = false,
    required this.last4,
  });

  final bool isFrozen;
  final String last4;

  @override
  State<CryptoCardWidget> createState() => _CryptoCardWidgetState();
}

class _CryptoCardWidgetState extends State<CryptoCardWidget> {
  final FlipCardController flipController = FlipCardController();

  bool isFlippingEnd = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      flipController.state!.animationController.addListener(
        () {
          if (flipController.state!.animationController.value > 0.95) {
            setState(() {
              isFlippingEnd = true;
            });
          } else {
            setState(() {
              isFlippingEnd = false;
            });
          }
          if (flipController.state!.animationController.value == 1) {
            sAnalytics.tapFlipCard();

            if (!flipController.state!.isFront) {
              sAnalytics.viewCardDetailsScreen();
            }
          }
        },
      );
    });

    getIt<EventBus>().on<FlipCryptoCard>().listen((event) {
      flipController.flipcard();
    });
    if (widget.isFrozen) {
      sAnalytics.viewFrozenCardState();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isFrozen) {
      if (!(flipController.state?.isFront ?? false)) {
        flipController.flipcard();
      }
    }

    final colors = SColorsLight();

    void onCopyAction(String value) {
      Clipboard.setData(
        ClipboardData(
          text: value.replaceAll(' ', ''),
        ),
      );
      sNotification.showError(
        intl.simple_card_copied,
        id: 1,
        isError: false,
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 16.0,
        horizontal: 24.0,
      ),
      child: Stack(
        children: [
          FlipCard(
            onTapFlipping: !widget.isFrozen,
            controller: flipController,
            rotateSide: RotateSide.right,
            frontWidget: _buildCardView(
              child: Container(
                clipBehavior: Clip.antiAlias,
                decoration: const BoxDecoration(),
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Assets.svg.card.simpleCryptoCard.simpleSvg(
                        height: 151.8,
                        width: 247.43,
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: Text(
                        '\u2022\u2022\u2022\u2022 ${widget.last4}',
                        style: STStyles.body2Bold.copyWith(
                          color: colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            backWidget: _buildCardView(
              child: Observer(
                builder: (context) {
                  final sensitiveInfo = Provider.of<MainCryptoCardStore>(context).sensitiveInfo;

                  return Container(
                    clipBehavior: Clip.antiAlias,
                    decoration: const BoxDecoration(),
                    margin: const EdgeInsets.only(
                      left: 6.22,
                      bottom: 3.0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Spacer(),
                        _CryptoCardSensitiveDataWidget(
                          name: intl.crypto_card_card_number,
                          value: sensitiveInfo != null ? formatCardNumber(sensitiveInfo.cardNumber) : '',
                          onTap: (value) {
                            sAnalytics.tapCopyNumber();
                            onCopyAction(value);
                          },
                          loaderWidth: 177,
                        ),
                        const SpaceH12(),
                        Row(
                          children: [
                            _CryptoCardSensitiveDataWidget(
                              showCopy: false,
                              name: intl.crypto_card_valid_thru,
                              value: DateFormat('MM/yyyy').format(sensitiveInfo?.expDate ?? DateTime.now()),
                              onTap: onCopyAction,
                              loaderWidth: 56,
                            ),
                            const SizedBox(
                              width: 32.0,
                            ),
                            _CryptoCardSensitiveDataWidget(
                              name: intl.crypto_card_cvv,
                              value: sensitiveInfo?.cvv ?? '',
                              onTap: (value) {
                                sAnalytics.tapCopyCVV();
                                onCopyAction(value);
                              },
                              loaderWidth: 41,
                              withSecure: true,
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
          _buildCardMask(
            child: AnimatedOpacity(
              opacity: (widget.isFrozen && isFlippingEnd) ? 1 : 0,
              duration: const Duration(milliseconds: 300),
              child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: 8.0,
                  sigmaY: 8.0,
                ),
                child: Container(
                  color: Colors.black.withOpacity(0.1),
                ),
              ),
            ),
          ),
          _buildCardMask(
            child: AnimatedOpacity(
              opacity: (widget.isFrozen && isFlippingEnd) ? 0.5 : 0.0,
              duration: const Duration(milliseconds: 300),
              child: Image.asset(
                simpleCardMask,
                height: 206.0,
                width: double.infinity,
                fit: BoxFit.fill,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardMask({required Widget child}) {
    return Positioned.fill(
      child: IgnorePointer(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16.0),
          child: child,
        ),
      ),
    );
  }

  String formatCardNumber(String input) {
    return input.replaceAllMapped(RegExp('(.{4})'), (match) => '${match.group(0)} ').trim();
  }

  Widget _buildCardView({required Widget child}) {
    return Container(
      clipBehavior: Clip.antiAlias,
      padding: const EdgeInsets.only(
        left: 9.78,
        right: 10.65,
        top: 11.66,
        bottom: 13.0,
      ),
      width: double.infinity,
      height: 206,
      decoration: BoxDecoration(
        color: SColorsLight().violet50,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1E000000),
            blurRadius: 33.11,
            offset: Offset(0, 8.28),
          ),
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 3.31,
            offset: Offset(0, 1.66),
          ),
        ],
      ),
      child: Stack(
        children: [
          const Align(
            alignment: Alignment.bottomRight,
            child: SMasterCardBigIcon(
              height: 42.55,
              width: 68.91,
            ),
          ),
          Positioned(
            top: 0,
            right: 1.26,
            child: Assets.svg.card.simpleLogo.simpleSvg(
              height: 20.67,
              width: 66.1,
            ),
          ),
          child,
        ],
      ),
    );
  }
}

class _CryptoCardSensitiveDataWidget extends StatefulWidget {
  const _CryptoCardSensitiveDataWidget({
    required this.name,
    required this.value,
    required this.onTap,
    required this.loaderWidth,
    this.withSecure = false,
    this.showCopy = true,
  });

  final String name;
  final String value;
  final bool showCopy;
  final bool withSecure;
  final double loaderWidth;
  final Function(String value) onTap;

  @override
  State<_CryptoCardSensitiveDataWidget> createState() => _CryptoCardSensitiveDataWidgetState();
}

class _CryptoCardSensitiveDataWidgetState extends State<_CryptoCardSensitiveDataWidget> {
  bool isHided = true;

  @override
  Widget build(BuildContext context) {
    final colors = SColorsLight();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.name,
          style: STStyles.captionBold.copyWith(
            color: colors.white,
          ),
        ),
        SafeGesture(
          onTap: () {
            if (widget.withSecure && isHided) {
              setState(() {
                isHided = false;
              });
              sAnalytics.tapShowCVV();
            } else {
              if (widget.value != '') {
                widget.onTap(widget.value);
              }
            }
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.value == '')
                SSkeletonLoader(
                  height: 28,
                  width: widget.loaderWidth,
                  borderRadius: BorderRadius.circular(4),
                )
              else if (widget.withSecure)
                SizedBox(
                  height: 28.0,
                  child: AnimatedCrossFade(
                    firstChild: Padding(
                      padding: const EdgeInsets.only(
                        top: 1.0,
                      ),
                      child: Text(
                        intl.crypto_card_show,
                        style: STStyles.body1Bold.copyWith(
                          color: colors.white,
                        ),
                      ),
                    ),
                    secondChild: Text(
                      widget.value,
                      style: STStyles.header6.copyWith(
                        color: colors.white,
                      ),
                    ),
                    crossFadeState: isHided ? CrossFadeState.showFirst : CrossFadeState.showSecond,
                    duration: const Duration(milliseconds: 300),
                  ),
                )
              else
                SizedBox(
                  height: 28.0,
                  child: Text(
                    widget.value,
                    style: STStyles.header6.copyWith(
                      color: colors.white,
                    ),
                  ),
                ),
              if (widget.showCopy && widget.value != '') ...[
                const SpaceW4(),
                AnimatedCrossFade(
                  firstChild: Assets.svg.medium.show.simpleSvg(
                    color: colors.white,
                    width: 16,
                    height: 16,
                  ),
                  secondChild: Assets.svg.medium.copy.simpleSvg(
                    color: colors.white,
                    width: 16,
                    height: 16,
                  ),
                  crossFadeState: widget.withSecure && isHided ? CrossFadeState.showFirst : CrossFadeState.showSecond,
                  duration: const Duration(milliseconds: 300),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

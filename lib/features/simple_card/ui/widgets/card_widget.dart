import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:simple_kit/core/simple_kit.dart';
import 'package:simple_kit/modules/colors/simple_colors_light.dart';
import 'package:simple_kit/modules/icons/24x24/public/action_deposit/simple_action_deposit_icon.dart';
import 'package:simple_kit/modules/icons/custom/public/cards/simple_mastercard_big_icon.dart';
import 'package:simple_kit/modules/icons/custom/public/cards/simple_visa_card_big_icon.dart';
import 'package:simple_kit/modules/shared/simple_spacers.dart';
import 'package:simple_kit/modules/texts/simple_text_styles.dart';
import 'package:simple_networking/modules/signal_r/models/banking_profile_model.dart';
import 'package:simple_networking/modules/wallet_api/models/simple_card/simple_card_sevsitive_response.dart';

import '../../../../core/l10n/i10n.dart';
import '../../../../core/services/notification_service.dart';
import '../../../../utils/constants.dart';
import 'card_sensitive_data.dart';

class FlipCardController {
  CardWidgetState? _state;

  Future flip() async => _state?.flip();

  Future flipBack() async => _state?.flipBack();
}

class CardWidget extends StatefulWidget {
  const CardWidget({
    Key? key,
    this.isFrozen = false,
    this.showDetails = false,
    required this.card,
    required this.cardSensitive,
    required this.onTap,
  }) : super(key: key);

  final bool isFrozen;
  final bool showDetails;
  final CardDataModel card;
  final SimpleCardSensitiveResponse cardSensitive;
  final Function() onTap;

  @override
  State<CardWidget> createState() => CardWidgetState();
}

class CardWidgetState extends State<CardWidget> with TickerProviderStateMixin {
  late AnimationController controller;
  FlipCardController controllerFlip = FlipCardController();

  bool isFront = true;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    controllerFlip._state = this;
  }

  Future flip() async {
    isFront = !isFront;

    await controller.forward();
  }

  Future flipBack() async {
    isFront = !isFront;

    await controller.reverse();
  }

  @override
  void didUpdateWidget(oldWidget) {
    controllerFlip._state = this;
    if (widget.showDetails && isFront) {
      flip();
    } else if (!widget.showDetails && !isFront) {
      flipBack();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    final colors = sKit.colors;

    void onCopyAction(String value)  {
      Clipboard.setData(
        ClipboardData(
          text: value,
        ),
      );
      sNotification.showError(
        intl.simple_card_copied,
        id: 1,
        isError: false,
      );
    }

    return InkWell(
      highlightColor: SColorsLight().grey5,
      splashColor: Colors.transparent,
      onTap: () {
        if (!widget.isFrozen) {
          widget.onTap();
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 16,
        ),
        child: Center(
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: ImageFiltered(
                  imageFilter: widget.isFrozen
                    ? ImageFilter.blur(sigmaX: 4.0, sigmaY: 4.0)
                    : ImageFilter.blur(),
                  child: AnimatedBuilder(
                    animation: controller,
                    builder: (context, child) {
                      final angle = controller.value * -pi;
                      final transform = Matrix4.identity()
                        ..setEntry(3, 0, 0)
                        ..rotateY(angle);

                      return Transform(
                        transform: transform,
                        alignment: Alignment.center,
                        child: Container(
                          clipBehavior: Clip.antiAlias,
                          padding: const EdgeInsets.only(
                            left: 16,
                            right: 16,
                            top: 12,
                            bottom: 8,
                          ),
                          width: 279,
                          height: 170,
                          decoration: BoxDecoration(
                            color: colors.lightPurple,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: !isFrontImage(angle.abs())
                            ? Transform(
                                transform: Matrix4.identity()..rotateY(pi),
                                alignment: Alignment.center,
                                child: Container(
                                  clipBehavior: Clip.antiAlias,
                                  decoration: const BoxDecoration(),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          const Spacer(),
                                          SvgPicture.asset(
                                            simpleSmileLogo,
                                            width: 112,
                                          ),
                                        ],
                                      ),
                                      const Spacer(),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          CardSensitiveData(
                                            name: intl.simple_card_card_number,
                                            value: widget.cardSensitive.cardNumber ?? '',
                                            onTap: onCopyAction,
                                          ),
                                          const SpaceH10(),
                                          Row(
                                            children: [
                                              CardSensitiveData(
                                                showCopy: false,
                                                name: intl.simple_card_valid_thru,
                                                value: widget.cardSensitive.cardExpDate ?? '',
                                                onTap: onCopyAction,
                                              ),
                                              const SpaceW24(),
                                              CardSensitiveData(
                                                showCopy: false,
                                                name: intl.simple_card_cvv,
                                                value: widget.cardSensitive.cardCvv ?? '',
                                                onTap: onCopyAction,
                                              ),
                                            ],
                                          ),
                                          const SpaceH8(),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                            )
                          : Container(
                            clipBehavior: Clip.antiAlias,
                            decoration: const BoxDecoration(),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    const Spacer(),
                                    SvgPicture.asset(
                                      simpleSmileLogo,
                                      width: 112,
                                    ),
                                  ],
                                ),
                                const Spacer(),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    SizedBox(
                                      width: 48,
                                      height: 48,
                                      child: Center(
                                        child: Text(
                                          '\u2022 \u2022 '
                                              '${widget.card.cardNumberMasked
                                              ?.substring(
                                            (
                                                widget.card.cardNumberMasked?.length ?? 0
                                            ) - 4,)}',
                                          style: sCaptionTextStyle.copyWith(
                                            color: colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const Spacer(),
                                    Column(
                                      children: [
                                        Text(
                                          'debit',
                                          style: sCaptionTextStyle.copyWith(
                                            color: colors.white,
                                          ),
                                        ),
                                        const SpaceH4(),
                                        SizedBox(
                                          width: 48,
                                          height: 48,
                                          child: getNetworkIcon(widget.card.cardType),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              if (widget.isFrozen)
                Positioned(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12.0),
                    child: Image.asset(
                      simpleCardMask,
                      width: 279,
                      height: 170,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  bool isFrontImage(double angle) {
    const degrees90 = pi / 2;
    const degrees270 = 3 * pi / 2;

    return angle <= degrees90 || angle >= degrees270;
  }
}

Widget getNetworkIcon(SimpleCardNetwork? network) {
  switch (network) {
    case SimpleCardNetwork.VISA:
      return const SVisaCardBigIcon(
        width: 40,
        height: 25,
      );
    case SimpleCardNetwork.MASTERCARD:
      return const SMasterCardBigIcon(
        width: 40,
        height: 25,
      );
    default:
      return const SActionDepositIcon();
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_flip_card/flutter_flip_card.dart';
import 'package:simple_kit/modules/icons/custom/public/cards/simple_mastercard_big_icon.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';
import 'package:simple_networking/modules/wallet_api/models/crypto_card/sensitive_info_crypto_card_response_model.dart';

import '../../../../core/l10n/i10n.dart';
import '../../../../core/services/notification_service.dart';
import '../../../../utils/constants.dart';

class CryptoCardWidget extends StatelessWidget {
  const CryptoCardWidget({
    super.key,
    this.isFrozen = false,
    required this.last4,
    this.sensitiveInfo,
  });

  final bool isFrozen;
  final String last4;
  final SensitiveInfoCryptoCardResponseModel? sensitiveInfo;

  @override
  Widget build(BuildContext context) {
    final flipController = FlipCardController();

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
      child: Center(
        child: Stack(
          children: [
            FlipCard(
              onTapFlipping: true,
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
                          '\u2022\u2022\u2022\u2022 $last4',
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
                child: Container(
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
                        value: sensitiveInfo != null ? formatCardNumber(sensitiveInfo!.cardNumber) : '',
                        onTap: onCopyAction,
                        loaderWidth: 177,
                      ),
                      const SpaceH12(),
                      Row(
                        children: [
                          _CryptoCardSensitiveDataWidget(
                            showCopy: false,
                            name: intl.crypto_card_valid_thru,
                            value: sensitiveInfo?.expDate ?? '',
                            onTap: onCopyAction,
                            loaderWidth: 56,
                          ),
                          const SizedBox(
                            width: 32.0,
                          ),
                          _CryptoCardSensitiveDataWidget(
                            name: intl.crypto_card_cvv,
                            value: sensitiveInfo?.cvv ?? '',
                            onTap: onCopyAction,
                            loaderWidth: 41,
                            withSecure: true,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            if (isFrozen)
              Positioned(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12.0),
                  child: Image.asset(
                    simpleCardMask,
                    width: double.infinity,
                    height: 206,
                  ),
                ),
              ),
          ],
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
        Row(
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
            if (widget.showCopy) ...[
              const SpaceW4(),
              SafeGesture(
                onTap: () {
                  if (widget.withSecure && isHided) {
                    setState(() {
                      isHided = false;
                    });
                  } else {
                    widget.onTap(widget.value);
                  }
                },
                child: AnimatedCrossFade(
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
              ),
            ],
          ],
        ),
      ],
    );
  }
}

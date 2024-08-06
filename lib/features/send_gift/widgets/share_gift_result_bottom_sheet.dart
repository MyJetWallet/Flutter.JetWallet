import 'dart:ui' as ui;

import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/services/device_size/device_size.dart';
import 'package:jetwallet/core/services/device_size/models/device_size_union.dart';
import 'package:jetwallet/core/services/notification_service.dart';
import 'package:jetwallet/utils/formatting/formatting.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:share_plus/share_plus.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../utils/constants.dart';

void shareGiftResultBottomSheet({
  required BuildContext context,
  required CurrencyModel currency,
  required Decimal amount,
  String? phoneNumber,
  String? email,
  void Function()? onClose,
}) {
  sAnalytics.shareGiftSheetScreenView();
  sShowBasicModalBottomSheet(
    scrollable: sDeviceSize == const DeviceSizeUnion.small(),
    context: context,
    horizontalPinnedPadding: 24,
    then: (_) {
      onClose?.call();
    },
    pinned: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const SizedBox(width: 24),
        Text(
          intl.send_gift_share,
          style: sTextH5Style,
        ),
        SIconButton(
          onTap: () => Navigator.pop(context),
          defaultIcon: const SEraseIcon(),
          pressedIcon: const SErasePressedIcon(),
        ),
      ],
    ),
    children: [
      _ShareGiftResultBottomSheet(
        amount: amount,
        currency: currency,
        phoneNumber: phoneNumber,
        email: email,
      ),
    ],
  );
}

class _ShareGiftResultBottomSheet extends StatelessWidget {
  const _ShareGiftResultBottomSheet({
    required this.currency,
    required this.amount,
    this.phoneNumber,
    this.email,
  });

  final CurrencyModel currency;
  final Decimal amount;
  final String? phoneNumber;
  final String? email;

  @override
  Widget build(BuildContext context) {
    final sColors = sKit.colors;

    final String shareText;
    shareText = email != '' && email != null
        ? '''${intl.send_gift_message_1_part} ${amount.toFormatCount(accuracy: currency.accuracy, symbol: currency.symbol)} ${intl.send_gift_share_text_2_part} $appDownloadUrl, ${intl.send_gift_share_text_email_part} $email ${intl.send_gift_share_text_3_part}'''
        : '''${intl.send_gift_message_1_part} ${amount.toFormatCount(accuracy: currency.accuracy, symbol: currency.symbol)} ${intl.send_gift_share_text_2_part} $appDownloadUrl, ${intl.send_gift_share_text_phone_part} $phoneNumber ${intl.send_gift_share_text_3_part}''';

    final cardMessage =
        '''${intl.send_gift_message_1_part} ${amount.toFormatCount(accuracy: currency.accuracy, symbol: currency.symbol)} ${intl.send_gift_message_2_part}''';

    final widgetForImageKey = GlobalKey();

    return SPaddingH24(
      child: Stack(
        alignment: AlignmentDirectional.topCenter,
        children: [
          // this widget is hidden from the user,
          // but it is needed to make a share with a picture
          Padding(
            padding: const EdgeInsets.only(top: 30),
            child: RepaintBoundary(
              key: widgetForImageKey,
              child: Container(
                width: 327,
                height: 240,
                decoration: BoxDecoration(
                  color: sKit.colors.white,
                ),
                child: Stack(
                  children: [
                    Container(
                      width: 327,
                      height: 240,
                      decoration: BoxDecoration(
                        color: sKit.colors.grey5,
                      ),
                      child: Image.asset(
                        shareGiftBackgroundAsset,
                        fit: BoxFit.fitWidth,
                        alignment: Alignment.topCenter,
                      ),
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Row(
                          children: [
                            SNetworkSvg24(
                              url: currency.iconUrl,
                            ),
                            const SpaceW4(),
                            Text(
                              amount.toFormatCount(
                                accuracy: currency.accuracy,
                                symbol: currency.symbol,
                              ),
                              style: sTextH4Style.copyWith(
                                color: sColors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 16,
                        ),
                        child: Image.asset(
                          logoWithTitle,
                          fit: BoxFit.contain,
                          alignment: Alignment.topCenter,
                          width: 104,
                          height: 32,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Column(
            children: [
              Container(
                width: 327,
                height: 496,
                decoration: BoxDecoration(
                  color: sKit.colors.grey5,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: Stack(
                    children: [
                      Image.asset(
                        shareGiftBackgroundAsset,
                        fit: BoxFit.contain,
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Row(
                            children: [
                              SNetworkSvg24(
                                url: currency.iconUrl,
                              ),
                              const SpaceW4(),
                              Text(
                                amount.toFormatCount(
                                  accuracy: currency.accuracy,
                                  symbol: currency.symbol,
                                ),
                                style: sTextH4Style.copyWith(
                                  color: sColors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Column(
                          children: [
                            const Spacer(),
                            Container(
                              width: 327,
                              decoration: BoxDecoration(
                                color: sKit.colors.grey5,
                                borderRadius: BorderRadius.circular(24),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(24),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      intl.send_gift_hey,
                                      style: sTextH4Style.copyWith(
                                        color: sColors.black,
                                      ),
                                    ),
                                    const SpaceH8(),
                                    Text(
                                      cardMessage,
                                      style: sBodyText1Style.copyWith(
                                        color: sColors.black,
                                      ),
                                      maxLines: 4,
                                    ),
                                    const SpaceH16(),
                                    Container(
                                      width: 279,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 12,
                                      ),
                                      decoration: ShapeDecoration(
                                        color: sColors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(16),
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          Image.asset(
                                            simpleLogoAsset,
                                            width: 48,
                                            height: 48,
                                          ),
                                          const SpaceW14(),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Text(
                                                  intl.send_gift_simple,
                                                  style: sSubtitle3Style.copyWith(
                                                    color: sColors.black,
                                                  ),
                                                ),
                                                Text(
                                                  intl.send_gift_get_app,
                                                  style: sHelperTextStyle.copyWith(
                                                    color: sColors.grey2,
                                                  ),
                                                  maxLines: 2,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SpaceH24(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: sKit.colors.grey5,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    padding: const EdgeInsets.all(10),
                    child: SIconButton(
                      onTap: () {
                        sAnalytics.tapOnTheButtonCopyOnShareSheet();
                        sNotification.showError(
                          intl.copy_message,
                          id: 1,
                          isError: false,
                        );
                        Clipboard.setData(
                          ClipboardData(
                            text: shareText,
                          ),
                        );
                      },
                      defaultIcon: SCopyIcon(
                        color: sKit.colors.black,
                      ),
                      pressedIcon: const SCopyPressedIcon(),
                    ),
                  ),
                  const SpaceW24(),
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: sKit.colors.grey5,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    padding: const EdgeInsets.all(10),
                    child: SIconButton(
                      onTap: () async {
                        sAnalytics.tapOnTheButtonShareOnShareSheet();

                        final boundary = widgetForImageKey.currentContext!.findRenderObject()! as RenderRepaintBoundary;

                        final image = await boundary.toImage(pixelRatio: 3.0);

                        final byteData = await image.toByteData(
                          format: ui.ImageByteFormat.png,
                        );
                        final buffer = byteData!.buffer;

                        await Share.shareXFiles(
                          [
                            XFile.fromData(
                              buffer.asUint8List(
                                byteData.offsetInBytes,
                                byteData.lengthInBytes,
                              ),
                              name: 'share_gift.png',
                              mimeType: 'image/png',
                            ),
                          ],
                          text: shareText,
                        );
                      },
                      defaultIcon: const SShareIcon(),
                    ),
                  ),
                ],
              ),
              const SpaceH37(),
            ],
          ),
        ],
      ),
    );
  }
}

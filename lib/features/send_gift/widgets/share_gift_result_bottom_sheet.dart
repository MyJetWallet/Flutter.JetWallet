import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/services/notification_service.dart';
import 'package:jetwallet/utils/formatting/base/volume_format.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:share_plus/share_plus.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../utils/constants.dart';

void shareGiftResultBottomSheet({
  required BuildContext context,
  required CurrencyModel currency,
  required Decimal amount,
}) {
  sShowBasicModalBottomSheet(
    context: context,
    horizontalPinnedPadding: 24,
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
          defaultIcon: const SErasePressedIcon(),
          pressedIcon: const SEraseMarketIcon(),
        ),
      ],
    ),
    children: [
      _ShareGiftResultBottomSheet(
        amount: amount,
        currency: currency,
      ),
    ],
  );
}

class _ShareGiftResultBottomSheet extends StatelessWidget {
  const _ShareGiftResultBottomSheet({
    required this.currency,
    required this.amount,
  });

  final CurrencyModel currency;
  final Decimal amount;

  @override
  Widget build(BuildContext context) {
    final shareText =
        '''${intl.send_gift_message_1_part} ${volumeFormat(prefix: currency.prefixSymbol, decimal: amount, accuracy: currency.accuracy, symbol: currency.symbol)} ${intl.send_gift_share_text_2_part} $appDownloadUrl ${intl.send_gift_share_text_3_part}''';
    final cardMessage =
        '''${intl.send_gift_message_1_part} ${volumeFormat(prefix: currency.prefixSymbol, decimal: amount, accuracy: currency.accuracy, symbol: currency.symbol)} ${intl.send_gift_message_2_part}''';

    return SPaddingH24(
      child: Column(
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
                            color: sKit.colors.white,
                          ),
                          const SpaceW4(),
                          Text(
                            volumeFormat(
                              prefix: currency.prefixSymbol,
                              decimal: amount,
                              accuracy: currency.accuracy,
                              symbol: currency.symbol,
                            ),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontFamily: 'Gilroy',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      width: 327,
                      height: 248,
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
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 24,
                                fontFamily: 'Gilroy',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SpaceH12(),
                            Text(
                              cardMessage,
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontFamily: 'Gilroy',
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SpaceH24(),
                            Container(
                              width: 279,
                              height: 72,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              decoration: ShapeDecoration(
                                color: Colors.white,
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
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Text(
                                        intl.send_gift_simple,
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                          fontFamily: 'Gilroy',
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      Text(
                                        intl.send_gift_get_app,
                                        style: const TextStyle(
                                          color: Color(0xFFA8B0BA),
                                          fontSize: 12,
                                          fontFamily: 'Gilroy',
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
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
                  onTap: () {
                    Share.share(shareText);
                  },
                  defaultIcon: const SShareIcon(),
                ),
              ),
            ],
          ),
          const SpaceH37(),
        ],
      ),
    );
  }
}

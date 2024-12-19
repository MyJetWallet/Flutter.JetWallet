import 'package:auto_route/auto_route.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/notification_service.dart';
import 'package:jetwallet/core/services/simple_networking/simple_networking.dart';
import 'package:jetwallet/utils/formatting/formatting.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';
import 'package:simple_kit_updated/widgets/shared/simple_safe_button_padding.dart';
import 'package:simple_networking/helpers/models/server_reject_exception.dart';
import 'package:simple_networking/modules/signal_r/models/crypto_card_otps_message_model.dart';
import 'package:simple_networking/modules/wallet_api/models/crypto_card/otp_used_crypto_card_request_model.dart';

@RoutePage(name: 'CryptoCardOtpCodeRoute')
class CryptoCardOtpCodeScreen extends StatefulWidget {
  const CryptoCardOtpCodeScreen({super.key, required this.cryptoCardOtp});

  final CryptoCardOtpsModel cryptoCardOtp;

  @override
  State<CryptoCardOtpCodeScreen> createState() => _CryptoCardOtpCodeScreenState();
}

class _CryptoCardOtpCodeScreenState extends State<CryptoCardOtpCodeScreen> {
  @override
  void initState() {
    super.initState();
    useOtp();
  }

  @override
  Widget build(BuildContext context) {
    return SPageFrame(
      loaderText: '',
      header: GlobalBasicAppBar(
        hasRightIcon: false,
        leftIcon: Assets.svg.medium.close.simpleSvg(),
        title: intl.crypto_card_otp_verification,
      ),
      child: CustomScrollView(
        physics: const ClampingScrollPhysics(),
        slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: Column(
              children: [
                const SpaceH24(),
                SafeGesture(
                  onTap: () {
                    Clipboard.setData(
                      ClipboardData(
                        text: widget.cryptoCardOtp.code,
                      ),
                    );
                    sNotification.showError(
                      intl.copy_message,
                      id: 1,
                      isError: false,
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: ShapeDecoration(
                      color: SColorsLight().gray2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          Decimal.parse(widget.cryptoCardOtp.code).toFormatCount(),
                          style: STStyles.header5,
                        ),
                        const SpaceW16(),
                        Assets.svg.medium.copy.simpleSvg(
                          color: SColorsLight().gray8,
                        ),
                      ],
                    ),
                  ),
                ),
                const SpaceH8(),
                Text(
                  intl.crypto_card_otp_your_verification_code,
                  style: STStyles.body1Semibold,
                ),
                const SpaceH32(),
                const SDivider(withHorizontalPadding: true),
                const SpaceH16(),
                TwoColumnCell(
                  label: intl.crypto_card_otp_amount,
                  value: widget.cryptoCardOtp.amount.toFormatCount(symbol: widget.cryptoCardOtp.asset),
                ),
                TwoColumnCell(
                  label: intl.crypto_card_otp_merchant,
                  value: widget.cryptoCardOtp.merchant,
                ),
                const SpaceH16(),
                const SDivider(withHorizontalPadding: true),
                const SpaceH24(),
                SPaddingH24(
                  child: Text(
                    intl.crypto_card_otp_description,
                    style: STStyles.body2Semibold.copyWith(
                      color: SColorsLight().gray10,
                    ),
                    maxLines: 10,
                  ),
                ),
                const Spacer(),
                SafeArea(
                  top: false,
                  child: SSafeButtonPadding(
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 24,
                        right: 24,
                        bottom: 8,
                      ),
                      child: SButton.black(
                        text: intl.crypto_card_otp_close,
                        callback: () {
                          sRouter.maybePop();
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> useOtp() async {
    try {
      final model = OtpUsedCryptoCardRequestModel(otpId: widget.cryptoCardOtp.id);

      final response = await sNetwork.getWalletModule().otpUsedCryptoCard(model);
      response.pick(
        onNoError: (data) {},
        onError: (error) {
          sNotification.showError(
            error.cause,
            id: 1,
          );
        },
      );
    } on ServerRejectException catch (error) {
      sNotification.showError(
        error.cause,
        id: 1,
      );
    } catch (error) {
      sNotification.showError(
        intl.something_went_wrong_try_again2,
        id: 1,
      );
    }
  }
}

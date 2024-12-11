import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/features/crypto_card/store/change_pin_crypto_card_store.dart';
import 'package:jetwallet/features/pin_screen/ui/widgets/pin_box.dart';
import 'package:jetwallet/features/pin_screen/ui/widgets/shake_widget/shake_widget.dart';
import 'package:provider/provider.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';

@RoutePage(name: 'CryptoCardChangePinRoute')
class CryptoCardChangePinScreen extends StatefulWidget {
  const CryptoCardChangePinScreen({
    super.key,
  });

  @override
  State<CryptoCardChangePinScreen> createState() => _CryptoCardChangePinScreenState();
}

class _CryptoCardChangePinScreenState extends State<CryptoCardChangePinScreen> {
  @override
  void initState() {
    super.initState();
    sAnalytics.viewCreatePINScreen();
  }

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (_) => ChangePinCryptoCardStore(),
      child: const _CryptoCardChangePinBody(),
    );
  }
}

class _CryptoCardChangePinBody extends StatelessWidget {
  const _CryptoCardChangePinBody();

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<ChangePinCryptoCardStore>(context);

    return Observer(
      builder: (context) {
        return SPageFrame(
          resizeToAvoidBottomInset: false,
          loaderText: intl.register_pleaseWait,
          loading: store.loader,
          header: AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: store.isConfirmPinFlow
                ? SimpleLargeAppbar(
                    key: ValueKey(intl.crypto_card_confirm_your_pin),
                    title: intl.crypto_card_confirm_your_pin,
                    hasLeftIcon: false,
                    hasRightIcon: true,
                  )
                : SimpleLargeAppbar(
                    key: ValueKey(intl.crypto_card_change_your_pin),
                    title: intl.crypto_card_change_your_pin,
                    hasLeftIcon: false,
                    hasRightIcon: true,
                  ),
          ),
          child: Column(
            children: [
              const Spacer(),
              AnimatedOpacity(
                opacity: store.error != null ? 1 : 0,
                duration: const Duration(milliseconds: 200),
                child: Column(
                  children: [
                    Text(
                      store.error ?? '',
                      style: STStyles.subtitle2.copyWith(color: SColorsLight().red),
                    ),
                    const SpaceH40(),
                  ],
                ),
              ),
              ShakeWidget(
                key: store.shakePinKey,
                shakeDuration: pinBoxErrorDuration,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    for (int id = 0; id < 4; id++)
                      PinBox(
                        state: store.pinStates[id],
                      ),
                  ],
                ),
              ),
              const SpaceH64(),
              const Spacer(),
              SNumericKeyboard(
                type: NumericKeyboardType.none,
                onKeyPressed: (value) {
                  store.updatePin(value);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

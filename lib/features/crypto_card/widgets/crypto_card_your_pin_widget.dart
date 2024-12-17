import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_ui_kit/flutter_ui_kit.dart';
import 'package:jetwallet/core/l10n/i10n.dart';

class CryptoCardYourPinWidget extends StatefulWidget {
  const CryptoCardYourPinWidget({
    required this.pin,
    super.key,
  });

  final String pin;

  @override
  State<CryptoCardYourPinWidget> createState() => _CryptoCardYourPinWidgetState();
}

class _CryptoCardYourPinWidgetState extends State<CryptoCardYourPinWidget> {
  static const int _initialCountdown = 5;
  late int _secondsRemaining;
  Timer? _timer;

  String _loadingDots = '';
  late Timer _dotsTimer;

  bool showWidget = true;

  @override
  void initState() {
    super.initState();
    _secondsRemaining = _initialCountdown;
    _startCountdownTimer();
    _startDotsAnimation();
  }

  void _startCountdownTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_secondsRemaining > 0) {
          _secondsRemaining--;
        } else {
          _timer?.cancel();
          showWidget = false;
        }
      });
    });
  }

  void _startDotsAnimation() {
    _dotsTimer = Timer.periodic(const Duration(milliseconds: 500), (_) {
      setState(() {
        if (_loadingDots.length >= 3) {
          _loadingDots = '';
        } else {
          _loadingDots += '.';
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: showWidget ? 1 : 0,
      duration: const Duration(milliseconds: 300),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 11.5,
            ),
            decoration: BoxDecoration(
              color: SColorsLight().gray2,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              widget.pin,
              style: STStyles.header5,
            ),
          ),
          const SizedBox(height: 12.0),
          Text(
            intl.crypto_card_here_your_pin,
            style: STStyles.body1Semibold,
          ),
          const SizedBox(height: 4.0),
          Row(
            children: [
              const Spacer(),
              Text(
                intl.crypto_card_hiding_pin(_secondsRemaining),
                style: STStyles.captionMedium.copyWith(color: SColorsLight().gray10),
              ),
              SizedBox(
                width: 13.0,
                child: Text(
                  _loadingDots,
                  style: STStyles.captionMedium.copyWith(color: SColorsLight().gray10),
                ),
              ),
              const Spacer(),
            ],
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _dotsTimer.cancel();
    super.dispose();
  }
}

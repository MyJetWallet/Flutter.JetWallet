import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ui_kit/flutter_ui_kit.dart';
import 'package:jetwallet/features/withdrawal/store/withdrawal_store.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:simple_kit/simple_kit.dart';

@RoutePage()
class ScannerScreen extends StatelessWidget {
  const ScannerScreen({
    super.key,
    required this.qrKey,
    required this.onQRScanned,
  });

  final Key qrKey;
  final Function(BarcodeCapture, BuildContext) onQRScanned;

  @override
  Widget build(BuildContext context) {
    final scanWindow = Rect.fromCenter(
      center: MediaQuery.of(context).size.center(Offset.zero),
      width: 200,
      height: 200,
    );

    return Scaffold(
      body: Stack(
        children: [
          MobileScanner(
            key: qrKey,
            scanWindow: scanWindow,
            onDetect: (c) => onQRScanned(c, context),
          ),
          CustomPaint(
            painter: ScannerOverlay(scanWindow),
          ),
          Positioned(
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                margin: const EdgeInsets.only(
                  left: 28.0,
                  top: 68.0,
                ),
                width: 24,
                height: 24,
                child: SCloseIcon(
                  color: SColorsLight().white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

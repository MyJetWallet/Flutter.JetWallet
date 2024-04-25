import 'dart:async';
import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:jetwallet/features/withdrawal/store/withdrawal_store.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:simple_kit/simple_kit.dart';

@RoutePage()
class ScannerScreen extends StatefulWidget {
  const ScannerScreen({
    super.key,
    required this.qrKey,
    required this.onQRScanned,
  });

  final Key qrKey;
  final Function(Barcode, BuildContext) onQRScanned;

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> with WidgetsBindingObserver {
  final MobileScannerController controller = MobileScannerController(
    torchEnabled: true,
    useNewCameraSelector: true,
  );

  StreamSubscription<Object?>? _subscription;

  void _handleBarcode(BarcodeCapture barcodes) {
    if (mounted) {
      widget.onQRScanned(barcodes.barcodes.first, context);
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    _subscription = controller.barcodes.listen(_handleBarcode);

    unawaited(controller.start());
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    switch (state) {
      case AppLifecycleState.detached:
      case AppLifecycleState.hidden:
      case AppLifecycleState.paused:
        return;
      case AppLifecycleState.resumed:
        _subscription = controller.barcodes.listen(_handleBarcode);

        unawaited(controller.start());
      case AppLifecycleState.inactive:
        unawaited(_subscription?.cancel());
        _subscription = null;
        unawaited(controller.stop());
    }
  }

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
            controller: controller,
            key: widget.qrKey,
            scanWindow: scanWindow,
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
                  color: sKit.colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Future<void> dispose() async {
    WidgetsBinding.instance.removeObserver(this);
    unawaited(_subscription?.cancel());
    _subscription = null;
    super.dispose();
    await controller.dispose();
  }
}

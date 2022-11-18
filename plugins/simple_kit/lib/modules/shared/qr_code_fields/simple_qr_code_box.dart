import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:simple_kit/modules/shared/qr_code_fields/simple_skeleton_qr_loader.dart';
import 'package:simple_kit/utils/constants.dart';

class SQrCodeBox extends StatelessWidget {
  const SQrCodeBox({
    Key? key,
    this.loading = false,
    required this.data,
    required this.qrBoxSize,
    required this.logoSize,
  }) : super(key: key);

  final bool loading;
  final String data;
  final double qrBoxSize;
  final double logoSize;

  @override
  Widget build(BuildContext context) {
    return loading
        ? SSkeletonQrCodeLoader(size: qrBoxSize)
        : QrImage(
            data: data,
            errorCorrectionLevel: QrErrorCorrectLevel.H,
            embeddedImage: const AssetImage(sQrLogo, package: 'simple_kit'),
            embeddedImageStyle:
                QrEmbeddedImageStyle(size: Size(logoSize, logoSize)),
            size: qrBoxSize,
          );
  }
}

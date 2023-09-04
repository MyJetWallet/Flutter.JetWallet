import 'dart:io';

import 'package:flutter/material.dart';
import 'package:simple_kit/simple_kit.dart';

class CompleteDocumentSide extends StatelessWidget {
  const CompleteDocumentSide({
    super.key,
    this.isSelfie = false,
    required this.removeImage,
    required this.documentSide,
  });

  final bool isSelfie;
  final File documentSide;
  final Function() removeImage;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: isSelfie ? 320 : 200,
      child: Stack(
        children: [
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16.0),
                  child: Image.file(
                    File(documentSide.path),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            right: 8.0,
            top: 8.0,
            child: GestureDetector(
              onTap: removeImage,
              child: const SizedBox(
                height: 28,
                width: 28,
                child: SCloseWithBorderIcon(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

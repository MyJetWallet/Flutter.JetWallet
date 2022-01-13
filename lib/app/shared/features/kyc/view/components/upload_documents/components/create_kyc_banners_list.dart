import 'dart:io';

import 'package:flutter/material.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../notifier/upload_kyc_documents/upload_kyc_documents_notifier.dart';
import 'skeleton_first_side.dart';
import 'skeleton_second_side.dart';

List<Widget> createKycBannersList({
  File? documentFirstSide,
  File? documentSecondSide,
  required SimpleColors colors,
  required UploadKycDocumentsNotifier notifier,
}) {
  final bannersList = <Widget>[];

  if (documentFirstSide == null) {
    bannersList.add(
      const SkeletonFirstSide(),
    );
  } else {
    bannersList.add(
      SizedBox(
        height: 200,
        child: Stack(
          children: [
            Row(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16.0),
                    child: Image.file(
                      File(documentFirstSide.path),
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
                onTap: () {
                  notifier.removeDocumentSide();
                },
                child: const SizedBox(
                  height: 28,
                  width: 28,
                  child: SCloseWithBorderIcon(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  if (documentSecondSide == null) {
    bannersList.add(
      const SkeletonSecondSide(),
    );
  } else {
    bannersList.add(
      SizedBox(
        height: 200,
        child: Stack(
          children: [
            Row(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16.0),
                    child: Image.file(
                      File(documentSecondSide.path),
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
                onTap: () {
                  notifier.removeDocumentSide();
                },
                child: const SizedBox(
                  height: 28,
                  width: 28,
                  child: SCloseWithBorderIcon(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  return bannersList;
}

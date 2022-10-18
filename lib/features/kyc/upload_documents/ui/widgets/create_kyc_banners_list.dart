import 'dart:io';

import 'package:flutter/material.dart';
import 'package:jetwallet/features/kyc/upload_documents/store/upload_kyc_documents_store.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../utils/constants.dart';
import 'blank_document_first_side.dart';
import 'blank_document_second_side.dart';
import 'complete_document_side.dart';

List<Widget> createKycBannersList({
  File? documentFirstSide,
  File? documentSecondSide,
  File? documentSelfie,
  File? documentCard,
  required SimpleColors colors,
  required UploadKycDocumentsStore notifier,
}) {
  final bannersList = <Widget>[];

  if (documentFirstSide == null) {
    bannersList.add(
      const BlankDocumentFirstSide(),
    );
  } else {
    bannersList.add(
      CompleteDocumentSide(
        documentSide: documentFirstSide,
        removeImage: () {
          notifier.removeDocumentSide();
        },
      ),
    );
  }

  if (documentSecondSide == null) {
    bannersList.add(
      const BlankDocumentSecondSide(),
    );
  } else {
    bannersList.add(
      CompleteDocumentSide(
        documentSide: documentSecondSide,
        removeImage: () {
          notifier.removeDocumentSide();
        },
      ),
    );
  }

  if (documentSelfie == null) {
    bannersList.add(
      Image.asset(
        selfiePhotoAsset,
      ),
    );
  } else {
    bannersList.add(
      CompleteDocumentSide(
        documentSide: documentSelfie,
        isSelfie: true,
        removeImage: () {
          notifier.removeDocument(true);
        },
      ),
    );
  }

  if (documentCard == null) {
    bannersList.add(
      Image.asset(
        cardPhotoAsset,
      ),
    );
  } else {
    bannersList.add(
      CompleteDocumentSide(
        documentSide: documentCard,
        removeImage: () {
          notifier.removeDocument(false);
        },
      ),
    );
  }

  return bannersList;
}

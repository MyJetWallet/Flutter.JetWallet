import 'dart:async';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/notification_service.dart';
import 'package:jetwallet/core/services/simple_networking/simple_networking.dart';
import 'package:jetwallet/features/kyc/choose_documents/store/choose_documents_store.dart';
import 'package:jetwallet/features/kyc/choose_documents/store/kyc_country_store.dart';
import 'package:jetwallet/features/kyc/helper/convert_kyc_documents.dart';
import 'package:jetwallet/features/kyc/models/kyc_operation_status_model.dart';
import 'package:jetwallet/features/kyc/upload_documents/models/upload_kyc_documents_union.dart';
import 'package:jetwallet/utils/logging.dart';
import 'package:logging/logging.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';
import 'package:simple_networking/modules/wallet_api/models/card_add/card_check_request_model.dart';
import 'package:simple_networking/modules/wallet_api/models/card_add/card_verification_request_model.dart';
import 'package:simple_networking/modules/wallet_api/models/card_add/card_verification_response_model.dart';
import 'package:universal_io/io.dart';

part 'upload_kyc_documents_store.g.dart';

class UploadKycDocumentsStore extends _UploadKycDocumentsStoreBase with _$UploadKycDocumentsStore {
  UploadKycDocumentsStore() : super();

  static UploadKycDocumentsStore of(BuildContext context) =>
      Provider.of<UploadKycDocumentsStore>(context, listen: false);
}

abstract class _UploadKycDocumentsStoreBase with Store {
  _UploadKycDocumentsStoreBase();

  static final _logger = Logger('UploadKycDocumentsStore');

  @observable
  File? documentFirstSide;

  @observable
  File? documentSecondSide;

  @observable
  File? documentSelfie;

  @observable
  File? documentCard;

  @observable
  String verificationId = '';

  @observable
  int numberSide = 0;

  @observable
  bool skippedWaiting = false;

  @observable
  bool uploadTapped = false;

  @observable
  UploadKycDocumentsUnion union = const UploadKycDocumentsUnion.input();

  PageController pageViewController = PageController(viewportFraction: 0.9);

  final loader = StackLoaderStore();

  final loaderSuccess = StackLoaderStore();

  @computed
  bool get getActiveScanButton {
    if (documentFirstSide != null && documentSecondSide != null) {
      return true;
    }

    return numberSide == 0 ? documentFirstSide == null : documentSecondSide == null;
  }

  @computed
  bool get buttonIcon {
    return (documentFirstSide != null && documentSecondSide != null) || documentSelfie != null || documentCard != null;
  }

  @action
  void changeDocumentSide(int index) {
    numberSide = index;
  }

  @action
  void removeDocumentSide() {
    numberSide == 0 ? documentFirstSide = null : documentSecondSide = null;
  }

  @action
  void removeDocument(bool isSelfie) {
    isSelfie ? documentSelfie = null : documentCard = null;
  }

  @action
  Future<void> uploadVerificationDocuments(
    bool isSelfie,
    String cardId,
    Function() onSuccess,
  ) async {
    _logger.log(notifier, 'uploadDocuments');

    try {
      final formData = await convertKycDocuments(
        isSelfie ? documentSelfie : documentCard,
        null,
      );

      final countries = getIt.get<KycCountryStore>();

      final response = await getIt.get<SNetwork>().simpleImageNetworking.getWalletModule().postUploadDocuments(
            formData,
            isSelfie ? 8 : 9,
            countries.activeCountry!.countryCode,
          );

      if (response.hasError) {
        union = UploadKycDocumentsUnion.error(response.error?.cause ?? '');

        sNotification.showError(
          intl.something_went_wrong_try_again,
          id: 1,
        );

        loader.finishLoadingImmediately();
      } else {
        if (isSelfie) {
          unawaited(
            sRouter.push(
              UploadVerificationPhotoRouter(
                cardId: cardId,
                onSuccess: onSuccess,
              ),
            ),
          );
        } else {
          unawaited(
            sRouter.push(
              VerifyingScreenRouter(
                cardId: cardId,
                onSuccess: onSuccess,
              ),
            ),
          );
        }
      }
    } catch (error) {
      _logger.log(stateFlow, 'uploadDocuments', error);

      union = UploadKycDocumentsUnion.error(error);

      sNotification.showError(
        intl.something_went_wrong_try_again,
        id: 1,
      );

      loader.finishLoadingImmediately();
    }
  }

  @action
  Future<void> getVerificationId(
    Function() onSuccess,
    String cardId,
  ) async {
    _logger.log(notifier, 'getVerificationId');
    skippedWaiting = false;

    try {
      final model = CardCheckRequestModel(
        cardId: cardId,
      );

      final response = await sNetwork.getWalletModule().cardStart(
            model,
          );

      response.pick(
        onData: (data) {
          verificationId = data.data.verificationId ?? '';
          verificationCheck(
            cardId,
            onSuccess,
            data.data.verificationId ?? '',
          );
        },
        onError: (error) {
          union = UploadKycDocumentsUnion.error(error);

          sNotification.showError(
            intl.something_went_wrong_try_again,
            id: 1,
          );
        },
      );
    } catch (error) {
      _logger.log(stateFlow, 'verificationCheck', error);

      union = UploadKycDocumentsUnion.error(error);

      sNotification.showError(
        intl.something_went_wrong_try_again,
        id: 1,
      );
    }
  }

  @action
  Future<void> verificationCheck(
    String cardId,
    Function() onSuccess,
    String verificationId,
  ) async {
    _logger.log(notifier, 'uploadDocuments');

    try {
      final model = CardVerificationRequestModel(
        verificationId: verificationId,
      );

      final response = await sNetwork.getWalletModule().cardVerification(
            model,
          );

      response.pick(
        onData: (data) async {
          if (data.data.verificationState == CardVerificationState.blocked) {
            _showBlockedScreen();
          } else if (data.data.verificationState == CardVerificationState.fail) {
            _showFailureScreen(
              onSuccess,
              cardId,
            );
          } else if (data.data.verificationState == CardVerificationState.success) {
            await sRouter.push(
              SuccessVerifyingScreenRouter(
                onSuccess: onSuccess,
              ),
            );
          } else {
            await Future.delayed(const Duration(seconds: 1));
            if (!skippedWaiting) {
              await verificationCheck(
                cardId,
                onSuccess,
                verificationId,
              );
            }
          }
        },
        onError: (error) {
          union = UploadKycDocumentsUnion.error(error);

          sNotification.showError(
            intl.something_went_wrong_try_again,
            id: 1,
          );
        },
      );
    } catch (error) {
      _logger.log(stateFlow, 'uploadDocuments', error);

      union = UploadKycDocumentsUnion.error(error);

      sNotification.showError(
        intl.something_went_wrong_try_again,
        id: 1,
      );
    }
  }

  @action
  Future<void> uploadDocuments(
    int type,
  ) async {
    _logger.log(notifier, 'uploadDocuments');

    try {
      final formData = await convertKycDocuments(
        documentFirstSide,
        documentSecondSide,
      );

      final countries = getIt.get<KycCountryStore>();

      final response = await getIt.get<SNetwork>().simpleImageNetworking.getWalletModule().postUploadDocuments(
            formData,
            type,
            countries.activeCountry!.countryCode,
          );

      if (response.hasError) {
        union = UploadKycDocumentsUnion.error(response.error?.cause ?? '');

        sNotification.showError(
          intl.something_went_wrong_try_again,
          id: 1,
        );

        loader.finishLoadingImmediately();
      } else {
        union = const UploadKycDocumentsUnion.done();
      }
    } catch (error) {
      _logger.log(stateFlow, 'uploadDocuments', error);

      union = UploadKycDocumentsUnion.error(error);

      sNotification.showError(
        intl.something_went_wrong_try_again,
        id: 1,
      );

      loader.finishLoadingImmediately();
    }
  }

  @action
  Future<void> documentPageViewLogic(
    KycDocumentType? document,
    String? cardId,
    Function() onSuccess,
  ) async {
    _logger.log(notifier, 'documentPageViewLogic');

    if (!uploadTapped) {
      uploadTapped = true;
      if (document == KycDocumentType.creditCard) {
        if (documentCard == null) {
          await _pickFile(false, isCard: true);
        } else {
          loader.startLoadingImmediately();
          await uploadVerificationDocuments(
            false,
            cardId ?? '',
            onSuccess,
          );
        }
      } else if (document == KycDocumentType.selfieWithCard) {
        if (documentSelfie == null) {
          await _pickFile(false, isSelfie: true);
        } else {
          loader.startLoadingImmediately();
          await uploadVerificationDocuments(
            true,
            cardId ?? '',
            onSuccess,
          );
        }
      } else if (document != KycDocumentType.passport) {
        if (documentFirstSide == null || documentSecondSide == null) {
          await _pickFile(true);
        } else {
          loader.startLoadingImmediately();
          await uploadDocuments(
            kycDocumentTypeInt(document!),
          );
        }
      } else {
        if (documentFirstSide == null) {
          await _pickFile(false);
        } else {
          loader.startLoadingImmediately();
          await _uploadPassportDocument(
            kycDocumentTypeInt(document!),
          );
        }
      }

      await Future.delayed(const Duration(seconds: 1));
      uploadTapped = false;
    }
  }

  @action
  Future<void> _uploadPassportDocument(
    int type,
  ) async {
    _logger.log(notifier, 'uploadPassportDocument');

    try {
      final formData = await convertKycDocuments(
        documentFirstSide,
        null,
      );

      final countries = getIt.get<KycCountryStore>();

      final response = await getIt.get<SNetwork>().simpleImageNetworking.getWalletModule().postUploadDocuments(
            formData,
            type,
            countries.activeCountry!.countryCode,
          );

      if (response.hasError) {
        sNotification.showError(
          intl.something_went_wrong_try_again,
          id: 1,
        );

        union = const UploadKycDocumentsUnion.error(Object());

        loader.finishLoadingImmediately();
      } else {
        union = const UploadKycDocumentsUnion.done();
      }
    } catch (error) {
      _logger.log(stateFlow, 'uploadDocuments', error);

      union = UploadKycDocumentsUnion.error(error);

      sNotification.showError(
        intl.something_went_wrong_try_again,
        id: 1,
      );

      loader.finishLoadingImmediately();
    }
  }

  @action
  bool activeScanButton() {
    _logger.log(notifier, 'activeScanButton');

    final activeDocument = getIt.get<ChooseDocumentsStore>().getActiveDocument();

    if (activeDocument?.document == KycDocumentType.passport) {
      return activeScanButtonType(ActiveScanButton.active);
    }

    if (documentFirstSide != null && documentSecondSide != null) {
      return activeScanButtonType(ActiveScanButton.active);
    }

    return numberSide == 0
        ? documentFirstSide == null
            ? activeScanButtonType(ActiveScanButton.active)
            : activeScanButtonType(ActiveScanButton.notActive)
        : documentSecondSide == null
            ? activeScanButtonType(ActiveScanButton.active)
            : activeScanButtonType(ActiveScanButton.notActive);
  }

  @action
  Future<void> _pickFile(
    bool isAnimatePageView, {
    bool isSelfie = false,
    bool isCard = false,
  }) async {
    final imagePicker = ImagePicker();
    final file = await imagePicker.pickImage(source: ImageSource.camera);
    if (file != null) {
      _updateDocumentSide(
        File(file.path),
        isSelfie: isSelfie,
        isCard: isCard,
      );
      if (isAnimatePageView) await _animatePageView(pageViewController);
    }
  }

  @action
  Future<void> _animatePageView(
    PageController controller,
  ) async {
    if (numberSide == 0 && documentSecondSide == null || numberSide == 1 && documentFirstSide == null) {
      await controller.animateToPage(
        (numberSide == 0) ? 1 : 0,
        duration: const Duration(milliseconds: 2000),
        curve: Curves.ease,
      );
    }
  }

  @action
  void _updateDocumentSide(
    File file, {
    bool isSelfie = false,
    bool isCard = false,
  }) {
    if (isSelfie) {
      documentSelfie = file;
    } else if (isCard) {
      documentCard = file;
    } else if (numberSide == 0) {
      documentFirstSide = file;
    } else {
      documentSecondSide = file;
    }
  }

  @action
  String buttonName({bool isSelfie = false, bool isCard = false}) {
    final activeDocument = getIt.get<ChooseDocumentsStore>().getActiveDocument();

    if (isSelfie) {
      return documentSelfie == null ? intl.cardVerification_takeSelfie : intl.cardVerification_uploadPhoto;
    }

    if (isCard) {
      return documentCard == null ? intl.cardVerification_takePhoto : intl.cardVerification_uploadPhoto;
    }

    return activeDocument?.document != KycDocumentType.passport
        ? documentFirstSide != null && documentSecondSide != null
            ? intl.uploadKycDocuments_uploadPhotos
            : numberSide == 0
                ? intl.uploadKycDocuments_frontSide
                : intl.uploadKycDocuments_backSide
        : documentFirstSide != null
            ? intl.uploadKycDocuments_uploadPhotos
            : intl.uploadKycDocuments_frontSide;
  }

  @action
  void _showBlockedScreen() {
    sRouter.push(
      FailureScreenRouter(
        primaryText: intl.cardVerification_cardBlocked,
        secondaryText: intl.cardVerification_cardBlockedDescription,
        secondaryButtonName: intl.cardVerification_choosePaymentMethod,
        onSecondaryButtonTap: () {
          sRouter.popUntilRoot();
        },
      ),
    );
  }

  @action
  void _showFailureScreen(
    Function() onSuccess,
    String cardId,
  ) {
    sRouter.push(
      FailureScreenRouter(
        primaryText: intl.cardVerification_reviewFailed,
        secondaryText: intl.cardVerification_reviewFailedDescription,
        secondaryButtonName: intl.cardVerification_title,
        onSecondaryButtonTap: () {
          loader.finishLoadingImmediately();
          loaderSuccess.finishLoadingImmediately();
          if (documentSelfie != null) {
            sRouter.push(
              UploadVerificationPhotoRouter(
                isSelfie: true,
                cardId: cardId,
                onSuccess: onSuccess,
              ),
            );
          } else {
            sRouter.push(
              UploadVerificationPhotoRouter(
                cardId: cardId,
                onSuccess: onSuccess,
              ),
            );
          }
          documentSelfie = null;
          documentCard = null;
        },
      ),
    );
  }

  @action
  void skipWaiting() {
    skippedWaiting = true;
  }
}

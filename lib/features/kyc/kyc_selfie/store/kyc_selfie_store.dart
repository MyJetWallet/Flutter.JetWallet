import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/services/notification_service.dart';
import 'package:jetwallet/core/services/simple_networking/simple_networking.dart';
import 'package:jetwallet/features/kyc/choose_documents/store/kyc_country_store.dart';
import 'package:jetwallet/features/kyc/helper/convert_kyc_documents.dart';
import 'package:jetwallet/features/kyc/kyc_selfie/models/kyc_selfie_union.dart';
import 'package:jetwallet/utils/logging.dart';
import 'package:logging/logging.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';
import 'package:universal_io/io.dart';

import '../../../../core/l10n/i10n.dart';

part 'kyc_selfie_store.g.dart';

class KycSelfieStore extends _KycSelfieStoreBase with _$KycSelfieStore {
  KycSelfieStore() : super();

  static _KycSelfieStoreBase of(BuildContext context) => Provider.of<KycSelfieStore>(context, listen: false);
}

abstract class _KycSelfieStoreBase with Store {
  static final _logger = Logger('KycSelfieStore');

  final loader = StackLoaderStore();

  final loaderSuccess = StackLoaderStore();

  @observable
  File? selfie;

  @observable
  KycSelfieUnion union = const KycSelfieUnion.input();

  @computed
  bool get isSelfieNotEmpty {
    return selfie != null;
  }

  @action
  Future<void> pickedImage() async {
    _logger.log(notifier, 'uploadDocuments');

    try {
      final picker = ImagePicker();

      final file = await picker.pickImage(
        source: ImageSource.camera,
        preferredCameraDevice: CameraDevice.front,
      );

      if (file != null) {
        selfie = File(file.path);
      }
    } catch (error) {
      _logger.log(stateFlow, 'pickedImage', error);
    }
  }

  @action
  Future<void> uploadDocuments(
    int type,
  ) async {
    _logger.log(notifier, 'uploadDocuments');

    try {
      final formData = await convertKycDocuments(
        selfie,
        null,
      );

      final countries = getIt.get<KycCountryStore>();

      final response = await getIt.get<SNetwork>().simpleImageNetworking.getWalletModule().postUploadDocuments(
            formData,
            type,
            countries.activeCountry!.countryCode,
          );

      response.pick(
        onNoData: () {
          union = const KycSelfieUnion.done();
        },
        onData: (data) {
          union = const KycSelfieUnion.done();
        },
        onError: (error) {
          _logger.log(stateFlow, 'uploadDocuments', error);

          union = KycSelfieUnion.error(error);
        },
      );
    } catch (error) {
      _logger.log(stateFlow, 'uploadDocuments', error);

      union = KycSelfieUnion.error(error);

      sNotification.showError(
        intl.something_went_wrong,
        id: 1,
        needFeedback: true,
      );
    }
  }

  @action
  void removeSelfie() {
    selfie = null;
  }
}

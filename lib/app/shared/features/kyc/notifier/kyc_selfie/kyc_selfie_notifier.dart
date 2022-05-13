import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logging/logging.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:universal_io/io.dart';

import '../../../../../../shared/logging/levels.dart';
import '../../../../../../shared/providers/service_providers.dart';
import '../../helper/convert_kyc_documents.dart';
import 'kyc_selfie_state.dart';
import 'kyc_selfie_union.dart';

class KycSelfieNotifier extends StateNotifier<KycSelfieState> {
  KycSelfieNotifier({
    required this.read,
  }) : super(
          const KycSelfieState(),
        );

  final Reader read;
  static final _logger = Logger('KycSelfieNotifier');

  Future<void> pickedImage() async {
    _logger.log(notifier, 'uploadDocuments');

    try {
      final picker = ImagePicker();

      final file = await picker.pickImage(
        source: ImageSource.camera,
      );

      if (file != null) {
        state = state.copyWith(selfie: File(file.path));
      }
    } catch (error) {
      _logger.log(stateFlow, 'pickedImage', error);
    }
  }

  Future<void> uploadDocuments(
    int type,
  ) async {
    _logger.log(notifier, 'uploadDocuments');

    try {
      final service = read(kycDocumentsServicePod);

      final formData = await convertKycDocuments(
        state.selfie,
        null,
        read,
      );

      await service.upload(formData, type);

      sAnalytics.kycSelfieUploaded();

      state = state.copyWith(union: const KycSelfieUnion.done());
    } catch (error) {
      _logger.log(stateFlow, 'uploadDocuments', error);

      final intl = read(intlPod);

      state = state.copyWith(union: KycSelfieUnion.error(error));
      read(sNotificationNotipod.notifier).showError(
        intl.something_went_wrong2,
        id: 1,
      );
    }
  }

  void removeSelfie() {
    state = state.copyWith(selfie: null);
  }
}

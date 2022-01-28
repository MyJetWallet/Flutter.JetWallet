import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logging/logging.dart';
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
      final service = read(uploadKycDocumentsPod);

      final formData = await convertKycDocuments(
        state.selfie,
        null,
      );

      await service.uploadDocuments(formData, type);

      state = state.copyWith(union: const KycSelfieUnion.done());
    } catch (error) {
      _logger.log(stateFlow, 'uploadDocuments', error);

      state = state.copyWith(union: KycSelfieUnion.error(error));
      sShowErrorNotification(
        read(sNotificationQueueNotipod.notifier),
        'Something went wrong. Please try again',
      );
    }
  }

  void removeSelfie() {
    state = state.copyWith(selfie: null);
  }
}

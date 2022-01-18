import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'upload_kyc_documents_notifier.dart';
import 'upload_kyc_documents_state.dart';


final uploadKycDocumentsNotipod = StateNotifierProvider
    .autoDispose<UploadKycDocumentsNotifier, UploadKycDocumentsState>(
      (ref) {

    return UploadKycDocumentsNotifier(
      read: ref.read,
    );
  },
);

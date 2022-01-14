import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../choose_documents/choose_documents_state.dart';
import 'camera_permission_notifier.dart';
import 'camera_permission_state.dart';

final cameraPermissionNotipod = StateNotifierProvider.autoDispose.family<
    CameraPermissionNotifier, CameraPermissionState, DocumentsModel>(
  (ref, activeDocument) {
    return CameraPermissionNotifier(ref.read, activeDocument);
  },
  name: 'cameraPermissionNotipod',
);

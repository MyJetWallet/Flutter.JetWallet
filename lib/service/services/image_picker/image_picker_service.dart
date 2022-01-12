import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'services/picked_file_service.dart';

class ImagePickerService {
  ImagePickerService();
  final imagePicker = ImagePicker();

  Future<File?> pickedFile() async {
    return pickedFileService(imagePicker);
  }
}

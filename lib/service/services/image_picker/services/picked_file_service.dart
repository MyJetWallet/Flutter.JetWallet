import 'dart:io';

import 'package:image_picker/image_picker.dart';

Future<File?> pickedFileService(ImagePicker imagePicker) async {
  final pickedFile = await imagePicker.pickImage(
    source: ImageSource.camera,
  );

  if (pickedFile != null) {
    return File(pickedFile.path);
  } else {
    return null;
  }
}

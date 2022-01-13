import 'dart:io';
import 'package:dio/dio.dart';

Future<FormData> convertKycDocuments(
    File? fileFront,
    File? fileBack,
    ) async {
  final formData = FormData();

  if (fileFront != null && fileBack != null) {
    formData.files.addAll([
      MapEntry('FileSide1', await MultipartFile.fromFile(fileFront.path)),
      MapEntry('FileSide2', await MultipartFile.fromFile(fileBack.path)),
    ]);
  } else if (fileFront != null && fileBack == null) {
    formData.files.addAll([
      MapEntry('FileSide1', await MultipartFile.fromFile(fileFront.path)),
    ]);
  } else {
    formData.files.addAll([
      MapEntry('FileSide2', await MultipartFile.fromFile(fileBack!.path)),
    ]);
  }

  return formData;
}

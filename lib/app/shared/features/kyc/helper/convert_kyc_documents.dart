import 'dart:io';
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mime_type/mime_type.dart';

Future<FormData> convertKycDocuments(
  File? documentFirstSide,
  File? documentSecondSide,
) async {
  final formData = FormData();

  if (documentFirstSide != null) {
    final documentFirstSideName = documentFirstSide.path.split('/').last;
    final mimeTypeFirstSide = mime(documentFirstSideName);
    final mimee = mimeTypeFirstSide!.split('/')[0];
    final type = mimeTypeFirstSide.split('/')[1];

    formData.files.addAll([
      MapEntry(
        'FileSide1',
        await MultipartFile.fromFile(
          documentFirstSide.path,
          contentType: MediaType(mimee, type),
        ),
      ),
    ]);
  }

  if (documentSecondSide != null) {
    final documentSecondSideName = documentSecondSide.path.split('/').last;
    final mimeTypeSecondSide = mime(documentSecondSideName);
    final mimee1 = mimeTypeSecondSide!.split('/')[0];
    final type1 = mimeTypeSecondSide.split('/')[1];

    formData.files.addAll([
      MapEntry(
        'FileSide2',
        await MultipartFile.fromFile(
          documentSecondSide.path,
          contentType: MediaType(mimee1, type1),
        ),
      ),
    ]);
  }

  return formData;
}

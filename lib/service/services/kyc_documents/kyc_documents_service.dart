import 'package:dio/dio.dart';
import 'services/upload_service.dart';

class KycDocumentsService {
  KycDocumentsService(this.dio);
  final Dio dio;

  Future<void> upload(FormData formData, int typeDocument) async {
    return uploadService(dio, formData, typeDocument);
  }
}

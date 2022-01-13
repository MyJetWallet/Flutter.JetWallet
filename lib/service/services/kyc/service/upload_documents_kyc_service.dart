import 'package:dio/dio.dart';
import 'services/upload_documents_service.dart';

class UploadDocumentsKycService {
  UploadDocumentsKycService(this.dio);
  final Dio dio;

  Future<void> uploadDocuments(FormData formData, int typeDocument) async {
    return uploadDocumentsService(dio, formData, typeDocument);
  }
}

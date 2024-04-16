import 'package:dio/dio.dart';

class InternalServerApiError extends DioException {
  final DioException dioError;

  InternalServerApiError({
    required this.dioError,
  }) : super(requestOptions: dioError.requestOptions);
}

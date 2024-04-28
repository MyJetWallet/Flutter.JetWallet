import 'package:dio/dio.dart';

class UnauthorizedApiError extends DioException {
  final DioException dioError;

  UnauthorizedApiError({
    required this.dioError,
  }) : super(requestOptions: dioError.requestOptions);
}

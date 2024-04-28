import 'package:dio/dio.dart';

class BadNetworkApiError extends DioException {
  final DioException dioError;

  BadNetworkApiError({
    required this.dioError,
  }) : super(requestOptions: dioError.requestOptions);
}

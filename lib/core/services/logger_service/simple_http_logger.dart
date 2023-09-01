import 'package:dio/dio.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/services/logger_service/logger_service.dart';
import 'package:logger/logger.dart';

class SimpleHTTPLogger extends Interceptor {
  SimpleHTTPLogger({
    this.request = true,
    this.requestHeader = false,
    this.requestBody = false,
    this.responseHeader = false,
    this.responseBody = true,
    this.error = true,
  });

  /// Print request [Options]
  final bool request;

  /// Print request header [Options.headers]
  final bool requestHeader;

  /// Print request data [Options.data]
  final bool requestBody;

  /// Print [Response.data]
  final bool responseBody;

  /// Print [Response.headers]
  final bool responseHeader;

  /// Print error message
  final bool error;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    /*
      if (requestHeader) {
        _printMapAsTable(options.queryParameters, header: 'Query Parameters');
        final requestHeaders = <String, dynamic>{};
        requestHeaders.addAll(options.headers);
        requestHeaders['contentType'] = options.contentType?.toString();
        requestHeaders['responseType'] = options.responseType.toString();
        requestHeaders['followRedirects'] = options.followRedirects;
        requestHeaders['connectTimeout'] = options.connectTimeout;
        requestHeaders['receiveTimeout'] = options.receiveTimeout;
        _printMapAsTable(requestHeaders, header: 'Headers');
        _printMapAsTable(options.extra, header: 'Extras');
      }
    */
    var body = '';

    if (requestBody && options.method != 'GET') {
      final dynamic data = options.data;
      if (data != null) {
        body = data.toString();

        /*
        if (data is Map) {
          (options.data as Map?).forEach(
              (dynamic key, dynamic value) => _printKV(key.toString(), value));
        }
        _printMapAsTable(options.data as Map?, header: 'Body');
        if (data is FormData) {
          final formDataMap = <String, dynamic>{}
            ..addEntries(data.fields)
            ..addEntries(data.files);
          _printMapAsTable(formDataMap, header: 'Form data | ${data.boundary}');
        } else {
          _printBlock(data.toString());
        }
        */
      }
    }

    getIt.get<SimpleLoggerService>().log(
      level: Level.info,
      place: 'SimpleNetwork',
      message:
          '''Request ║ ${options.method} ║ ${options.uri}${body.isNotEmpty ? '\nBody: $body' : ''}''',
    );

    super.onRequest(options, handler);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    if (error) {
      if (err.type == DioErrorType.badResponse) {
        var msg = '';

        if (err.response != null && err.response?.data != null) {
          msg = err.response!.data.toString();
        }

        getIt.get<SimpleLoggerService>().log(
          level: Level.error,
          place: 'SimpleNetwork',
          message:
              '''DioError ║ Status: ${err.response?.statusCode} ${err.response?.statusMessage} \n Message: $msg''',
        );
      } else {
        getIt.get<SimpleLoggerService>().log(
              level: Level.error,
              place: 'SimpleNetwork',
              message: 'DioError ║ ${err.type} \n ${err.message}',
            );
      }
    }
    super.onError(err, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    /*
    _printResponseHeader(response);

    if (responseHeader) {
      final responseHeaders = <String, String>{};
      response.headers
          .forEach((k, list) => responseHeaders[k] = list.toString());
      _printMapAsTable(responseHeaders, header: 'Headers');
    }

    if (responseBody) {
      logPrint('╔ Body');
      logPrint('║');
      _printResponse(response);
      logPrint('║');
      _printLine('╚');
    }
    */

    getIt.get<SimpleLoggerService>().log(
          level: Level.info,
          place: 'SimpleNetwork',
          message: 'Response ║ $response',
        );

    super.onResponse(response, handler);
  }
}

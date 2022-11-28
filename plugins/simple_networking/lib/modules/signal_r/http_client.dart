import 'package:http/http.dart' as http;

class SignalRHttpClient extends http.BaseClient {
  SignalRHttpClient({required this.defaultHeaders});
  final _httpClient = http.Client();
  final Map<String, String> defaultHeaders;

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    request.headers.addAll(defaultHeaders);

    return _httpClient.send(request);
  }
}

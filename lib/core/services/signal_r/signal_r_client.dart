import 'package:http/http.dart' as http;

class SignalRClient extends http.BaseClient {
  SignalRClient({required this.defaultHeaders});
  final _httpClient = http.Client();
  final Map<String, String> defaultHeaders;

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    request.headers.addAll(defaultHeaders);

    return _httpClient.send(request);
  }
}

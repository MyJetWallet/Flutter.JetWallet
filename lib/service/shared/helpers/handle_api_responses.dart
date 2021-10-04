import '../models/server_reject_exception.dart';

/// Handles common response with [result] and [data] from the API
/// If data is a primitive type then pass [T] as primitive type
/// else pass just [Map] in the generic field
Map<String, dynamic> handleFullResponse<T>(Map<String, dynamic> json) {
  final result = json['result'] as String;

  _validateResultResponse(result);

  final data = json['data'];

  if (T == Map) {
    return data as Map<String, dynamic>;
  } else {
    return json;
  }
}

/// Handles common response with just [result] from the API
void handleResultResponse(Map<String, dynamic> json) {
  final result = json['result'] as String;

  _validateResultResponse(result);
}

void _validateResultResponse(String result) {
  if (result != 'OK') {
    throw ServerRejectException(result);
  }
}

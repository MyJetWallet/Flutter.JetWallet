import '../models/server_reject_exception.dart';
import 'error_codes_description.dart';

/// Handles common response with [result] and [data] from the API
/// If data is a primitive type then pass [T] as primitive type
/// else pass just [Map] in the generic field
Map<String, dynamic> handleFullResponse<T>(Map<String, dynamic> json) {
  final result = json['result'] as String;

  _validateFullResponse(result, json);

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

void _validateFullResponse(String result, Map<String, dynamic> json) {
  if (result == 'OperationBlocked') {
    final data = json['data'] as Map<String, dynamic>;
    final blockerExpired = data['blockerExpired'] as String;

    throw ServerRejectException(
      'Access to account was restricted, '
      'remaining time is ${_timeLeft(blockerExpired)}.',
    );
  } else if (result != 'OK') {
    throw ServerRejectException(errorCodesDescription[result] ?? result);
  }
}

void _validateResultResponse(String result) {
  if (result != 'OK') {
    throw ServerRejectException(errorCodesDescription[result] ?? result);
  }
}

String _timeLeft(String blockerExpired) {
  final split = blockerExpired.split(':');
  var hours = split[0];
  final minutes = split[1];
  var seconds = split[2];

  if (hours[0] == '-') {
    hours = hours.substring(1);
  }

  seconds = seconds.substring(0, 2);

  final hInt = int.parse(hours);
  final mInt = int.parse(minutes);
  final sInt = int.parse(seconds);

  final hEnd = hInt == 1 ? '' : 's';
  final mEnd = mInt == 1 ? '' : 's';
  final sEnd = sInt == 1 ? '' : 's';

  if (hInt != 0) {
    return '$hInt hour$hEnd $mInt minute$mEnd $sInt second$sEnd';
  } else if (mInt != 0) {
    return '$mInt minute$mEnd $sInt second$sEnd';
  } else {
    return '$sInt second$sEnd';
  }
}

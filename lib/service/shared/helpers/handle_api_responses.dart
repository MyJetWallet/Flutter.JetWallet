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
    final expire = data['blockerExpired'] as String;

    throw ServerRejectException(_blockerMessage(expire));
  } else if (result != 'OK') {
    throw ServerRejectException(errorCodesDescription[result] ?? result);
  }
}

void _validateResultResponse(String result) {
  if (result != 'OK') {
    throw ServerRejectException(errorCodesDescription[result] ?? result);
  }
}

String _blockerMessage(String expire) {
  const phrase1 = 'Access to your account is temporarily restricted';
  const phrase2 = ', time remaining -';

  final split = expire.split(':');
  var hours = split[0];
  final minutes = split[1];
  var seconds = split[2];

  if (hours[0] == '-') {
    hours = hours.substring(1);
  }

  if (hours.contains('.')) {
    return '$phrase1.';
  }

  seconds = seconds.substring(0, 2);

  final hInt = int.parse(hours);
  final mInt = int.parse(minutes);
  final sInt = int.parse(seconds);

  final hEnd = hInt == 1 ? '' : 's';
  final mEnd = mInt == 1 ? '' : 's';
  final sEnd = sInt == 1 ? '' : 's';

  if (hInt != 0) {
    return '$phrase1$phrase2 $hInt hour$hEnd $mInt minute$mEnd.';
  } else if (mInt != 0) {
    return '$phrase1$phrase2 $mInt minute$mEnd.';
  } else if (sInt != 0) {
    return '$phrase1$phrase2 $sInt second$sEnd.';
  } else {
    return '$phrase1.';
  }
}

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
  const phrase1 = 'Due to several failed log in attempts access '
      'to this account will be suspended';
  const phrase2 = ' for';

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

  var hInt = int.parse(hours);
  final dInt = hInt ~/ 24;
  hInt = hInt % 24;
  final mInt = int.parse(minutes);
  final sInt = int.parse(seconds);

  final dEnd = dInt == 1 ? '' : 's';
  final hEnd = hInt == 1 ? '' : 's';
  final mEnd = mInt == 1 ? '' : 's';
  final sEnd = sInt == 1 ? '' : 's';

  if (dInt != 0) {
    return '$phrase1$phrase2 $dInt day$dEnd $hInt hour$hEnd.';
  } else if (hInt != 0) {
    return '$phrase1$phrase2 $hInt hour$hEnd $mInt minute$mEnd.';
  } else if (mInt != 0) {
    return '$phrase1$phrase2 $mInt minute$mEnd.';
  } else if (sInt != 0) {
    return '$phrase1$phrase2 $sInt second$sEnd.';
  } else {
    return '$phrase1.';
  }
}

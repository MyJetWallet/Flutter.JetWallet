import 'package:simple_networking/helpers/models/server_reject_exception.dart';

import 'error_codes_description.dart';

/// Handles common response with [result] and [data] from the API
/// If data is a primitive type then pass [T] as primitive type
/// else pass just [Map] in the generic field
Map<String, dynamic> handleFullResponse<T>(
  Map<String, dynamic> json,
) {
  final result = json['result'] as String;

  _validateFullResponse(result, json);

  final data = json['data'];

  if (T == Map) {
    try {
      return data as Map<String, dynamic>;
    } catch (e) {
      return json;
    }
  } else {
    return json;
  }
}

Map<String, dynamic> handleFullNumberResponse<T>(
  Map<String, dynamic> json,
) {
  final result = json['result'] as String;

  _handleFullNumberResponse(result, json);

  final data = json['data'];

  if (T == Map) {
    try {
      return data as Map<String, dynamic>;
    } catch (e) {
      return json;
    }
  } else {
    return json;
  }
}

/// Handles common response with just [result] from the API
void handleResultResponse(
  Map<String, dynamic> json,
) {
  final result = json['result'] as String;

  if (result != 'OK') {
    throw ServerRejectException(
      json['message'],
    );
  }
}

void validateRejectResponse(
  Map<String, dynamic> json,
) {
  final result = (json['data'] as Map<String, dynamic>)['rejectCode'] == null
      ? 'null'
      : (json['data'] as Map<String, dynamic>)['rejectCode'] as String;

  _validateRejectResponse(result);
}

void _validateFullResponse(
  String result,
  Map<String, dynamic> json,
) {
  if (result != 'OK') {
    throw ServerRejectException(
      json['message'],
    );
  }
  /*
  if (result == 'OperationBlocked') {
    final rejectDetail = json['rejectDetail'] as Map<String, dynamic>?;
    if (rejectDetail != null) {
      final blocker = rejectDetail['blocker'] as Map<String, dynamic>;
      final expired = blocker['expired'] as String;
      throw ServerRejectException(_blockerMessage(timespanToDuration(expired)));
    }
  } else if (result == 'InvalidUserNameOrPassword') {
    final data = json['data'] as Map<String, dynamic>;
    final attempts = data['attempts'] as Map<String, dynamic>?;
    if (attempts == null) {
      throw const ServerRejectException('$emailPasswordIncorrectEn.');
    } else {
      final left = attempts['left'] as int;
      throw ServerRejectException(
        '$emailPasswordIncorrectEn, $left $attemptsRemainingEn.',
      );
    }
  } else if (result == 'InvalidCode') {
    final data = json['rejectDetail'] as Map<String, dynamic>?;

    if (data == null) {
      throw const ServerRejectException('$pinIncorrectEn.');
    } else {
      final attempts = data['attempts'] as Map<String, dynamic>?;
      if (attempts == null) {
        final blocker = data['blocker'] as Map<String, dynamic>?;
        if (blocker == null) {
          throw const ServerRejectException('$pinIncorrectFinalEn.');
        } else {
          final blockerTimes = blocker.toString().split(':');
          final hours = int.parse(blockerTimes[1]);
          final minutes = int.parse(blockerTimes[2]);
          var blockerTimesText = '';
          if (hours > 0) {
            blockerTimesText = hours == 1
                ? '1 $timeRemainingHourEn'
                : '$hours $timeRemainingHoursEn';
          } else if (minutes > 1) {
            blockerTimesText = '$minutes $timeRemainingMinutesEn';
          } else {
            blockerTimesText = '1 $timeRemainingMinuteEn';
          }
          throw ServerRejectException(
            '$pinIncorrectFinalEn, $blockerTimesText.',
          );
        }
      } else {
        final left = attempts['left'] as int;

        throw ServerRejectException(
          '$pinIncorrectEn, $left $attemptsRemainingEn.',
        );
      }
    }
  } else if (result != 'OK') {
    throw ServerRejectException(errorCodesDescriptionEn[result] ?? result);
  }
  */
}

void _handleFullNumberResponse(
  String result,
  Map<String, dynamic> json,
) {
  if (result != 'OK') {
    throw ServerRejectException(json['message']);
  }
  /*
  if (result == 'OperationBlocked') {
    final rejectDetail = json['rejectDetail'] as Map<String, dynamic>?;
    if (rejectDetail != null) {
      final blocker = rejectDetail['blocker'] as Map<String, dynamic>;
      final expired = blocker['expired'] as String;
      throw ServerRejectException(
          _blockerNumberMessage(timespanToDuration(expired)));
    }
  } else if (result != 'OK') {
    throw ServerRejectException(errorCodesDescriptionEn[result] ?? result);
  }
  */
}

void _validateRejectResponse(String rejectCode) {
  if (rejectCode != 'OK' && rejectCode != 'null') {
    throw ServerRejectException(
      errorCodesDescriptionEn[rejectCode] ?? rejectCode,
    );
  }
}

String _blockerMessage(Duration duration) {
  const phrase1 = 'Due to several failed log in attempts access '
      'to this account will be suspended for';

  final d = duration.inDays;
  final h = duration.inHours;
  final m = duration.inMinutes - h * 60;

  final dEnd = _pluralEnd(d);
  final hEnd = _pluralEnd(h);
  final mEnd = _pluralEnd(m);

  if (d != 0) {
    return '$phrase1 $d day$dEnd $h hour$hEnd.';
  } else if (h != 0) {
    return '$phrase1 $h hour$hEnd $m minute$mEnd.';
  } else if (m != 0) {
    return '$phrase1 $m minute$mEnd.';
  } else {
    return '$phrase1 < 1 minute.';
  }
}

String _blockerNumberMessage(Duration duration) {
  const phrase1 = 'Operation blocked for';

  final d = duration.inDays;
  final h = duration.inHours;
  final m = duration.inMinutes - h * 60;

  final dEnd = _pluralEnd(d);
  final hEnd = _pluralEnd(h);
  final mEnd = _pluralEnd(m);

  if (d != 0) {
    return '$phrase1 $d day$dEnd $h hour$hEnd.';
  } else if (h != 0) {
    return '$phrase1 $h hour$hEnd $m minute$mEnd.';
  } else if (m != 0) {
    return '$phrase1 $m minute$mEnd.';
  } else {
    return '$phrase1 < 1 minute.';
  }
}

String _pluralEnd(int number) => number == 1 ? '' : 's';

import '../models/server_reject_exception.dart';
import 'error_codes_description.dart';
import 'timespan_to_duration.dart';

/// Handles common response with [result] and [data] from the API
/// If data is a primitive type then pass [T] as primitive type
/// else pass just [Map] in the generic field
Map<String, dynamic> handleFullResponse<T>(
  Map<String, dynamic> json,
  String localName,
) {
  final result = json['result'] as String;

  _validateFullResponse(result, json, localName);

  final data = json['data'];

  if (T == Map) {
    return data as Map<String, dynamic>;
  } else {
    return json;
  }
}

/// Handles common response with just [result] from the API
void handleResultResponse(
  Map<String, dynamic> json,
  String localName,
) {
  final result = json['result'] as String;

  _validateResultResponse(result);
}

void _validateFullResponse(
  String result,
  Map<String, dynamic> json,
  String localName,
) {
  if (result == 'OperationBlocked') {
    final data = json['data'] as Map<String, dynamic>;
    final blocker = data['blocker'] as Map<String, dynamic>;
    final expired = blocker['expired'] as String;

    throw ServerRejectException(_blockerMessage(timespanToDuration(expired)));
  } else if (result == 'InvalidUserNameOrPassword') {
    final data = json['data'] as Map<String, dynamic>;
    final attempts = data['attempts'] as Map<String, dynamic>?;

    if (attempts == null) {
      /// @Refactor
      /*
      if (localName == 'ru') {
        throw const ServerRejectException(
          '$emailPasswordIncorrectRu.',
        );
      } else {
        throw const ServerRejectException(
          '$emailPasswordIncorrectEn.',
        );
      }
      */
      throw const ServerRejectException(
        '$emailPasswordIncorrectEn.',
      );
    } else {
      final left = attempts['left'] as int;

      /// @Refactor
      /*
      if (localName == 'ru') {
        throw ServerRejectException(
          '$emailPasswordIncorrectRu, '
              '$left $attemptsRemainingRu.',
        );
      } else {
        throw ServerRejectException(
          '$emailPasswordIncorrectEn, '
              '$left $attemptsRemainingEn.',
        );
      }
      */
      throw ServerRejectException(
        '$emailPasswordIncorrectEn, '
        '$left $attemptsRemainingEn.',
      );
    }
  } else if (result != 'OK') {
    /// @Refactor
    /*
    if (localName == 'ru') {
      throw ServerRejectException(errorCodesDescriptionRu[result] ?? result);
    } else {
      throw ServerRejectException(errorCodesDescriptionEn[result] ?? result);
    }
    */
    throw ServerRejectException(errorCodesDescriptionEn[result] ?? result);
  }
}

void _validateResultResponse(String result) {
  if (result != 'OK') {
    throw ServerRejectException(errorCodesDescriptionEn[result] ?? result);
  }
}

String _blockerMessage(Duration duration) {
  const phrase1 = 'Due to several failed log in attempts access '
      'to this account will be suspended for';

  final d = duration.inDays;
  final h = duration.inHours;
  final m = duration.inMinutes;

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

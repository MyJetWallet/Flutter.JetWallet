import 'package:flutter/material.dart';

/// Contains words to describe WithdrawAction
/// Made to show 2 actions inside one flow: [Withdraw] and [Send]
@immutable
class WithdrawalDictionaryModel {
  const WithdrawalDictionaryModel({
    required this.verb,
    required this.noun,
  });

  const WithdrawalDictionaryModel.withdraw()
      : verb = 'Withdraw',
        noun = 'Withdrawal';

  const WithdrawalDictionaryModel.send()
      : verb = 'Send',
        noun = 'Sending';

  final String verb;
  final String noun;
}

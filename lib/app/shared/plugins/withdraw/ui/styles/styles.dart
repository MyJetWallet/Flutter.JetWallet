import 'package:flutter/material.dart';

const InputDecoration baseWithdrawFieldDecoration = InputDecoration(
  hintStyle: TextStyle(
    color: Colors.grey,
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(
      width: 2.0,
    ),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(
      width: 2.0,
    ),
  ),
  border: OutlineInputBorder(),
);

InputDecoration widthdrawAddressDecoration =
    baseWithdrawFieldDecoration.copyWith(
  hintText: 'Withdraw Address',
);

InputDecoration widthdrawTagDecoration = baseWithdrawFieldDecoration.copyWith(
  hintText: 'Withdraw Tag',
);

InputDecoration widthdrawAmountDecoration =
    baseWithdrawFieldDecoration.copyWith(
  hintText: 'Amount',
);

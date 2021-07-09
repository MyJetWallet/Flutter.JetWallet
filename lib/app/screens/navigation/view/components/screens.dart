import 'package:flutter/material.dart';

import '../../../account/view/account.dart';
import '../../../education/education.dart';
import '../../../portfolio/portfolio.dart';
import '../../../wallet/view/wallet.dart';

const screens = [
  Wallet(),
  Portfolio(),
  SizedBox(), // Placeholder to solve RangeError 
  Education(),
  Account(),
];

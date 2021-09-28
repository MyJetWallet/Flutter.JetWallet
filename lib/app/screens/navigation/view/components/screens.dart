import 'package:flutter/material.dart';

import '../../../account/account.dart';
import '../../../education/education.dart';
import '../../../market/view/market.dart';
import '../../../portfolio/view/portfolio.dart';

const screens = [
  Market(),
  Portfolio(),
  SizedBox(), // Placeholder to solve RangeError 
  Education(),
  Account(),
];

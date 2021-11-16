import 'package:flutter/material.dart';

import '../../../account/account.dart';
import '../../../education/education.dart';
import '../../../market/view/market.dart';
import '../../../portfolio/view/portfolio.dart';

List<Widget> screens = [
  Market(),
  const Portfolio(),
  const Education(),
  const Account(),
];

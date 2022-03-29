import 'package:flutter/material.dart';

import '../../../account/account.dart';
import '../../../market/view/market.dart';
import '../../../news/view/news.dart';
import '../../../portfolio/view/portfolio.dart';

List<Widget> screens = [
  const Market(),
  const Portfolio(),
  const News(),
  const Account(),
];

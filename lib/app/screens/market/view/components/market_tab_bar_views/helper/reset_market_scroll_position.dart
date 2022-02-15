import 'package:flutter/material.dart';

const marketItemHeight = 88.0;
const marketHeaderHeight = 160.0;
const marketBottomHeight = 152.0;
const maxScrollOffset = 150.0;

bool resetMarketScrollPosition(
  BuildContext context,
  int itemsLength,
) {
  if (itemsLength == 0) {
    return true;
  }
  final screenHeight = MediaQuery.of(context).size.height;

  final minQuantity =
      ((screenHeight - marketHeaderHeight) - marketBottomHeight) /
          marketItemHeight;

  return minQuantity > itemsLength;
}

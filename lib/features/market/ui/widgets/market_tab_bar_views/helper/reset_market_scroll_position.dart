import 'package:flutter/material.dart';

const marketItemHeight = 88.0;
const marketHeaderHeight = 160.0;
const marketBottomHeight = 152.0;
const maxScrollOffset = 150.0;

void resetMarketScrollPosition(
  BuildContext context,
  int itemsLength,
  ScrollController scrollController,
) {
  if (itemsLength == 0) {
    _resetPosition(scrollController);
  }
  final screenHeight = MediaQuery.of(context).size.height;

  final minQuantity = ((screenHeight - marketHeaderHeight) - marketBottomHeight) / marketItemHeight;

  if (minQuantity > itemsLength) {
    _resetPosition(scrollController);
  }
}

void _resetPosition(ScrollController scrollController) {
  if (scrollController.offset >= maxScrollOffset) {
    scrollController.animateTo(
      0.0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeIn,
    );
  }
}

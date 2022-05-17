import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../providers/service_providers.dart';

List<Map<String, String>> localizedActionItems(BuildContext context) {
  final intl = context.read(intlPod);

  final array = [
    {
      'name': intl.actionBuy_bottomSheetItemTitle1,
      'description': intl.sActionItem_description1,
    },
    {
      'name': intl.buy,
      'description': intl.sActionItem_description2,
    },
    {
      'name': intl.sell,
      'description': intl.sActionItem_description3,
    },
    {
      'name': intl.convert,
      'description': intl.sActionItem_description4,
    },
    {
      'name': intl.actionBuy_bottomSheetItemTitle1,
      'description': intl.sActionItem_description1,
    },
    {
      'name': intl.receive,
      'description': intl.sActionItem_description5,
    },
    {
      'name': intl.send,
      'description': intl.sActionItem_description6,
    },
  ];

  return array;
}

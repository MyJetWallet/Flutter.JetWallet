import 'package:flutter/material.dart';
import 'package:jetwallet/core/l10n/i10n.dart';

List<Map<String, String>> localizedActionItems(BuildContext context) {
  final array = [
    {
      'name': intl.localizedActionItems_buy,
      'description': intl.sActionItem_description1,
    },
    {
      'name': intl.localizedActionItems_buy,
      'description': intl.sActionItem_description2,
    },
    {
      'name': intl.localizedActionItems_sell,
      'description': intl.sActionItem_description3,
    },
    {
      'name': intl.localizedActionItems_Exchange,
      'description': intl.sActionItem_description4,
    },
    {
      'name': intl.localizedActionItems_buy,
      'description': intl.sActionItem_description1,
    },
    {
      'name': intl.localizedActionItems_receive,
      'description': intl.sActionItem_description5,
    },
    {
      'name': intl.localizedActionItems_send,
      'description': intl.sActionItem_description6,
    },
  ];

  return array;
}

import 'package:flutter/material.dart';

/// Processes the given string and returns the first letter
/// from the first 2 words.
String initialsFrom(String string) {
  var value = '';

  final splittedString = string.split(' ');
  final array = <String>[];

  for (final i in splittedString) {
    final replaced = i.replaceAll(' ', '');

    if (replaced.isNotEmpty) {
      array.add(replaced);
    }
  }

  if (array.isEmpty) {
    value = '';
  } else if (array.length == 1) {
    final chars = array.first.characters.toList();

    value = chars.length == 1 ? chars.first : '${chars[0]}${chars[1]}';
  } else {
    final chars1 = array[0].characters.toList();
    final chars2 = array[1].characters.toList();

    value = '${chars1.first}${chars2.first}';
  }

  return value.toUpperCase();
}

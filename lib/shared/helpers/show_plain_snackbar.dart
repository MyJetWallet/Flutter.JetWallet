import 'package:flutter/material.dart';

/// TODO remove (deprecated code)
/// doesn't work with CupertinoApp
void showPlainSnackbar(BuildContext context, String text) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: Colors.grey[200],
      content: Text(
        text,
        style: const TextStyle(
          color: Colors.black,
        ),
      ),
    ),
  );
}

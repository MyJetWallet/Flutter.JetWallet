import 'package:flutter/material.dart';

TextStyle baseFieldStyle = const TextStyle(
  color: Colors.white,
);

InputDecoration baseFieldDecoration = const InputDecoration(
  border: InputBorder.none,
  hintStyle: TextStyle(
    color: Colors.white,
    fontSize: 15,
  ),
  contentPadding: EdgeInsets.only(
    top: 30,
    right: 30,
    bottom: 30,
    left: 5,
  ),
);

InputDecoration emailFieldDecoration = baseFieldDecoration.copyWith(
  icon: const Icon(
    Icons.person_outline,
    color: Colors.white,
  ),
  hintText: 'Email',
);

InputDecoration passwordFieldDecoration({
  required Function() onSuffixTap,
  bool isRepeat = false,
}) {
  return baseFieldDecoration.copyWith(
    icon: const Icon(
      Icons.lock_outline,
      color: Colors.white,
    ),
    suffix: IconButton(
      icon: const Icon(
        Icons.visibility,
        color: Colors.white,
      ),
      onPressed: onSuffixTap,
    ),
    hintText: isRepeat ? 'Repeat Password' : 'Password',
  );
}

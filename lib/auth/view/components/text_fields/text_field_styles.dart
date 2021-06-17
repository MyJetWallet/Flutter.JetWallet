import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

TextStyle baseFieldStyle = const TextStyle(
  color: Colors.black,
);

InputDecoration baseFieldDecoration = const InputDecoration(
  border: UnderlineInputBorder(),
  hintStyle: TextStyle(
    color: Colors.black,
    fontSize: 15,
  ),
  contentPadding: EdgeInsets.only(
    top: 30,
    right: 30,
    bottom: 30,
    left: 5,
  ),
);

InputDecoration emailFieldDecoration(AppLocalizations? intl) {
  return baseFieldDecoration.copyWith(
    icon: const Icon(
      Icons.person_outline,
      color: Colors.white,
    ),
    hintText: intl!.email,
  );
}

InputDecoration passwordFieldDecoration({
  required Function() onSuffixTap,
  required AppLocalizations? intl,
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
    hintText: isRepeat ? intl!.repeatPassword : intl!.password,
  );
}

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../service_providers.dart';
import 'text_field_styles.dart';

class EmailTextField extends HookWidget {
  const EmailTextField({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    final intl = useProvider(intlPod);

    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.emailAddress,
      style: baseFieldStyle,
      decoration: emailFieldDecoration(intl),
    );
  }
}

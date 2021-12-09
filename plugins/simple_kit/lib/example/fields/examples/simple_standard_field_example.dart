import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../../simple_kit.dart';
import '../../shared.dart';

class SimpleStandardFieldExample extends HookWidget {
  const SimpleStandardFieldExample({Key? key}) : super(key: key);

  static const routeName = '/simple_standard_field_example';

  @override
  Widget build(BuildContext context) {
    final emailError = useValueNotifier(StandardFieldErrorNotifier());
    final passwordError = useValueNotifier(StandardFieldErrorNotifier());

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: SPaddingH24(
          child: Column(
            children: [
              TextButton(
                onPressed: () => emailError.value.enableError(),
                child: const Text('Enable Email Error'),
              ),
              TextButton(
                onPressed: () => emailError.value.disableError(),
                child: const Text('Disable Email Error'),
              ),
              TextButton(
                onPressed: () => passwordError.value.enableError(),
                child: const Text('Enable Password Error'),
              ),
              TextButton(
                onPressed: () => passwordError.value.disableError(),
                child: const Text('Disable Password Error'),
              ),
              SStandardField(
                labelText: 'Email Address',
                onChanged: (value) {},
                onErrorIconTap: () => showSnackBar(context),
                errorNotifier: emailError.value,
              ),
              SStandardFieldObscure(
                labelText: 'Password',
                onChanged: (value) {},
                onErrorIconTap: () => showSnackBar(context),
                errorNotifier: passwordError.value,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

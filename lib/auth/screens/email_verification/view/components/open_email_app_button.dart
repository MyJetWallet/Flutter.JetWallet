import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../../shared/helpers/open_email_app.dart';
import '../../../../../shared/providers/service_providers.dart';

class OpenEmailAppButton extends HookWidget {
  const OpenEmailAppButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final intl = useProvider(intlPod);

    return InkWell(
      onTap: () => openEmailApp(context),
      borderRadius: BorderRadius.circular(20.0),
      child: Container(
        width: 140.0,
        height: 26.0,
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey,
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Center(
          child: Text(
            intl.openEmailAppButton_openEmailApp,
            style: const TextStyle(
              fontSize: 16.0,
              color: Colors.black54,
            ),
          ),
        ),
      ),
    );
  }
}

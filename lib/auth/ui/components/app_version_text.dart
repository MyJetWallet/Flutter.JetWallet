import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../service_providers.dart';

class AppVersionText extends HookWidget {
  const AppVersionText({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final intl = useProvider(intlPod);

    return Text(
      '${intl!.jetWalletAppVersion} 1.0.0',
      textAlign: TextAlign.center,
      overflow: TextOverflow.ellipsis,
      softWrap: true,
      style: const TextStyle(
        fontWeight: FontWeight.w300,
        letterSpacing: 0.5,
        color: Colors.grey,
        fontSize: 12,
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../../shared/notifiers/user_info_notifier/user_info_state.dart';
import '../../../../../shared/providers/service_providers.dart';
import '../model/protection_level.dart';

ProtectionLevel protectionLevel(UserInfoState userInfo, BuildContext context) {
  final intl = context.read(intlPod);

  if (userInfo.pinEnabled && userInfo.twoFaEnabled) {
    return ProtectionLevel(
      name: intl.maximum,
      color: Colors.green,
    );
  } else if (userInfo.twoFaEnabled) {
    return ProtectionLevel(
      name: intl.medium,
      color: Colors.yellow,
    );
  } else {
    return ProtectionLevel(
      name: intl.minimum,
      color: Colors.red,
    );
  }
}

import 'package:flutter/material.dart';

import '../../../../../shared/notifiers/user_info_notifier/user_info_state.dart';
import '../model/protection_level.dart';

ProtectionLevel protectionLevel(UserInfoState userInfo) {
  if (userInfo.pinEnabled && userInfo.twoFaEnabled) {
    return const ProtectionLevel(
      name: 'Maximum',
      color: Colors.green,
    );
  } else if (userInfo.twoFaEnabled) {
    return const ProtectionLevel(
      name: 'Medium',
      color: Colors.yellow,
    );
  } else {
    return const ProtectionLevel(
      name: 'Minimum',
      color: Colors.red,
    );
  }
}

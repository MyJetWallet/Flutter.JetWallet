import 'package:flutter/material.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/services/user_info/models/user_info.dart';
import 'package:jetwallet/features/account/account_security/model/protection_level.dart';

ProtectionLevel protectionLevel(
  bool pinEnabled,
  bool twoFaEnabled,
  BuildContext context,
) {
  if (pinEnabled && twoFaEnabled) {
    return ProtectionLevel(
      name: intl.maximum,
      color: Colors.green,
    );
  } else if (twoFaEnabled) {
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

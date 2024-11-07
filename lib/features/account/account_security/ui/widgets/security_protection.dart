import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/services/user_info/user_info_service.dart';
import 'package:jetwallet/features/account/account_security/helper/protection_level.dart';
import 'package:simple_kit/simple_kit.dart';

class SecurityProtection extends StatelessObserverWidget {
  const SecurityProtection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final userInfo = getIt.get<UserInfoService>();
    final level = protectionLevel(userInfo.pinEnabled, userInfo.twoFaEnabled, context);
    final colors = sKit.colors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          alignment: Alignment.bottomLeft,
          height: 40.0,
          child: Text(
            '${level.name} ${intl.securityProtection_protectionLevel}',
            style: sSubtitle3Style.copyWith(
              color: colors.grey1,
            ),
          ),
        ),
        const SpaceH20(),
        SimpleAccountProtectionIndicator(
          indicatorColor: level.color,
        ),
      ],
    );
  }
}

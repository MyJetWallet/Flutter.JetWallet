import 'package:crisp/crisp.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../auth/shared/notifiers/auth_info_notifier/auth_info_notipod.dart';
import '../../../../shared/helpers/navigator_push.dart';
import '../../../../shared/notifiers/user_info_notifier/user_info_notipod.dart';
import '../../../../shared/providers/device_info_pod.dart';
import '../../../../shared/providers/package_info_fpod.dart';
import '../../../../shared/providers/service_providers.dart';
import '../../../../shared/services/remote_config_service/remote_config_values.dart';

class Crisp extends StatefulHookWidget {
  const Crisp({
    Key? key,
    required this.welcomeText,
  }) : super(key: key);

  static void push(
    BuildContext context,
    String welcomeText,
  ) {
    navigatorPush(
      context,
      Crisp(
        welcomeText: welcomeText,
      ),
    );
  }

  final String welcomeText;

  @override
  _CrispState createState() => _CrispState();
}

class _CrispState extends State<Crisp> {
  late CrispMain crispMain;

  @override
  void initState() {
    super.initState();
    final localizations = context.read(intlPod);
    final packageInfo = context.read(packageInfoPod);
    final authInfo = context.read(authInfoNotipod);
    final userInfo = context.read(userInfoNotipod);
    final deviceInfo = context.read(deviceInfoPod);

    crispMain = CrispMain(
      websiteId: crispWebsiteId,
      locale: localizations.localeName,
    );

    crispMain.register(
      user: CrispUser(
        email: authInfo.email,
        nickname: userInfo.firstName.isNotEmpty
            ? '${userInfo.firstName} ${userInfo.lastName}'
            : authInfo.email,
        phone: userInfo.phone,
      ),
    );

    crispMain.setMessage('${widget.welcomeText}!');

    crispMain.setSessionData({
      'app_version': '${packageInfo.version} (${packageInfo.buildNumber})',
      'os_name': deviceInfo.osName,
      'os_version': deviceInfo.version,
      'os_sdk': deviceInfo.sdk,
      'device_manufacturer': deviceInfo.manufacturer,
      'device_model': deviceInfo.model,
      'country_of_registration': userInfo.countryOfRegistration,
      'country_of_residence': userInfo.countryOfResidence,
      'country_of_citizenship': userInfo.countryOfCitizenship,
    });
  }

  @override
  Widget build(BuildContext context) {
    final intl = useProvider(intlPod);

    return SPageFrame(
      header: SPaddingH24(
        child: SSmallHeader(
          title: intl.support,
        ),
      ),
      child: CrispView(
        crispMain: crispMain,
      ),
    );
  }
}

import 'package:auto_route/auto_route.dart';
import 'package:crisp/crisp.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/services/device_info/device_info.dart';
import 'package:jetwallet/core/services/package_info_service.dart';
import 'package:jetwallet/core/services/remote_config/remote_config_values.dart';
import 'package:jetwallet/core/services/user_info/user_info_service.dart';
import 'package:jetwallet/features/app/store/app_store.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';

@RoutePage(name: 'CrispRouter')
class Crisp extends StatefulObserverWidget {
  const Crisp({
    super.key,
    required this.welcomeText,
  });

  final String welcomeText;

  @override
  _CrispState createState() => _CrispState();
}

class _CrispState extends State<Crisp> {
  late CrispMain crispMain;

  @override
  void initState() {
    super.initState();
    final packageInfo = getIt.get<PackageInfoService>().info;
    final authInfo = getIt.get<AppStore>().authState;
    final deviceInfo = sDeviceInfo;

    crispMain = CrispMain(
      websiteId: crispWebsiteId,
      locale: intl.localeName,
    );

    crispMain.register(
      user: CrispUser(
        email: authInfo.email,
        nickname: sUserInfo.firstName.isNotEmpty ? '${sUserInfo.firstName} ${sUserInfo.lastName}' : authInfo.email,
        phone: sUserInfo.phone,
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
      'country_of_registration': sUserInfo.countryOfRegistration,
      'country_of_residence': sUserInfo.countryOfResidence,
      'country_of_citizenship': sUserInfo.countryOfCitizenship,
    });
  }

  @override
  Widget build(BuildContext context) {
    return SPageFrame(
      loaderText: intl.register_pleaseWait,
      header: GlobalBasicAppBar(
        title: intl.crisp_support,
        hasRightIcon: false,
      ),
      child: CrispView(
        crispMain: crispMain,
      ),
    );
  }
}

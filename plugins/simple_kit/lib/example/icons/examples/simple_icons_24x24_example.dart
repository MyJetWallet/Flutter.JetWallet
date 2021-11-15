import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../simple_kit.dart';

class SimpleIcons24X24Example extends StatelessWidget {
  const SimpleIcons24X24Example({Key? key}) : super(key: key);

  static const routeName = '/simple_icons_24x24_example';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(30.w),
          child: GridView.count(
            crossAxisCount: 2,
            children: const [
              SLockIcon(),
              STwoFactorAuthIcon(),
              SChangePinIcon(),
              SSupportIcon(),
              SNotificationsIcon(),
              SLogOutIcon(),
              SFaqIcon(),
              SSecurityIcon(),
              SAboutUsIcon(),
              SProfileDetailsIcon(),
              SBackIcon(),
              SBackPressedIcon(),
              SBigArrowPositiveIcon(),
              SBigArrowNegativeIcon(),
              SCheckboxIcon(),
              SCheckboxSelectedIcon(),
              SCloseIcon(),
              SClosePressedIcon(),
              SEraseIcon(),
              SErasePressedIcon(),
              SErrorIcon(),
              SErrorPressedIcon(),
              SEyeCloseIcon(),
              SEyeClosePressedIcon(),
              SEyeOpenIcon(),
              SEyeOpenPressedIcon(),
              SGiftIcon(),
              SGiftPressedIcon(),
              SInfoIcon(),
              SInfoPressedIcon(),
              SMailIcon(),
              SMailPressedIcon(),
              SPhotoIcon(),
              SPhotoPressedIcon(),
              SSearchIcon(),
              SSearchPressedIcon(),
              SStarIcon(),
              SStarPressedIcon(),
              SStarSelectedIcon(),
              SActionBuyIcon(),
              SActionConvertIcon(),
              SActionDepositIcon(),
              SActionReceiveIcon(),
              SActionSellIcon(),
              SActionSendIcon(),
              SActionWithdrawIcon(),
              SAssetPlaceholderIcon(),
            ],
          ),
        ),
      ),
    );
  }
}

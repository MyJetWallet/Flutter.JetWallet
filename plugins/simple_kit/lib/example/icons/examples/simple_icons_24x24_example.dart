import 'package:flutter/material.dart';

import '../../../simple_kit.dart';

class SimpleIcons24X24Example extends StatelessWidget {
  const SimpleIcons24X24Example({Key? key}) : super(key: key);

  static const routeName = '/simple_icons_24x24_example';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(30.0),
          child: GridView.count(
            crossAxisCount: 2,
            children: const [
              SBlueRightArrowIcon(),
              SCompleteIcon(),
              SBlueRightArrowIcon(),
              SCompleteIcon(),
              SLockIcon(),
              STwoFactorAuthIcon(),
              SChangePinIcon(),
              SSupportIcon(),
              SNotificationsIcon(),
              SLogOutIcon(),
              SFaqIcon(),
              STopUpIcon(),
              SForwardIcon(),
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
              SGiftPortfolioIcon(),
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
              SAngleDownIcon(),
              SAngleDownPressedIcon(),
              SAngleUpIcon(),
              SAngleUpPressedIcon(),
              SCopyIcon(),
              SCopyPressedIcon(),
              SShareIcon(),
              SPasteIcon(),
              SPastePressedIcon(),
              SQrCodeIcon(),
              SQrCodePressedIcon(),
              SWalletIcon(),
              SWireIcon(),
              SAdvCashIcon(),
              SPhoneIcon(),
            ],
          ),
        ),
      ),
    );
  }
}

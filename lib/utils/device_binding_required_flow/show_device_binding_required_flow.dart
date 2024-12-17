import 'package:flutter_ui_kit/flutter_ui_kit.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/user_info/user_info_service.dart';
import 'package:jetwallet/features/phone_verification/ui/phone_verification.dart';
import 'package:jetwallet/utils/helpers/country_code_by_user_register.dart';

Future<void> showDeviceBindingRequiredFlow({
  void Function()? onConfirmed,
  void Function()? onCanceled,
}) async {
  var continueBuying = false;

  await sShowAlertPopup(
    sRouter.navigatorKey.currentContext!,
    primaryText: '',
    secondaryText: intl.device_binding_required_text,
    primaryButtonName: intl.binding_phone_dialog_confirm,
    secondaryButtonName: intl.binding_phone_dialog_cancel,
    onPrimaryButtonTap: () {
      continueBuying = true;
      sRouter.maybePop();
    },
    onSecondaryButtonTap: () {
      continueBuying = false;
      sRouter.maybePop();
      onCanceled?.call();
    },
  );

  if (!continueBuying) return;

  final phoneNumber = countryCodeByUserRegister();
  await sRouter.push(
    PhoneVerificationRouter(
      args: PhoneVerificationArgs(
        isDeviceBinding: true,
        phoneNumber: sUserInfo.phone,
        activeDialCode: phoneNumber,
        onVerified: () {
          sRouter.maybePop();
          onConfirmed?.call();
        },
      ),
    ),
  );
}

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:share_plus/share_plus.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../app/screens/portfolio/view/components/empty_portfolio_body/components/earn_bottom_sheet/earn_bottom_sheet.dart';
import '../../app/shared/components/show_start_earn_options.dart';
import '../../app/shared/features/currency_withdraw/provider/withdraw_dynamic_link_stpod.dart';
import '../../app/shared/features/send_by_phone/provider/send_by_phone_dynamic_link_stpod.dart';
import '../../app/shared/models/currency_model.dart';
import '../../auth/screens/email_verification/notifier/email_verification_notipod.dart';
import '../../auth/screens/login/login.dart';
import '../../auth/screens/reset_password/view/reset_password.dart';
import '../../router/notifier/startup_notifier/authorized_union.dart';
import '../../router/notifier/startup_notifier/startup_notipod.dart';
import '../helpers/navigator_push.dart';
import '../notifiers/logout_notifier/logout_notipod.dart';
import '../notifiers/user_info_notifier/user_info_notipod.dart';
import '../providers/service_providers.dart';
import 'local_storage_service.dart';

/// Parameters
const _code = 'jw_code';
const _token = 'jw_token';
const _command = 'jw_command';
const _operationId = 'jw_operation_id';

/// Commands
const _confirmEmail = 'ConfirmEmail';
const _login = 'Login';
const _forgotPassword = 'ForgotPassword';
const _confirmWithdraw = 'jw_withdrawal_email_confirm';
const _confirmSendByPhone = 'jw_transfer_email_confirm';
const _inviteFriend = 'InviteFriend';
const _referralRedirect = 'ReferralRedirect';
const _depositStart = 'DepositStart';

class DeepLinkService {
  DeepLinkService(this.read);

  final Reader read;

  final _logger = Logger('');

  void handle(Uri link) {
    final parameters = link.queryParameters;
    final command = parameters[_command];

    if (command == _confirmEmail) {
      _confirmEmailCommand(parameters);
    } else if (command == _login) {
      _loginCommand();
    } else if (command == _forgotPassword) {
      _forgotPasswordCommand(parameters);
    } else if (command == _confirmWithdraw) {
      _confirmWithdrawCommand(parameters);
    } else if (command == _confirmSendByPhone) {
      _confirmSendByPhoneCommand(parameters);
    } else if (command == _inviteFriend) {
      _inviteFriendCommand();
    } else if (command == _referralRedirect) {
      _referralRedirectCommand(parameters);
    } else if (command == _depositStart) {
      _depositStartCommand();
    } else {
      _logger.log(Level.INFO, 'Deep link is undefined: $link');
    }
  }

  void _confirmEmailCommand(Map<String, String> parameters) {
    if (read(startupNotipod).authorized is EmailVerification) {
      final notifier = read(emailVerificationNotipod.notifier);

      notifier.updateCode(parameters[_code]);
    }
  }

  void _loginCommand() {
    read(logoutNotipod.notifier).logout();

    navigatorPush(read(sNavigatorKeyPod).currentContext!, const Login());
  }

  void _forgotPasswordCommand(Map<String, String> parameters) {
    ResetPassword.push(
      context: read(sNavigatorKeyPod).currentContext!,
      args: ResetPasswordArgs(token: parameters[_token]!),
    );
  }

  void _confirmWithdrawCommand(Map<String, String> parameters) {
    final id = parameters[_operationId]!;
    read(withdrawDynamicLinkStpod(id)).state = true;
  }

  void _confirmSendByPhoneCommand(Map<String, String> parameters) {
    final id = parameters[_operationId]!;
    read(sendByPhoneDynamicLinkStpod(id)).state = true;
  }

  void _inviteFriendCommand() {
    final userInfo = read(userInfoNotipod);

    sShowBasicModalBottomSheet(
      context: read(sNavigatorKeyPod).currentContext!,
      removePinnedPadding: true,
      removeBottomSheetBar: true,
      removeBarPadding: true,
      horizontalPinnedPadding: 0,
      scrollable: true,
      pinned: const SReferralInvitePinned(),
      pinnedBottom: SReferralInviteBottomPinned(
        onShare: () {
          Share.share(userInfo.referralLink);
        },
      ),
      children: [
        SReferralInviteBody(
          primaryText: 'Invite friends and get \$15',
          qrCodeLink: userInfo.referralLink,
          referralLink: userInfo.referralLink,
        ),
      ],
    );
  }

  void _referralRedirectCommand(Map<String, String> parameters) {
    final storage = read(localStorageServicePod);
    final referralCode = parameters[_code];

    storage.setString(referralCodeKey, referralCode);
  }

  void _depositStartCommand() {
    final context = read(sNavigatorKeyPod).currentContext!;

    showStartEarnBottomSheet(
      context: context,
      onTap: (CurrencyModel currency) {
        Navigator.pop(context);

        showStartEarnOptions(
          currency: currency,
          read: read,
        );
      },
    );
  }
}

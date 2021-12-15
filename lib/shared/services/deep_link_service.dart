import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../app/shared/features/currency_withdraw/provider/withdraw_dynamic_link_stpod.dart';
import '../../auth/screens/email_verification/notifier/email_verification_notipod.dart';
import '../../auth/screens/email_verification/view/email_verification.dart';
import '../../auth/screens/login/login.dart';
import '../../auth/screens/reset_password/view/reset_password.dart';
import '../../router/notifier/startup_notifier/startup_notipod.dart';
import '../helpers/navigator_push.dart';
import '../notifiers/logout_notifier/logout_notipod.dart';
import '../notifiers/user_info_notifier/user_info_notipod.dart';

const _code = 'jw_code';
const _token = 'jw_token';
const _command = 'jw_command';
const _confirmEmail = 'ConfirmEmail';
const _forgotPassword = 'ForgotPassword';
const _login = 'Login';
const _confirmWithdraw = 'jw_withdrawal_email_confirm';
const _confirmSend = 'jw_transfer_email_confirm';
const _operationId = 'jw_operation_id';
const _jwCommand = 'InviteFriend';

class DeepLinkService {
  DeepLinkService(this.read);

  final Reader read;

  final _logger = Logger('');

  void handle(Uri link) {
    final parameters = link.queryParameters;
    final command = parameters[_command];

    if (command == _confirmEmail) {
      if (read(startupNotipod).authorized is EmailVerification) {
        final notifier = read(emailVerificationNotipod.notifier);

        notifier.updateCode(parameters[_code]);
      }
    } else if (command == _login) {
      read(logoutNotipod.notifier).logout();

      navigatorPush(read(sNavigatorKeyPod).currentContext!, const Login());
    } else if (command == _forgotPassword) {
      navigatorPush(
        read(sNavigatorKeyPod).currentContext!,
        ResetPassword(
          token: parameters[_token]!,
        ),
      );
    } else if (command == _confirmWithdraw || command == _confirmSend) {
      final id = parameters[_operationId]!;
      read(withdrawDynamicLinkStpod(id)).state = true;
    } else if (command == _jwCommand) {
      final userInfo = read(userInfoNotipod);

      sShowBasicModalBottomSheet(
        context: read(sNavigatorKeyPod).currentContext!,
        removeBottomHeaderPadding: true,
        removeBottomSheetBar: true,
        removeTopHeaderPadding: true,
        horizontalPinnedPadding: 0,
        scrollable: true,
        pinned: const SReferralInvitePinned(),
        children: [
          SReferralInviteBody(
            primaryText: 'Invite friends and get \$10',
            qrCodeLink: userInfo.referralLink,
            referralLink: userInfo.referralLink,
          ),
        ],
      );
    } else {
      _logger.log(Level.INFO, 'Deep link is undefined');
    }
  }

  // Todo: remove after fix link on backend
  Uri parseDeepLink(String deepLink) {
    final secondPartOfDeepLink = deepLink.split('/?')[1];
    final link = secondPartOfDeepLink.split('&apn')[0];
    return Uri.parse(Uri.decodeComponent(link).split('link=')[1]);
  }
}

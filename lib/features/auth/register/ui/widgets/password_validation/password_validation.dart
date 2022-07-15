import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/services/credentials_service/credentials_service.dart';
import 'package:jetwallet/features/auth/register/store/register_password_store.dart';
import 'package:jetwallet/utils/helpers/string_helper.dart';
import 'package:simple_kit/simple_kit.dart';

class PasswordValidation extends StatelessObserverWidget {
  const PasswordValidation({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SpaceH24(),
        SRequirement(
          passed: isPasswordLengthValid(
            getIt.get<CredentialsService>().password,
          ),
          description: intl.passwordValidation_text1,
        ),
        SRequirement(
          passed: isPasswordHasAtLeastOneLetter(
            getIt.get<CredentialsService>().password,
          ),
          description: intl.passwordValidation_text2,
        ),
        SRequirement(
          passed: isPasswordHasAtLeastOneNumber(
            getIt.get<CredentialsService>().password,
          ),
          description: intl.passwordValidation_text3,
        ),
      ],
    );
  }
}

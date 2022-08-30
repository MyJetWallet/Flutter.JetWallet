import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/features/auth/biometric/store/biometric_store.dart';
import 'package:jetwallet/utils/constants.dart';
import 'package:provider/provider.dart';
import 'package:simple_kit/modules/buttons/basic_buttons/primary_button/public/simple_primary_button_4.dart';
import 'package:simple_kit/modules/headers/simple_auth_header.dart';
import 'package:simple_kit/simple_kit.dart';

class Biometric extends StatelessWidget {
  const Biometric({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Provider<BiometricStore>(
      create: (context) => BiometricStore(),
      builder: (context, child) => const _BiometricBody(),
    );
  }
}

class _BiometricBody extends StatelessObserverWidget {
  const _BiometricBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colors = sKit.colors;
    final biometric = BiometricStore.of(context);

    late String headerText;
    late String buttonText;
    late String image;

    return FutureBuilder<BiometricStatus>(
      future: biometricStatus(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data == BiometricStatus.face) {
            headerText = intl.bio_screen_face_id_title;
            buttonText = intl.bio_screen_face_id_button_text;
            image = bioFaceId;
          } else {
            headerText = intl.bio_screen_touch_id_title;
            buttonText = intl.bio_screen_touch_id_button_text;
            image = bioTouchId;
          }

          return SPageFrame(
            header: SAuthHeader(
              customIconButton: const SpaceH10(),
              title: headerText,
            ),
            child: SPaddingH24(
              child: Column(
                children: [
                  const Spacer(),
                  Image.asset(
                    image,
                    height: 225,
                    width: 225,
                  ),
                  const Spacer(),
                  Text(
                    intl.bio_screen_text,
                    maxLines: 2,
                    style: sBodyText1Style.copyWith(
                      color: colors.grey1,
                    ),
                  ),
                  const SpaceH40(),
                  SPrimaryButton4(
                    active: true,
                    name: buttonText,
                    onTap: () {
                      biometric.useBio(useBio: true);
                    },
                  ),
                  const SpaceH10(),
                  STextButton1(
                    active: true,
                    name: intl.bio_screen_button_late_text,
                    onTap: () {
                      biometric.useBio(useBio: false);
                    },
                  ),
                  const SpaceH24(),
                ],
              ),
            ),
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}

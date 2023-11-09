import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/services/logout_service/logout_service.dart';
import 'package:jetwallet/core/services/sumsub_service/sumsub_service.dart';
import 'package:simple_kit/modules/headers/simple_small_header.dart';
import 'package:simple_kit/modules/icons/40x40/public/user/simple_user_icon.dart';
import 'package:simple_kit/modules/shared/page_frames/simple_page_frame_with_padding.dart';
import 'package:simple_kit/simple_kit.dart';

@RoutePage()
class FaceCheckScreen extends StatelessWidget {
  const FaceCheckScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SPageFrameWithPadding(
      loaderText: '',
      header: SSmallHeader(
        title: '',
        showBackButton: false,
        showCloseButton: true,
        onCLoseButton: () {
          getIt.get<LogoutService>().logout(
                'FaceCheck',
                callbackAfterSend: () {},
              );
        },
      ),
      child: Column(
        children: [
          Center(
            child: Container(
              width: 80,
              height: 80,
              padding: const EdgeInsets.all(20),
              decoration: const ShapeDecoration(
                gradient: LinearGradient(
                  begin: Alignment(-0.90, 0.44),
                  end: Alignment(0.9, -0.44),
                  colors: [Color(0xFF8ADE39), Color(0xFFBEF275)],
                ),
                shape: OvalBorder(),
              ),
              child: const SUserTopIcon(),
            ),
          ),
          const SizedBox(height: 32),
          Text(
            intl.face_check_title,
            style: sTextH4Style,
          ),
          const SizedBox(height: 8),
          Text(
            intl.face_check_subtitle,
            maxLines: 8,
            style: sSubtitle3Style.copyWith(color: sKit.colors.grey1),
          ),
          const Spacer(),
          SPrimaryButton2(
            active: true,
            name: intl.face_check_continue,
            onTap: () async {
              await getIt<SumsubService>().launchFacecheck();
            },
          ),
          const SizedBox(height: 37),
        ],
      ),
    );
  }
}

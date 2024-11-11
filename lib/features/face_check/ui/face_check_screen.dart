import 'dart:async';

import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/services/logout_service/logout_service.dart';
import 'package:jetwallet/core/services/sumsub_service/sumsub_service.dart';
import 'package:jetwallet/features/face_check/store/face_check_store.dart';
import 'package:simple_kit/modules/icons/40x40/public/user/simple_user_icon.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';

@RoutePage()
class FaceCheckScreen extends StatefulWidget {
  const FaceCheckScreen({super.key});

  @override
  State<FaceCheckScreen> createState() => _FaceCheckScreenState();
}

class _FaceCheckScreenState extends State<FaceCheckScreen> {
  final store = FaceCheckStore();

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (context) {
        return SPageFrame(
          loaderText: intl.loader_please_wait,
          loading: store.loader,
          header: GlobalBasicAppBar(
            title: '',
            hasLeftIcon: false,
            onRightIconTap: () {
              getIt.get<LogoutService>().logout(
                    'FaceCheck',
                    callbackAfterSend: () {},
                  );
            },
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
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
                  style: STStyles.header5,
                ),
                const SizedBox(height: 8),
                Text(
                  intl.face_check_subtitle,
                  maxLines: 8,
                  style: STStyles.subtitle2.copyWith(color: sKit.colors.grey1),
                ),
                const Spacer(),
                SButton.blue(
                  text: intl.face_check_continue,
                  callback: () async {
                    unawaited(store.runPreloadLoader());

                    await getIt<SumsubService>().launchFacecheck(store.checkStatus);
                  },
                ),
                const SizedBox(height: 37),
              ],
            ),
          ),
        );
      },
    );
  }
}

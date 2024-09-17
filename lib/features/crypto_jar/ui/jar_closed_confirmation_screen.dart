import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:simple_kit/simple_kit.dart' as sk;
import 'package:simple_kit_updated/simple_kit_updated.dart';

@RoutePage(name: 'JarClosedConfirmationRouter')
class JarClosedConfirmationScreen extends StatefulWidget {
  const JarClosedConfirmationScreen({
    required this.name,
    super.key,
  });

  final String name;

  @override
  State<JarClosedConfirmationScreen> createState() => _JarClosedConfirmationScreenState();
}

class _JarClosedConfirmationScreenState extends State<JarClosedConfirmationScreen> {
  @override
  Widget build(BuildContext context) {
    final colors = sk.sKit.colors;

    return PopScope(
      canPop: false,
      child: sk.SPageFrame(
        loaderText: '',
        color: colors.white,
        header: GlobalBasicAppBar(
          title: '',
          hasLeftIcon: false,
          rightIcon: Assets.svg.medium.close.simpleSvg(),
          onRightIconTap: () {
            getIt<AppRouter>().popUntil((route) {
              return route.settings.name == HomeRouter.name;
            });
          },
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              Assets.images.jar.jarClosed.simpleImg(
                height: 200.0,
                width: 200.0,
              ),
              const SizedBox(
                height: 26,
              ),
              Text(
                intl.jar_closed_title('"${widget.name}"'),
                softWrap: true,
                textAlign: TextAlign.center,
                overflow: TextOverflow.visible,
                style: STStyles.header3.copyWith(
                  color: SColorsLight().black,
                ),
              ),
              const SizedBox(
                height: 8.0,
              ),
              Text(
                intl.jar_closed_hint,
                style: STStyles.body2Medium.copyWith(
                  color: SColorsLight().gray10,
                ),
              ),
              const Spacer(),
              SButton.black(
                text: intl.jar_done,
                callback: () {
                  getIt<AppRouter>().popUntil(
                    (route) {
                      return route.settings.name == HomeRouter.name;
                    },
                  );
                },
              ),
              const SizedBox(
                height: 50.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

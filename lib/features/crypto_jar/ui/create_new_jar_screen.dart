import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/local_storage_service.dart';
import 'package:jetwallet/features/crypto_jar/store/create_jar_store.dart';
import 'package:jetwallet/features/crypto_jar/store/jars_store.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart' as sk;
import 'package:simple_kit_updated/simple_kit_updated.dart';

@RoutePage(name: 'CreateNewJarRouter')
class CreateNewJarScreen extends StatefulWidget {
  const CreateNewJarScreen({
    required this.name,
    required this.goal,
    super.key,
  });

  final String name;
  final int goal;

  @override
  State<CreateNewJarScreen> createState() => _CreateNewJarScreenState();
}

class _CreateNewJarScreenState extends State<CreateNewJarScreen> {
  bool isPolicyAgree = false;

  @override
  void initState() {
    super.initState();

    sAnalytics.jarScreenViewCreatingJar();
  }

  @override
  Widget build(BuildContext context) {
    final colors = sk.sKit.colors;

    return sk.SPageFrame(
      loaderText: '',
      color: colors.white,
      header: const GlobalBasicAppBar(
        title: '',
        hasRightIcon: false,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            Assets.images.jar.jarEmpty.simpleImg(
              height: 200.0,
              width: 200.0,
            ),
            const SizedBox(
              height: 26,
            ),
            Text(
              intl.jar_creating_jar_title('"${widget.name}"'),
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
              intl.jar_target_amount_hint('USDT', widget.goal),
              style: STStyles.body2Medium.copyWith(
                color: SColorsLight().gray10,
              ),
            ),
            const Spacer(),
            FutureBuilder<String?>(
              future: getIt.get<LocalStorageService>().getValue(isJarTermsConfirmed),
              builder: (context, snap) {
                if (snap.hasData) {
                  if (!isPolicyAgree && (bool.parse(snap.data ?? 'false'))) {
                    Future.microtask(() {
                      setState(() {
                        isPolicyAgree = true;
                      });
                    });
                  }
                }

                return sk.SPolicyCheckbox(
                  firstText: intl.jar_terms1,
                  userAgreementText: intl.jar_terms2,
                  betweenText: '                                     ',
                  privacyPolicyText: '',
                  isChecked: isPolicyAgree,
                  onCheckboxTap: () {
                    setState(() {
                      isPolicyAgree = !isPolicyAgree;
                    });
                  },
                  onUserAgreementTap: () {},
                  onPrivacyPolicyTap: () {},
                );
              },
            ),
            const SizedBox(
              height: 32.0,
            ),
            Observer(
              builder: (context) {
                final loading = getIt.get<CreateJarStore>().loading;

                return SButton.black(
                  isLoading: loading,
                  text: intl.jar_create,
                  callback: isPolicyAgree
                      ? () async {
                          sAnalytics.jarTapOnButtonCreateOnCreatingJar(
                            asset: 'USDT',
                            network: 'TRC20',
                            target: widget.goal,
                          );

                          await getIt.get<LocalStorageService>().setString(isJarTermsConfirmed, true.toString());
                          final result = await getIt.get<CreateJarStore>().createNewJar(widget.name, widget.goal);

                          if (result != null) {
                            getIt.get<JarsStore>().addNewJar(result);
                            await getIt<AppRouter>().push(
                              JarRouter(
                                jar: result,
                                hasLeftIcon: false,
                              ),
                            );
                          }
                        }
                      : null,
                );
              },
            ),
            const SizedBox(
              height: 50.0,
            ),
          ],
        ),
      ),
    );
  }
}

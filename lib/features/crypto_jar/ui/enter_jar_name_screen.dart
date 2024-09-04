import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/features/crypto_jar/store/jars_store.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart' as sk;
import 'package:simple_kit_updated/simple_kit_updated.dart';
import 'package:simple_networking/modules/wallet_api/models/jar/jar_response_model.dart';

@RoutePage(name: 'EnterJarNameRouter')
class EnterJarNameScreen extends StatefulWidget {
  const EnterJarNameScreen({
    this.isCreatingNewJar = true,
    this.jar,
    super.key,
  });

  final bool isCreatingNewJar;
  final JarResponseModel? jar;

  @override
  State<EnterJarNameScreen> createState() => _EnterJarNameScreenState();
}

class _EnterJarNameScreenState extends State<EnterJarNameScreen> {
  final TextEditingController nameController = TextEditingController();

  @override
  void initState() {
    super.initState();

    sAnalytics.jarScreenViewJarName();

    if (widget.jar != null) {
      nameController.text = widget.jar!.title;
    }

    nameController.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = sk.sKit.colors;

    final mediaQuery = MediaQuery.of(context);
    final screenHeight = mediaQuery.size.height - 64 - 53;
    final keyboardHeight = mediaQuery.viewInsets.bottom;

    return sk.SPageFrame(
      resizeToAvoidBottomInset: false,
      loaderText: '',
      color: colors.white,
      header: const GlobalBasicAppBar(
        title: '',
        hasRightIcon: false,
      ),
      child: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: screenHeight,
          ),
          child: IntrinsicHeight(
            child: Column(
              children: [
                Assets.images.jar.jarEmpty.simpleImg(
                  height: 160.0,
                  width: 160.0,
                ),
                const SizedBox(
                  height: 12.0,
                ),
                Text(
                  intl.jar_input_jar_name,
                  style: STStyles.header6.copyWith(
                    color: SColorsLight().black,
                  ),
                ),
                const Spacer(),
                SInput(
                  label: intl.jar_jar_name,
                  controller: nameController,
                  hasCloseIcon: true,
                  autofocus: true,
                  textCapitalization: TextCapitalization.sentences,
                  onCloseIconTap: () {
                    nameController.clear();
                  },
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(jarNameLength),
                  ],
                ),
                Container(
                  height: 26.0 + 24.0 + 56.0 + keyboardHeight,
                  width: double.infinity,
                  color: SColorsLight().gray2,
                  child: Column(
                    children: [
                      const SizedBox(height: 26.0),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        child: SButton.black(
                          text: widget.isCreatingNewJar ? intl.jar_next : intl.jar_confirm,
                          callback:
                              (nameController.text.trim().isNotEmpty && nameController.text.length <= jarNameLength)
                                  ? () async {
                                      sAnalytics.jarTapOnButtonNextOnJarName();
                                      if (widget.isCreatingNewJar) {
                                        await getIt<AppRouter>().push(
                                          EnterJarGoalRouter(
                                            name: nameController.text.trim(),
                                          ),
                                        );
                                      } else {
                                        final result = await getIt.get<JarsStore>().updateJar(
                                              jarId: widget.jar!.id,
                                              title: nameController.text.trim(),
                                              target: widget.jar!.target.toInt(),
                                              description: widget.jar!.description,
                                              imageUrl: widget.jar!.imageUrl,
                                            );

                                        if (result != null) {
                                          getIt.get<JarsStore>().selectedJar = result;
                                          await getIt<AppRouter>().push(
                                            JarRouter(
                                              hasLeftIcon: false,
                                            ),
                                          );
                                        }
                                      }
                                    }
                                  : null,
                        ),
                      ),
                      const Spacer(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

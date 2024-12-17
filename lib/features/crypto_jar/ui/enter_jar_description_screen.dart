import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ui_kit/flutter_ui_kit.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/features/crypto_jar/helpers/jar_extension.dart';
import 'package:jetwallet/features/crypto_jar/store/jars_store.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_networking/modules/wallet_api/models/jar/jar_response_model.dart';

@RoutePage(name: 'EnterJarDescriptionRouter')
class EnterJarDescriptionScreen extends StatefulWidget {
  const EnterJarDescriptionScreen({
    required this.name,
    this.isCreatingNewJar = true,
    this.jar,
    super.key,
  });

  final String name;
  final bool isCreatingNewJar;
  final JarResponseModel? jar;

  @override
  State<EnterJarDescriptionScreen> createState() => _EnterJarDescriptionScreenState();
}

class _EnterJarDescriptionScreenState extends State<EnterJarDescriptionScreen> {
  final TextEditingController _descriptionController = TextEditingController();

  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    sAnalytics.jarScreenViewJarDescription();

    if (widget.jar != null) {
      if (widget.jar!.description != null) {
        _descriptionController.text = widget.jar!.description!;
      }
    }

    _descriptionController.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = SColorsLight();

    final mediaQuery = MediaQuery.of(context);
    final screenHeight = mediaQuery.size.height - 64 - 53;
    final keyboardHeight = mediaQuery.viewInsets.bottom;

    return SPageFrame(
      resizeToAvoidBottomInset: false,
      loaderText: '',
      color: colors.white,
      header: GlobalBasicAppBar(
        title: '',
        hasRightIcon: widget.isCreatingNewJar,
        rightIcon: SafeGesture(
          onTap: () {
            getIt<AppRouter>().push(
              EnterJarGoalRouter(
                name: widget.name,
                description: '',
              ),
            );
          },
          child: Text(
            intl.jar_skip,
            style: STStyles.button.copyWith(
              color: SColorsLight().blue,
            ),
          ),
        ),
      ),
      child: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: screenHeight,
          ),
          child: IntrinsicHeight(
            child: Column(
              children: [
                if (widget.jar != null)
                  widget.jar!.getIcon(height: 160.0, width: 160.0)
                else
                  Assets.images.jar.jarEmpty.simpleImg(
                    height: 160.0,
                    width: 160.0,
                  ),
                const SizedBox(
                  height: 12.0,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    intl.jar_description_title,
                    style: STStyles.header6.copyWith(
                      color: SColorsLight().black,
                    ),
                    maxLines: 5,
                    textAlign: TextAlign.center,
                  ),
                ),
                const Spacer(),
                SInput(
                  label: intl.jar_description,
                  controller: _descriptionController,
                  hasCloseIcon: true,
                  autofocus: true,
                  textCapitalization: TextCapitalization.sentences,
                  onCloseIconTap: () {
                    _descriptionController.clear();
                  },
                  inputFormatters: [
                    FilteringTextInputFormatter.deny(RegExp(r'\n')),
                    LengthLimitingTextInputFormatter(jarDescriptionLength),
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
                          isLoading: isLoading,
                          text: widget.isCreatingNewJar ? intl.jar_next : intl.jar_confirm,
                          callback: _descriptionController.text.trim() != widget.jar?.description &&
                                  _descriptionController.text.trim().isNotEmpty &&
                                  _descriptionController.text.length <= jarDescriptionLength
                              ? () async {
                                  sAnalytics.jarTapOnButtonNextOnJarDescription();

                                  if (widget.isCreatingNewJar) {
                                    await getIt<AppRouter>().push(
                                      EnterJarGoalRouter(
                                        name: widget.name,
                                        description: _descriptionController.text.trim(),
                                      ),
                                    );
                                  } else {
                                    setState(() {
                                      isLoading = true;
                                    });

                                    final result = await getIt.get<JarsStore>().updateJar(
                                          jarId: widget.jar!.id,
                                          title: widget.jar!.title,
                                          target: widget.jar!.target.toInt(),
                                          description: _descriptionController.text.trim(),
                                          imageUrl: widget.jar!.imageUrl,
                                        );

                                    if (result != null) {
                                      getIt.get<JarsStore>().setSelectedJar(result);

                                      setState(() {
                                        isLoading = false;
                                      });

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

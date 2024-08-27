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

@RoutePage(name: 'EnterJarDescriptionRouter')
class EnterJarDescriptionScreen extends StatefulWidget {
  const EnterJarDescriptionScreen({
    required this.jar,
    this.isOnlyEdit = true,
    super.key,
  });

  final JarResponseModel jar;
  final bool isOnlyEdit;

  @override
  State<EnterJarDescriptionScreen> createState() => _EnterJarDescriptionScreenState();
}

class _EnterJarDescriptionScreenState extends State<EnterJarDescriptionScreen> {
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();

    sAnalytics.jarScreenViewJarDescription();

    _descriptionController.text = widget.jar.description;

    _descriptionController.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = sk.sKit.colors;

    return sk.SPageFrame(
      loaderText: '',
      color: colors.white,
      header: GlobalBasicAppBar(
        title: '',
        hasRightIcon: !widget.isOnlyEdit,
        rightIcon: SafeGesture(
          onTap: () {
            getIt<AppRouter>().push(
              JarShareRouter(
                jar: widget.jar,
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
            intl.jar_description_title,
            style: STStyles.header6.copyWith(
              color: SColorsLight().black,
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
              LengthLimitingTextInputFormatter(jarDescriptionLength),
            ],
          ),
          Container(
            height: 26.0 + 24.0 + 56.0,
            width: double.infinity,
            color: SColorsLight().gray2,
            child: Column(
              children: [
                const SizedBox(height: 26.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: SButton.black(
                    text: widget.isOnlyEdit ? intl.jar_confirm : intl.jar_next,
                    callback: _descriptionController.text != widget.jar.description &&
                            _descriptionController.text.length <= jarDescriptionLength
                        ? () async {
                            sAnalytics.jarTapOnButtonNextOnJarDescription();

                            final result = await getIt.get<JarsStore>().updateJar(
                                  jarId: widget.jar.id,
                                  title: widget.jar.title,
                                  target: widget.jar.target.toInt(),
                                  description: _descriptionController.text,
                                  imageUrl: widget.jar.imageUrl,
                                );

                            if (result != null) {
                              if (widget.isOnlyEdit) {
                                await getIt<AppRouter>().push(
                                  JarRouter(
                                    hasLeftIcon: false,
                                    jar: result,
                                  ),
                                );
                              } else {
                                await getIt<AppRouter>().push(
                                  JarShareRouter(
                                    jar: result,
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
    );
  }
}

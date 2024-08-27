import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/notification_service.dart';
import 'package:jetwallet/features/crypto_jar/store/jars_store.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart' as sk;
import 'package:simple_kit_updated/simple_kit_updated.dart';
import 'package:simple_networking/modules/wallet_api/models/jar/jar_response_model.dart';

@RoutePage(name: 'EnterJarGoalRouter')
class EnterJarGoalScreen extends StatefulWidget {
  const EnterJarGoalScreen({
    required this.name,
    this.isCreatingNewJar = true,
    this.jar,
    super.key,
  });

  final String name;
  final bool isCreatingNewJar;
  final JarResponseModel? jar;

  @override
  State<EnterJarGoalScreen> createState() => _EnterJarGoalScreenState();
}

class _EnterJarGoalScreenState extends State<EnterJarGoalScreen> {
  final TextEditingController _goalController = TextEditingController();

  double _textWidth = 0;
  bool showError = false;

  @override
  void initState() {
    super.initState();

    sAnalytics.jarScreenViewJarGoal();

    if (widget.jar != null) {
      _goalController.text = widget.jar!.target.toInt().toString();
    }

    _goalController.addListener(() {
      if ((int.tryParse(_goalController.text) ?? 0) > jarMaxGoal) {
        if (!showError) {
          showError = true;
          sNotification.showError(intl.jar_input_jar_goal_error);
        }
      } else {
        showError = false;
      }
      _calculateTextWidth();
    });
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
      child: Column(
        children: [
          Assets.images.jar.jarEmpty.simpleImg(
            height: 160.0,
            width: 160.0,
          ),
          const SizedBox(
            height: 12,
          ),
          Text(
            intl.jar_input_jar_goal,
            style: STStyles.header6.copyWith(
              color: SColorsLight().black,
            ),
          ),
          const Spacer(),
          Stack(
            children: [
              SInput(
                label: intl.jar_purpose,
                controller: _goalController,
                hasCloseIcon: true,
                autofocus: true,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(6),
                  FilteringTextInputFormatter.allow(
                    RegExp('[0-9]'),
                  ),
                ],
                keyboardType: TextInputType.number,
                onCloseIconTap: () {
                  _goalController.clear();
                },
              ),
              Positioned(
                top: 33.0,
                left: 24.0 + _textWidth,
                child: Text(
                  'USDT',
                  style: STStyles.subtitle1.copyWith(
                    color: SColorsLight().gray8,
                  ),
                ),
              ),
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
                    text: widget.isCreatingNewJar ? intl.jar_next : intl.jar_confirm,
                    callback: _goalController.text.isNotEmpty &&
                            (int.tryParse(_goalController.text) ?? 0) <= jarMaxGoal &&
                            (int.tryParse(_goalController.text) ?? 0) >= 1
                        ? () async {
                            sAnalytics.jarTapOnButtonNextOnJarPurpose(
                              asset: 'USDT',
                              network: 'TRC20',
                              target: int.parse(_goalController.text),
                            );

                            if (widget.isCreatingNewJar) {
                              await getIt<AppRouter>().push(
                                CreateNewJarRouter(
                                  name: widget.name,
                                  goal: int.parse(_goalController.text),
                                ),
                              );
                            } else {
                              final result = await getIt.get<JarsStore>().updateJar(
                                    jarId: widget.jar!.id,
                                    title: widget.jar!.title,
                                    target: int.tryParse(_goalController.text),
                                    description: widget.jar!.description,
                                    imageUrl: widget.jar!.imageUrl,
                                  );

                              if (result != null) {
                                await getIt<AppRouter>().push(
                                  JarRouter(
                                    hasLeftIcon: false,
                                    jar: result,
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
    );
  }

  void _calculateTextWidth() {
    final textSpan = TextSpan(
      text: '${_goalController.text} ',
      style: STStyles.subtitle1.copyWith(
        color: SColorsLight().black,
      ),
    );

    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );

    textPainter.layout();
    setState(() {
      _textWidth = textPainter.size.width;
    });
  }
}

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:simple_kit/simple_kit.dart' as sk;
import 'package:simple_kit_updated/simple_kit_updated.dart';

@RoutePage(name: 'CreateNewJarGoalRouter')
class CreateNewJarGoalScreen extends StatefulWidget {
  const CreateNewJarGoalScreen({
    required this.name,
    super.key,
  });

  final String name;

  @override
  State<CreateNewJarGoalScreen> createState() => _CreateNewJarGoalScreenState();
}

class _CreateNewJarGoalScreenState extends State<CreateNewJarGoalScreen> {
  final TextEditingController goalController = TextEditingController();

  @override
  void initState() {
    super.initState();

    goalController.addListener(() {
      if ((int.tryParse(goalController.text) ?? 0) > 15000) {

      }
      setState(() {});
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
          SInput(
            label: intl.jar_purpose,
            controller: goalController,
            hasCloseIcon: true,
            autofocus: true,
            inputFormatters: [
              FilteringTextInputFormatter.allow(
                RegExp('[0-9]'),
              ),
            ],
            keyboardType: TextInputType.number,
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
                    text: intl.jar_next,
                    callback: goalController.text.isNotEmpty
                        ? () {
                            getIt<AppRouter>().push(
                              CreateNewJarRouter(
                                name: widget.name,
                                goal: int.parse(goalController.text),
                              ),
                            );
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

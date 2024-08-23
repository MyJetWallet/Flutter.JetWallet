import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:simple_kit/simple_kit.dart' as sk;
import 'package:simple_kit_updated/simple_kit_updated.dart';

@RoutePage(name: 'CreateNewJarNameRouter')
class CreateNewJarNameScreen extends StatefulWidget {
  const CreateNewJarNameScreen({super.key});

  @override
  State<CreateNewJarNameScreen> createState() => _CreateNewJarNameScreenState();
}

class _CreateNewJarNameScreenState extends State<CreateNewJarNameScreen> {
  final TextEditingController nameController = TextEditingController();

  @override
  void initState() {
    super.initState();

    nameController.addListener(() {
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
                    callback: nameController.text.isNotEmpty
                        ? () {
                            getIt<AppRouter>().push(
                              CreateNewJarGoalRouter(
                                name: nameController.text,
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

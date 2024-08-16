import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:jetwallet/core/di/di.dart';
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
  final TextEditingController name = TextEditingController();

  @override
  void initState() {
    super.initState();

    name.addListener(() {
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
        hasRightIcon: false,
      ),
      child: Column(
        children: [
          SizedBox(
            height: 160.0,
            width: 160.0,
            child: Image.asset('assets/images/jar_empty.png'),
          ),
          SizedBox(
            height: 12,
          ),
          Text(
            'What is your goal?',
            style: STStyles.header6.copyWith(
              color: SColorsLight().black,
            ),
          ),
          const Spacer(),
          SInput(
            label: 'Purpose',
            controller: name,
            hasCloseIcon: true,
            autofocus: true,
            keyboardType: TextInputType.number,
          ),
          Container(
            height: 26.0 + 24.0 + 56.0,
            width: double.infinity,
            color: SColorsLight().gray2,
            child: Column(
              children: [
                SizedBox(height: 26.0),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.0),
                  child: SButton.black(
                    text: 'Next',
                    callback: name.text.isNotEmpty
                        ? () {
                            getIt<AppRouter>().push(CreateNewJarRouter(name: widget.name, goal: int.parse(name.text), ));
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

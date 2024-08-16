import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/simple_networking/simple_networking.dart';
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
  bool isPolicyAgree = true;

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
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            SizedBox(
              height: 200.0,
              width: 200.0,
              child: Image.asset('assets/images/jar_empty.png'),
            ),
            SizedBox(
              height: 26,
            ),
            Text(
              'You are creating jar "${widget.name}"',
              style: STStyles.header3.copyWith(
                color: SColorsLight().black,
              ),
            ),
            SizedBox(
              height: 8.0,
            ),
            Text(
              'The target amount is ${widget.goal} USDT',
              style: STStyles.body2Medium.copyWith(
                color: SColorsLight().gray10,
              ),
            ),
            const Spacer(),
            sk.SPolicyCheckbox(
              firstText: 'I have read and agreed to ',
              userAgreementText: 'Terms and conditions',
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
            ),
            SizedBox(
              height: 32.0,
            ),
            SButton.black(
              text: 'Create',
              callback: isPolicyAgree
                  ? () {
                sNetwork.getWalletModule().postCreateJar(
                  assetSymbol: 'USDT',
                  blockchain: 'TRC20',
                  target: widget.goal,
                  imageUrl: '',
                  title: widget.name,
                  description: '',
                );
                getIt<AppRouter>().push(JarRouter(
                  name: widget.name,
                  goal: widget.goal,
                ));
              }
                  : null,
            ),
            SizedBox(
              height: 50.0,
            ),
          ],
        ),
      ),
    );
  }
}

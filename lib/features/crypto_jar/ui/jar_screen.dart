import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:simple_kit/simple_kit.dart' as sk;
import 'package:simple_kit_updated/simple_kit_updated.dart';
import 'package:simple_networking/modules/wallet_api/models/jar/jar_response_model.dart';

@RoutePage(name: 'JarRouter')
class JarScreen extends StatefulWidget {
  const JarScreen({
    required this.jar,
    super.key,
  });

  final JarResponseModel jar;

  @override
  State<JarScreen> createState() => _JarScreenState();
}

class _JarScreenState extends State<JarScreen> {
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
        hasLeftIcon: false,
        rightIcon: Assets.svg.medium.close.simpleSvg(),
        onRightIconTap: () {
          getIt<AppRouter>().popUntil((route) {
            return route.settings.name == HomeRouter.name;
          });
        },
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.center,
              child: SizedBox(
                height: 200.0,
                width: 200.0,
                child: Image.asset('assets/images/jar_empty.png'),
              ),
            ),
            SizedBox(
              height: 24,
            ),
            Text(
              'Crypto Jar',
              style: STStyles.body2Semibold.copyWith(
                color: SColorsLight().gray10,
              ),
            ),
            Row(
              children: [
                Text(
                  widget.jar.title,
                  style: STStyles.header5.copyWith(
                    color: SColorsLight().black,
                  ),
                ),
                const Spacer(),
                Text(
                  '0 EUR',
                  style: STStyles.header5.copyWith(
                    color: SColorsLight().black,
                  ),
                ),
              ],
            ),
            Text(
              '${widget.jar.balance} / ${widget.jar.target} ${widget.jar.assetSymbol}',
              style: STStyles.body1Medium.copyWith(
                color: SColorsLight().gray10,
              ),
            ),
            SizedBox(
              height: 36.0,
            ),
            Row(
              children: [
                const Spacer(),
                _buildButton(
                  'Share',
                  Assets.svg.medium.share.simpleSvg(color: SColorsLight().white),
                  SColorsLight().blueDark,
                ),
                SizedBox(
                  width: 8.0,
                ),
                _buildButton(
                  'Withdraw',
                  Assets.svg.medium.withdrawal.simpleSvg(color: SColorsLight().white),
                  SColorsLight().black,
                  false,
                ),
                SizedBox(
                  width: 8.0,
                ),
                _buildButton(
                  'Close',
                  Assets.svg.medium.close.simpleSvg(color: SColorsLight().white),
                  SColorsLight().black,
                ),
                SizedBox(
                  width: 8.0,
                ),
                _buildButton(
                  'More',
                  Assets.svg.medium.more.simpleSvg(color: SColorsLight().white),
                  SColorsLight().black,
                ),
                const Spacer(),
              ],
            ),
            SizedBox(
              height: 44.0,
            ),
            Text(
              'Transactions',
              style: STStyles.header5.copyWith(
                color: SColorsLight().black,
              ),
            ),
            SizedBox(
              height: 12.0,
            ),
            Container(
              height: 32.0,
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                horizontal: 12.0,
                vertical: 6.0,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: SColorsLight().gray2,
              ),
              child: Text(
                'No funds withdrawn',
                style: STStyles.body2Medium.copyWith(
                  color: SColorsLight().gray10,
                ),
              ),
            ),
            SizedBox(
              height: 68.0,
            ),
            Align(
              alignment: Alignment.center,
              child: SizedBox(
                height: 48.0,
                width: 48.0,
                child: Image.asset('assets/images/simple_1.png'),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 56),
                child: Text(
                  'Your transactions will appear here',
                  style: STStyles.subtitle2.copyWith(
                    color: SColorsLight().gray8,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButton(String text, Widget icon, Color color, [bool active = true]) {
    return Opacity(
      opacity: active ? 1 : 0.2,
      child: SizedBox(
        height: 76.0,
        width: 76.0,
        child: Column(
          children: [
            Container(
              height: 48.0,
              width: 48.0,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color,
              ),
              child: Center(
                child: icon,
              ),
            ),
            SizedBox(
              height: 12.0,
            ),
            Text(
              text,
              style: STStyles.captionSemibold.copyWith(
                color: SColorsLight().black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

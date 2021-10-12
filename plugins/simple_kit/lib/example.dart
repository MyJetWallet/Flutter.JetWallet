import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'simple_kit.dart';

class ExampleScreen extends StatefulWidget {
  const ExampleScreen({Key? key}) : super(key: key);

  @override
  State<ExampleScreen> createState() => _ExampleScreenState();
}

class _ExampleScreenState extends State<ExampleScreen> {
  var _light = true;

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      builder: () {
        return MaterialApp(
          theme: _light ? sLightTheme : sDarkTheme,
          debugShowCheckedModeBanner: false,
          home: Home(
            mySwitch: Switch(
              value: _light,
              onChanged: (toggle) {
                setState(() {
                  _light = toggle;
                });
              },
            ),
          ),
        );
      },
    );
  }
}

class Home extends StatelessWidget {
  const Home({
    Key? key,
    required this.mySwitch,
  }) : super(key: key);

  final Switch mySwitch;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            mySwitch,
          ],
        ),
      ),
    );
  }
}

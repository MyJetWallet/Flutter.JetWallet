import 'package:flutter/material.dart';

import '../theme/styles.dart';
import 'loader.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: backgroundImage,
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: <Color>[
              Color.fromRGBO(162, 146, 199, 0.8),
              Color.fromRGBO(51, 51, 63, 0.9),
            ],
            stops: [0.2, 1.0],
            begin: FractionalOffset(0, 0),
            end: FractionalOffset(0, 1),
          ),
        ),
        child: Loader(),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class CurrencyBuy extends StatelessWidget {
  const CurrencyBuy({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: const Center(
        child: Text(
          'Currency Buy flow',
        ),
      ),
    );
  }
}

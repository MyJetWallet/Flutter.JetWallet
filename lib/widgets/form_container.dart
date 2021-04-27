import 'package:flutter/material.dart';
import 'package:jetwallet/widgets/input_field_area.dart';

class FormContainer extends StatelessWidget {
  const FormContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Form(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: const <Widget>[
                InputFieldArea(
                  hint: 'Username',
                  obscure: false,
                  icon: Icons.person_outline,
                ),
                InputFieldArea(
                  hint: 'Password',
                  obscure: true,
                  icon: Icons.lock_outline,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

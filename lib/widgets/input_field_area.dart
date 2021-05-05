import 'package:flutter/material.dart';
import 'package:jetwallet/screens/login/login_screen.dart';

class InputFieldArea extends StatelessWidget {
  InputFieldArea({
    required this.hint,
    required this.obscure,
    required this.icon,
    Key? key,
  }) : super(key: key);

  final String hint;
  final bool obscure;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            width: 0.5,
            color: Colors.white24,
          ),
        ),
      ),
      child: TextFormField(
        obscureText: obscure,
        style: const TextStyle(
          color: Colors.white,
        ),
        decoration: InputDecoration(
          icon: Icon(
            icon,
            color: Colors.white,
          ),
          border: InputBorder.none,
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.white, fontSize: 15),
          contentPadding:
              const EdgeInsets.only(top: 30, right: 30, bottom: 30, left: 5),
        ),
      ),
    );
  }
}

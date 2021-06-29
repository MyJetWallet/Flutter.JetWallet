import 'package:flutter/material.dart';

class EmailVerificationTextField extends StatelessWidget {
  const EmailVerificationTextField({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: (value) {
        // TODO add onChanged functionality
        // ignore: avoid_print
        print(value);
      },
      cursorColor: Colors.grey,
      textAlign: TextAlign.center,
      keyboardType: TextInputType.emailAddress,
      style: const TextStyle(
        fontSize: 45.0,
        color: Colors.black87,
        fontWeight: FontWeight.bold,
      ),
      decoration: InputDecoration(
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(
            color: Colors.grey,
          ),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(
            color: Colors.black87,
            width: 2.0,
          ),
        ),
        hintText: 'XXXX',
        hintStyle: TextStyle(
          color: Colors.grey[400],
        ),
      ),
    );
  }
}

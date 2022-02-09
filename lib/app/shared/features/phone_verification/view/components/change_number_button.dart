import 'package:flutter/material.dart';

class ChangeNumberButton extends StatelessWidget {
  const ChangeNumberButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.pop(context),
      borderRadius: BorderRadius.circular(20.0),
      child: Container(
        width: 140.0,
        height: 26.0,
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey,
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: const Center(
          child: Text(
            'Change number',
            style: TextStyle(
              fontSize: 16.0,
              color: Colors.black54,
            ),
          ),
        ),
      ),
    );
  }
}

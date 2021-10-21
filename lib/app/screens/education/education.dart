import 'package:flutter/material.dart';
import 'package:simple_kit/example/example_screen.dart';

class Education extends StatelessWidget {
  const Education({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return const ExampleScreen();
                    },
                  ),
                );
              },
              child: const Text(
                'Example Screen',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

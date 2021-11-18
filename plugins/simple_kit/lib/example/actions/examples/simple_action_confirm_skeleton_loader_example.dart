import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../../simple_kit.dart';

class SimpleActionConfrimSkeletonLoaderExample extends HookWidget {
  const SimpleActionConfrimSkeletonLoaderExample({Key? key}) : super(key: key);

  static const routeName = '/simple_action_skeleton_loader_example';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SPaddingH24(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              SActionConfirmSkeletonLoader(),
              SpaceH10(),
              SActionConfirmSkeletonLoader(),
              SpaceH10(),
              SActionConfirmSkeletonLoader(),
            ],
          ),
        ),
      ),
    );
  }
}

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/features/kyc/kyc_selfie/store/kyc_selfie_store.dart';
import 'package:simple_kit/simple_kit.dart';

class SelfieBox extends StatelessObserverWidget {
  const SelfieBox({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = sKit.colors;
    final state = KycSelfieStore.of(context);

    return Stack(
      children: [
        Container(
          height: 225,
          width: 225,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.0),
            color: colors.grey4,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16.0),
            child: Image.file(
              File(state.selfie!.path),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
          right: 8.0,
          top: 8.0,
          child: GestureDetector(
            onTap: () {
              state.removeSelfie();
            },
            child: const SizedBox(
              height: 28,
              width: 28,
              child: SCloseWithBorderIcon(),
            ),
          ),
        ),
      ],
    );
  }
}

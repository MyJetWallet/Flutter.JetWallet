import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../../app_state.dart';

class Notifier extends StatelessWidget {
  const Notifier({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return StoreConnector<AppState, String>(
      converter: (store) => store.state.notifierState.message,
      builder: (_, message) {
        return Positioned(
          bottom: 0,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            color: Colors.red,
            height: message.isEmpty ? 0 : 30 + bottomPadding / 2,
            width: MediaQuery.of(context).size.width,
            child: Center(
              child: Material(
                color: Colors.transparent,
                child: AutoSizeText(
                  message,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  style: const TextStyle(
                    color: Colors.white,
                    fontFamily: 'Montserrat',
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:simple_kit/core/simple_kit.dart';
import 'package:simple_kit/modules/shared/simple_paddings.dart';
import 'package:simple_kit/modules/shared/stack_loader/stack_loader.dart';
import 'package:simple_kit/modules/shared/stack_loader/store/stack_loader_store.dart';

class SPageFrameWithPadding extends StatelessObserverWidget {
  const SPageFrameWithPadding({
    Key? key,
    this.header,
    this.loading,
    this.customLoader,
    this.bottomNavigationBar,
    required this.loaderText,
    this.color = Colors.transparent,
    this.resizeToAvoidBottomInset = true,
    required this.child,
  }) : super(key: key);

  final Widget? header;
  final String loaderText;
  final Widget child;
  final Color color;
  final bool resizeToAvoidBottomInset;
  final StackLoaderStore? loading;
  final Widget? customLoader;
  final Widget? bottomNavigationBar;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: sKit.getTheme().scaffoldBackgroundColor,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      bottomNavigationBar: bottomNavigationBar,
      body: StackLoader(
        loaderText: loaderText,
        loading: loading,
        customLoader: customLoader,
        child: SPaddingH24(
          child: Column(
            children: [
              if (header != null) header!,
              Expanded(
                child: Material(
                  color: color,
                  child: child,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

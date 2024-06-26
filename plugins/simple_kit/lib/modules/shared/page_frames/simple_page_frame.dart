import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:simple_kit/core/simple_kit.dart';
import 'package:simple_kit/modules/shared/stack_loader/stack_loader.dart';
import 'package:simple_kit/modules/shared/stack_loader/store/stack_loader_store.dart';

class SPageFrame extends StatelessObserverWidget {
  const SPageFrame({
    super.key,
    this.header,
    this.loading,
    this.loadSuccess,
    this.bottomNavigationBar,
    required this.loaderText,
    this.color = Colors.transparent,
    this.resizeToAvoidBottomInset,
    required this.child,
  });

  final Widget? header;
  final StackLoaderStore? loading;
  final StackLoaderStore? loadSuccess;
  final Widget? bottomNavigationBar;
  final String loaderText;
  final bool? resizeToAvoidBottomInset;
  final Color color;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return StackLoader(
      loaderText: loaderText,
      loading: loading,
      loadSuccess: loadSuccess,
      child: Scaffold(
        backgroundColor: sKit.getTheme().scaffoldBackgroundColor,
        bottomNavigationBar: bottomNavigationBar,
        resizeToAvoidBottomInset: resizeToAvoidBottomInset,
        body: Column(
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
    );
  }
}

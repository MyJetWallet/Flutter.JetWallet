import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';
import 'package:simple_kit_updated/widgets/shared/page_frame/stack_loader.dart';

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
    this.customLoader,
  });

  final Widget? header;
  final StackLoaderStore? loading;
  final StackLoaderStore? loadSuccess;
  final Widget? bottomNavigationBar;
  final String loaderText;
  final Widget? customLoader;
  final bool? resizeToAvoidBottomInset;
  final Color color;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return StackLoader(
      loaderText: loaderText,
      loading: loading,
      loadSuccess: loadSuccess,
      customLoader: customLoader,
      child: Scaffold(
        backgroundColor: SColorsLight().black.withOpacity(0.5),
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

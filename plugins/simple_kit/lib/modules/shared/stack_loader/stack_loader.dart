import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:simple_kit/modules/shared/stack_loader/components/loader_background.dart';
import 'package:simple_kit/modules/shared/stack_loader/components/loader_container.dart';
import 'package:simple_kit/modules/shared/stack_loader/components/simple_loader_success.dart';
import 'package:simple_kit/modules/shared/stack_loader/store/stack_loader_store.dart';

class StackLoader extends StatefulObserverWidget {
  const StackLoader({
    super.key,
    this.loadSuccess,
    required this.loaderText,
    this.customLoader,
    required this.child,
    required this.loading,
  });

  final Widget child;
  final Widget? customLoader;
  final String loaderText;
  final StackLoaderStore? loading;
  final StackLoaderStore? loadSuccess;

  @override
  State<StackLoader> createState() => _StackLoaderState();
}

class _StackLoaderState extends State<StackLoader> {
  @override
  void dispose() {
    widget.loading?.dispose();
    widget.loadSuccess?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loadingStore = widget.loading ?? StackLoaderStore();
    final loadSuccessStore = widget.loadSuccess ?? StackLoaderStore();

    final loadingValue = loadingStore.loading;
    final loadSuccessValue = loadSuccessStore.loading;

    return Stack(
      alignment: Alignment.center,
      children: [
        widget.child,
        if (loadingValue) ...[
          if (widget.customLoader != null) ...[
            widget.customLoader!,
          ] else ...[
            const LoaderBackground(),
            LoaderContainer(
              loadingText: widget.loaderText,
            ),
          ],
        ],
        if (loadSuccessValue) ...[
          const LoaderBackground(),
          SimpleLoaderSuccess(
            loadingText: widget.loaderText,
          ),
        ],
      ],
    );
  }
}

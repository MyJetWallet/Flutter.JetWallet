import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:mobx/mobx.dart';
import 'package:simple_kit/modules/shared/stack_loader/components/loader_background.dart';
import 'package:simple_kit/modules/shared/stack_loader/components/loader_container.dart';
part 'global_loader.g.dart';

class GlobalLoader = _GlobalLoaderBase with _$GlobalLoader;

abstract class _GlobalLoaderBase with Store {
  @observable
  bool isLoading = false;
  @action
  void setLoading(bool value) => isLoading = value;
}

class GlobalLoaderWidget extends StatelessWidget {
  const GlobalLoaderWidget({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (context) {
        final store = getIt.get<GlobalLoader>();

        return Stack(
          alignment: Alignment.center,
          children: [
            child,
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              reverseDuration: const Duration(milliseconds: 250),
              child: store.isLoading
                  ? Stack(
                      alignment: Alignment.center,
                      children: [
                        const LoaderBackground(),
                        LoaderContainer(
                          loadingText: intl.loader_please_wait,
                        ),
                      ],
                    )
                  : const SizedBox.shrink(),
            ),
          ],
        );
      },
    );
  }
}

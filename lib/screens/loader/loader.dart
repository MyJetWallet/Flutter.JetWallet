import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../../app_state.dart';
import 'loader_view_model.dart';

class Loader extends StatefulWidget {
  const Loader({Key? key}) : super(key: key);

  @override
  _LoaderState createState() => _LoaderState();
}

class _LoaderState extends State<Loader> {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, LoaderViewModel>(
        converter: (store) => LoaderViewModel.fromStore(store),
        builder: (context, vm) {
          return vm.isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Container();
        });
  }
}

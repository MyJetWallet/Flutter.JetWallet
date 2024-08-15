import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';
import 'package:simple_kit/modules/shared/stack_loader/store/stack_loader_store.dart';

part 'jars_store.g.dart';

@lazySingleton
class JarsStore = _JarsStoreBase with _$JarsStore;

abstract class _SimpleCardStoreBase with Store {
  @observable
  StackLoaderStore loader = StackLoaderStore();
}
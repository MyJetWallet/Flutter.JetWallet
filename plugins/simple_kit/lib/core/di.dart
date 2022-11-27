import 'package:get_it/get_it.dart';
import 'package:simple_kit/core/simple_kit.dart';

final sGetIt = GetIt.instance;

void setup() {
  sGetIt.registerSingleton<SimpleKit>(SimpleKit());
}

import 'package:hooks_riverpod/hooks_riverpod.dart';

class ProviderLogger extends ProviderObserver {
  @override
  void didUpdateProvider(ProviderBase provider, Object? newValue) {
    // ignore: avoid_print
    print(
      '''
∫ ✅ UPDATED PROVIDER ✅
∫ Provider: "${provider.name ?? provider.runtimeType}",
∫ Value: "$newValue"                                   
➫➫➫➫➫➫➫➫➫➫➫➫➫➫➫➫➫➫➫➫➫➫➫➫➫➫➫➫➫➫➫➫➫➫➫➫➫➫➫➫➫➫➫➫➫➫➫➫➫
''',
    );
  }

  @override
  void didAddProvider(ProviderBase provider, Object? value) {
    // ignore: avoid_print
    print(
      '''
∫ ⚡ ADDED PROVIDER ⚡
∫ Provider: "${provider.name ?? provider.runtimeType}",
∫ Value: "$value"                                   
➫➫➫➫➫➫➫➫➫➫➫➫➫➫➫➫➫➫➫➫➫➫➫➫➫➫➫➫➫➫➫➫➫➫➫➫➫➫➫➫➫➫➫➫➫➫➫➫➫
''',
    );
  }

  @override
  void didDisposeProvider(ProviderBase provider) {
    // ignore: avoid_print
    print(
      '''
∫ 🗑️ DISPOSED PROVIDER 🗑️
∫ Provider: "${provider.name ?? provider.runtimeType}",                           
➫➫➫➫➫➫➫➫➫➫➫➫➫➫➫➫➫➫➫➫➫➫➫➫➫➫➫➫➫➫➫➫➫➫➫➫➫➫➫➫➫➫➫➫➫➫➫➫➫
''',
    );
  }

  @override
  void mayHaveChanged(ProviderBase provider) {
    // ignore: avoid_print
    print(
      '''
∫ 💡 PROVIDER CHANGED 💡
∫ Provider: "${provider.name ?? provider.runtimeType}",                           
➫➫➫➫➫➫➫➫➫➫➫➫➫➫➫➫➫➫➫➫➫➫➫➫➫➫➫➫➫➫➫➫➫➫➫➫➫➫➫➫➫➫➫➫➫➫➫➫➫
''',
    );
  }
}

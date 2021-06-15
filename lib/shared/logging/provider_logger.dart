import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';

import 'levels.dart';

class ProviderLogger extends ProviderObserver {
  ProviderLogger({
    this.exludedProviders = const <String>[],
    this.update = true,
    this.add = true,
    this.dispose = true,
    this.change = true,
  });

  /// Providers you want to exclude from Logger \
  /// You need to add full [Type] of the Provider
  final List<String> exludedProviders;

  /// Turns [Update log] ON and OFF
  final bool update;

  /// Turns [Add log] ON and OFF
  final bool add;

  /// Turns [Dispose log] ON and OFF
  final bool dispose;

  /// Turns [Change log] ON and OFF
  final bool change;

  static final _logger = Logger('');

  @override
  void didUpdateProvider(ProviderBase provider, Object? newValue) {
    if (update) {
      if (!_excludeProvider(provider)) {
        _logger.log(
          providerLevel,
          '''
▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬
✅ UPDATED PROVIDER ✅
[Provider]: "${provider.runtimeType}",
[Value]: "$newValue"
▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬                    
''',
        );
      }
    }
  }

  @override
  void didAddProvider(ProviderBase provider, Object? value) {
    if (add) {
      if (!_excludeProvider(provider)) {
        _logger.log(
          providerLevel,
          '''
▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬
⚡ ADDED PROVIDER ⚡
[Provider]: "${provider.runtimeType}",
[Value]: "$value"     
▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬                          
''',
        );
      }
    }
  }

  @override
  void didDisposeProvider(ProviderBase provider) {
    if (dispose) {
      if (!_excludeProvider(provider)) {
        _logger.log(
          providerLevel,
          '''
▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬
🗑️ DISPOSED PROVIDER 🗑️
[Provider]: "${provider.runtimeType}", 
▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬                          
''',
        );
      }
    }
  }

  @override
  void mayHaveChanged(ProviderBase provider) {
    if (change) {
      if (!_excludeProvider(provider)) {
        _logger.log(
          providerLevel,
          '''
▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬
💡 PROVIDER CHANGED 💡
[Provider]: "${provider.runtimeType}",   
▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬                        
''',
        );
      }
    }
  }

  bool _excludeProvider(ProviderBase provider) {
    final type = _providerType(provider);

    for (final i in exludedProviders) {
      if (type == i) {
        return true;
      }
    }

    return false;
  }

  String _providerType(ProviderBase provider) {
    final string = provider.toString();

    final buffer = StringBuffer();

    for (final i in string.split('')) {
      if (i == '#') break;
      buffer.write(i);
    }

    return buffer.toString();
  }
}

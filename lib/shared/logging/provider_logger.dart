import 'package:flutter/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';

import 'levels.dart';

/// [ProviderLog] was made to avoid exception during parsing
/// of the value of the Provider \
/// [ProviderLog] is passed through [error] instead of [message]
/// parameter of the log in order to avoid toString() formatting
class ProviderLog {
  ProviderLog({
    required this.action,
    required this.provider,
    this.value,
  });

  final String action;
  final String provider;
  final Object? value;
}

class ProviderLogger extends ProviderObserver {
  ProviderLogger({
    this.update = true,
    this.add = true,
    this.dispose = true,
    this.change = true,
    this.disableAll = false,
    this.ignoreByType = const <String>[],
    this.ignoreByName = const <String>[],
  });

  /// Turns [Update log] ON and OFF
  final bool update;

  /// Turns [Add log] ON and OFF
  final bool add;

  /// Turns [Dispose log] ON and OFF
  final bool dispose;

  /// Turns [Change log] ON and OFF
  final bool change;

  /// Disables update, add, dispose and change
  final bool disableAll;

  /// Providers you want Logger to ignore \
  /// You need to add full [Type] of the Provider
  final List<String> ignoreByType;

  /// Providers you want Logger to ignore \
  /// You need to add the name of provider
  final List<String> ignoreByName;

  static final _logger = Logger('');

  @override
  void didUpdateProvider(ProviderBase provider, Object? value) {
    if (!disableAll) {
      if (update) {
        if (!_ignoreProviderByName(provider)) {
          if (!_ignoreProviderByType(provider)) {
            // In order to avoid the following error:
            //
            // "This UncontrolledProviderScope widget cannot be marked as
            // needing to build because the framework is already in the process
            // of building widgets..."
            //
            // We need to wrap the observer lifecycles in a addPostFrameCallback
            // because we're modifying the state on any log but logs
            // can happen during "build"
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _logger.log(
                providerLevel,
                null,
                ProviderLog(
                  action: '✅ UPDATED PROVIDER ✅',
                  provider: '${provider.name ?? provider.runtimeType}',
                  value: value,
                ),
              );
            });
          }
        }
      }
    }
  }

  @override
  void didAddProvider(ProviderBase provider, Object? value) {
    if (!disableAll) {
      if (add) {
        if (!_ignoreProviderByName(provider)) {
          if (!_ignoreProviderByType(provider)) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _logger.log(
                providerLevel,
                null,
                ProviderLog(
                  action: '⚡ ADDED PROVIDER ⚡',
                  provider: '${provider.name ?? provider.runtimeType}',
                  value: value,
                ),
              );
            });
          }
        }
      }
    }
  }

  @override
  void didDisposeProvider(ProviderBase provider) {
    if (!disableAll) {
      if (dispose) {
        if (!_ignoreProviderByName(provider)) {
          if (!_ignoreProviderByType(provider)) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _logger.log(
                providerLevel,
                null,
                ProviderLog(
                  action: '🗑️ DISPOSED PROVIDER 🗑️',
                  provider: '${provider.name ?? provider.runtimeType}',
                ),
              );
            });
          }
        }
      }
    }
  }

  @override
  void mayHaveChanged(ProviderBase provider) {
    if (!disableAll) {
      if (change) {
        if (!_ignoreProviderByName(provider)) {
          if (!_ignoreProviderByType(provider)) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _logger.log(
                providerLevel,
                null,
                ProviderLog(
                  action: '💡 PROVIDER CHANGED 💡',
                  provider: '${provider.name ?? provider.runtimeType}',
                ),
              );
            });
          }
        }
      }
    }
  }

  bool _ignoreProviderByName(ProviderBase provider) {
    for (final i in ignoreByName) {
      if (provider.name == i) {
        return true;
      }
    }

    return false;
  }

  bool _ignoreProviderByType(ProviderBase provider) {
    final type = _providerType(provider);

    for (final i in ignoreByType) {
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

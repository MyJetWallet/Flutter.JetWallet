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

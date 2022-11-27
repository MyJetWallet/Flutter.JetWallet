class SimpleOptions {
  SimpleOptions({
    this.candlesApi,
    this.authApi,
    this.walletApi,
    this.walletApiSignalR,
    this.validationApi,
    this.iconApi,
  });

  String? candlesApi;
  String? authApi;
  String? walletApi;
  String? walletApiSignalR;
  String? validationApi;
  String? iconApi;

  SimpleOptions copyWith({
    String? candlesApi,
    String? authApi,
    String? walletApi,
    String? walletApiSignalR,
    String? validationApi,
    String? iconApi,
  }) {
    return SimpleOptions(
      candlesApi: candlesApi ?? this.candlesApi,
      authApi: authApi ?? this.authApi,
      walletApi: walletApi ?? this.walletApi,
      walletApiSignalR: walletApiSignalR ?? this.walletApiSignalR,
      validationApi: validationApi ?? this.validationApi,
      iconApi: iconApi ?? this.iconApi,
    );
  }
}

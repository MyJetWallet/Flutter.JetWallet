class AuthenticationBody {
  AuthenticationBody(this.email, this.password);

  String email;
  String password;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'email': email,
        'password': password,
        'captcha': 'captcha',
      };
}

class AuthenticationResponse {
  AuthenticationResponse(
    this.token,
    this.refreshToken,
    this.tradingUrl,
    this.connectionTimeOut,
    this.reconnectTimeOut,
  );

  factory AuthenticationResponse.fromJson(Map<String, dynamic> json) {
    return AuthenticationResponse(
      json['token'].toString(),
      json['refreshToken'].toString(),
      json['tradingUrl'].toString(),
      json['connectionTimeOut'].toString(),
      json['reconnectTimeOut'].toString(),
    );
  }

  String token;
  String refreshToken;
  String tradingUrl;
  String connectionTimeOut;
  String reconnectTimeOut;
}

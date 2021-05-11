class RegistrationBody {
  RegistrationBody(this.email, this.password);

  String email;
  String password;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'email': email,
        'password': password,
      };
}

class RegistrationResponse {
  RegistrationResponse(
    this.token,
    this.refreshToken,
    this.tradingUrl,
    this.connectionTimeOut,
    this.reconnectTimeOut,
  );

  factory RegistrationResponse.fromJson(Map<String, dynamic> json) {
    return RegistrationResponse(
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

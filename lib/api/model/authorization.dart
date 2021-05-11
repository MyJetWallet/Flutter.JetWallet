class AuthorizationBody {
  AuthorizationBody(this.token);

  String token;

  Map<String, dynamic> toJson() =>
      <String, dynamic>{'authToken': token, 'publicKeyPem': 'publicKeyPem'};
}

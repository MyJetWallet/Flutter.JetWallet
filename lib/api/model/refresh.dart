class RefreshBody {
  RefreshBody(this.token, this.requestTime);

  String token;
  String requestTime;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'token': token,
        'requestTime': requestTime,
        'signature': 'signature',
      };
}

class CommonResponse {
  CommonResponse(this.result, this.data);

  factory CommonResponse.fromJson(Map<String, dynamic> json) {
    return CommonResponse(json['result'].toString(), json['data']);
  }

  String result;
  dynamic data;
}

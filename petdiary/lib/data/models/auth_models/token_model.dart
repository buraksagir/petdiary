class TokenModel {
  String? message;
  int? userId;
  String? accessToken;

  TokenModel({this.message, this.userId, this.accessToken});

  TokenModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    userId = json['userId'];
    accessToken = json['accessToken'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    data['userId'] = userId;
    data['accessToken'] = accessToken;
    return data;
  }
}

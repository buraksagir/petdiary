class LoginModel {
  String? userName;
  String? password;
  String? name;
  String? surname;
  String? mail;
  String? phone;

  LoginModel(
      {this.userName,
      this.password,
      this.name,
      this.surname,
      this.mail,
      this.phone});

  LoginModel.fromJson(Map<String, dynamic> json) {
    userName = json['userName'];
    password = json['password'];
    name = json['name'];
    surname = json['surname'];
    mail = json['mail'];
    phone = json['phone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['userName'] = userName;
    data['password'] = password;
    data['name'] = name;
    data['surname'] = surname;
    data['mail'] = mail;
    data['phone'] = phone;

    return data;
  }
}

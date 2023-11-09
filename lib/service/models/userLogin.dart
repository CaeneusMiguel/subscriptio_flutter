import 'dart:convert';

UserLogin documentFromJson(String str) => UserLogin.fromJson(json.decode(str));

String documentToJson(UserLogin data) => json.encode(data.toJson());

class UserLogin {
  String token;
  dynamic userProyect;
  List<String> userRoles;
  String userId;
  String? userName;
  String? userSurnames;
  String? userTown;
  String? userProvince;
  String? userCountry;
  String? userUsername;
  String? userImg;
  bool? active;
  String? email;
  int? companyId;
  String? companyName;
  int? companyPinCode;
  bool? companyProyect;
  bool? companyHasProyects;
  bool? companyHolidays;
  String? companyCheckInTime;
  String? userExpiration;

  UserLogin({
    required this.token,
    required this.userProyect,
    required this.userRoles,
    required this.userId,
    this.userName,
    this.userSurnames,
    this.userTown,
    this.userProvince,
    this.userCountry,
    this.userUsername,
    this.userImg,
    this.active,
    this.email,
    this.companyId,
    this.companyName,
    this.companyPinCode,
    this.companyProyect,
    this.companyHasProyects,
    this.companyHolidays,
    this.companyCheckInTime,
    this.userExpiration,
  });

  factory UserLogin.fromJson(Map<String, dynamic> json) => UserLogin(
        token: json["token"],
        userProyect: json["user_proyect"],
        userRoles: List<String>.from(json["user_roles"].map((x) => x)),
        userId: json["user_id"],
        userName: json["user_name"],
        userSurnames: json["user_surnames"],
        userTown: json["user_town"],
        userProvince: json["user_province"],
        userCountry: json["user_country"],
        userUsername: json["user_username"],
        userImg: json["user_img"],
        active: json["active"],
        email: json["email"],
        companyId: json["company_id"],
        companyName: json["company_name"],
        companyPinCode: json["company_pinCode"],
        companyProyect: json["company_proyect"],
        companyHasProyects: json["company_has_proyects"],
        companyHolidays: json["company_holidays"],
        companyCheckInTime: json["company_checkInTime"],
        userExpiration: json["user_expiration"],
      );

  Map<String, dynamic> toJson() => {
        "token": token,
        "user_proyect": userProyect,
        "user_roles": List<dynamic>.from(userRoles.map((x) => x)),
        "user_id": userId,
        "user_name": userName,
        "user_surnames": userSurnames,
        "user_town": userTown,
        "user_province": userProvince,
        "user_country": userCountry,
        "user_username": userUsername,
        "user_img": userImg,
        "active": active,
        "email": email,
        "company_id": companyId,
        "company_name": companyName,
        "company_pinCode": companyPinCode,
        "company_proyect": companyProyect,
        "company_has_proyects": companyHasProyects,
        "company_holidays": companyHolidays,
        "company_checkInTime": companyCheckInTime,
        "user_expiration": userExpiration,
      };
}

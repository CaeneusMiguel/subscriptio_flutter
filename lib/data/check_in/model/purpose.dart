import 'dart:convert';

Purpose purposeFromJson(String str) => Purpose.fromJson(json.decode(str));

String purposeToJson(Purpose data) => json.encode(data.toJson());

class Purpose {
  String purpose;
  int id;
  double? estimatedTime;

  Purpose({required this.purpose, required this.id, this.estimatedTime});

  static List<Purpose> fromJsonList(List<dynamic> jsonList) {
    List<Purpose> toList = [];
    jsonList.forEach((element) {
      Purpose listPurpose = Purpose.fromJson(element);
      toList.add(listPurpose);
    });

    return toList;
  }

  factory Purpose.fromJson(Map<String, dynamic> json) => Purpose(
      purpose: json["purpose"],
      id: json["id"],
      estimatedTime: json["estimatedTime"]?.toDouble());

  Map<String, dynamic> toJson() =>
      {"purpose": purpose, "id": id, "estimatedTime": estimatedTime};
}

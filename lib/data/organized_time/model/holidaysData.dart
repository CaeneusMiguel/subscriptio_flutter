import 'dart:convert';

HolidaysData holidaysFromJson(String str) =>
    HolidaysData.fromJson(json.decode(str));

String holidaysToJson(HolidaysData data) => json.encode(data.toJson());

class HolidaysData {
  int id;
  Date startDate;
  Date endDate;
  String? petitionComment;
  String? responseComment;
  bool? accepted;

  HolidaysData({
    required this.id,
    required this.startDate,
    required this.petitionComment,
    required this.responseComment,
    required this.endDate,
    this.accepted,
  });

  static List<HolidaysData> fromJsonList(List<dynamic> jsonList) {
    List<HolidaysData> toList = [];
    jsonList.forEach((element) {
      HolidaysData listCheking = HolidaysData.fromJson(element);
      toList.add(listCheking);
    });

    return toList;
  }

  factory HolidaysData.fromJson(Map<String, dynamic> json) => HolidaysData(
        id: json["id"],
        startDate: Date.fromJson(json["startDate"]),
        endDate: Date.fromJson(json["endDate"]),
        petitionComment: json["petitionComment"],
        responseComment: json["responseComment"],
        accepted: json["accepted"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "startDate": startDate.toJson(),
        "endDate": endDate.toJson(),
        "petitionComment": petitionComment,
        "responseComment": responseComment,
        "accepted": accepted,
      };
}

class Date {
  DateTime date;
  int timezoneType;
  String timezone;

  Date({
    required this.date,
    required this.timezoneType,
    required this.timezone,
  });

  factory Date.fromJson(Map<String, dynamic> json) => Date(
        date: DateTime.parse(json["date"]),
        timezoneType: json["timezone_type"],
        timezone: json["timezone"],
      );

  Map<String, dynamic> toJson() => {
        "date": date.toIso8601String(),
        "timezone_type": timezoneType,
        "timezone": timezone,
      };
}

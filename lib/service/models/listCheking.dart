import 'dart:convert';

ListCheking listChekingFromJson(String str) => ListCheking.fromJson(json.decode(str));

String listChekingToJson(ListCheking data) => json.encode(data.toJson());

class ListCheking {
  Checked checkedIn;
  Checked? checkedOut;
  double? numberOfHours;

  ListCheking({
    required this.checkedIn,
    this.checkedOut,
    this.numberOfHours,
  });

  static List<ListCheking> fromJsonList(List<dynamic> jsonList) {
    List<ListCheking> toList = [];
    jsonList.forEach((element) {
      ListCheking listCheking = ListCheking.fromJson(element);
      toList.add(listCheking);
    });

    return toList;
  }

  factory ListCheking.fromJson(Map<String, dynamic> json) => ListCheking(
    checkedIn: Checked.fromJson(json["checkedIn"]),
    checkedOut: json["checkedOut"] != null ? Checked.fromJson(json["checkedOut"]) : null,
    numberOfHours: json["numberOfHours"]?.toDouble() ,
  );

  Map<String, dynamic> toJson() => {
    "checkedIn": checkedIn.toJson(),
    "checkedOut": checkedOut?.toJson(),
    "numberOfHours": numberOfHours,
  };
}

class Checked {
  DateTime date;
  int timezoneType;
  String timezone;

  Checked({
    required this.date,
    required this.timezoneType,
    required this.timezone,
  });

  factory Checked.fromJson(Map<String, dynamic> json) => Checked(
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

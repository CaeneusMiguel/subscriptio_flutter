import 'dart:convert';

ListCheking listChekingFromJson(String str) =>
    ListCheking.fromJson(json.decode(str));

String listChekingToJson(ListCheking data) => json.encode(data.toJson());

class ListCheking {
  int id;
  Checked checkedIn;
  Checked? checkedOut;
  double? numberOfHours;
  List<PurposeElement> purposes;
  double? totalBreakPurposes;

  ListCheking(
      {required this.id,
      required this.checkedIn,
      this.checkedOut,
      this.numberOfHours,
      required this.purposes,
      this.totalBreakPurposes});

  static List<ListCheking> fromJsonList(List<dynamic> jsonList) {
    List<ListCheking> toList = [];
    jsonList.forEach((element) {
      ListCheking listCheking = ListCheking.fromJson(element);
      toList.add(listCheking);
    });

    return toList;
  }

  factory ListCheking.fromJson(Map<String, dynamic> json) => ListCheking(
        id: json["id"],
        checkedIn: Checked.fromJson(json["checkedIn"]),
        checkedOut: json["checkedOut"] != null
            ? Checked.fromJson(json["checkedOut"])
            : null,
        numberOfHours: json["numberOfHours"]?.toDouble(),
        purposes: List<PurposeElement>.from(
            json["purposes"].map((x) => PurposeElement.fromJson(x))),
        totalBreakPurposes: json["totalBreakPurposes"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "checkedIn": checkedIn.toJson(),
        "checkedOut": checkedOut?.toJson(),
        "numberOfHours": numberOfHours,
        "purposes": List<dynamic>.from(purposes.map((x) => x.toJson())),
        "totalBreakPurposes": totalBreakPurposes,
      };
}

class Checked {
  DateTime date;

  Checked({
    required this.date,
  });

  factory Checked.fromJson(Map<String, dynamic> json) => Checked(
        date: DateTime.parse(json["date"]),
      );

  Map<String, dynamic> toJson() => {
        "date": date.toIso8601String(),
      };
}

class PurposeElement {
  String? purpose;
  Checked? breakIn;
  Checked? breakOut;
  double? timeOfbreak;

  PurposeElement({
    this.purpose,
    this.breakIn,
    this.breakOut,
    this.timeOfbreak,
  });

  factory PurposeElement.fromJson(Map<String, dynamic> json) => PurposeElement(
        purpose: json["purpose"],
        breakIn:
            json["breakIn"] != null ? Checked.fromJson(json["breakIn"]) : null,
        breakOut: json["breakOut"] != null
            ? Checked.fromJson(json["breakOut"])
            : null,
        timeOfbreak: json["timeOfbreak"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "purpose": purpose,
        "breakIn": breakIn?.toJson(),
        "breakOut": breakOut?.toJson(),
        "timeOfbreak": timeOfbreak,
      };
}

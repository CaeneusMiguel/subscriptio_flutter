import 'dart:convert';

CheckinDataCont purposeFromJson(String str) =>
    CheckinDataCont.fromJson(json.decode(str));

String purposeToJson(CheckinDataCont data) => json.encode(data.toJson());

class CheckinDataCont {
  CreateDate creationDate;

  CheckinDataCont({required this.creationDate});

  factory CheckinDataCont.fromJson(Map<String, dynamic> json) =>
      CheckinDataCont(creationDate: CreateDate.fromJson(json["creationDate"]));

  Map<String, dynamic> toJson() => {"creationDate": creationDate.toJson()};
}

class CreateDate {
  DateTime date;

  CreateDate({
    required this.date,
  });

  factory CreateDate.fromJson(Map<String, dynamic> json) => CreateDate(
        date: DateTime.parse(json["date"]),
      );

  Map<String, dynamic> toJson() => {
        "date": date.toIso8601String(),
      };
}

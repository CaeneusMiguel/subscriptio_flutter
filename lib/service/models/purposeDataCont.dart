import 'dart:convert';

PurposeDataCont purposeFromJson(String str) => PurposeDataCont.fromJson(json.decode(str));

String purposeToJson(PurposeDataCont data) => json.encode(data.toJson());

class PurposeDataCont {
  int id;
  String idTimeRecord;
  CreateDate breakIn;
  String purpose;
  double? estimatedTime;

  PurposeDataCont({ required this.idTimeRecord,required this.id,required this.breakIn, this.estimatedTime,required this.purpose});



  factory PurposeDataCont.fromJson(Map<String, dynamic> json) => PurposeDataCont(

      id: json["id"],
      idTimeRecord: json["idTimeRecord"],
      purpose:json["purpose"],
      breakIn: CreateDate.fromJson(json["breakIn"]),
      estimatedTime: json["estimatedTime"]?.toDouble());

  Map<String, dynamic> toJson() =>
      { "id": id,"idTimeRecord": idTimeRecord,"purpose": purpose, "estimatedTime": estimatedTime,"breakIn": breakIn.toJson(),};
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

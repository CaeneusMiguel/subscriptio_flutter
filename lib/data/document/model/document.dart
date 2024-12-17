import 'dart:convert';

Document documentFromJson(String str) => Document.fromJson(json.decode(str));

String documentToJson(Document data) => json.encode(data.toJson());

class Document {
  int id;
  String nombre;
  String file;
  CreateDate createDate;
  bool? isSignTemplate;
  bool? isSigned;
  double? startX;
  double? startY;
  double? width;
  double? height;

  Document(
      {required this.id,
      required this.nombre,
      required this.file,
      required this.createDate,
      this.height,
      this.width,
      this.isSigned,
      this.isSignTemplate,
      this.startX,
      this.startY});

  static List<Document> fromJsonList(List<dynamic> jsonList) {
    List<Document> toList = [];
    jsonList[0].forEach((element) {
      Document document = Document.fromJson(element);
      toList.add(document);
    });

    return toList;
  }

  factory Document.fromJson(Map<String, dynamic> json) => Document(
      id: json["id"],
      nombre: json["name"],
      file: json["file"],
      createDate: CreateDate.fromJson(json["create_date"]),
      height: json["height"]?.toDouble(),
      width: json["width"]?.toDouble(),
      isSigned: json["isSigned"],
      isSignTemplate: json["isSignTemplate"],
      startX: json["startX"]?.toDouble(),
      startY: json["startY"]?.toDouble());

  Map<String, dynamic> toJson() => {
        "id": id,
        "nombre": nombre,
        "file": file,
        "create_date": createDate.toJson(),
        "height": height,
        "width": width,
        "isSigned": isSigned,
        "isSignTemplate": isSignTemplate,
        "startX": startX,
        "startY": startY
      };
}

class CreateDate {
  DateTime date;
  int timezoneType;
  String timezone;

  CreateDate({
    required this.date,
    required this.timezoneType,
    required this.timezone,
  });

  factory CreateDate.fromJson(Map<String, dynamic> json) => CreateDate(
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

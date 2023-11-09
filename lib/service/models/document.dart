
import 'dart:convert';

Document documentFromJson(String str) => Document.fromJson(json.decode(str));

String documentToJson(Document data) => json.encode(data.toJson());

class Document {
  int id;
  String nombre;
  String file;
  String idUser;
  CreateDate createDate;

  Document({
    required this.id,
    required this.nombre,
    required this.file,
    required this.idUser,
    required this.createDate,
  });

  static List<Document> fromJsonList(List<dynamic> jsonList) {
    List<Document> toList = [];
    jsonList.forEach((element) {
      Document document = Document.fromJson(element);
      toList.add(document);
    });

    return toList;
  }

  factory Document.fromJson(Map<String, dynamic> json) => Document(
    id: json["id"],
    nombre: json["name"],
    file: json["file"],
    idUser: json["id_user"],
    createDate: CreateDate.fromJson(json["create_date"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "nombre": nombre,
    "file": file,
    "id_user": idUser,
    "create_date": createDate.toJson(),
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

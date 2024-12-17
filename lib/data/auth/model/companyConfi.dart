import 'dart:convert';

CompanyConfi CompanyConfiFromJson(String str) =>
    CompanyConfi.fromJson(json.decode(str));

String CompanyConfiToJson(CompanyConfi data) => json.encode(data.toJson());

class CompanyConfi {
  bool showChecking;
  bool includePauses;
  bool includeCheckinLocation;
  bool holidaysManagement;

  CompanyConfi(
      {required this.showChecking,
      required this.includePauses,
      required this.includeCheckinLocation,
      required this.holidaysManagement});

  factory CompanyConfi.fromJson(Map<String, dynamic> json) => CompanyConfi(
      showChecking: json["showChecking"],
      includePauses: json["includePauses"],
      includeCheckinLocation: json["includeCheckinLocation"],
      holidaysManagement: json["holidaysManagement"]);

  Map<String, dynamic> toJson() => {
        "showChecking": showChecking,
        "includePauses": includePauses,
        "includeCheckinLocation": includeCheckinLocation,
        "holidaysManagement": holidaysManagement,
      };
}

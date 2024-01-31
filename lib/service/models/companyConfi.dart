
import 'dart:convert';

CompanyConfi CompanyConfiFromJson(String str) => CompanyConfi.fromJson(json.decode(str));

String CompanyConfiToJson(CompanyConfi data) => json.encode(data.toJson());

class CompanyConfi {
  bool showChecking;
  bool includePauses;
  bool includeCheckinLocation;

  CompanyConfi({
    required this.showChecking,
    required this.includePauses,
    required this.includeCheckinLocation,
  });



  factory CompanyConfi.fromJson(Map<String, dynamic> json) => CompanyConfi(
    showChecking: json["showChecking"],
    includePauses: json["includePauses"],
    includeCheckinLocation: json["includeCheckinLocation"],
  );

  Map<String, dynamic> toJson() => {
    "showChecking": showChecking,
    "includePauses": includePauses,
    "includeCheckinLocation": includeCheckinLocation,
  };
}

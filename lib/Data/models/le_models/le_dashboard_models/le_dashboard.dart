// import 'dart:convert';
//
// class LeDashboardModel {
//   final Approved? underSelection;
//   final Approved? approved;
//   final Approved? ongoing;
//   final Approved? underVerification;
//   final Approved? verified;
//   final Approved? rejected;
//
//   LeDashboardModel({
//     this.underSelection,
//     this.approved,
//     this.ongoing,
//     this.underVerification,
//     this.verified,
//     this.rejected,
//   });
//
//   factory LeDashboardModel.fromRawJson(String str) => LeDashboardModel.fromJson(json.decode(str));
//
//   String toRawJson() => json.encode(toJson());
//
//   factory LeDashboardModel.fromJson(Map<String, dynamic> json) => LeDashboardModel(
//     underSelection: json["Under Selection"] == null ? null : Approved.fromJson(json["Under Selection"]),
//     approved: json["Approved"] == null ? null : Approved.fromJson(json["Approved"]),
//     ongoing: json["Ongoing"] == null ? null : Approved.fromJson(json["Ongoing"]),
//     underVerification: json["Under Verification"] == null ? null : Approved.fromJson(json["Under Verification"]),
//     verified: json["Verified"] == null ? null : Approved.fromJson(json["Verified"]),
//     rejected: json["Rejected"] == null ? null : Approved.fromJson(json["Rejected"]),
//   );
//
//   Map<String, dynamic> toJson() => {
//     "Under Selection": underSelection?.toJson(),
//     "Approved": approved?.toJson(),
//     "Ongoing": ongoing?.toJson(),
//     "Under Verification": underVerification?.toJson(),
//     "Verified": verified?.toJson(),
//     "Rejected": rejected?.toJson(),
//   };
// }
//
// class Approved {
//   final int? count;
//   final List<int>? ids;
//
//   Approved({
//     this.count,
//     this.ids,
//   });
//
//   factory Approved.fromRawJson(String str) => Approved.fromJson(json.decode(str));
//
//   String toRawJson() => json.encode(toJson());
//
//   factory Approved.fromJson(Map<String, dynamic> json) => Approved(
//     count: json["count"],
//     ids: json["ids"] == null ? [] : List<int>.from(json["ids"]!.map((x) => x)),
//   );
//
//   Map<String, dynamic> toJson() => {
//     "count": count,
//     "ids": ids == null ? [] : List<dynamic>.from(ids!.map((x) => x)),
//   };
// }



import 'dart:convert';

class LeDashboardModel {
  final Approved? underSelection;
  final Approved? approved;
  final Approved? ongoing;
  final Approved? underVerification;
  final Approved? verified;
  final Approved? billPaid;

  LeDashboardModel({
    this.underSelection,
    this.approved,
    this.ongoing,
    this.underVerification,
    this.verified,
    this.billPaid,
  });

  factory LeDashboardModel.fromRawJson(String str) => LeDashboardModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory LeDashboardModel.fromJson(Map<String, dynamic> json) => LeDashboardModel(
    underSelection: json["Under Selection"] == null ? null : Approved.fromJson(json["Under Selection"]),
    approved: json["Approved"] == null ? null : Approved.fromJson(json["Approved"]),
    ongoing: json["Ongoing"] == null ? null : Approved.fromJson(json["Ongoing"]),
    underVerification: json["Under Verification"] == null ? null : Approved.fromJson(json["Under Verification"]),
    verified: json["Verified"] == null ? null : Approved.fromJson(json["Verified"]),
    billPaid: json["Bill Paid"] == null ? null : Approved.fromJson(json["Bill Paid"]),
  );

  Map<String, dynamic> toJson() => {
    "Under Selection": underSelection?.toJson(),
    "Approved": approved?.toJson(),
    "Ongoing": ongoing?.toJson(),
    "Under Verification": underVerification?.toJson(),
    "Verified": verified?.toJson(),
    "Bill Paid": billPaid?.toJson(),
  };
}

class Approved {
  final int? count;
  final List<int>? ids;

  Approved({
    this.count,
    this.ids,
  });

  factory Approved.fromRawJson(String str) => Approved.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Approved.fromJson(Map<String, dynamic> json) => Approved(
    count: json["count"],
    ids: json["ids"] == null ? [] : List<int>.from(json["ids"]!.map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "count": count,
    "ids": ids == null ? [] : List<dynamic>.from(ids!.map((x) => x)),
  };
}


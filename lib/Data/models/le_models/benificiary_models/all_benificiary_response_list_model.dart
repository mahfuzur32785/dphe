import 'dart:convert';

class AllBeneficiaryResponseListModel {
  final List<Datum>? data;
  final Links? links;
  final Meta? meta;

  AllBeneficiaryResponseListModel({
    this.data,
    this.links,
    this.meta,
  });

  factory AllBeneficiaryResponseListModel.fromRawJson(String str) => AllBeneficiaryResponseListModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AllBeneficiaryResponseListModel.fromJson(Map<String, dynamic> json) => AllBeneficiaryResponseListModel(
    data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
    links: json["links"] == null ? null : Links.fromJson(json["links"]),
    meta: json["meta"] == null ? null : Meta.fromJson(json["meta"]),
  );

  Map<String, dynamic> toJson() => {
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    "links": links?.toJson(),
    "meta": meta?.toJson(),
  };
}

class Datum {
  final int? id;
  final String? name;
  final String? phone;
  final int? nid;
  final String? religion;
  final String? gender;
  final Division? division;
  final District? district;
  final Division? upazila;
  final Division? union;
  final int? status;

  Datum({
    this.id,
    this.name,
    this.phone,
    this.nid,
    this.religion,
    this.gender,
    this.division,
    this.district,
    this.upazila,
    this.union,
    this.status,
  });

  factory Datum.fromRawJson(String str) => Datum.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    name: json["name"],
    phone: json["phone"],
    nid: json["nid"],
    religion: json["religion"],
    gender: json["gender"],
    division: json["division"] == null ? null : Division.fromJson(json["division"]),
    district: json["district"] == null ? null : District.fromJson(json["district"]),
    upazila: json["upazila"] == null ? null : Division.fromJson(json["upazila"]),
    union: json["union"] == null ? null : Division.fromJson(json["union"]),
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "phone": phone,
    "nid": nid,
    "religion": religion,
    "gender": gender,
    "division": division?.toJson(),
    "district": district?.toJson(),
    "upazila": upazila?.toJson(),
    "union": union?.toJson(),
    "status": status,
  };
}

class District {
  final int? id;
  final int? divisionId;
  final String? name;
  final String? bnName;
  final String? lat;
  final String? lon;
  final String? url;
  final dynamic createdAt;
  final dynamic updatedAt;

  District({
    this.id,
    this.divisionId,
    this.name,
    this.bnName,
    this.lat,
    this.lon,
    this.url,
    this.createdAt,
    this.updatedAt,
  });

  factory District.fromRawJson(String str) => District.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory District.fromJson(Map<String, dynamic> json) => District(
    id: json["id"],
    divisionId: json["division_id"],
    name: json["name"],
    bnName: json["bn_name"],
    lat: json["lat"],
    lon: json["lon"],
    url: json["url"],
    createdAt: json["created_at"],
    updatedAt: json["updated_at"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "division_id": divisionId,
    "name": name,
    "bn_name": bnName,
    "lat": lat,
    "lon": lon,
    "url": url,
    "created_at": createdAt,
    "updated_at": updatedAt,
  };
}

class Division {
  final int? id;
  final String? name;
  final String? bnName;
  final String? url;
  final dynamic createdAt;
  final dynamic updatedAt;
  final int? upazilaId;
  final int? districtId;

  Division({
    this.id,
    this.name,
    this.bnName,
    this.url,
    this.createdAt,
    this.updatedAt,
    this.upazilaId,
    this.districtId,
  });

  factory Division.fromRawJson(String str) => Division.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Division.fromJson(Map<String, dynamic> json) => Division(
    id: json["id"],
    name: json["name"],
    bnName: json["bn_name"],
    url: json["url"],
    createdAt: json["created_at"],
    updatedAt: json["updated_at"],
    upazilaId: json["upazila_id"],
    districtId: json["district_id"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "bn_name": bnName,
    "url": url,
    "created_at": createdAt,
    "updated_at": updatedAt,
    "upazila_id": upazilaId,
    "district_id": districtId,
  };
}

class Links {
  final String? first;
  final String? last;
  final dynamic prev;
  final dynamic next;

  Links({
    this.first,
    this.last,
    this.prev,
    this.next,
  });

  factory Links.fromRawJson(String str) => Links.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Links.fromJson(Map<String, dynamic> json) => Links(
    first: json["first"],
    last: json["last"],
    prev: json["prev"],
    next: json["next"],
  );

  Map<String, dynamic> toJson() => {
    "first": first,
    "last": last,
    "prev": prev,
    "next": next,
  };
}

class Meta {
  final int? currentPage;
  final int? from;
  final int? lastPage;
  final List<Link>? links;
  final String? path;
  final int? perPage;
  final int? to;
  final int? total;

  Meta({
    this.currentPage,
    this.from,
    this.lastPage,
    this.links,
    this.path,
    this.perPage,
    this.to,
    this.total,
  });

  factory Meta.fromRawJson(String str) => Meta.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Meta.fromJson(Map<String, dynamic> json) => Meta(
    currentPage: json["current_page"],
    from: json["from"],
    lastPage: json["last_page"],
    links: json["links"] == null ? [] : List<Link>.from(json["links"]!.map((x) => Link.fromJson(x))),
    path: json["path"],
    perPage: json["per_page"],
    to: json["to"],
    total: json["total"],
  );

  Map<String, dynamic> toJson() => {
    "current_page": currentPage,
    "from": from,
    "last_page": lastPage,
    "links": links == null ? [] : List<dynamic>.from(links!.map((x) => x.toJson())),
    "path": path,
    "per_page": perPage,
    "to": to,
    "total": total,
  };
}

class Link {
  final String? url;
  final String? label;
  final bool? active;

  Link({
    this.url,
    this.label,
    this.active,
  });

  factory Link.fromRawJson(String str) => Link.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Link.fromJson(Map<String, dynamic> json) => Link(
    url: json["url"],
    label: json["label"],
    active: json["active"],
  );

  Map<String, dynamic> toJson() => {
    "url": url,
    "label": label,
    "active": active,
  };
}

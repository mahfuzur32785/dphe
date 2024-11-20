import 'dart:convert';

import 'package:hive/hive.dart';

part 'district_model.g.dart';


@HiveType(typeId: 0)
class District {
  @HiveField(0)
  final int? id;
  @HiveField(1)
  final int? divisionId;
  @HiveField(2)
  final String? name;
  @HiveField(3)
  final String? bnName;
 @HiveField(4)
  final String? lat;
 @HiveField(5)
  final String? lon;
 @HiveField(6)
  final String? url;
 @HiveField(7)
  final dynamic createdAt;
  @HiveField(8)
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

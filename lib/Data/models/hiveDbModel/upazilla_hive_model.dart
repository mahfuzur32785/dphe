import 'package:hive/hive.dart';
part 'upazilla_hive_model.g.dart';

@HiveType(typeId: 2)
class UpazillaHiveModel {
  @HiveField(0)
  int? id;
  @HiveField(1)
  String? name;
  @HiveField(2)
  int? districtID;
  

  UpazillaHiveModel({this.id, this.name,this.districtID});
}

class NewUserDataModel {
  int? id;
  String? name;
  String? email;
  String? phone;
  String? type;
  String? nid;
  String? religion;
  String? gender;
  int? designationId;
  int? districtId;
  int? upazilaId;
  int? unionId;
  int? wardId;
  bool? status;
  Designation? designation;
  dynamic district;
  dynamic upazila;
  List<Districts>? districts;
  List<Upazilas>? upazilas;
  List<String>? role;
  List<int>? roleId;
  List<String>? permissions;
  String? photoUrl;

  NewUserDataModel(
      {this.id,
      this.name,
      this.email,
      this.phone,
      this.type,
      this.nid,
      this.religion,
      this.gender,
      this.designationId,
      this.districtId,
      this.upazilaId,
      this.unionId,
      this.wardId,
      this.status,
      this.designation,
      this.district,
      this.upazila,
      this.districts,
      this.upazilas,
      this.role,
      this.roleId,
      this.permissions,
      this.photoUrl});

  NewUserDataModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    type = json['type'];
    nid = json['nid'];
    religion = json['religion'];
    gender = json['gender'];
    designationId = json['designation_id'];
    districtId = json['district_id'];
    upazilaId = json['upazila_id'];
    unionId = json['union_id'];
    wardId = json['ward_id'];
    status = json['status'];
    designation = json['designation'] != null
        ? new Designation.fromJson(json['designation'])
        : null;
    district = json['district'];
    upazila = json['upazila'];
    if (json['districts'] != null) {
      districts = <Districts>[];
      json['districts'].forEach((v) {
        districts!.add(new Districts.fromJson(v));
      });
    } else {
      districts = [];
    }
    if (json['upazilas'] != null) {
      upazilas = <Upazilas>[];
      json['upazilas'].forEach((v) {
        upazilas!.add(new Upazilas.fromJson(v));
      });
    } else {
      upazilas = [];
    }
    role = json['role'].cast<String>();
    roleId = json['role_id'].cast<int>();
    permissions = json['permissions'].cast<String>();
    photoUrl = json['photo_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['type'] = this.type;
    data['nid'] = this.nid;
    data['religion'] = this.religion;
    data['gender'] = this.gender;
    data['designation_id'] = this.designationId;
    data['district_id'] = this.districtId;
    data['upazila_id'] = this.upazilaId;
    data['union_id'] = this.unionId;
    data['ward_id'] = this.wardId;
    data['status'] = this.status;
     if (this.designation != null) {
      data['designation'] = this.designation!.toJson();
    }
    data['designation'] = this.designation;
    data['district'] = this.district;
    data['upazila'] = this.upazila;
    if (this.districts != null) {
      data['districts'] = this.districts!.map((v) => v.toJson()).toList();
    }
    if (this.upazilas != null) {
      data['upazilas'] = this.upazilas!.map((v) => v.toJson()).toList();
    }
    data['role'] = this.role;
    data['role_id'] = this.roleId;
    data['permissions'] = this.permissions;
    data['photo_url'] = this.photoUrl;
    return data;
  }
}

class Districts {
  int? id;
  int? divisionId;
  String? name;
  String? bnName;
  String? lat;
  String? lon;
  String? url;
  dynamic createdAt;
  dynamic updatedAt;
  Pivot? pivot;

  Districts(
      {this.id,
      this.divisionId,
      this.name,
      this.bnName,
      this.lat,
      this.lon,
      this.url,
      this.createdAt,
      this.updatedAt,
      this.pivot});

  Districts.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    divisionId = json['division_id'];
    name = json['name'];
    bnName = json['bn_name'];
    lat = json['lat'];
    lon = json['lon'];
    url = json['url'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    pivot = json['pivot'] != null ? new Pivot.fromJson(json['pivot']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['division_id'] = this.divisionId;
    data['name'] = this.name;
    data['bn_name'] = this.bnName;
    data['lat'] = this.lat;
    data['lon'] = this.lon;
    data['url'] = this.url;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.pivot != null) {
      data['pivot'] = this.pivot!.toJson();
    }
    return data;
  }
}

class Pivot {
  int? userId;
  int? districtId;

  Pivot({this.userId, this.districtId});

  Pivot.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    districtId = json['district_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['district_id'] = this.districtId;
    return data;
  }
}

class Upazilas {
  int? id;
  int? districtId;
  String? name;
  String? bnName;
  String? url;
  dynamic createdAt;
  dynamic updatedAt;
  Pivot? pivot;

  Upazilas(
      {this.id,
      this.districtId,
      this.name,
      this.bnName,
      this.url,
      this.createdAt,
      this.updatedAt,
      this.pivot});

  Upazilas.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    districtId = json['district_id'];
    name = json['name'];
    bnName = json['bn_name'];
    url = json['url'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    pivot = json['pivot'] != null ? new Pivot.fromJson(json['pivot']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['district_id'] = this.districtId;
    data['name'] = this.name;
    data['bn_name'] = this.bnName;
    data['url'] = this.url;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.pivot != null) {
      data['pivot'] = this.pivot!.toJson();
    }
    return data;
  }
}
class Designation {
  int? id;
  String? name;
  dynamic description;
  String? createdAt;
  String? updatedAt;

  Designation(
      {this.id, this.name, this.description, this.createdAt, this.updatedAt});

  Designation.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['description'] = this.description;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

// class Pivot {
//   int? userId;
//   int? upazilaId;

//   Pivot({this.userId, this.upazilaId});

//   Pivot.fromJson(Map<String, dynamic> json) {
//     userId = json['user_id'];
//     upazilaId = json['upazila_id'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['user_id'] = this.userId;
//     data['upazila_id'] = this.upazilaId;
//     return data;
//   }
// }
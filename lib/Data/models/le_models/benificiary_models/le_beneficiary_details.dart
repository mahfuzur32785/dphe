import 'package:dphe/Data/models/common_models/dlc_model/beneficiary_model.dart';

class LEBeneficiaryModel {
  BeneficiaryDetailsData? data;

  LEBeneficiaryModel({this.data});

  LEBeneficiaryModel.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? BeneficiaryDetailsData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['data'] = this.data?.toJson();
    return data;
  }
}
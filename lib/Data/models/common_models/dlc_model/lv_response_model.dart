class LeaveResponseMessageModel {
  String? status;
  int? statusCode;
  dynamic date;
  String? message;

  LeaveResponseMessageModel(
      {this.status, this.statusCode, this.date, this.message});

  LeaveResponseMessageModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    statusCode = json['status_code'];
    date = json['date'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['status_code'] = this.statusCode;
    data['date'] = this.date;
    data['message'] = this.message;
    return data;
  }
}
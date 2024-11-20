class LeGivenAnswerModel {
  int? id;
  int? questionId;
  int? beneficiaryId;
  int? isAnswer;
  int? createdBy;
  String? createdAt;
  String? updatedAt;
  Question? question;

  LeGivenAnswerModel(
      {this.id,
      this.questionId,
      this.beneficiaryId,
      this.isAnswer,
      this.createdBy,
      this.createdAt,
      this.updatedAt,
      this.question});

  LeGivenAnswerModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    questionId = json['question_id'];
    beneficiaryId = json['beneficiary_id'];
    isAnswer = json['is_answer'];
    createdBy = json['created_by'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    question = json['question'] != null
        ? new Question.fromJson(json['question'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['question_id'] = this.questionId;
    data['beneficiary_id'] = this.beneficiaryId;
    data['is_answer'] = this.isAnswer;
    data['created_by'] = this.createdBy;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.question != null) {
      data['question'] = this.question!.toJson();
    }
    return data;
  }
}

class Question {
  int? id;
  String? title;
  String? type;
  dynamic createdBy;
  String? createdAt;
  String? updatedAt;

  Question(
      {this.id,
      this.title,
      this.type,
      this.createdBy,
      this.createdAt,
      this.updatedAt});

  Question.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    type = json['type'];
    createdBy = json['created_by'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['type'] = this.type;
    data['created_by'] = this.createdBy;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
import 'package:hive/hive.dart';
part 'dlc_que_ans.g.dart';

@HiveType(typeId: 4)
class LocalDlcQuesAns {
  @HiveField(0)
  String? id;
  @HiveField(1)
  String? title;
  @HiveField(2)
  String? type;

  LocalDlcQuesAns({this.id, this.title, this.type});
}

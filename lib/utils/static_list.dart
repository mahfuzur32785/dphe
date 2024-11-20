import 'package:dphe/Data/models/citizen/service_model.dart';

import '../Data/models/common_models/union_model.dart';
import '../Data/models/le_models/le_dashboard_models/le_qsn_model.dart';

class StaticList{

  final  List<UnionModel> unionDummy = [
    UnionModel(id: 1, name: "Dhaka"),
    UnionModel(id: 2, name: "Rajshahi"),
    UnionModel(id: 3, name: "Dhaka"),
    UnionModel(id: 4, name: "Dhaka"),
    UnionModel(id: 5, name: "Dhaka"),
  ];

  final List<int> statusList = [0,1,2,3,4,5];
  final List<LeQsnModel> leQsnList = [
    LeQsnModel(id: 1, title: "যে স্থানে ল্যাট্রিন স্থাপন করা হবে সে স্থান থেকে আশে পাশের পরিবারে/প্রতিবেশীদের পরিবেশগত কোন সমস্যার সৃষ্টি হবে কি না?"),
    LeQsnModel(id: 2, title: "ল্যাট্রিনের স্থান খাল, পুকুর বা টিউবওয়েলের কাছে নির্বাচন করা হয়েছে কি না, যার মাধ্যমে পানি দূষিত হতে পারে?"),
    LeQsnModel(id: 3, title: "শিশু শ্রমিকসহ কোন ঝুঁকিপূর্ণ শ্রেণীর শ্রমিকদের দিয়ে কাজ করানো হবে কি না?"),
    LeQsnModel(id: 4, title: "ল্যাট্রিন স্থাপন করার সময় ইট, বালু, সিমেন্ট, খোয়া কিংবা গর্তের মাটি বাড়ীর পাশে রাখার জায়গা আছে কি না?"),
    LeQsnModel(id: 5, title: "কাজের সময়ে পানি জমে রাস্তা বন্ধ হবে কি না?"),
    LeQsnModel(id: 6, title: "ল্যাট্রিন পিটের তলদেশ ও চারপাশে কমপক্ষে ৩’-৬” উচ্চতা পর্যন্ত ৬” পুরু বালি দিয়ে ভরাট করার জায়গা আছে কি না? "),
  ];

  final List<ServiceModel> serviceModelList = [
    ServiceModel(id: 1, title: "টুইন পিট ল্যাট্রিন"),
    ServiceModel(id: 2, title: "পাবলিক টয়লেট"),
    ServiceModel(id: 3, title: "হাত ধোয়ার স্টেশন"),
    ServiceModel(id: 4, title: "কমিউনিটি ক্লিনিকগুলিতে নতুন স্যানিটেশন এবং স্বাস্থ্যবিধি সুবিধা"),
    ServiceModel(id: 5, title: "কমিউনিটি ক্লিনিকের টয়লেটগুলিতে চলমান জল এবং সংশ্লিষ্ট সুবিধার ব্যবস্থা"),
    ServiceModel(id: 6, title: "ছোট পাইপযুক্ত জল সরবরাহ প্রকল্প"),
    ServiceModel(id: 7, title: "বড় পাইপযুক্ত জল সরবরাহ প্রকল্প"),
  ];

}
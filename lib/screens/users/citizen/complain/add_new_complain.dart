import 'dart:developer';

import 'package:dphe/Data/models/citizen/service_model.dart';
import 'package:dphe/api/citizen/complain_list_api.dart';
import 'package:dphe/components/custom_appbar/custom_appbar_inner.dart';
import 'package:dphe/components/custom_buttons/custom_button_rounded.dart';
import 'package:dphe/components/custom_snackbar/custom_snakcbar.dart';
import 'package:dphe/components/text_input_filed/custom_textFIeld.dart';
import 'package:dphe/screens/users/citizen/applicaton_form/application_form.dart';
import 'package:dphe/utils/app_strings.dart';
import 'package:flutter/material.dart';

import '../../../../components/custom_dropdown/union_dropdown.dart';
import '../../../../utils/static_list.dart';

class AddNewComplain extends StatefulWidget {
  const AddNewComplain({super.key});

  @override
  State<AddNewComplain> createState() => _AddNewComplainState();
}

class _AddNewComplainState extends State<AddNewComplain> {
  final TextEditingController descriptionController = TextEditingController();
  final nidFormKey = GlobalKey<FormState>();
  final infoFormKey = GlobalKey<FormState>();

  ServiceModel? serviceModelValue;
  String? selectedService;
  String? selectedServiceId;

  final nidCtrl = TextEditingController();
  final nameCtrl = TextEditingController();
  final addressCtrl = TextEditingController();

  bool isBeneficiaryLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppbarInner(title: "নতুন অভিযোগ",),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DropdownButtonFormField<ServiceModel>(
                isExpanded: true,
                decoration: const InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    labelText: 'সেবা নির্বাচন করুন',
                    hintText: "সেবা নির্বাচন করুন"),
                value: serviceModelValue,
                items: StaticList().serviceModelList.map<DropdownMenuItem<ServiceModel>>((item) {
                  return DropdownMenuItem<ServiceModel>(
                    value: item,
                    onTap: () {
                      log('selected office ID ${item.id}');
                    },
                    child: Text("${item.title}", style: const TextStyle(fontSize: 16),),
                  );
                }).toList(),
                onChanged: (ServiceModel? newValue) {
                  setState(() {
                    serviceModelValue = newValue;
                  //   selectedService = newValue!.title.toString();
                    selectedServiceId = newValue?.id.toString();
                    nidCtrl.clear();
                    nameCtrl.clear();
                    addressCtrl.clear();
                  });
                  // log('Selected Office from dialog $selectedServiceId');
                },
                validator: (value) {
                  if (value == null) {
                    return 'সেবা নির্বাচন করুন';
                  }
                  return null;
                },
              ),

              Visibility(
                visible: selectedServiceId!=null&&selectedServiceId == "1",
                 child: Form(
                   key: nidFormKey,
                   child: Padding(
                     padding: const EdgeInsets.all(10),
                     child: Column(
                       crossAxisAlignment: CrossAxisAlignment.start,
                       children: [
                         const SizedBox(height: 20),
                         const Text("আপনার নিবন্ধিত এনআইডি প্রদান করুন",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),),
                         const SizedBox(height: 5),
                         TextFormField(
                           controller: nidCtrl,
                           maxLines: 1,
                           keyboardType: TextInputType.phone,
                           decoration: const InputDecoration(
                             border: OutlineInputBorder(),
                             labelText: "এনআইডি",
                             contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                           ),
                           // validator: null,
                           validator: (value) {
                             if (value!.isEmpty) {
                               return 'দয়া করে এনআইডি লিখুন';
                             }
                             return null;
                           },
                         ),
                         const SizedBox(height: 15),
                         Align(
                           alignment: Alignment.centerRight,
                           child: GestureDetector(
                             onTap: () {
                               if(nidFormKey.currentState!.validate()){
                                 isBeneficiaryLoading = true;
                                 setState(() {});
                                 CitizenApi().getBeneficiaryDataApi(nid: nidCtrl.text.trim()).then((value) {
                                   isBeneficiaryLoading = false;
                                   setState(() {});
                                   if(value!=null){
                                     var address = "${value.houseName}, ${value.wardNo}, ${value.union?.name}, ${value.upazila?.name}, ${value.district?.name}";
                                     Navigator.of(context).push(MaterialPageRoute(builder: (builder)=> ApplicationForm(name: value.name??"", address: address,beneficiaryId: value.id.toString(),serviceId: selectedServiceId??"")));
                                   }else{
                                     CustomSnackBar(message: 'The given nid is invalid', isSuccess: false).show();
                                   }
                                 },);
                               }
                             },
                             child: Container(
                               alignment: Alignment.center,
                               padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                               width: 90,
                               decoration: BoxDecoration(
                                 color: Colors.green,
                                 borderRadius: BorderRadius.circular(5),
                               ),
                               child: isBeneficiaryLoading?Center(child: CircularProgressIndicator(color: Colors.white,),):Text('পরবর্তী', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                             ),
                           ),
                         )
                      ],
                     ),
                   ),
                 ),
              ),

              Visibility(
                visible: selectedServiceId!=null&&selectedServiceId != "1",
                 child: Form(
                   key: infoFormKey,
                   child: Padding(
                     padding: const EdgeInsets.all(10),
                     child: Column(
                       crossAxisAlignment: CrossAxisAlignment.start,
                       children: [
                         const SizedBox(height: 20),
                         const Text("আপনার তথ্য প্রদান করুন",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),),
                         const SizedBox(height: 5),
                         TextFormField(
                           controller: nameCtrl,
                           maxLines: 1,
                           decoration: const InputDecoration(
                             border: OutlineInputBorder(),
                             labelText: "নাম",
                             contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                           ),
                           // validator: null,
                           validator: (value) {
                             if (value!.isEmpty) {
                               return 'দয়া করে আপনার নাম লিখুন';
                             }
                             return null;
                           },
                         ),
                         const SizedBox(height: 10),
                         TextFormField(
                           controller: addressCtrl,
                           maxLines: 1,
                           decoration: const InputDecoration(
                             border: OutlineInputBorder(),
                             labelText: "ঠিকানা",
                             contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                           ),
                           // validator: null,
                           validator: (value) {
                             if (value!.isEmpty) {
                               return 'দয়া করে আপনার ঠিকানা লিখুন';
                             }
                             return null;
                           },
                         ),
                         const SizedBox(height: 15),
                         Align(
                           alignment: Alignment.centerRight,
                           child: GestureDetector(
                             onTap: () {
                               if(infoFormKey.currentState!.validate()){
                                 Navigator.of(context).push(MaterialPageRoute(builder: (builder)=> ApplicationForm(name: nameCtrl.text.trim(), address: addressCtrl.text.trim(),serviceId: selectedServiceId??"")));
                               }
                             },
                             child: Container(
                               alignment: Alignment.center,
                               padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                               width: 90,
                               decoration: BoxDecoration(
                                 color: Colors.green,
                                 borderRadius: BorderRadius.circular(5),
                               ),
                               child: const Text('পরবর্তী', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                             ),
                           ),
                         )
                      ],
                     ),
                   ),
                 ),
              ),


            ],
          ),
        ),
      ),
      // body: SingleChildScrollView(
      //   child: Padding(
      //     padding: const EdgeInsets.symmetric(horizontal: 10.0),
      //     child: Form(
      //       key: _formKey,
      //       child: Column(
      //         children: [
      //           const SizedBox(height: 15,),
      //           // UnionDropdown(
      //           //     hintText: "Select Scheme",
      //           //     itemList: StaticList().unionDummy,
      //           //     callBackFunction: (value){
      //           //       print(value.name);
      //           //     }
      //           // ),
      //
      //           const SizedBox(height: 15,),
      //           // UnionDropdown(
      //           //     hintText: "Complaint Type",
      //           //     itemList: StaticList().unionDummy,
      //           //     callBackFunction: (value){
      //           //       print(value.name);
      //           //     }
      //           // ),
      //
      //           const SizedBox(height: 15,),
      //           CustomTextInputFieldRegular(
      //               controller: descriptionController,
      //               textInputType: TextInputType.text,
      //               maxLine: 15,
      //               hintText: "আপনার অভিযোগ...",
      //               validatorFunction: (value) {
      //                 if (value == null || value.isEmpty) {
      //                   return AppStrings.requiredField;
      //                 }
      //                 return null;
      //               },
      //           ),
      //
      //           const SizedBox(height: 90,),
      //
      //           CustomButtonRounded(
      //               title: AppStrings.submit,
      //               onPress: (){
      //                 if(_formKey.currentState!.validate()){
      //
      //                 }
      //               }
      //           ),
      //           const SizedBox(height: 30,),
      //         ],
      //       ),
      //     ),
      //   ),
      // ),
    );
  }
}

import 'dart:convert';
import 'dart:io';

import 'package:dphe/api/citizen/complain_list_api.dart';
import 'package:dphe/components/custom_appbar/custom_appbar_inner.dart';
import 'package:dphe/components/custom_snackbar/custom_snakcbar.dart';
import 'package:dphe/components/text_input_filed/custom_textFIeld.dart';
import 'package:dphe/utils/utlis.dart';
import 'package:flutter/material.dart';

class ApplicationForm extends StatefulWidget {
  const ApplicationForm({super.key, required this.name, required this.address, this.beneficiaryId, required this.serviceId});

  final String name;
  final String address;
  final String serviceId;
  final String? beneficiaryId;

  @override
  State<ApplicationForm> createState() => _ApplicationFormState();
}

class _ApplicationFormState extends State<ApplicationForm> {
  final applicationFormKey = GlobalKey<FormState>();

  final subjectCtrl = TextEditingController();
  final detailsCtrl = TextEditingController();

  bool isApplicationLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppbarInner(
        title: "অভিযোগের ফরম",
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: applicationFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ///User Info
                Center(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: Colors.grey)),
                    padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          text: TextSpan(
                            text: 'নাম : ',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontSize: 16),
                            children: <TextSpan>[
                              TextSpan(
                                  text: widget.name,
                                  style: const TextStyle(
                                      // fontWeight: FontWeight.bold,
                                      color: Colors.green,
                                      fontSize: 14)),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        RichText(
                          text: TextSpan(
                            text: 'ঠিকানা : ',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontSize: 16),
                            children: <TextSpan>[
                              TextSpan(
                                  text: widget.address,
                                  style: const TextStyle(
                                      // fontWeight: FontWeight.bold,
                                      color: Colors.green,
                                      fontSize: 14)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                ///Complain Section
                const SizedBox(height: 30),

                const Text("আপনার অভিযোগের বিস্তারিত প্রদান করুন",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 10),
                CustomTextInputFieldRegular(
                  controller: subjectCtrl,
                  textInputType: TextInputType.text,
                  maxLine: 1,
                  hintText: "বিষয়",
                  validatorFunction: (value) {
                    if (value == null || value.isEmpty) {
                      return 'বিষয় লিখুন';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                CustomTextInputFieldRegular(
                  controller: detailsCtrl,
                  textInputType: TextInputType.text,
                  maxLine: 10,
                  hintText: "বর্ণনা",
                  validatorFunction: (value) {
                    if (value == null || value.isEmpty) {
                      return 'বর্ণনা লিখুন';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                FormField<String>(
                  validator: (value) {
                    // Check if an image has been selected
                    if (gallerySingleImage == null || gallerySingleImage!.isEmpty) {
                      return 'ফাইল নির্বাচন করুন';
                    }
                    return null; // No error if an image is selected
                  },
                  builder: (FormFieldState<String> field) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.only(left: 5, right: 10),
                          decoration: BoxDecoration(
                              border: Border.all(color: field.hasError? Colors.red:  Colors.grey.shade600),
                              borderRadius: BorderRadius.circular(5)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  selectFile();
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.black,
                                  elevation: 3,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(3),
                                  ),
                                ),
                                child: const Text(
                                  "নির্বাচন করুন",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              Expanded(
                                child: Text(
                                  gallerySingleImage!= null ? "${gallerySingleImage?.substring(gallerySingleImage!.lastIndexOf('/') + 1)}" : "No file chosen",
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // const SizedBox(height: 10),
                        if (field.hasError)
                          Padding(
                            padding: const EdgeInsets.only(top: 3, left: 15),
                            child: Text(
                              field.errorText ?? '',
                              style: TextStyle(color: Colors.red.shade900, fontSize: 12),
                            ),
                          ),
                      ],
                    );
                  },
                ),

                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerRight,
                  child: SizedBox(
                    width: 150,
                    child: ElevatedButton(
                      onPressed: () async {
                        if(applicationFormKey.currentState!.validate()){
                          isApplicationLoading = true;
                          setState(() {});
                          await CitizenApi().complainSubmitApi(
                            serviceId: widget.serviceId,
                            name: widget.name,
                            address: widget.address,
                            subject: subjectCtrl.text.trim(),
                            body: detailsCtrl.text.trim(),
                            beneficiaryId: widget.beneficiaryId,
                            imagePath: gallerySingleImage??""
                          ).then((value) {
                            if(value!=null) {
                              gallerySingleImage = null;
                              subjectCtrl.clear();
                              detailsCtrl.clear();
                              CustomSnackBar(message: value, isSuccess: true).show();
                              Navigator.pop(context);
                              Navigator.pop(context);
                            }else{
                              CustomSnackBar(message: "Something Wrong", isSuccess: true).show();
                            }
                            isApplicationLoading = false;
                            setState(() {});
                          },);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(3)),
                      ),
                      child: isApplicationLoading ? const Center(child: CircularProgressIndicator(color: Colors.white,),): const Text(
                        "সাবমিট করুন",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  selectFile() {
    Utils.showCustomDialog(context,
        child: Wrap(
          children: [
            Container(
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(5)),
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "নির্বাচন করুন",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Row(
                    children: [
                      Expanded(
                        flex: 5,
                        child: GestureDetector(
                          onTap: () {
                            pickGalleryImageFromCamera().then((value) {
                              Navigator.of(context).pop();
                            });
                          },
                          child: Container(
                              alignment: Alignment.center,
                              color: const Color(0xFFDAD9D9),
                              height: MediaQuery.of(context).size.height * 0.1,
                              width: MediaQuery.of(context).size.width * 0.5,
                              child: const Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Icon(Icons.camera_alt),
                                  Text('ক্যামেরা')
                                ],
                              )),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(
                          height: 2,
                        ),
                      ),
                      Expanded(
                        flex: 5,
                        child: GestureDetector(
                          onTap: () {
                            pickGalleryImageFromGallery().then((value) {
                              Navigator.of(context).pop();
                            });
                          },
                          child: Container(
                              alignment: Alignment.center,
                              color: const Color(0xFFDAD9D9),
                              height: MediaQuery.of(context).size.height * 0.1,
                              width: MediaQuery.of(context).size.width * 0.5,
                              child: const Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [Icon(Icons.photo), Text('গ্যালারি')],
                              )),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      style: TextButton.styleFrom(
                          backgroundColor: Colors.red,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 1)),
                      child: const Text(
                        'বন্ধ করুন',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ));
  }

  String? galleryImage;
  String? gallerySingleImage;

  pickGalleryImageFromCamera() async {
    await Utils.pickSingleImageFromCamera().then((value) async {
      if (value != null) {
        galleryImage = value;
        File file = File(galleryImage!);
        if (file != null) {
          gallerySingleImage = file.path;
          print("gkjsghjdfg $gallerySingleImage");
        }
      }
    });
    setState(() {});
    return gallerySingleImage;
  }

  pickGalleryImageFromGallery() async {
    await Utils.pickSingleImageFromGallery().then((value) async {
      if (value != null) {
        galleryImage = value;
        File file = File(galleryImage!);
        if (file != null) {
          gallerySingleImage = file.path;
          print("gkjsghjdfg $gallerySingleImage");
        }
      }
    });
    setState(() {});
    return gallerySingleImage;
  }


}

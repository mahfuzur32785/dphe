import 'package:dphe/Data/models/citizen/complain_model.dart';
import 'package:dphe/api/citizen/complain_list_api.dart';
import 'package:dphe/components/common_widgets/common_widgets.dart';
import 'package:dphe/components/custom_appbar/custom_appbar_inner.dart';
import 'package:dphe/components/custom_image/custom_image.dart';
import 'package:dphe/components/custom_snackbar/custom_snakcbar.dart';
import 'package:dphe/components/show_single_image/show_single_image.dart';
import 'package:dphe/utils/api_constant.dart';
import 'package:dphe/utils/app_colors.dart';
import 'package:dphe/utils/custom_text_style.dart';
import 'package:dphe/utils/local_storage_manager.dart';
import 'package:dphe/utils/utlis.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;

class ComplainDetails extends StatefulWidget {
  const ComplainDetails({super.key, required this.complainModel});

  final ComplainModel complainModel;

  @override
  State<ComplainDetails> createState() => _ComplainDetailsState();
}

class _ComplainDetailsState extends State<ComplainDetails> {
  final ScrollController scrollController = ScrollController();
  final messageController = TextEditingController();

  List<Comment> commentList = [];

  @override
  void initState() {
    super.initState();
    commentList.addAll(widget.complainModel.comments?.reversed.toList() ?? []);
    WidgetsBinding.instance
        .addPostFrameCallback((_) => scrollController.position.maxScrollExtent);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppbarInner(
        title: "অভিযোগের বিস্তারিত",
      ),
      backgroundColor: Colors.white,
      body: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ///COMPLAIN DETAILS SECTION
            if(widget.complainModel.status == "Resolved" || widget.complainModel.status == "Invalid")
              Expanded(child: Container(
                padding: const EdgeInsets.all(10),
                margin: const EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                    color: MyColors.cardBackgroundColor,
                    borderRadius: BorderRadius.circular(5),
                    border:
                    Border.all(color: MyColors.customGreyLight, width: 1)),
                child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                            child: Text(
                              "${widget.complainModel.subject}",
                              style: MyTextStyle.primaryBold(fontSize: 14),
                            )),
                        customStatus(
                            status:
                            "${widget.complainModel.status}",
                            bgColor: widget.complainModel
                                .status ==
                                "Resolved"
                                ? Colors.green
                                : widget.complainModel
                                .status ==
                                "Invalid"
                                ? Colors.red
                                : widget.complainModel
                                .status ==
                                "Pending"
                                ? Colors.orange
                                : widget.complainModel
                                .status ==
                                "Processing"
                                ? Colors.blue
                                : MyColors
                                .customRed)
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [
                        Text(
                          Utils.convertToBengaliNumerals(
                              intl.DateFormat('dd/MM/yyyy, hh:mm')
                                  .format(widget.complainModel.createdAt!)),
                          style: MyTextStyle.primaryLight(fontSize: 14),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              Utils.createPageRouteTop(
                                  context,
                                  ShowSingleImage(
                                      imageUrl:
                                      "http://165.232.182.172:8000/${widget.complainModel.document}")));
                        },
                        child: const Text("ফাইল দেখুন",
                            style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold))),
                    const Divider(),
                    Text(
                      "${widget.complainModel.body}",
                      style: MyTextStyle.primaryLight(fontSize: 12),
                    ),
                  ],
                ),
                            ),
              )),

            if(widget.complainModel.status != "Resolved" && widget.complainModel.status != "Invalid")
              Container(
              height: MediaQuery.of(context).size.height * 0.25,
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                  color: MyColors.cardBackgroundColor,
                  borderRadius: BorderRadius.circular(5),
                  border:
                      Border.all(color: MyColors.customGreyLight, width: 1)),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                            child: Text(
                          "${widget.complainModel.subject}",
                          style: MyTextStyle.primaryBold(fontSize: 14),
                        )),
                        customStatus(
                            status:
                            "${widget.complainModel.status}",
                            bgColor: widget.complainModel
                                .status ==
                                "Resolved"
                                ? Colors.green
                                : widget.complainModel
                                .status ==
                                "Invalid"
                                ? Colors.red
                                : widget.complainModel
                                .status ==
                                "Pending"
                                ? Colors.orange
                                : widget.complainModel
                                .status ==
                                "Processing"
                                ? Colors.blue
                                : MyColors
                                .customRed)
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [
                        Text(
                          Utils.convertToBengaliNumerals(
                              intl.DateFormat('dd/MM/yyyy, hh:mm')
                                  .format(widget.complainModel.createdAt!)),
                          style: MyTextStyle.primaryLight(fontSize: 14),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              Utils.createPageRouteTop(
                                  context,
                                  ShowSingleImage(
                                      imageUrl:
                                      "http://165.232.182.172:8000/${widget.complainModel.document}")));
                        },
                        child: const Text("ফাইল দেখুন",
                            style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold))),
                    const Divider(),
                    Text(
                      "${widget.complainModel.body}",
                      style: MyTextStyle.primaryLight(fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),

            ///MESSAGE LIST SECTION
            Visibility(
              visible: (widget.complainModel
                  .status !=
                  "Resolved" && widget.complainModel
                  .status != "Invalid"),
              child: Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  reverse: true,
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: ListView.separated(
                    shrinkWrap: true,
                    reverse: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: commentList.length,
                    itemBuilder: (context, index) {
                      String input = commentList[index].creatorType.toString();
                      RegExp regExp = RegExp(r'\\(\w+)$');
                      String? result = regExp.firstMatch(input)?.group(1);
                      String creatorType = '';
                      if (result != null) {
                        print(result); // Output: Citizen
                        creatorType = result;
                      }
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 3),
                        child: Row(
                          mainAxisAlignment: creatorType == "Citizen"
                              ? MainAxisAlignment.end
                              : MainAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: creatorType == "Citizen"
                                    ? CrossAxisAlignment.end
                                    : CrossAxisAlignment.start,
                                children: [
                                  LayoutBuilder(builder: (context, constraints) {
                                    // Check the width of the screen
                                    double screenWidth =
                                        MediaQuery.of(context).size.width;

                                    // Create a TextPainter to measure the text width
                                    TextPainter textPainter = TextPainter(
                                      text: TextSpan(
                                          text: commentList[index].comment,
                                          style: const TextStyle(fontSize: 16)),
                                      maxLines: 1,
                                      textDirection: TextDirection.ltr,
                                    )..layout(maxWidth: screenWidth);
                                    bool isLongText = textPainter.size.width >
                                        screenWidth * 0.65;

                                    return Container(
                                      width: isLongText
                                          ? MediaQuery.of(context).size.width *
                                              0.65
                                          : null,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16, vertical: 6),
                                      decoration: BoxDecoration(
                                          color: creatorType == "Citizen"
                                              ? Colors.blue
                                              : Colors.grey.shade200,
                                          borderRadius: BorderRadius.only(
                                            topLeft: const Radius.circular(6),
                                            topRight: const Radius.circular(6),
                                            bottomRight: index % 2 == 0
                                                ? const Radius.circular(0)
                                                : const Radius.circular(6),
                                            bottomLeft: const Radius.circular(0),
                                          )),
                                      child: Text(
                                        commentList[index].comment ?? "",
                                        style: TextStyle(
                                            color: creatorType == "Citizen"
                                                ? Colors.white
                                                : Colors.black87,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    );
                                  }),
                                  const SizedBox(
                                    height: 2,
                                  ),
                                  Row(
                                    mainAxisAlignment: creatorType == "Citizen"
                                        ? MainAxisAlignment.end
                                        : MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        Utils.timeAgo(
                                            "${commentList[index].createdAt}"),
                                        style: const TextStyle(
                                            color: Colors.black38,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    separatorBuilder: (context, index) {
                      return const SizedBox(
                        height: 8,
                      );
                    },
                  ),
                ),
              ),
            ),

            ///MESSAGE SEND SECTION
            Visibility(
              visible: (widget.complainModel
                  .status !=
                  "Resolved" && widget.complainModel
                  .status != "Invalid"),
              child: Container(
                // height: 60,
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                decoration:
                    BoxDecoration(color: Colors.grey.shade300, boxShadow: [
                  BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      blurRadius: 3,
                      offset: const Offset(0, -5))
                ]),
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: messageController,
                        textInputAction: TextInputAction.send,
                        onFieldSubmitted: (value) {
                          if (value != '') {
                            sendMessage();
                          }
                        },
                        maxLines: 1,
                        decoration: InputDecoration(
                          hintText: "আপনার মন্তব্য লিখুন",
                          hintStyle: const TextStyle(fontSize: 14),
                          fillColor: Colors.white,
                          filled: true,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              borderSide:
                                  const BorderSide(color: Colors.transparent)),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              borderSide:
                                  const BorderSide(color: Colors.transparent)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              borderSide:
                                  const BorderSide(color: Colors.transparent)),
                          errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              borderSide:
                                  const BorderSide(color: Colors.transparent)),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    GestureDetector(
                        onTap: () async {
                          sendMessage();
                        },
                        child: const Icon(
                          Icons.send,
                          color: Colors.blue,
                          size: 35,
                        )),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  sendMessage() async {
    if (messageController.text == '') {
      CustomSnackBar(message: "আপনার মন্তব্য লিখুন", isSuccess: false).show();
    } else {
      await CitizenApi()
          .commentSubmitApi(
              complainId: widget.complainModel.id.toString(),
              comment: messageController.text.trim())
          .then(
        (value) {
          commentList.insert(0, value);
          messageController.clear();
          setState(() {});
        },
      );
    }
  }
}

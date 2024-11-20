import 'package:dphe/components/custom_appbar/custom_appbar.dart';
import 'package:dphe/provider/le_providers/le_dashboard_provider.dart';
import 'package:dphe/provider/operation_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../components/custom_dropdown/union_dropdown.dart';
import '../../../components/custom_dropdown/upazila_dropdown.dart';

class TwinPitLatrineDetails extends StatefulWidget {
  final String title;
  const TwinPitLatrineDetails({super.key, required this.title});

  @override
  State<TwinPitLatrineDetails> createState() => _TwinPitLatrineDetailsState();
}

class _TwinPitLatrineDetailsState extends State<TwinPitLatrineDetails> {
  @override
  Widget build(BuildContext context) {
    return Consumer2<OperationProvider, LeDashboardProvider>(
        builder: (context, op, controller, child) {
      return Scaffold(
        appBar: CustomAppbar(
          title: op.getTwinPitLatrineDetTitle(widget.title),
          isTwinPitLatrineDetailsPage: true,
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Row(
                children: [
                  Expanded(
                    child: UpazilaDropdown(
                        hintText: controller.upazilaList.isNotEmpty
                            ? "উপজেলা"
                            : "Loading...",
                        itemList: controller.upazilaList,
                        callBackFunction: (value) {
                          // setState(() {
                          //   selectedUpazilaId = value.id;
                          // });
                          print(value.id);
                          controller.getUnionList(upazilaId: value.id);
                        }),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: UnionDropdown(
                        hintText: "ইউনিয়ন",
                        itemList: controller.unionList,
                        callBackFunction: (value) {
                          print(value.id);
                          // setState(() {
                          //   selectedUnionId = value.id;
                          // });
                        }),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}

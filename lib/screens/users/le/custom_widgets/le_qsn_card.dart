import 'package:dphe/utils/custom_text_style.dart';
import 'package:flutter/material.dart';
import '../../../../components/common_widgets/common_widgets.dart';
import '../../../../Data/models/le_models/le_dashboard_models/le_qsn_model.dart';

class LeQsnCard extends StatefulWidget {
  final int index;
  final LeQsnModel qsnObject;
  final Function(int?) ans;
  const LeQsnCard({super.key, required this.index, required this.qsnObject, required this.ans});

  @override
  State<LeQsnCard> createState() => _LeQsnCardState();
}

class _LeQsnCardState extends State<LeQsnCard> {
  int? selectedOption ;
  @override
  Widget build(BuildContext context) {
    return customCard(
        verticalMargin: 5,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.qsnObject.title),
            Row(
              children: [
                Expanded(
                  child: RadioListTile(
                    title: Text('হ্যা', style: MyTextStyle.primaryLight(fontSize: 14)),
                    value: 1,
                    groupValue: selectedOption,
                    onChanged: (value) {
                      setState(() {
                        selectedOption = 1;
                      });
                      widget.ans(value);
                    },
                  ),
                ),
                Expanded(
                  child: RadioListTile(
                    title: Text('না', style: MyTextStyle.primaryLight(fontSize: 14),),
                    value: 0,
                    groupValue: selectedOption,
                    onChanged: (value) {
                      setState(() {
                        selectedOption = 0;
                      });
                      widget.ans(value);
                    },
                  ),
                ),
              ],
            )
          ],
        )
    );
  }
}

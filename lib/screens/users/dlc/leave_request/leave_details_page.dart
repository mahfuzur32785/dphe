import 'package:dphe/helper/date_converter.dart';
import 'package:dphe/provider/leave_provider.dart';
import 'package:dphe/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:developer' as dev;
import '../../../../Data/models/common_models/dlc_model/leave_details_model.dart';

class LeaveDetailsPage extends StatefulWidget {
  const LeaveDetailsPage({super.key});

  @override
  State<LeaveDetailsPage> createState() => _LeaveDetailsPageState();
}

class _LeaveDetailsPageState extends State<LeaveDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: DataTable(
          horizontalMargin: 15,
          dividerThickness: 2,
          showBottomBorder: true,
          dataRowHeight: kMinInteractiveDimension,
          // columnSpacing: (MediaQuery.of(context).size.width / 9) * 0.5,
          headingRowColor: MaterialStateProperty.resolveWith<Color?>(
              (Set<MaterialState> states) {
            if (states.contains(MaterialState.selected))
              return Colors.green.withOpacity(0.08);
            return MyColors.backgroundColor; // Use the default value.
          }),
          columns: [
            DataColumn(
              label: Text('From Date',),//style: TextStyle(color: Color(0xFF9E9E9E))
            ),
            DataColumn(
              label: Text('To Date'),
            ),
            DataColumn(
              label: Text('Leave Type'),
            ),
            DataColumn(
              label: Text('Status'),
            ),
          ],
          rows: [],
        ),
      ),
    );
  }
}

class UserDataTableSource extends DataTableSource {
  UserDataTableSource({
    required List<LeaveData> userData,
    required this.context,
    required this.rmrkController
  })  : _userData = userData,
        assert(userData != null);

  final List<LeaveData> _userData;
  final BuildContext context;
  final TextEditingController rmrkController;


  @override
  DataRow? getRow(int index) {
    assert(index >= 0);

    if (index >= _userData.length) {
      return null;
    }
    final _user = _userData[index];

    return DataRow.byIndex(
      index: index,

      // color: MaterialStateProperty.resolveWith<Color?>(
      //     (Set<MaterialState> states) {
      //   if (states.contains(MaterialState.selected))
      //     return Colors.white;
      //   return Colors.white; // Use the default value.
      // }),

      cells: <DataCell>[
        DataCell(
          Row(
            children: [
              Text('${DateConverter.dateFormatFromAPi(_user.fromDate!)}',
                  style: TextStyle(
                    fontSize: 12,
                  )),
              // VerticalDivider(),
            ],
          ),
        ),
        DataCell(Row(
          children: [
            Text('${DateConverter.dateFormatFromAPi(_user.toDate!)}',
                style: TextStyle(
                  fontSize: 12,
                )),
            // VerticalDivider()
          ],
        )),
        DataCell(Row(
          children: [
            Text('${_user.leaveType}',
                style: TextStyle(
                  fontSize: 12,
                )),
            // VerticalDivider()
          ],
        )),
        _user.isApproved == 1
            ? DataCell(Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                color: MyColors.apprvelvStsColor,
                child: Padding(
                 padding: const EdgeInsets.all(4.0),
                  child: Text('Approved', style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),),
                )))
            : _user.isRejected == 1
                ? DataCell(Card(
                   shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                    color: MyColors.rejectedlvStsColor,
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Text('Rejected', style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),),
                    )))
                : _user.isForwarded == 1
                    ? DataCell(Text('Forwarded'))
                    : DataCell(InkWell(
                        onTap: () {
                          // Provider.of<LeaveProvider>(context, listen: false)
                          //     .updateLeaveRequestData(
                          //   exnID: _user.exen!.id!,
                          //   exnName: _user.exen!.name!,
                          //   selectedLeaveType: _user.leaveType!,
                          //   fromDate: _user.fromDate!,
                          //   toDate:  _user.toDate!,
                          //   //rmrkController: rmrkController,
                          //   remarks: _user.description!,
                          //   leaveID: _user.id!
                          // );
                          dev.log('table index $index');
                        },
                        child: Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15)),
                            color: MyColors.pendinglvStsColor,
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Text(
                                'Pending',
                                style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            )),
                      )
                      ),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => _userData.length;

  @override
  int get selectedRowCount => 0;
}

class CustomDataColumn extends DataColumn {
  final VerticalDivider divider;

  CustomDataColumn({
    required DataColumn label,
    required this.divider,
  }) : super(
          label: label.label,
          tooltip: label.tooltip,
          onSort: label.onSort,
        );

  Widget render(BuildContext context) {
    final List<Widget> _children = <Widget>[];
    if (divider != null) {
      _children.add(divider);
    }
    _children.add(DefaultTextStyle(
      style: TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 14,
      ),
      child: label,
    ));
    return Container(
      height: kMinInteractiveDimension,
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(mainAxisSize: MainAxisSize.min, children: _children),
    );
  }
}

import 'package:dphe/Data/models/common_models/dlc_model/attendance_details_model.dart';
import 'package:dphe/screens/users/dlc/attendance/map_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:developer' as dev;
import '../../../../Data/models/common_models/dlc_model/leave_details_model.dart';
import '../../../../helper/date_converter.dart';
import '../../../../provider/leave_provider.dart';
import '../../../../utils/app_colors.dart';

class AttendanceDataTable extends DataTableSource {
  AttendanceDataTable({
    required List<AttendanceData> userData,
    required this.context,
    //required this.rmrkController
  })  : _userData = userData,
        assert(userData != null);

  final List<AttendanceData> _userData;
  final BuildContext context;
  //final TextEditingController rmrkController;

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
              Text(
                  '${DateConverter.formatDateIOS(
                    _user.checkIn!,
                  )}',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
              // VerticalDivider(),
            ],
          ),
        ),
        DataCell(Row(
          children: [
            Text('${DateConverter.formatDateIOS(_user.checkIn!, isTime: true)}', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
            // VerticalDivider()
          ],
        )),
        DataCell(Row(
          children: [
            IconButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return MapDialog(
                        latitude: _user.latitude /* Your latitude value */,
                        longitude: _user.longitude /* Your longitude value */,
                        date: DateConverter.formatDateIOS(_user.checkIn!),
                      );
                    },
                  );
                },
                icon: Icon(Icons.location_on)),
            // Text('${_user.latitude}',
            //     style: TextStyle(
            //       fontSize: 12,
            //        fontWeight: FontWeight.w500
            //     )),
            // VerticalDivider()
          ],
        )),
        // DataCell(Row(
        //   children: [
        //     Text('${_user.latitude}',
        //         style: TextStyle(
        //           fontSize: 12,
        //            fontWeight: FontWeight.w500
        //         )),
        //     // VerticalDivider()
        //   ],
        // )),
        //  DataCell(Row(
        //   children: [
        //     Text('${_user.longitude}',
        //         style: TextStyle(
        //           fontSize:12,
        //            fontWeight: FontWeight.w500
        //         )),
        //     // VerticalDivider()
        //   ],
        // )),
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

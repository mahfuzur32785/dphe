import 'dart:io';

import 'package:dphe/Data/models/common_models/union_model.dart';
import 'package:dphe/provider/operation_provider.dart';
import 'package:dphe/utils/app_colors.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

class UnionDialog extends StatefulWidget {
  final bool isDlcActivity;
  const UnionDialog({
    Key? key,
    this.isDlcActivity = false,
  }) : super(key: key);

  @override
  State<UnionDialog> createState() => _UnionDialogState();
}

class _UnionDialogState extends State<UnionDialog> {
  final searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      alignment: Alignment.center,
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      title: Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FittedBox(
              child: Text(
               widget.isDlcActivity ? 'Union List' : 'ইউনিয়নের তালিকা',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 15),
                // style: GoogleFonts.chakraPetch(
                //   fontWeight: FontWeight.w600,
                // ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        const Divider(
          thickness: 2,
        ),
        Center(
          child: CloseButton(
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
      ],
      // insetPadding: EdgeInsets.zero,
      contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),

      // contentPadding: EdgeInsets.all(45.0),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(18.0))),
      content: Builder(
        builder: (context) {
          var height = MediaQuery.of(context).size.height;
          var width = MediaQuery.of(context).size.width;
          return Container(
              height: height / 2,
              width: width,
              //color: Colors.white,
              child: Consumer<OperationProvider>(
                builder: (context, op, child) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: TextField(
                          controller: searchController,
                          //style: robotoRegular.copyWith(color: Colors.black87, fontSize: 16),
                          decoration: InputDecoration(
                              hintText: widget.isDlcActivity ? 'Search Union': 'ইউনিয়ন খুজুন',
                              focusColor: Colors.green,
                              contentPadding: EdgeInsets.symmetric(vertical: 18, horizontal: 22),
                              // suffixIcon: ap.isCustomerSearch
                              //     ? IconButton(
                              //         onPressed: () {
                              //           searchController.text = '';
                              //           //ap.searchCustomer('');
                              //         },
                              //         icon: Icon(
                              //           Icons.close,
                              //           color: Colors.red,
                              //         ))
                              //     : Icon(
                              //         Icons.search,
                              //         color: Colors.black,
                              //       ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  width: 2.0,
                                  color: Colors.green,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0), borderSide: BorderSide(width: 2, color: Color(0xFFFC6A57)))),
                          onChanged: (query) {
                            op.searchUnion(query);
                            //  ap.searchCustomer(query);
                          },
                        ),
                      ),
                      // !op.isLoading
                      //     ? ap.customerList != null
                      //         ? ap.customerList!.isNotEmpty
                      //             ?
                      Expanded(
                        child: Scrollbar(
                          thumbVisibility: true,
                          thickness: 10,
                          radius: const Radius.circular(10),
                          child: ListView.builder(
                            itemCount: op.unionList.length,
                            // padding: const EdgeInsets.all(
                            //   Dimensions.PADDING_SIZE_DEFAULT,
                            // ),
                            physics: const BouncingScrollPhysics(),
                            itemBuilder: (context, index) => InkWell(
                              onTap: () {
                                if (widget.isDlcActivity) {
                                   final unionName = op.unionList[index].name ?? "";
                                final unionID = op.unionList[index].id;
                                final union = UnionModel(id: unionID!, name: unionName);
                                Navigator.pop(context, union);
                                } else {
                                      final unionName = op.unionList[index].bnName ?? "";
                                final unionID = op.unionList[index].id;
                                final union = UnionModel(id: unionID!, name: unionName);
                                Navigator.pop(context, union);
                                }
                               
                              },
                              child: ListTile(
                                title: Text(
                                widget.isDlcActivity ? '${op.unionList[index].name}' : '${op.unionList[index].bnName}',
                                  // style: GoogleFonts.chakraPetch(
                                  //   fontWeight: FontWeight.w800,
                                  //   fontSize: 12,
                                  // ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                      //         : Center(
                      //             child: Container(
                      //                 margin: const EdgeInsets.only(top: 150),
                      //                 child: const Text(
                      //                   'No Data Found or Please Check Your Internet Connection',
                      //                   textAlign: TextAlign.center,
                      //                   style: const TextStyle(
                      //                     fontWeight: FontWeight.w500,
                      //                   ),
                      //                 )))
                      //     : Expanded(child: Text('no Data'))
                      // : SizedBox(
                      //     height: MediaQuery.of(context).size.height * .2,
                      //     child: Center(
                      //       child: CircularProgressIndicator(
                      //         valueColor: AlwaysStoppedAnimation<Color>(MyColors.primaryColor),
                      //       ),
                      //     ),
                      //   ),
                    ],
                  );
                },
              ));
        },
      ),
    );
  }
}

class LeUpazilaDialog extends StatefulWidget {
  
  const LeUpazilaDialog({
    Key? key,

  }) : super(key: key);

  @override
  State<LeUpazilaDialog> createState() => _LeUpazilaDialogState();
}

class _LeUpazilaDialogState extends State<LeUpazilaDialog> {
  final searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      alignment: Alignment.center,
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FittedBox(
            child: Text(
            'উপজেলাগুলো তালিকা',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 15),
              // style: GoogleFonts.chakraPetch(
              //   fontWeight: FontWeight.w600,
              // ),
            ),
          ),
        ],
      ),
      actions: [
        const Divider(
          thickness: 2,
        ),
        Center(
          child: CloseButton(
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
      ],
      // insetPadding: EdgeInsets.zero,
      contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),

      // contentPadding: EdgeInsets.all(45.0),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(18.0))),
      content: Builder(
        builder: (context) {
          var height = MediaQuery.of(context).size.height;
          var width = MediaQuery.of(context).size.width;
          return Container(
              height: height / 2,
              width: width,
              //color: Colors.white,
              child: Consumer<OperationProvider>(
                builder: (context, op, child) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: TextField(
                          controller: searchController,
                          //style: robotoRegular.copyWith(color: Colors.black87, fontSize: 16),
                          decoration: InputDecoration(
                              hintText:  'উপজেলা খুজুন',
                              focusColor: Colors.green,
                              contentPadding: EdgeInsets.symmetric(vertical: 18, horizontal: 22),
                              // suffixIcon: ap.isCustomerSearch
                              //     ? IconButton(
                              //         onPressed: () {
                              //           searchController.text = '';
                              //           //ap.searchCustomer('');
                              //         },
                              //         icon: Icon(
                              //           Icons.close,
                              //           color: Colors.red,
                              //         ))
                              //     : Icon(
                              //         Icons.search,
                              //         color: Colors.black,
                              //       ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  width: 2.0,
                                  color: Colors.green,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0), borderSide: BorderSide(width: 2, color: Color(0xFFFC6A57)))),
                          onChanged: (query) {
                           op.searchUpazillas(query);
                          },
                        ),
                      ),
                      // !op.isLoading
                      //     ? ap.customerList != null
                      //         ? ap.customerList!.isNotEmpty
                      //             ?
                      Expanded(
                        child: Scrollbar(
                          thumbVisibility: true,
                          thickness: 10,
                          radius: const Radius.circular(10),
                          child: ListView.builder(
                            itemCount: op.leUpazillaList.length,
                            // padding: const EdgeInsets.all(
                            //   Dimensions.PADDING_SIZE_DEFAULT,
                            // ),
                            physics: const BouncingScrollPhysics(),
                            itemBuilder: (context, index) => InkWell(
                              onTap: () {
                             
                                      final upaName = op.leUpazillaList[index].bnName ?? "";
                                final upaiD = op.leUpazillaList[index].id;
                                final upazila = UnionModel(id: upaiD!, name: upaName);
                                Navigator.pop(context, upazila);
                                
                               
                              },
                              child: ListTile(
                                title: Text(
                              '${op.leUpazillaList[index].bnName}',
                                  // style: GoogleFonts.chakraPetch(
                                  //   fontWeight: FontWeight.w800,
                                  //   fontSize: 12,
                                  // ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                      //         : Center(
                      //             child: Container(
                      //                 margin: const EdgeInsets.only(top: 150),
                      //                 child: const Text(
                      //                   'No Data Found or Please Check Your Internet Connection',
                      //                   textAlign: TextAlign.center,
                      //                   style: const TextStyle(
                      //                     fontWeight: FontWeight.w500,
                      //                   ),
                      //                 )))
                      //     : Expanded(child: Text('no Data'))
                      // : SizedBox(
                      //     height: MediaQuery.of(context).size.height * .2,
                      //     child: Center(
                      //       child: CircularProgressIndicator(
                      //         valueColor: AlwaysStoppedAnimation<Color>(MyColors.primaryColor),
                      //       ),
                      //     ),
                      //   ),
                    ],
                  );
                },
              ));
        },
      ),
    );
  }
}

import 'dart:developer';

import 'package:dphe/Data/models/common_models/dlc_model/beneficiary_model.dart';
import 'package:dphe/Data/models/common_models/union_model.dart';
import 'package:dphe/components/custom_appbar/custom_appbar_inner.dart';
import 'package:dphe/components/custom_buttons/custom_button_rounded.dart';
import 'package:dphe/components/custom_dropdown/union_dialog.dart';
import 'package:dphe/components/custom_loader/custom_loader.dart';
import 'package:dphe/provider/operation_provider.dart';
import 'package:dphe/screens/users/le/custom_widgets/le_dashboard_details_card.dart';
import 'package:dphe/components/custom_dropdown/union_dropdown.dart';
import 'package:dphe/components/custom_dropdown/upazila_dropdown.dart';
import 'package:dphe/provider/le_providers/le_dashboard_provider.dart';
import 'package:dphe/utils/app_colors.dart';
import 'package:dphe/utils/common_functions.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';
import '../../../../components/text_input_filed/custom_search_field.dart';
import '../../../../utils/app_constant.dart';
import '../../../../utils/local_storage_manager.dart';

class DashboardDetails extends StatefulWidget {
  final String title;
  final List statusIdList;
  const DashboardDetails({super.key, required this.title, required this.statusIdList});

  @override
  State<DashboardDetails> createState() => _DashboardDetailsState();
}

class _DashboardDetailsState extends State<DashboardDetails> {
  final ScrollController _scrollController = ScrollController();
  final searchController = TextEditingController();
  final PagingController<int, BeneficiaryDetailsData> _pagingController = PagingController(firstPageKey: 0);
  // PaginationScrollController paginationScrollController =
  //     PaginationScrollController();
  int currentPageNo = 1;
  int userDistrictId = -1;
  int? upazilaID;
  String? leUpazilaName;
  int selectedUpazilaId = -10;
  int selectedUnionId = -10;
  bool isLoadingMore = false;
  String unionname = '';
  bool unionDropdownLoading = false;
  int? wardNo;
  int? unionID;
  String? unionValue;
  bool isunionWardLoading = false;
  @override
  void initState() {
    // TODO: implement initState
    // Provider.of<LeDashboardProvider>(context, listen: false).nonSelectedBeneficiaryList.clear();

    super.initState();
    fetchData();
    _scrollController.addListener(() {
      if (_scrollController.position.maxScrollExtent == _scrollController.offset) {
        fetchData();
      }
    });

    // refreshData();
  }

  fetchData() async {
    final op = Provider.of<OperationProvider>(context, listen: false);
    final lep = Provider.of<LeDashboardProvider>(context, listen: false);
    await lep.fetchNonSelectedPaginatedLeBenf(
      statusIdList: widget.statusIdList,
      upazilaId: upazilaID,
      unionId: unionID,
      wardNo: wardNo,
      op: op,
      searchQuery: searchController.text
    );
  }

  Future refreshPaginatedData() async {
    final le = Provider.of<LeDashboardProvider>(context, listen: false);
    le.lePaginatedRefresh();
    await fetchData();
  }

  // Future<void> paginationM(int pageKey) async {
  //   //_fetchPage(pageKey);
  //   final lep = Provider.of<LeDashboardProvider>(context, listen: false);
  //   lep.nonSelectedBeneficiaryList.clear();

  //   await lep.getNonSelectedBeneficiaryList(
  //     statusIdList: widget.statusIdList,
  //     unionId: unionID,
  //     wardNo: wardNo,
  //     upazilaId: upazilaID,
  //     pageNo: pageKey,
  //     rows: 15,
  //   );

  //   final isLastPage = lep.nonSelectedBeneficiaryList.length < lep.totalData;
  //   if (isLastPage) {
  //     _pagingController.appendLastPage(lep.nonSelectedBeneficiaryList);
  //   } else {
  //     final nextPageKey = pageKey + 1;
  //     _pagingController.appendPage(lep.nonSelectedBeneficiaryList, nextPageKey);
  //   }
  // }

  // void checkUserInfo() async {
  //   // upazilaID = await LocalStorageManager.readData(AppConstant.userUpazilaId);
  //   // log('user upazilla ID $upazilaID');
  //   userDistrictId = await LocalStorageManager.readData(AppConstant.userDistrictId) ?? -10;
  //   // if (userDistrictId != -10) {
  //   //   Provider.of<LeDashboardProvider>(context, listen: false).getUpazilaList(districtId: userDistrictId);
  //   // }
  // }

  loadMoreData() {
    setState(() {
      Provider.of<LeDashboardProvider>(context, listen: false).nonSelectedBeneficiaryList.clear();
    });
    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {

    // Provider.of<LeDashboardProvider>(context, listen: false).getNonSelectedBeneficiaryList(
    //  statusIdList: widget.statusIdList,
    //  unionId: unionID,
    //  wardNo: wardNo,
    //  upazilaId: upazilaID,
    //  // pageNo: currentPageNo,
    //  // rows: 13,
    //     );

    // });
    // setState(() {
    //   isLoadingMore = false;
    // });
    print("currentPageNo $currentPageNo");
  }

  refreshData() {
    setState(() {
      Provider.of<LeDashboardProvider>(context, listen: false).nonSelectedBeneficiaryList.clear();
    });
    Provider.of<LeDashboardProvider>(context, listen: false).getNonSelectedBeneficiaryList(
      statusIdList: widget.statusIdList,
      upazilaId: upazilaID,
      unionId: unionID,
      wardNo: wardNo,
      // pageNo: 1,
      // rows: 15,
    );
  }

  getUpazilaData() {
    Provider.of<OperationProvider>(context, listen: false).getUpazillasFromUser();
  }

  @override
  Widget build(BuildContext context) {
    getUpazilaData();
//refreshData();
    //WidgetsBinding.instance.addPostFrameCallback((timeStamp) {

    //});
    // Provider.of<LeDashboardProvider>(context, listen: false).getNonSelectedBeneficiaryList(
    //     statusIdList: widget.statusIdList, upazilaId: upazilaID, unionId: unionID, wardNo: wardNo, pageNo: 1, rows: 15);
    // _pagingController.addPageRequestListener((pageKey) {
    //   paginationM(pageKey);
    // });
    return Consumer2<LeDashboardProvider, OperationProvider>(builder: (context, controller, op, child) {
      //  _pagingController.addPageRequestListener((pageKey) {
      //     paginationM(pageKey);
      //   });
      return GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Scaffold(
          backgroundColor: MyColors.backgroundColor,
          appBar: CustomAppbarInner(
            title: widget.title,
          ),
          // floatingActionButton: IconButton(
          //     onPressed: () {
          //       // Provider.of<LeDashboardProvider>(context, listen: false).nonSelectedBeneficiaryList.clear();
          //       Provider.of<LeDashboardProvider>(context, listen: false).getNonSelectedBeneficiaryList(
          //         statusIdList: widget.statusIdList,
          //         unionId: unionID ?? -10,
          //         wardNo: wardNo,
          //         pageNo: 1,
          //       );
          //     },
          //     icon: const Icon(Icons.refresh)),
          body: RefreshIndicator(
            onRefresh: () async {
              await refreshPaginatedData();

              // Future.sync(() => _pagingController.refresh());
              // await Provider.of<LeDashboardProvider>(context, listen: false).getNonSelectedBeneficiaryList(
              //   statusIdList: widget.statusIdList,
              //   upazilaId: upazilaID,
              //   unionId: unionID,
              //   wardNo: wardNo,
              //   // pageNo: 1,
              //   // rows: 15,
              // );
            },
            child: Stack(
              children: [
                ListView(),
                Column(
                  children: [
                    // const SizedBox(
                    //   height: 15,
                    // ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Flexible(
                            child: InkWell(
                              onTap: () async {
                                setState(() {
                                  upazilaID = null;
                                  leUpazilaName = null;
                                });
                                // controller.clearNonSelectedLEBenfList();
                                setState(() {
                                  unionID = null;
                                  unionname = '';
                                  wardNo = null;
                                });
                                final upazilla = await showDialog(
                                  context: context,
                                  builder: (context) {
                                    return LeUpazilaDialog();
                                  },
                                );
                                if (upazilla != null && upazilla is UnionModel) {
                                  setState(() {
                                    leUpazilaName = upazilla.name;
                                    if (upazilla.id == 0) {
                                      upazilaID = null;
                                    } else {
                                      upazilaID = upazilla.id;
                                    }
                                  });
                                  await refreshPaginatedData();
                                  // await controller.getNonSelectedBeneficiaryList(
                                  //   statusIdList: widget.statusIdList,
                                  //   upazilaId: upazilaID,
                                  //   unionId: unionID,
                                  //   wardNo: wardNo,
                                  //   // pageNo: 1,
                                  //   // rows: 15,
                                  // );
                                }
                              },
                              child: Container(
                                height: 50,
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                    color: Colors.grey,
                                  ),
                                  borderRadius: BorderRadius.circular(
                                    5,
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: FittedBox(
                                        fit: BoxFit.scaleDown,
                                        child: Text(
                                          leUpazilaName == null ? 'উপজেলা' : leUpazilaName!,
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500,
                                            //  fontSize: 10
                                          ),
                                        ),
                                      ),
                                    ),
                                    Icon(Icons.arrow_drop_down, color: Colors.grey)
                                  ],
                                ),
                              ),
                            ),
                          ),
                          unionDropdownLoading
                              ? Expanded(child: CustomLoader())
                              : Flexible(
                                  child: InkWell(
                                    onTap: () async {
                                      setState(() {
                                        unionDropdownLoading = true;
                                      });
                                      await op.getUnionListFromApi(upazillaID: upazilaID ?? -1);
                                      setState(() {
                                        unionDropdownLoading = false;
                                      });
                                      if (mounted) {
                                        final union = await showDialog(
                                          context: context,
                                          builder: (context) {
                                            return UnionDialog();
                                          },
                                        );
                                        if (union != null && union is UnionModel) {
                                          setState(() {
                                            unionname = union.name;
                                            if (union.id == 0) {
                                              unionID = null;
                                              wardNo = null;
                                            } else {
                                              unionID = union.id;
                                            }
                                          });
                                          await refreshPaginatedData();
                                          // await controller.getNonSelectedBeneficiaryList(
                                          //   statusIdList: widget.statusIdList,
                                          //   upazilaId: upazilaID,
                                          //   unionId: unionID,
                                          //   wardNo: wardNo,
                                          //   // pageNo: 1,
                                          //   // rows: 15,
                                          // );
                                        }
                                      }
                                    },
                                    child: Container(
                                      height: 50,
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                                      margin: const EdgeInsets.symmetric(
                                        horizontal: 4,
                                      ),
                                      // padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(
                                          color: Colors.grey,
                                        ),
                                        borderRadius: BorderRadius.circular(
                                          5,
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: FittedBox(
                                              fit: BoxFit.scaleDown,
                                              child: Text(
                                                unionname.isEmpty ? 'ইউনিয়ন' : unionname,
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w500,
                                                  //fontSize: 14,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Icon(Icons.arrow_drop_down, color: Colors.grey)
                                        ],
                                      ),
                                    ),
                                  ),
                                ),

                          Flexible(
                            child: Container(
                                height: 50,
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                    color: Colors.grey,
                                  ),
                                  borderRadius: BorderRadius.circular(
                                    5,
                                  ),
                                ),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButtonFormField(
                                    value: wardNo,
                                    isExpanded: true,
                                    hint: Text(
                                      'ওয়ার্ড',
                                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 14),
                                    ),
                                    decoration: InputDecoration(
                                      enabledBorder: InputBorder.none,
                                      focusedBorder: InputBorder.none,
                                    ),
                                    items: op.wardDropdown
                                        .map((e) => DropdownMenuItem(
                                              value: e,
                                              onTap: () async {
                                                setState(() {
                                                  if (e != AppConstant.allward) {
                                                    wardNo = e as int;
                                                  } else {
                                                    wardNo = null;
                                                  }
                                                });
                                                print('ward no $wardNo');
                                                await refreshPaginatedData();
                                                // await controller.getNonSelectedBeneficiaryList(
                                                //   statusIdList: widget.statusIdList,
                                                //   upazilaId: upazilaID,
                                                //   unionId: unionID,
                                                //   wardNo: wardNo,
                                                //   // pageNo: 1,
                                                //   // rows: 15,
                                                // );
                                              },
                                              child: Padding(
                                                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                                child: Text(
                                                  e != AppConstant.allward ? CommonFunctions.convertNumberToBangla(e.toString()) : e,
                                                  style: TextStyle(color: Colors.black),
                                                ),
                                              ),
                                            ))
                                        .toList(),
                                    onChanged: unionID == null
                                        ? null
                                        : (value) {
                                            setState(() {
                                              if (value != AppConstant.allward) {
                                                wardNo = value as int;
                                              } else {
                                                wardNo = null;
                                              }
                                            });
                                          },
                                  ),
                                )
                                // child: Row(
                                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                //   children: [
                                //     Text(
                                //       'Ward',
                                //       style: TextStyle(color: Colors.grey),
                                //     ),
                                //     Icon(Icons.arrow_drop_down, color: Colors.grey)
                                //   ],
                                // ),
                                ),
                          ),
                          // Expanded(
                          //   child: UnionDropdown(
                          //       hintText: "ইউনিয়ন",
                          //       itemList: controller.unionList,
                          //       callBackFunction: (value) {
                          //         print(value.id);
                          //         setState(() {
                          //           selectedUnionId = value.id;
                          //         });
                          //       }),
                          // ),
                        ],
                      ),
                    ),
                    // const SizedBox(
                    //   height: 15,
                    // ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: searchController,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                          hintText: 'নাম/মোবাইল/এনআইডি',
                          hintStyle: TextStyle(color: Colors.black45),
                          filled: true,
                          fillColor: Colors.white,
                          suffixIcon: IconButton(onPressed: (){
                            refreshPaginatedData();
                          }, icon: Icon(Icons.search)),

                          // suffix: IconButton(onPressed: (){

                          // }, icon: Icon(Icons.search)),
                          
                          // suffixIcon: op.isSearching
                          //     ? IconButton(
                          //         onPressed: () {
                          //           setState(() {
                          //             searchController.clear();
                          //           });
                          //           op.stopSearching();
                          //         },
                          //         icon: Icon(Icons.clear))
                          //     : Icon(Icons.search),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: BorderSide(
                              width: 1.0,
                              color: Colors.black,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: BorderSide(
                              width: 1.0,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        onChanged: (value) {
                          if (value.isEmpty) {
                            refreshPaginatedData();
                          }
                          // setState(() {
                          //     controller.nonSelectedBeneficiaryList.clear();
                          //   });
                          // if (value.isNotEmpty) {
                          //   refreshPaginatedData();
                          //   // refreshData();
                          //   // controller.getNonSelectedBeneficiaryList(
                          //   //   statusIdList: widget.statusIdList,
                          //   //   upazilaId: upazilaID,
                          //   //   unionId: unionID,
                          //   //   wardNo: wardNo,
                          //   //   searchQuery: value,
                          //   // );
                          // } else {
                          //   refreshPaginatedData();
                          //   // controller.clearNonSelBenf();
                          //   //  await controller.getNonSelectedBeneficiaryList(
                          //   //   statusIdList: widget.statusIdList,
                          //   //   upazilaId: upazilaID,
                          //   //   unionId: unionID,
                          //   //   wardNo: wardNo,
                          //   //   //searchQuery: value,
                          //   // );
                          // }
                        },
                         onSubmitted: (value) {
                           refreshPaginatedData();
                          
                        },
                      ),
                    ),
                    // CustomSearchFieldWidget(
                    //   searchController: searchController,
                    //   hintText: 'নাম/মোবাইল/এনআইডি',
                    //   onchanged: (text) {
                    //     if (text.isEmpty) {
                    //       op.stopSearching();
                    //        controller.getNonSelectedBeneficiaryList(
                    //           statusIdList: widget.statusIdList,
                    //           upazilaId: upazilaID,
                    //           unionId: unionID,
                    //           wardNo: wardNo,
                    //           searchQuery: searchController.text
                    //           // pageNo: 1,
                    //           // rows: 15,
                    //           );
                    //     } else {
                    //       op.startSearching();
                    //     }
                    //     if (op.isConnected) {

                    //       controller.getNonSelectedBeneficiaryList(
                    //           statusIdList: widget.statusIdList,
                    //           upazilaId: upazilaID,
                    //           unionId: unionID,
                    //           wardNo: wardNo,
                    //           searchQuery: searchController.text
                    //           // pageNo: 1,
                    //           // rows: 15,
                    //           );
                    //       // op.getBeneficiaryList(
                    //       //   distID: widget.distID,
                    //       //   upazilaID: widget.upaID,
                    //       //   isSearch: true,
                    //       //   phoneOrLe: val,
                    //       //   statusID: statusID,
                    //       // );
                    //     } else {
                    //       //op.searchLocalBenfData(val);
                    //     }
                    //   },
                    // ),
                    // isunionWardLoading
                    //     ? CircularProgressIndicator()
                    //     : Padding(
                    //         padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    //         child: CustomButtonRounded(
                    //           title: "খুঁজুন",
                    //           onPress: () async {
                    //             setState(() {
                    //               isunionWardLoading = true;
                    //             });
                    //             Provider.of<LeDashboardProvider>(context, listen: false).nonSelectedBeneficiaryList.clear();
                    //             currentPageNo = 1;
                    //             // _pagingController.addPageRequestListener((pageKey) {
                    //             //   paginationM(pageKey);
                    //             // });
                    //             // paginationM();
                    //             WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                    //               Provider.of<LeDashboardProvider>(context, listen: false).getNonSelectedBeneficiaryList(
                    //                 statusIdList: widget.statusIdList,
                    //                 upazilaId: upazilaID,
                    //                 unionId: unionID,
                    //                 wardNo: wardNo,
                    //                 //rows: 3,

                    //                 // unionId: selectedUnionId,
                    //                 //  pageNo: currentPageNo,
                    //               );
                    //             });
                    //             setState(() {
                    //               isunionWardLoading = false;
                    //             });
                    //           },
                    //         ),
                    //       ),
                    const SizedBox(
                      height: 15,
                    ),
                    // if (controller.isLeBenfLoading)
                    //   Expanded(
                    //       child: Center(
                    //     child: CircularProgressIndicator(),
                    //   ))
                    //else if (controller.nonSelectedBeneficiaryList.isNotEmpty)
                    Expanded(
                      child: Container(
                        color: MyColors.customWhite,
                        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
                        child: ListView.builder(
                            physics: AlwaysScrollableScrollPhysics(),
                            itemCount: controller.nonSelectedBeneficiaryList.length + 1,
                            controller: _scrollController,
                            itemBuilder: (BuildContext context, int index) {
                              if (index < controller.nonSelectedBeneficiaryList.length) {
                                return LeDashboardDetailsCard(
                                  index: index,
                                  beneficiary: controller.nonSelectedBeneficiaryList[index],
                                  isNetworkConnected: controller.networkConnected,
                                );
                              } else if (controller.hasMore) {
                                return Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                );
                              } else if (index == 0) {
                                return Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Center(
                                    child: Text("কিছুই পাওয়া যায়নি !"),
                                  ),
                                );
                              } else {
                                 return Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Center(
                                    child: Text(""),
                                  ),
                                );
                              }
                            }),
                      ),
                    )
                    // else
                    //   const Center(child: Text("কিছুই পাওয়া যায়নি !"))
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}

import 'package:dphe/components/common_widgets/common_widgets.dart';
import 'package:dphe/components/custom_buttons/custom_button_rounded.dart';
import 'package:dphe/components/text_input_filed/custom_input_suffix.dart';
import 'package:dphe/provider/hive_provider.dart';
import 'package:dphe/provider/operation_provider.dart';
import 'package:dphe/screens/users/dlc/dlc_hhs_verification/dlc_verification_page.dart';
import 'package:dphe/screens/users/dlc/dlc_widget/dlc_verify_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';

import '../../../../Data/models/common_models/dlc_model/beneficiary_model.dart';
import '../../../../Data/models/common_models/union_model.dart';
import '../../../../components/custom_dropdown/union_dialog.dart';
import '../../../../components/text_input_filed/custom_search_field.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_constant.dart';
import '../../../../utils/common_functions.dart';
import '../../../../utils/custom_text_style.dart';
import '../dlc_dashboard/dlc_dashboard_page.dart';

class TwinPitLatrineLePage extends StatefulWidget {
  final String upazilaName;
  final int upaID;
  final int distID;
  const TwinPitLatrineLePage({super.key, required this.upazilaName, required this.upaID, required this.distID});

  @override
  State<TwinPitLatrineLePage> createState() => _TwinPitLatrineLePageState();
}

class _TwinPitLatrineLePageState extends State<TwinPitLatrineLePage> {
  final scrollController = ScrollController();
  int selectedTabIndex = 0;
  int statusID = 1;
  bool isload = false;
  String unionname = '';
  bool isunionLoading = false;

  int? unionID;

  int? wardNo;
  @override
  void initState() {
    super.initState();
    getQuestions();
    fetchData();
    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent == scrollController.offset) {
        fetchData();
      }
    });
    //getData();
  }
  

  getQuestions() {
    final op = Provider.of<OperationProvider>(context, listen: false);
    final local = Provider.of<LocalStoreHiveProvider>(context, listen: false);
    //SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
    op.getDlcQuestionsForPhysicalVerify(local, op);
    // });
  }

  fetchData() async {
    final op = Provider.of<OperationProvider>(context, listen: false);
    final local = Provider.of<LocalStoreHiveProvider>(context, listen: false);

    await op.fetchPaginatedBenfData(
        distID: widget.distID,
        upazilaID: widget.upaID,
        // isSearch: false,
        statusID: statusID,
        unionId: unionID,
        wardNo: wardNo,
        phoneOrLe: searchController.text,
        local: local);
  }

  Future refreshPaginatedData() async {
    final op = Provider.of<OperationProvider>(context, listen: false);
    op.paginatedRefresh();
    await fetchData();
  }

  getData() async {
    final op = Provider.of<OperationProvider>(context, listen: false);

    final local = Provider.of<LocalStoreHiveProvider>(context, listen: false);
    if (op.isConnected) {
      // if (op.fromLocalData) {
      //    op.getLocalPhverData(local: local);
      // } else {

      await op.getBeneficiaryList(
        distID: widget.distID,
        upazilaID: widget.upaID,
        isSearch: false,
        statusID: statusID,
        unionId: unionID,
        wardNo: wardNo,
        local: local,
      );
      // }
    } else {
      
      // op.getLocalPhverData(
      //   local: local,
      //   upaID: widget.upaID,
      // );
    }

    // await op.getBeneficiaryList(distID: widget.distID, upazilaID: widget.upaID, isSearch: false, statusID: statusID, local: local);
    // op.storeDraftedDataInLocal(local: local);
  }

  fromLocalDb() {
    final op = Provider.of<OperationProvider>(context, listen: false);

    final local = Provider.of<LocalStoreHiveProvider>(context, listen: false);
    if (!op.isConnected) {
      op.getLocalPhverData(
        local: local,
        upaID: widget.upaID,
      );
    } else {
      return;
    }
  }
  // @override
  // void didChangeDependencies() {

  //   // TODO: implement didChangeDependencies
  //   super.didChangeDependencies();
  //   getData();

  // }
  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  final searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    //getQuestions();
    //fromLocalDb();
    // Provider.of<OperationProvider>(context,listen: false).getBeneficiaryList(
    //     distID: widget.distID,
    //     upazilaID: widget.upaID,
    //     isSearch: false,
    //     statusID: statusID,
    //     unionId: unionID,
    //     wardNo: wardNo,
    //     local: Provider.of<LocalStoreHiveProvider>(context, listen: false),
    // );
    print('working physical verification');
    final size = MediaQuery.of(context).size;
    //  WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    //   getData();
    //  });
    //getData();
    return SafeArea(
      child: Consumer2<OperationProvider, LocalStoreHiveProvider>(builder: (context, op, local, child) {
        // getData();
        return GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
            print('Hello world');
          },
          child: Scaffold(
            backgroundColor: Colors.white,
            // appBar: AppBar(
            //   backgroundColor: Color.fromARGB(255, 191, 222, 247),
            //   elevation: 0,
            //   title: Text('Twin Pit Latrine $upazilaName',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),
            // ),
            body: RefreshIndicator(
              onRefresh: () async {
                await refreshPaginatedData();
              },
              child: Stack(
                children: [
                  ListView(),
                  Column(children: [
                    //  op.isBackUpComplete ? Text('data'):SizedBox.shrink(),
                    Container(
                      // height: size.height / 6,
                      decoration: BoxDecoration(color: Color.fromARGB(255, 230, 239, 247)),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              BackButton(
                                onPressed: () => Navigator.pop(context),
                              ),
                              Expanded(
                                child: Text(
                                  'HHs Verification : ${widget.upazilaName} Upazila',
                                  style: TextStyle(fontFamily: AppConstant.roboto, fontWeight: FontWeight.bold, fontSize: 16),
                                ),
                              ),
                              IconButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => DlcDashBoardPage(),
                                        ));
                                  },
                                  icon: Icon(Icons.home))
                            ],
                          ),

                          Row(
                            children: [
                              Expanded(
                                child: !op.isConnected
                                    ? Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                                        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                                        decoration: BoxDecoration(
                                          color: Colors.white54,
                                          borderRadius: BorderRadius.circular(
                                            5,
                                          ),
                                        ),
                                        child: Text(
                                          'Union',
                                          style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w500),
                                        ),
                                      )
                                    : InkWell(
                                        onTap: () async {
                                          setState(() {
                                            isunionLoading = true;
                                          });
                                          await op.getUnionListFromApi(upazillaID: widget.upaID);
                                          setState(() {
                                            isunionLoading = false;
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
                                                  // wardNo = null;
                                                } else {
                                                  unionID = union.id;
                                                }
                                              });
                                              refreshPaginatedData();
                                              // await fetchData();
                                              //await getData();
                                            }
                                          }
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                                          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            border: Border.all(
                                              color: Colors.black45,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              5,
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              unionname.isEmpty
                                                  ? Text(
                                                      'Union', //'ইউনিয়ন',
                                                      style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w500),
                                                    )
                                                  : Text(
                                                      unionname,
                                                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
                                                    ),
                                              unionname.isEmpty
                                                  ? Icon(Icons.arrow_drop_down, color: Colors.black)
                                                  : isunionLoading
                                                      ? SizedBox(
                                                          height: 20,
                                                          width: 20,
                                                          child: CircularProgressIndicator(
                                                            color: Colors.black,
                                                          ))
                                                      : InkWell(
                                                          onTap: () async {
                                                            setState(() {
                                                              unionID = null;
                                                              unionname = '';
                                                              wardNo = null;
                                                            });
                                                            refreshPaginatedData();
                                                            //await getData();
                                                          },
                                                          child: Icon(Icons.clear, color: Colors.black))
                                            ],
                                          ),
                                        ),
                                      ),
                              ),
                              !op.isConnected
                                  ? Expanded(
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                                        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                                        decoration: BoxDecoration(
                                          color: Colors.white54,
                                          borderRadius: BorderRadius.circular(
                                            5,
                                          ),
                                        ),
                                        child: Text(
                                          'Ward',
                                          style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                    )
                                  : Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.only(right: 8.0),
                                        child: Container(
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
                                              hint: Padding(
                                                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                                child: Text(
                                                  'Ward', //'ওয়ার্ড',
                                                  style: TextStyle(
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                              ),
                                              iconEnabledColor: Colors.black,
                                              decoration: InputDecoration(
                                                // hintText: textControllers[formItem.cid]?.text ?? '',
                                                enabledBorder: InputBorder.none,
                                                focusedBorder: InputBorder.none,
                                              ),
                                              items: op.wardDropdown
                                                  .map((e) => DropdownMenuItem(
                                                        value: e,
                                                        onTap: () async {
                                                          // refreshPaginatedData();
                                                          //await getData();
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
                                                          wardNo = value as int?;
                                                        } else {
                                                          wardNo = null;
                                                        }
                                                      });
                                                      refreshPaginatedData();
                                                    },
                                            ),
                                          ),
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
                                    ),
                              // Padding(
                              //   padding: const EdgeInsets.only(right: 8.0),
                              //   child: CircleAvatar(
                              //     backgroundColor: Colors.white,
                              //     child: IconButton(
                              //         onPressed: () async {
                              //           await op.getBeneficiaryList(
                              //             distID: widget.distID,
                              //             upazilaID: widget.upaID,
                              //             isSearch: false,
                              //             statusID: statusID,
                              //             unionId: unionID,
                              //             wardNo: wardNo,
                              //             local: local,
                              //           );
                              //         },
                              //         icon: Icon(Icons.search)),
                              //   ),
                              // )
                              // IconButton(onPressed: (){

                              // }, icon: Icon(Icons.search))
                            ],
                          ),
                          // Align(
                          //   alignment: Alignment.bottomRight,
                          //   child: ElevatedButton(
                          //     child: Text(
                          //       'Filter',
                          //     ),
                          //     onPressed: () {},
                          //   ),
                          // ),
                          // Padding(
                          //   padding: const EdgeInsets.symmetric(horizontal: 10),
                          //   child: CustomButtonRounded(width: MediaQuery.of(context).size.width ,height: 50,onPress: (){

                          //   }, title: 'Search'),
                          // ),
  Padding(
                      padding: const EdgeInsets.symmetric(horizontal:  8.0,vertical: 8),
                      child: TextField(
                        controller: searchController,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                          hintText: 'Name/Mobile/NID',
                          hintStyle: TextStyle(color: Colors.black45),
                          filled: true,
                          fillColor: Colors.white,
                      
                          // suffix: IconButton(onPressed: (){
                      
                          // }, icon: Icon(Icons.search)),
                          suffixIcon: IconButton(
                              onPressed: () {
                                refreshPaginatedData();
                                //searchController.clear();
                                //op.stopSearching();
                              },
                              icon: Icon(Icons.search)),
                          // : Icon(Icons.search),
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
                        onSubmitted: (value) {
                           refreshPaginatedData();
                          
                        },
                        onChanged: (value) {
                          if (value.isEmpty) {
                            refreshPaginatedData();
                          }
                        },
                      ),
                    ),
                          // CustomSearchFieldWidget(
                          //   searchController: searchController,
                          //   hintText: 'Name/Mobile/NID',
                          //   onchanged: (val) {
                          //     if (op.isConnected) {
                          //       if (val.isNotEmpty) {
                          //         refreshPaginatedData();
                          //       } else {
                          //         refreshPaginatedData();
                          //       }

                          //       //   fetchData();
                          //       // op.getBeneficiaryList(
                          //       //   distID: widget.distID,
                          //       //   upazilaID: widget.upaID,
                          //       //   isSearch: true,
                          //       //   phoneOrLe: val,
                          //       //   statusID: statusID,
                          //       // );
                          //     } else {
                          //      // op.searchBenfListData(val);
                          //     }
                          //   },
                          // ),

                          //CustomTextInputFieldSuffix(controller: searchController, textInputType: TextInputType.text, hintText: 'LE Name/Mobile No')
                        ],
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          newCustomTab(
                            index: 0,
                            selectedIndex: selectedTabIndex,
                            title: 'Drafted',
                            onTap: op.isPaginatedLoading
                                ? null
                                : () async {
                                    setState(() {
                                      searchController.clear();
                                      selectedTabIndex = 0;
                                      statusID = 1;
                                    });
                                    await refreshPaginatedData();
                                  },
                          ),
                          !op.isConnected
                              ? Text(
                                  'Verified',
                                  style: TextStyle(color: Colors.grey),
                                )
                              : newCustomTab(
                                  index: 1,
                                  selectedIndex: selectedTabIndex,
                                  title: 'Verified',
                                  onTap: op.isPaginatedLoading
                                      ? null
                                      : () async {
                                          setState(() {
                                            searchController.clear();
                                            selectedTabIndex = 1;
                                            statusID = 2;
                                          });
                                          await refreshPaginatedData();
                                        },
                                ),
                          !op.isConnected
                              ? Text(
                                  'Rejected',
                                  style: TextStyle(color: Colors.grey),
                                )
                              : newCustomTab(
                                  index: 2,
                                  selectedIndex: selectedTabIndex,
                                  title: 'Rejected',
                                  onTap: op.isPaginatedLoading
                                      ? null
                                      : () async {
                                          setState(() {
                                            searchController.clear();
                                            selectedTabIndex = 2;
                                            statusID = 3;
                                          });
                                          await refreshPaginatedData();
                                        },
                                ),
                        ],
                      ),
                    ),
                    // Divider(),
                    // Stack(
                    //     children: [
                    //       Divider(color: Colors.black,),
                    //        SizedBox(width: 40,child: Divider(color: Colors.green,)),
                    //     ],
                    //   ),
                    //working change
                    // op.isConnected
                    //     ? !op.fromLocalData
                    //         ? op.isBenficiaryLoading
                    //             ? Expanded(
                    //                 child: Center(
                    //                     child: CircularProgressIndicator(
                    //                 color: Colors.blue,
                    //               )))
                    //             : op.beneficiaryList.isEmpty
                    //                 ? Expanded(
                    //                     child: Center(
                    //                     child: Text('No Data Available'),
                    //                   ))
                    //                 : benfList(op)
                    //         : localbenfList(op)
                    //     : localbenfList(op)
                    //working change
                    //  op.beneficiaryList.isEmpty ? Expanded(
                    //   child: Center(child: Text('No Data Available'),),
                    //  ) :
                    Expanded(
                        child: ListView.builder(
                      controller: scrollController,
                      physics: AlwaysScrollableScrollPhysics(),
                      itemCount: op.beneficiaryList.length + 1,
                      itemBuilder: (context, index) {
                        if (index < op.beneficiaryList.length) {
                          var benficiaryData = op.beneficiaryList[index];
                          return InkWell(
                            onTap: () async {
                              if (statusID == 1) {
                                // await op.getDlcQuestionsForPhysicalVerify(local, op);
                                if (mounted) {
                                  Navigator.push(context, MaterialPageRoute(
                                    builder: (context) {
                                      return DlcVerificationPage(
                                        beneficiaryData: benficiaryData!,
                                      );
                                    },
                                  ));
                                }

                                //vif (context.mounted) await op.getSendBackList(id: widget.benfData!.id!, context: context);
                              } else {
                                null;
                              }

                              // ?
                              // : null;
                            },
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              margin: const EdgeInsets.symmetric(horizontal: 9, vertical: 8),
                              decoration: BoxDecoration(
                                color: MyColors.cardBackgroundColor,
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(color: MyColors.customGreyLight, width: 1),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                          child: Row(
                                        children: [
                                          Text(
                                            '${benficiaryData?.sl ?? ''}. ',
                                            style: MyTextStyle.robotoHeadline(fontSize: 17),
                                          ),
                                          Text(
                                            benficiaryData?.name ?? "Unknown name",
                                            overflow: TextOverflow.ellipsis,
                                            style: MyTextStyle.robotoHeadline(fontSize: 17),
                                          ),
                                        ],
                                      )),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 5),
                                    child: RichText(
                                      text: TextSpan(
                                          text: "Mobile : ",
                                          style: MyTextStyle.robotoHeadline(fontWeight: FontWeight.w600, fontSize: 16),
                                          children: [
                                            TextSpan(
                                              text: '${benficiaryData?.phone ?? 000000}',
                                              style: MyTextStyle.robotoHeadline(fontWeight: FontWeight.w400, fontSize: 16),
                                            )
                                          ]),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 5),
                                    child: RichText(
                                      text: TextSpan(
                                          text: "NID : ",
                                          style: MyTextStyle.robotoHeadline(fontWeight: FontWeight.w600, fontSize: 16),
                                          children: [
                                            TextSpan(
                                              text: '${benficiaryData?.nid ?? 000000}',
                                              style: MyTextStyle.robotoHeadline(fontWeight: FontWeight.w400, fontSize: 16),
                                            )
                                          ]),
                                    ),
                                  ),
                                  // Text(
                                  //     "Mobile : ${benficiaryData?.phone ?? 000000}",
                                  //  style: MyTextStyle.robotoHeadline(fontWeight: FontWeight.w500, fontSize: 17),
                                  //     // style: MyTextStyle.primaryLight(fontSize: 14),
                                  //   ),
                                  // Text(
                                  //   "NID : ${benficiaryData?.nid ?? 000000}",
                                  //   style: MyTextStyle.robotoHeadline(fontWeight: FontWeight.w500, fontSize: 17),
                                  // ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                                    child: RichText(
                                        text: TextSpan(
                                            text: 'Address: ',
                                            style: TextStyle(
                                                fontFamily: AppConstant.roboto, fontWeight: FontWeight.w600, color: Colors.black, fontSize: 18),
                                            children: [
                                          TextSpan(
                                              style: TextStyle(
                                                  fontFamily: AppConstant.roboto, fontWeight: FontWeight.w400, color: Colors.black, fontSize: 17),
                                              children: [
                                                TextSpan(
                                                  text: '${benficiaryData?.houseName ?? ''}, ',
                                                  style: TextStyle(
                                                      fontFamily: AppConstant.roboto, fontWeight: FontWeight.w400, color: Colors.black, fontSize: 18),
                                                ),
                                              ]),
                                          TextSpan(
                                              text: 'Ward: ',
                                              style: TextStyle(
                                                  fontFamily: AppConstant.roboto, fontWeight: FontWeight.w400, color: Colors.black, fontSize: 17),
                                              children: [
                                                TextSpan(
                                                  text: '${benficiaryData?.wardNo ?? ''}, ',
                                                  style: TextStyle(
                                                      fontFamily: AppConstant.roboto, fontWeight: FontWeight.w400, color: Colors.black, fontSize: 17),
                                                ),
                                              ]),
                                          TextSpan(
                                              style: TextStyle(
                                                  fontFamily: AppConstant.roboto, fontWeight: FontWeight.w400, color: Colors.black, fontSize: 17),
                                              children: [
                                                TextSpan(
                                                  text: '${benficiaryData?.union?.name ?? ''}, ',
                                                  style: TextStyle(
                                                      fontFamily: AppConstant.roboto, fontWeight: FontWeight.w400, color: Colors.black, fontSize: 17),
                                                ),
                                              ]),
                                          TextSpan(
                                              style: TextStyle(
                                                  fontFamily: AppConstant.roboto, fontWeight: FontWeight.w400, color: Colors.black, fontSize: 17),
                                              children: [
                                                TextSpan(
                                                  text: '${benficiaryData?.upazila?.name}, ',
                                                  style: TextStyle(
                                                      fontFamily: AppConstant.roboto, fontWeight: FontWeight.w400, color: Colors.black, fontSize: 17),
                                                ),
                                              ]),
                                          TextSpan(
                                            style: TextStyle(
                                                fontFamily: AppConstant.roboto, fontWeight: FontWeight.w400, color: Colors.black, fontSize: 17),
                                            children: [
                                              TextSpan(
                                                text: '${benficiaryData?.district?.name} ',
                                                style: TextStyle(
                                                    fontFamily: AppConstant.roboto, fontWeight: FontWeight.w400, color: Colors.black, fontSize: 17),
                                              ),
                                            ],
                                          ),
                                        ])),
                                  )
                                  // Wrap(
                                  //   // alignment: WrapAlignment.start,
                                  //   direction: Axis.horizontal,

                                  //   children: [
                                  //     AddressCardTextWidget(
                                  //       title: 'Address :',
                                  //     ),
                                  //     AddressCardTextWidget(
                                  //       title: 'District :',
                                  //     ),
                                  //     AddressCardTextWidget(
                                  //       title: '${benficiaryData?.district?.name},',
                                  //     ),
                                  //     AddressCardTextWidget(
                                  //       title: 'Upazila :',
                                  //     ),
                                  //     AddressCardTextWidget(
                                  //       title: '${benficiaryData?.upazila?.name},',
                                  //     ),
                                  //     AddressCardTextWidget(title: 'Union :'),
                                  //     AddressCardTextWidget(title: '${benficiaryData?.union?.name ?? ''},'),
                                  //     AddressCardTextWidget(title: 'Ward :'),
                                  //     AddressCardTextWidget(title: '${benficiaryData?.wardNo ?? ''},'),
                                  //     AddressCardTextWidget(title: 'House :'),
                                  //     AddressCardTextWidget(title: '${benficiaryData?.houseName ?? ''}')
                                  //   ],
                                  // )
                                  //Divider(),
                                ],
                              ),
                            ),
                          );
                        } else if (op.hasMore) {
                          return Padding(
                            padding: const EdgeInsets.all(8),
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          );
                        } else if (index == 0) {
                          return Container(
                            height: MediaQuery.of(context).size.height / 2,
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: Center(
                                child: Text('No Data Available to show'),
                              ),
                            ),
                          );
                        } else {
                          return Padding(
                            padding: const EdgeInsets.all(8),
                            child: Center(
                              child: Text(''),
                            ),
                          );
                        }
                      },
                    ))
                    // : Expanded(
                    //     child: ListView.builder(
                    //     itemCount: op.beneficiaryList.length,
                    //     itemBuilder: (context, index) {
                    //       var benficiaryData = op.beneficiaryList[index];
                    //       return InkWell(
                    //         onTap: () {
                    //           statusID == 1
                    //               ? Navigator.push(context, MaterialPageRoute(
                    //                   builder: (context) {
                    //                     return DlcVerificationPage(
                    //                       beneficiaryData: benficiaryData!,
                    //                     );
                    //                   },
                    //                 ))
                    //               : null;
                    //         },
                    //         child: Container(
                    //           padding: const EdgeInsets.all(10),
                    //           margin: const EdgeInsets.symmetric(horizontal: 9, vertical: 8),
                    //           decoration: BoxDecoration(
                    //             color: MyColors.cardBackgroundColor,
                    //             borderRadius: BorderRadius.circular(5),
                    //             border: Border.all(color: MyColors.customGreyLight, width: 1),
                    //           ),
                    //           child: Column(
                    //             crossAxisAlignment: CrossAxisAlignment.start,
                    //             children: [
                    //               Row(
                    //                 children: [
                    //                   Expanded(
                    //                       child: Text(
                    //                     benficiaryData?.name ?? "Unknown name",
                    //                     style: MyTextStyle.primaryBold(fontSize: 15),
                    //                   )),
                    //                   Text(
                    //                     "Mobile : ${benficiaryData?.phone ?? 000000}",
                    //                     style: MyTextStyle.primaryLight(fontSize: 9),
                    //                   ),
                    //                 ],
                    //               ),
                    //               const SizedBox(
                    //                 height: 5,
                    //               ),
                    //               Text(
                    //                 "NID : ${benficiaryData?.nid ?? 000000}",
                    //                 style: MyTextStyle.primaryLight(fontSize: 10),
                    //               ),
                    //               const SizedBox(
                    //                 height: 8,
                    //               ),
                    //               Wrap(
                    //                 // alignment: WrapAlignment.start,
                    //                 direction: Axis.horizontal,

                    //                 children: [
                    //                   AddressCardTextWidget(
                    //                     title: 'Address :',
                    //                   ),
                    //                   AddressCardTextWidget(
                    //                     title: 'District :',
                    //                   ),
                    //                   AddressCardTextWidget(
                    //                     title: '${benficiaryData?.district?.name},',
                    //                   ),
                    //                   AddressCardTextWidget(
                    //                     title: 'Upazila :',
                    //                   ),
                    //                   AddressCardTextWidget(
                    //                     title: '${benficiaryData?.upazila?.name},',
                    //                   ),
                    //                   AddressCardTextWidget(title: 'Union :'),
                    //                   AddressCardTextWidget(title: '${benficiaryData?.union?.name ?? ''}'),
                    //                   AddressCardTextWidget(title: 'House :'),
                    //                   AddressCardTextWidget(title: '${benficiaryData?.houseName ?? ''}')
                    //                 ],
                    //               )
                    //               //Divider(),
                    //             ],
                    //           ),
                    //         ),
                    //       );
                    //     },
                    //   ))
                  ]),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget benfList(OperationProvider opm) {
    return opm.isBenficiaryLoading
        ? Expanded(
            child: Center(
            child: CircularProgressIndicator(),
          ))
        : Expanded(
            child: ListView.builder(
            itemCount: opm.beneficiaryList.length,
            itemBuilder: (context, index) {
              var benficiaryData = opm.beneficiaryList[index];
              return InkWell(
                onTap: () {
                  statusID == 1
                      ? Navigator.push(context, MaterialPageRoute(
                          builder: (context) {
                            return DlcVerificationPage(
                              beneficiaryData: benficiaryData!,
                            );
                          },
                        ))
                      : null;
                },
                child: Container(
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.symmetric(horizontal: 9, vertical: 8),
                  decoration: BoxDecoration(
                    color: MyColors.cardBackgroundColor,
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(color: MyColors.customGreyLight, width: 1),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                              child: Row(
                            children: [
                              Text(
                                '${index + 1}. ',
                                style: MyTextStyle.robotoHeadline(fontSize: 17),
                              ),
                              Text(
                                benficiaryData?.name ?? "Unknown name",
                                overflow: TextOverflow.ellipsis,
                                style: MyTextStyle.robotoHeadline(fontSize: 17),
                              ),
                            ],
                          )),
                        ],
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: RichText(
                          text: TextSpan(text: "Mobile : ", style: MyTextStyle.robotoHeadline(fontWeight: FontWeight.w600, fontSize: 16), children: [
                            TextSpan(
                              text: '${benficiaryData?.phone ?? 000000}',
                              style: MyTextStyle.robotoHeadline(fontWeight: FontWeight.w400, fontSize: 16),
                            )
                          ]),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: RichText(
                          text: TextSpan(text: "NID : ", style: MyTextStyle.robotoHeadline(fontWeight: FontWeight.w600, fontSize: 16), children: [
                            TextSpan(
                              text: '${benficiaryData?.nid ?? 000000}',
                              style: MyTextStyle.robotoHeadline(fontWeight: FontWeight.w400, fontSize: 16),
                            )
                          ]),
                        ),
                      ),
                      // Text(
                      //     "Mobile : ${benficiaryData?.phone ?? 000000}",
                      //  style: MyTextStyle.robotoHeadline(fontWeight: FontWeight.w500, fontSize: 17),
                      //     // style: MyTextStyle.primaryLight(fontSize: 14),
                      //   ),
                      // Text(
                      //   "NID : ${benficiaryData?.nid ?? 000000}",
                      //   style: MyTextStyle.robotoHeadline(fontWeight: FontWeight.w500, fontSize: 17),
                      // ),
                      const SizedBox(
                        height: 8,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: RichText(
                            text: TextSpan(
                                text: 'Address: ',
                                style: TextStyle(fontFamily: AppConstant.roboto, fontWeight: FontWeight.w600, color: Colors.black, fontSize: 18),
                                children: [
                              TextSpan(
                                  style: TextStyle(fontFamily: AppConstant.roboto, fontWeight: FontWeight.w400, color: Colors.black, fontSize: 17),
                                  children: [
                                    TextSpan(
                                      text: '${benficiaryData?.houseName ?? ''}, ',
                                      style:
                                          TextStyle(fontFamily: AppConstant.roboto, fontWeight: FontWeight.w400, color: Colors.black, fontSize: 18),
                                    ),
                                  ]),
                              TextSpan(
                                  text: 'Ward: ',
                                  style: TextStyle(fontFamily: AppConstant.roboto, fontWeight: FontWeight.w400, color: Colors.black, fontSize: 17),
                                  children: [
                                    TextSpan(
                                      text: '${benficiaryData?.wardNo ?? ''}, ',
                                      style:
                                          TextStyle(fontFamily: AppConstant.roboto, fontWeight: FontWeight.w400, color: Colors.black, fontSize: 17),
                                    ),
                                  ]),
                              TextSpan(
                                  style: TextStyle(fontFamily: AppConstant.roboto, fontWeight: FontWeight.w400, color: Colors.black, fontSize: 17),
                                  children: [
                                    TextSpan(
                                      text: '${benficiaryData?.union?.name ?? ''}, ',
                                      style:
                                          TextStyle(fontFamily: AppConstant.roboto, fontWeight: FontWeight.w400, color: Colors.black, fontSize: 17),
                                    ),
                                  ]),
                              TextSpan(
                                  style: TextStyle(fontFamily: AppConstant.roboto, fontWeight: FontWeight.w400, color: Colors.black, fontSize: 17),
                                  children: [
                                    TextSpan(
                                      text: '${benficiaryData?.upazila?.name}, ',
                                      style:
                                          TextStyle(fontFamily: AppConstant.roboto, fontWeight: FontWeight.w400, color: Colors.black, fontSize: 17),
                                    ),
                                  ]),
                              TextSpan(
                                style: TextStyle(fontFamily: AppConstant.roboto, fontWeight: FontWeight.w400, color: Colors.black, fontSize: 17),
                                children: [
                                  TextSpan(
                                    text: '${benficiaryData?.district?.name} ',
                                    style: TextStyle(fontFamily: AppConstant.roboto, fontWeight: FontWeight.w400, color: Colors.black, fontSize: 17),
                                  ),
                                ],
                              ),
                            ])),
                      )
                      // Wrap(
                      //   // alignment: WrapAlignment.start,
                      //   direction: Axis.horizontal,

                      //   children: [
                      //     AddressCardTextWidget(
                      //       title: 'Address :',
                      //     ),
                      //     AddressCardTextWidget(
                      //       title: 'District :',
                      //     ),
                      //     AddressCardTextWidget(
                      //       title: '${benficiaryData?.district?.name},',
                      //     ),
                      //     AddressCardTextWidget(
                      //       title: 'Upazila :',
                      //     ),
                      //     AddressCardTextWidget(
                      //       title: '${benficiaryData?.upazila?.name},',
                      //     ),
                      //     AddressCardTextWidget(title: 'Union :'),
                      //     AddressCardTextWidget(title: '${benficiaryData?.union?.name ?? ''},'),
                      //     AddressCardTextWidget(title: 'Ward :'),
                      //     AddressCardTextWidget(title: '${benficiaryData?.wardNo ?? ''},'),
                      //     AddressCardTextWidget(title: 'House :'),
                      //     AddressCardTextWidget(title: '${benficiaryData?.houseName ?? ''}')
                      //   ],
                      // )
                      //Divider(),
                    ],
                  ),
                ),
              );
            },
          ));
  }

  Widget localbenfList(OperationProvider opm) {
    return Expanded(
        child: ListView.builder(
      itemCount: opm.localBenficiaryList.length,
      itemBuilder: (context, index) {
        var benficiaryData = opm.localBenficiaryList[index];
        return InkWell(
          onTap: () {
            statusID == 1
                ? Navigator.push(context, MaterialPageRoute(
                    builder: (context) {
                      return DlcVerificationPage(
                        localBenfData: benficiaryData,
                      );
                    },
                  ))
                : null;
          },
          child: Container(
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.symmetric(horizontal: 9, vertical: 8),
            decoration: BoxDecoration(
              color: MyColors.cardBackgroundColor,
              borderRadius: BorderRadius.circular(5),
              border: Border.all(color: MyColors.customGreyLight, width: 1),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                        child: Row(
                      children: [
                        Text(
                          '${index + 1}. ',
                          style: MyTextStyle.robotoHeadline(fontSize: 17),
                        ),
                        Text(
                          benficiaryData.benfName ?? "Unknown name",
                          overflow: TextOverflow.ellipsis,
                          style: MyTextStyle.robotoHeadline(fontSize: 17),
                        ),
                      ],
                    )),
                  ],
                ),
                const SizedBox(
                  height: 8,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: RichText(
                    text: TextSpan(text: "Mobile : ", style: MyTextStyle.robotoHeadline(fontWeight: FontWeight.w600, fontSize: 16), children: [
                      TextSpan(
                        text: '${benficiaryData.benfMobileNo ?? 000000}',
                        style: MyTextStyle.robotoHeadline(fontWeight: FontWeight.w400, fontSize: 16),
                      )
                    ]),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: RichText(
                    text: TextSpan(text: "NID : ", style: MyTextStyle.robotoHeadline(fontWeight: FontWeight.w600, fontSize: 16), children: [
                      TextSpan(
                        text: '${benficiaryData.benfNID ?? 000000}',
                        style: MyTextStyle.robotoHeadline(fontWeight: FontWeight.w400, fontSize: 16),
                      )
                    ]),
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: RichText(
                      text: TextSpan(
                          text: 'Address: ',
                          style: TextStyle(fontFamily: AppConstant.roboto, fontWeight: FontWeight.w600, color: Colors.black, fontSize: 18),
                          children: [
                        TextSpan(
                            style: TextStyle(fontFamily: AppConstant.roboto, fontWeight: FontWeight.w400, color: Colors.black, fontSize: 17),
                            children: [
                              TextSpan(
                                text: '${benficiaryData.benfHouse ?? ''}, ',
                                style: TextStyle(fontFamily: AppConstant.roboto, fontWeight: FontWeight.w400, color: Colors.black, fontSize: 18),
                              ),
                            ]),
                        // TextSpan(
                        //     text: 'Ward: ',
                        //     style: TextStyle(fontFamily: AppConstant.roboto, fontWeight: FontWeight.w400, color: Colors.black, fontSize: 17),
                        //     children: [
                        //       TextSpan(
                        //         text: '${benficiaryData. ?? ''}, ',
                        //         style:
                        //             TextStyle(fontFamily: AppConstant.roboto, fontWeight: FontWeight.w400, color: Colors.black, fontSize: 17),
                        //       ),
                        //     ]),
                        TextSpan(
                            style: TextStyle(fontFamily: AppConstant.roboto, fontWeight: FontWeight.w400, color: Colors.black, fontSize: 17),
                            children: [
                              TextSpan(
                                text: '${benficiaryData.unionName ?? ''}, ',
                                style: TextStyle(fontFamily: AppConstant.roboto, fontWeight: FontWeight.w400, color: Colors.black, fontSize: 17),
                              ),
                            ]),
                        TextSpan(
                            style: TextStyle(fontFamily: AppConstant.roboto, fontWeight: FontWeight.w400, color: Colors.black, fontSize: 17),
                            children: [
                              TextSpan(
                                text: '${benficiaryData.upazillaName}, ',
                                style: TextStyle(fontFamily: AppConstant.roboto, fontWeight: FontWeight.w400, color: Colors.black, fontSize: 17),
                              ),
                            ]),
                        TextSpan(
                          style: TextStyle(fontFamily: AppConstant.roboto, fontWeight: FontWeight.w400, color: Colors.black, fontSize: 17),
                          children: [
                            TextSpan(
                              text: '${benficiaryData.districtName} ',
                              style: TextStyle(fontFamily: AppConstant.roboto, fontWeight: FontWeight.w400, color: Colors.black, fontSize: 17),
                            ),
                          ],
                        ),
                      ])),
                )
                // Wrap(
                //   // alignment: WrapAlignment.start,
                //   direction: Axis.horizontal,

                //   children: [
                //     AddressCardTextWidget(
                //       title: 'Address :',
                //     ),
                //     AddressCardTextWidget(
                //       title: 'District :',
                //     ),
                //     AddressCardTextWidget(
                //       title: '${benficiaryData?.districtName},',
                //     ),
                //     AddressCardTextWidget(
                //       title: 'Upazila :',
                //     ),
                //     AddressCardTextWidget(
                //       title: '${benficiaryData.upazillaName},',
                //     ),
                //     AddressCardTextWidget(title: 'Union :'),
                //     AddressCardTextWidget(title: '${benficiaryData?.unionName ?? ''}'),
                //     AddressCardTextWidget(title: 'House :'),
                //     AddressCardTextWidget(title: '${benficiaryData?.benfHouse ?? ''}')
                //   ],
                // )
                //Divider(),
              ],
            ),
          ),
        );
      },
    ));
  }
}

class AddressCardTextWidget extends StatelessWidget {
  final String title;

  const AddressCardTextWidget({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: MyTextStyle.robotoHeadline(fontWeight: FontWeight.w500, fontSize: 17),
    );
  }
}

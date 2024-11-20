import 'package:dphe/Data/models/common_models/dlc_model/le_data_model.dart';
import 'package:dphe/Data/models/common_models/union_model.dart';
import 'package:dphe/components/custom_dropdown/union_dialog.dart';
import 'package:dphe/components/text_input_filed/custom_search_field.dart';
import 'package:dphe/provider/hive_provider.dart';
import 'package:dphe/provider/operation_provider.dart';
import 'package:dphe/screens/users/dlc/dlc_dashboard/dlc_dashboard_page.dart';
import 'package:dphe/screens/users/dlc/dlc_hhs_verification/twin_pit_le.dart';
import 'package:dphe/screens/users/dlc/dlc_latrine_verification/dlcverified_data_screen.dart';
import 'package:dphe/utils/app_colors.dart';
import 'package:dphe/utils/app_constant.dart';
import 'package:dphe/utils/common_functions.dart';
import 'package:dphe/utils/custom_text_style.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NewDlcBeneficiaryPage extends StatefulWidget {
  final int upaID;
  final int distID;
  final String upazilaName;
  const NewDlcBeneficiaryPage({super.key, required this.upaID, required this.distID, required this.upazilaName});

  @override
  State<NewDlcBeneficiaryPage> createState() => _NewDlcBeneficiaryPageState();
}

class _NewDlcBeneficiaryPageState extends State<NewDlcBeneficiaryPage> {
  late PageController pendingForVerifyPageController;
  int? unionID;
  int statusID = 11;

  int? wardNo;
  String unionname = '';
  StswiseLeData? leList;
  bool isunionLoading = false;
  final searchController = TextEditingController();
  final scrollController = ScrollController();
  fetchData() async {
    final op = Provider.of<OperationProvider>(context, listen: false);
    final local = Provider.of<LocalStoreHiveProvider>(context, listen: false);

    await op.fetchPaginatedBenfData(
        distID: widget.distID,
        upazilaID: widget.upaID,
        // isSearch: false,
        statusID: op.statusID, //statusID,
        unionId: unionID,
        wardNo: wardNo,
        isSendBack: op.isSendBack,
        phoneOrLe: searchController.text,
        local: local,
        leid: leList?.le!.id!);
  }

  Future refreshPaginatedData() async {
    final op = Provider.of<OperationProvider>(context, listen: false);
    //searchController.clear();
    op.paginatedRefresh();
    await fetchData();
  }

  getLEData() async {
    await Provider.of<OperationProvider>(context, listen: false)
        .getLeForLatrineVerification(distID: widget.distID, upazilaID: widget.upaID, statusID: statusID);
  }

  @override
  void initState() {
    pendingForVerifyPageController = PageController(initialPage: 0);
    super.initState();
    getLEData();
    fetchData();
    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent == scrollController.offset) {
        fetchData();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<OperationProvider>(builder: (context, op, child) {
      return Scaffold(
        body: SafeArea(
          child: Column(
            children: [
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
                            'HHs Verification : ${widget.upazilaName} Upazila', //widget.upazilaName
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
                    Container(
                      // height: 80,
                      //width: MediaQuery.of(context).size.width ,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                      ),
                      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(
                          5,
                        ),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButtonFormField<StswiseLeData>(
                          isExpanded: true,
                          value: leList,
                          decoration: InputDecoration(
                            hintText: 'Select LE',
                            // label: Text('LE'),
                            // hintText: textControllers[formItem.cid]?.text ?? '',
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                          ),
                          items: op.leListForLatrineVerification
                              .map((e) => DropdownMenuItem(
                                  value: e,
                                  child: Text(
                                    e!.le!.name!,
                                  )))
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              leList = null;
                              leList = value;
                            });
                            refreshPaginatedData();
                          },
                        ),
                      ),
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
                    //     if (val.isEmpty) {
                    //       refreshPaginatedData();

                    //     }else{
                    //       refreshPaginatedData();
                    //       //fetchData();
                    //     }
                    //      //refreshPaginatedData();
                    //     //if (op.isConnected) {
                    //       // if (val.isNotEmpty) {
                    //       //   refreshPaginatedData();
                    //       // } else {
                    //       //   refreshPaginatedData();
                    //       // }

                    //       //   fetchData();
                    //       // op.getBeneficiaryList(
                    //       //   distID: widget.distID,
                    //       //   upazilaID: widget.upaID,
                    //       //   isSearch: true,
                    //       //   phoneOrLe: val,
                    //       //   statusID: statusID,
                    //       // );
                    //     // } else {
                    //     //   op.searchBenfListData(val);
                    //     // }
                    //   },
                    // ),
                    Row(
                      //mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        TextButton(
                            style: TextButton.styleFrom(
                                //foregroundColor: Colors.black,
                                // textStyle: TextStyle(fontWeight: FontWeight.w500,fontSize: 18)
                                ),
                            onPressed: () {
                              op.setLatrinVerfTab(val: 0);
                              op.selectDlcStatusID(value: 11);
                              op.changeIsSendBackSts(value: null);
                              // setState(() {
                              //   statusID = 11;
                              // });
                              refreshPaginatedData();
                              // setState(() {
                              //   selectedTabColor = 0;
                              // });
                              // pendingForVerifyPageController.animateToPage(
                              //   0,
                              //   duration: Duration(milliseconds: 500),
                              //   curve: Curves.easeInOut,
                              // );
                            },
                            child: Text(
                              'Pending',
                              style: TextStyle(color: op.initialLvtab == 0 ? Colors.green : Colors.black, fontSize: 17),
                            )),
                        TextButton(
                            onPressed: () {
                              op.setLatrinVerfTab(val: 1);
                              op.selectDlcStatusID(value: 12);
                              op.changeIsSendBackSts(value: null);

                              refreshPaginatedData();
                              // setState(() {
                              //   selectedTabColor = 1;
                              // });
                              // pendingForVerifyPageController.animateToPage(
                              //   1,
                              //   duration: Duration(milliseconds: 500),
                              //   curve: Curves.easeInOut,
                              // );
                            },
                            child: Text('Verified', style: TextStyle(color: op.initialLvtab == 1 ? Colors.green : Colors.black, fontSize: 17))),
                        TextButton(
                            onPressed: () {
                              op.setLatrinVerfTab(val: 2);
                              op.changeIsSendBackSts(value: 1);
                              // setState(() {
                              //   statusID = 10;
                              // });
                              op.selectDlcStatusID(value: 10);
                              refreshPaginatedData();
                              // setState(() {
                              //   selectedTabColor = 2;
                              // });
                              // pendingForVerifyPageController.animateToPage(
                              //   2,
                              //   duration: Duration(milliseconds: 500),
                              //   curve: Curves.easeInOut,
                              // );
                            },
                            child: Text('Send Back', style: TextStyle(color: op.initialLvtab == 2 ? Colors.green : Colors.black, fontSize: 17))),
                      ],
                    ),

                    //CustomTextInputFieldSuffix(controller: searchController, textInputType: TextInputType.text, hintText: 'LE Name/Mobile No')
                  ],
                ),
              ),
              Expanded(
                  child: ListView.builder(
                physics: AlwaysScrollableScrollPhysics(),
                itemCount: op.beneficiaryList.length + 1,
                controller: scrollController,
                itemBuilder: (context, index) {
                  // var item = op.beneficiaryList[index];
                  if (index < op.beneficiaryList.length) {
                    return InkWell(
                      onTap: op.statusID == 12 || op.statusID == 10
                          ? null
                          : () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => LatrineVerifyQuestionDataScreen(
                                    distID: widget.distID,
                                    upaID: widget.upaID,
                                    benfData: op.beneficiaryList[index],
                                    // pageController: widget.pageController,
                                  ),
                                ),
                              );
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
                                  child: Text(
                                    '${index + 1}. ${op.beneficiaryList[index]?.name}' ?? "Unknown name",
                                    style: MyTextStyle.primaryBold(fontSize: 18),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    "Mobile :  ${op.beneficiaryList[index]?.phone ?? ''}",
                                    style: MyTextStyle.robotoHeadline(fontWeight: FontWeight.w500, fontSize: 16),
                                    // style: MyTextStyle.primaryLight(fontSize: 9),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              "NID :${op.beneficiaryList[index]?.nid ?? ''}",
                              style: MyTextStyle.robotoHeadline(fontWeight: FontWeight.w500, fontSize: 16),
                              //style: MyTextStyle.primaryLight(fontSize: 10),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Wrap(
                              // alignment: WrapAlignment.start,
                              direction: Axis.horizontal,

                              children: [
                                AddressCardTextWidget(
                                  title: 'Address :',
                                ),
                                AddressCardTextWidget(
                                  title: 'District :',
                                ),
                                AddressCardTextWidget(
                                  title: '${op.beneficiaryList[index]?.district?.name},',
                                ),
                                AddressCardTextWidget(
                                  title: 'Upazila :',
                                ),
                                AddressCardTextWidget(
                                  title: '${op.beneficiaryList[index]?.upazila?.name},',
                                ),
                                AddressCardTextWidget(title: 'Union :'),
                                AddressCardTextWidget(title: '${op.beneficiaryList[index]?.union?.name ?? ''} ,'),
                                AddressCardTextWidget(title: 'Ward :'),
                                AddressCardTextWidget(title: '${op.beneficiaryList[index]?.wardNo ?? ''}')
                              ],
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: [
                                Text(
                                  'LE :',
                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                                ),
                                Expanded(
                                    child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                  child: Text(
                                    op.beneficiaryList[index]?.le!.name ?? '',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ))
                              ],
                            ),
                            op.statusID == 12
                                ? Align(
                                    alignment: Alignment.bottomRight,
                                    child: Text(
                                      'Verified',
                                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
                                    ))
                                : op.statusID == 10
                                    ? Align(
                                        alignment: Alignment.bottomRight,
                                        child: Text(
                                          'Send Back',
                                          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
                                        ))
                                    : op.statusID == 11
                                        ? Align(
                                            alignment: Alignment.bottomRight,
                                            child: Text(
                                              'Pending',
                                              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
                                            ))
                                        : SizedBox.shrink()

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
                },
              )),
            ],
          ),
        ),
      );
    });
  }
}

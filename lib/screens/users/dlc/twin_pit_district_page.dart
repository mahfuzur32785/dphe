import 'package:dphe/Data/models/auth_models/new_user_data_model.dart';
import 'package:dphe/components/custom_appbar/custom_appbar.dart';
import 'package:dphe/provider/operation_provider.dart';
import 'package:dphe/screens/users/dlc/twin_pit_upazila_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyDistrictPage extends StatefulWidget {
  final bool isHcpVerificationPage;
  final bool isHcpForwardPage;
  final bool isLatrineVerification;
  final bool isOtherActivity;
  final bool isReporting;
  const MyDistrictPage(
      {super.key,
      required this.isHcpVerificationPage,
      required this.isHcpForwardPage,
      required this.isLatrineVerification,
      required this.isOtherActivity,
      required this.isReporting});

  @override
  State<MyDistrictPage> createState() => _MyDistrictPageState();
}

class _MyDistrictPageState extends State<MyDistrictPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //getDist();
  }

  getDist() {
    final op = Provider.of<OperationProvider>(context, listen: false);
    op.getDistrictListFromUser();
  }

  @override
  Widget build(BuildContext context) {
    print('is Report ${widget.isReporting}');
    getDist();
    return Consumer<OperationProvider>(builder: (context, op, child) {
      return Scaffold(
        appBar: CustomAppbar(
          title: 'My Districts',
          isDistPage: true,
        ),
        body: Column(
          children: [
            Expanded(
                child: ListView.builder(
              itemCount: op.districtsList.length,
              itemBuilder: (context, index) {
                var dist = op.districtsList[index];
                return InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MyUpazila(
                            distID: dist.id!,
                            distName: dist.name!,
                            isHcpForwardPage: widget.isHcpForwardPage,
                            isHcpVerificationPage: widget.isHcpVerificationPage,
                            isLatrineVerification: widget.isLatrineVerification,
                            isOtherActivity: widget.isOtherActivity,
                            isReportingPage: widget.isReporting,
                          ),
                        ));
                  },
                  child: DistUpazilaCard(dist: dist.name!),
                );
              },
            ))
          ],
        ),
      );
    });
  }
}

class DistUpazilaCard extends StatelessWidget {
  const DistUpazilaCard({
    super.key,
    required this.dist,
  });

  final String dist;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 18),
      decoration: BoxDecoration(border: Border.all(color: Colors.blue), borderRadius: BorderRadius.circular(4)),
      child: Center(
          child: Text(
        dist,
        style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 16),
      )),
    );
  }
}

import 'package:dphe/provider/operation_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomSearchFieldWidget extends StatelessWidget {
  const CustomSearchFieldWidget({
    super.key,
    required this.searchController,
    required this.onchanged,
    required this.hintText,
  });

  final TextEditingController searchController;
  final String? Function(String) onchanged;
  final String hintText;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 8),
      child: Consumer<OperationProvider>(builder: (context, op, child) {
        return TextField(
          controller: searchController,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
            hintText: hintText,
            hintStyle: TextStyle(color: Colors.black45),
            filled: true,
            fillColor: Colors.white,
           
            // suffix: IconButton(onPressed: (){

            // }, icon: Icon(Icons.search)),
            suffixIcon: op.isSearching
                ? IconButton(
                    onPressed: () {
                      searchController.clear();
                      op.stopSearching();
                    },
                    icon: Icon(Icons.clear))
                : Icon(Icons.search),
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
          onChanged: onchanged,
        );
      }),
    );
  }
}

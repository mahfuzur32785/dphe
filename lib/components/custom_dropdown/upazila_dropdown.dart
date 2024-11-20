import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import '../../Data/models/common_models/upazila_dropdown_model.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_constant.dart';
import '../../utils/app_strings.dart';
import '../../utils/custom_text_style.dart';

class UpazilaDropdown extends StatefulWidget {
  final String? hintText;
  final DropdownUpazila? selectedItem;
  final List<DropdownUpazila> itemList;
  final Function? callBackFunction;
  const UpazilaDropdown(
      {Key? key,
        required this.hintText,
        this.selectedItem,
        required this.itemList,
        required this.callBackFunction})
      : super(key: key);

  @override
  State<UpazilaDropdown> createState() => _UpazilaDropdownState();
}

class _UpazilaDropdownState extends State<UpazilaDropdown> {
  TextEditingController searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    ///Menu Mode with no searchBox MultiSelection
    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: Colors.white),
          borderRadius: BorderRadius.circular(7)),
      child: DropdownSearch<DropdownUpazila>(
        //validator: (v) => v == null ? "required field" : null,
        validator: (value) {
          if (value != null) {
            return null;
          } else {
            return AppStrings.requiredField;
          }

          return null;
        },
        dropdownDecoratorProps: DropDownDecoratorProps(
          dropdownSearchDecoration: InputDecoration(
            //labelText: widget.labelText,
            suffixIconColor: MyColors.customGrey,
            //prefixIcon: const Icon(Icons.person),
            prefixIconColor: MyColors.customGrey,
            iconColor: MyColors.customGrey,
            hintText: widget.hintText,
            hintMaxLines: 1,
            hintStyle: const TextStyle(
                color: MyColors.customGrey,
                fontFamily: AppConstant.kalpurush,
                fontSize: 14),
            //labelText: "Menu mode *",
            contentPadding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(7),
                borderSide: const BorderSide(color: Colors.white)),
          ), //new 2
        ),
        popupProps: PopupProps.dialog(
            dialogProps: DialogProps(),
            showSearchBox: true,
            showSelectedItems: true,
            itemBuilder: _customPopupItemBuilderExample),
        clearButtonProps:
        const ClearButtonProps(isVisible: false, splashRadius: 20),
        items: widget.itemList,
        onChanged: (value) {
          if (value != null) {
            widget.callBackFunction!(value);
          }
        },
        //  popupItemDisabled: (String? s) => s?.startsWith('I') ?? false,
        selectedItem: widget.selectedItem,
        compareFn: (item, selectedItem) => item.id == selectedItem.id,
        //filterFn: (item, search) => item?.name == search, //'কৃষি',
        // searchFieldProps: TextFieldProps(
        //   controller: searchController,
        // ),
        itemAsString: (item) => item.bnName!,
        dropdownBuilder: _customDropDownExample,
      ),
    );
  }

  Widget _customDropDownExample(BuildContext context, DropdownUpazila? item) {
    if (item == null) {
      return Text(
        widget.hintText!,
        style: MyTextStyle.primaryLight(
            fontColor: MyColors.customGrey,
            fontWeight: FontWeight.normal,
            fontSize: 13),
      );
    }

    return Text(
      item.bnName!,
      style: MyTextStyle.primaryLight(
          fontColor: MyColors.customGrey,
          fontWeight: FontWeight.normal,
          fontSize: 13),
    );
  }

  Widget _customPopupItemBuilderExample(
      BuildContext context, DropdownUpazila? item, bool isSelected) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4.0),
      padding: const EdgeInsets.only(left: 10.0, top: 2.0, bottom: 2.0),
      decoration: !isSelected
          ? null
          : BoxDecoration(
        border: Border.all(color: MyColors.white),
        borderRadius: BorderRadius.circular(7),
        color: Colors.white,
      ),
      child: Text(
        item?.bnName ?? '',
        style: const TextStyle(
          fontFamily: AppConstant.kalpurush,
          color: Colors.black,
        ),
      ),);
  }
}

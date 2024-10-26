import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:gossip_app/utils/colors_const.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

class CommonMultipleDropDownBtn extends StatelessWidget {
  const CommonMultipleDropDownBtn({
    super.key,
    required this.btnText,
    required this.titleValue,
    required this.items,
    this.icon,
    required this.onConfirm,
  });

  final String btnText;
  final String titleValue;
  final List<MultiSelectItem<dynamic?>> items;
  final Icon? icon;
  final Function(List<Object?>) onConfirm;
  @override
  Widget build(BuildContext context) {
    return MultiSelectBottomSheetField(
      initialChildSize: 0.4,
      listType: MultiSelectListType.CHIP,
      searchable: true,
      buttonText: Text(
        btnText,
        style: const TextStyle(
          fontSize: 14,
          color: Colors.black45,
          // fontWeight: FontWeight.bold,
        ),
      ),
      title: Text(
        titleValue,
        style: const TextStyle(
          fontSize: 16,
          color: Colors.black45,
          // fontWeight: FontWeight.bold,
        ),
      ),
      items: items,
      onConfirm: onConfirm,
      chipDisplay: MultiSelectChipDisplay(
        onTap: (value) {},
      ),
      decoration: BoxDecoration(
        color: kDropBackground,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: kPrimaryBoader),
      ),
      buttonIcon: icon,
    );
  }
}

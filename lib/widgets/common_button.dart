import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:gossip_app/utils/colors_const.dart';

class CommonButton extends StatelessWidget {
  const CommonButton({
    super.key,
    required this.onPress,
    required this.buttonName,
    this.backgroundColor,
    this.textColor,
    this.fontSize,
  });
  final Function() onPress;
  final String buttonName;
  final Color? backgroundColor;
  final Color? textColor;
  final double? fontSize;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPress,
      child: Text(
        "${buttonName}",
        style: TextStyle(
          color: textColor ?? kDefTextColor,
          fontSize: fontSize ?? 14,
          fontWeight: FontWeight.bold,
        ),
      ),
      style: ButtonStyle(
        backgroundColor: MaterialStatePropertyAll(
          backgroundColor,
        ),
        shape: MaterialStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(10), // Removes the border radius
            side: BorderSide.none, // Removes the border
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gossip_app/utils/colors_const.dart';
import 'package:provider/provider.dart';

class CommonTextFeild extends StatelessWidget {
  const CommonTextFeild({
    Key? key,
    required this.label,
    required this.hint,
    this.maxLength,
    this.maxLine = 1,
    this.isPassword = false,
    this.controller,
    this.isValidate = false,
    this.color = kDefTextColor,
    this.bordercolor,
    this.backgroundcolor,
    this.fullborder = false,
    this.filled,
    this.suffix,
    this.keyboardType = TextInputType.text,
    this.onChanged,
    this.capitalize = false,
    this.copyText = true,
    this.cutTextText = true,
    this.pasteText = true,
    this.selectAllText = true,
    this.height,
    this.fontSize,
    this.focusNode,
    this.textInputAction,
    this.fullbordercolor,
  }) : super(key: key);

  final String label;
  final String hint;
  final int? maxLength;
  final int? maxLine;
  final bool isPassword;
  final TextEditingController? controller;
  final bool isValidate;
  final Color? color;
  final Color? bordercolor;
  final Color? fullbordercolor;
  final Color? backgroundcolor;
  final bool fullborder;
  final bool? filled;
  final Widget? suffix;
  final TextInputType keyboardType;
  final Function(String)? onChanged;
  final bool capitalize;
  final bool copyText;
  final bool cutTextText;
  final bool pasteText;
  final bool selectAllText;
  final double? height;
  final double? fontSize;
  final FocusNode? focusNode;
  final TextInputAction? textInputAction;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      textInputAction: textInputAction,
      toolbarOptions: ToolbarOptions(
        copy: copyText,
        cut: cutTextText,
        paste: pasteText,
        selectAll: selectAllText,
      ),
      focusNode: focusNode, // Correctly assigning the FocusNode here
      inputFormatters: <TextInputFormatter>[],
      textCapitalization:
          capitalize ? TextCapitalization.characters : TextCapitalization.none,
      controller: controller,
      validator: (text) {
        if (isValidate) {
          if (text == null || text.isEmpty) {
            return '$hint is Required';
          }
          return null;
        }
        return null;
      },
      onChanged: onChanged,
      maxLength: maxLength,
      keyboardType: keyboardType,
      obscureText: isPassword,
      style: TextStyle(
          fontSize: fontSize ?? 14,
          height: height ?? 1.0,
          color: kDefTextColor),
      maxLines: !isPassword ? maxLine : 1,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        hintStyle: TextStyle(color: kDefTextColor),
        labelStyle: TextStyle(color: kDefTextColor),
        filled: filled,
        suffixIcon: suffix,
        fillColor: backgroundcolor ?? kPrimaryBoader,
        enabledBorder: fullborder
            ? OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: fullbordercolor ?? Colors.white,
                ),
              )
            : null,
        errorBorder: fullborder
            ? OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide(color: kErrorMessageColor),
              )
            : null,
        focusedBorder: !fullborder
            ? UnderlineInputBorder(
                borderSide:
                    BorderSide(color: bordercolor ?? color ?? kPrimaryBoader),
              )
            : OutlineInputBorder(
                borderRadius: BorderRadius.circular(15.0),
                borderSide: BorderSide(
                  color: kPrimaryBoader,
                ),
              ),
      ),
    );
  }
}

import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:gossip_app/utils/colors_const.dart';

class CommonDropDown extends StatelessWidget {
  const CommonDropDown({
    super.key,
    required this.jobRoleCtrl,
    required this.hintText,
    required this.items,
    this.onChanged,
    this.padding = 8,
    this.validator,
    this.isRequired = true, // Add the new boolean parameter
  });

  final TextEditingController jobRoleCtrl;
  final String hintText;
  final List<String>? items;
  final dynamic Function(String)? onChanged;
  final double padding;
  final String? Function(String?)? validator;
  final bool isRequired; // New boolean parameter

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(padding),
      child: FormField<String>(
        validator: isRequired
            ? validator ??
                (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select an option';
                  }
                  return null;
                }
            : null, // If isRequired is false, skip validation
        builder: (FormFieldState<String> state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomDropdown(
                fillColor: kDropBackground,
                borderSide: BorderSide(color: kDropboard, width: 1),
                hintStyle: TextStyle(color: kDefTextColor),
                fieldSuffixIcon: Icon(
                  Icons.arrow_drop_down_circle_outlined,
                  color: kiconColor,
                ),
                selectedStyle: TextStyle(color: kDefTextColor),
                hintText: hintText,
                items: items,
                controller: jobRoleCtrl,
                onChanged: (value) {
                  onChanged?.call(value);
                  jobRoleCtrl.text = value; // Update controller's text
                  state.didChange(value); // Notify form of change
                },
              ),
              if (state.hasError)
                Padding(
                  padding: const EdgeInsets.only(top: 5.0),
                  child: Text(
                    state.errorText ?? '',
                    style: TextStyle(color: Colors.red, fontSize: 12),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

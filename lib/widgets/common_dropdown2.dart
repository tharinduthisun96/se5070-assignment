import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CommonDropDownTwo extends StatelessWidget {
  final TextEditingController jobRoleCtrl;
  final String hintText;
  final List<String> items;
  final ValueChanged<String?>? onChanged;

  const CommonDropDownTwo({
    Key? key,
    required this.jobRoleCtrl,
    required this.hintText,
    required this.items,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: jobRoleCtrl.text.isEmpty ? null : jobRoleCtrl.text,
      icon: const FaIcon(
        FontAwesomeIcons.filter,
        color: Colors.black54,
      ),
      decoration: InputDecoration(
        hintText: hintText,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
      ),
      items: items.map((String item) {
        return DropdownMenuItem<String>(
          value: item,
          child: Text(item),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }
}

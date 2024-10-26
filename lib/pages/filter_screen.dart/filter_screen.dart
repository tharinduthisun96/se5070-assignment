import 'package:flutter/material.dart';
import 'package:gossip_app/pages/filter_screen.dart/filter_post_screen.dart';
import 'package:gossip_app/provider/home_provider.dart';
import 'package:gossip_app/utils/main_body.dart';
import 'package:gossip_app/widgets/common_dropdowm.dart';
import 'package:gossip_app/widgets/common_dropdown2.dart';
import 'package:provider/provider.dart';

class FilterScreen extends StatefulWidget {
  const FilterScreen({super.key});

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  late TextEditingController categoryFilterController;

  @override
  void initState() {
    super.initState();
    categoryFilterController = TextEditingController();
  }

  @override
  void dispose() {
    categoryFilterController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MainBody(
      automaticallyImplyLeading: true,
      container: Consumer<HomeProvider>(
        builder: (context, homeProvider, child) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 15, right: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Filter your selection",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    CommonDropDownTwo(
                      jobRoleCtrl: categoryFilterController,
                      hintText: "",
                      items: homeProvider.categoryList,
                      onChanged: (value) {
                        if (mounted) {
                          setState(() {
                            categoryFilterController.text = value ?? '';
                          });
                        }
                      },
                    ),
                  ],
                ),
              ),
              Expanded(
                child: FilterPostScreen(
                  selectedValue: categoryFilterController.text,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

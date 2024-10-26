import 'package:flutter/material.dart';
import 'package:gossip_app/pages/homepage/home_page.dart';
import 'package:gossip_app/provider/home_provider.dart';
import 'package:gossip_app/provider/sign_up_provider.dart';
import 'package:gossip_app/utils/main_body.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gossip_app/widgets/common_button.dart';
import 'package:gossip_app/widgets/common_dropdowm.dart';
import 'package:gossip_app/widgets/common_input.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class AddNewPostScreen extends StatefulWidget {
  const AddNewPostScreen({
    super.key,
    required this.userName,
  });

  final String userName;
  @override
  State<AddNewPostScreen> createState() => _AddNewPostScreenState();
}

class _AddNewPostScreenState extends State<AddNewPostScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<HomeProvider>(context, listen: false).loadNewPostData(
        context,
        userName: widget.userName,
      );
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> newPostStream = FirebaseFirestore.instance
        .collection('Post')
        .orderBy('time')
        .snapshots();
    final formattedDate = DateFormat('MM/dd/yyyy').format(DateTime.now());
    final formKey = GlobalKey<FormState>();

    return MainBody(
      automaticallyImplyLeading: true,
      container: SingleChildScrollView(
        child: Consumer2<HomeProvider, SignUpProvide>(
          builder: (context, homeProvider, signUpProvider, child) {
            return Form(
              key: formKey,
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Enter Discription",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black54,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        CommonTextFeild(
                          label: "",
                          hint: "Enter Discription",
                          fullborder: true,
                          fullbordercolor: Colors.black,
                          bordercolor: Colors.black,
                          maxLine: null,
                          controller:
                              homeProvider.getnewPostDiscriptionController,
                          textInputAction: TextInputAction.newline,
                          keyboardType: TextInputType.multiline,
                          isValidate: true,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Enter Auther Name",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black54,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        CommonTextFeild(
                          label: "",
                          hint: "Enter Auther Name",
                          controller: homeProvider.getnewPostuserNameController,
                          isValidate: true,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Select Category",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black54,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        CommonDropDown(
                          isRequired: true,
                          jobRoleCtrl: homeProvider.getcategoryTxtController,
                          hintText: '',
                          items: homeProvider.categoryList,
                          onChanged: (p0) {},
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(12),
                    child: CommonButton(
                      onPress: () {
                        if (formKey.currentState!.validate()) {
                          homeProvider.firebaseFirestore
                              .collection("Post")
                              .doc()
                              .set({
                            "date": formattedDate,
                            "discription": homeProvider
                                .getnewPostDiscriptionController.text,
                            "imagePath": '',
                            "postId": homeProvider.getnewPostId,
                            'profilePic':
                                '${signUpProvider.user?.photoUrl ?? ''}',
                            "time": DateTime.now(),
                            "username": homeProvider
                                .getnewPostuserNameController.text
                                .replaceAll('@gmail.com', ''),
                            "category":
                                homeProvider.getcategoryTxtController.text,
                            // "email":
                            //     '${profileProvider.getUserDataModel?.message.email ?? ''} ',
                          });
                          final snackBar = SnackBar(
                            backgroundColor: Colors.grey,
                            content: Text(
                              "New Post Publish Success",
                              style: TextStyle(
                                color: Colors.red.shade900,
                              ),
                            ),
                            action: SnackBarAction(
                              label: 'undo',
                              onPressed: () {},
                            ),
                          );

                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                          homeProvider.getnewPostDiscriptionController.clear();
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return const HomePage();
                              },
                            ),
                            (route) => false,
                          );
                        }
                        // if (homeProvider
                        //     .getnewPostDiscriptionController.text.isNotEmpty) {

                        // }
                      },
                      buttonName: "Publish",
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

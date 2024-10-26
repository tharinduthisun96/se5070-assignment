import 'package:flutter/material.dart';
import 'package:gossip_app/provider/home_provider.dart';
import 'package:gossip_app/provider/sign_up_provider.dart';
import 'package:gossip_app/utils/colors_const.dart';
import 'package:gossip_app/utils/main_body.dart';
import 'package:gossip_app/widgets/common_button.dart';
import 'package:gossip_app/widgets/common_input.dart';
import 'package:gossip_app/widgets/common_multiple_seleceted_dropdown.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({
    super.key,
    required this.userEmail,
  });

  final String userEmail;
  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<HomeProvider>(context, listen: false)
          .loadProfileRecords(context, email: widget.userEmail);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MainBody(
      automaticallyImplyLeading: true,
      appBarTitle: const Text(
        "My Profile",
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: kDefTextColor,
        ),
      ),
      container: SingleChildScrollView(
        child: Consumer2<SignUpProvide, HomeProvider>(
          builder: (context, signUpProvide, homeProvider, child) {
            if (homeProvider.getloadProfileRecordsValues) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                if (signUpProvide.user != null)
                  Center(
                    child: ClipOval(
                      child: Image.network(
                        "${signUpProvide.user?.photoUrl}",
                        fit: BoxFit.cover,
                        width: 65,
                        height: 65,
                        loadingBuilder: (BuildContext context, Widget child,
                            ImageChunkEvent? loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                  : null,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                if (signUpProvide.user != null)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "${signUpProvide.user!.email}",
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: Colors.black45,
                      ),
                    ),
                  ),
                if (signUpProvide.user == null &&
                    signUpProvide.getsingEmail != "")
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "${signUpProvide.getsingEmail}",
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: Colors.black45,
                      ),
                    ),
                  ),
                if (signUpProvide.user != null)
                  Padding(
                    padding: const EdgeInsets.only(left: 25),
                    child: Text(
                      "${signUpProvide.user!.displayName}",
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: Colors.black45,
                      ),
                    ),
                  ),
                if (signUpProvide.user == null)
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 80, left: 25, right: 25),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Enter Display Name",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            color: Colors.black45,
                          ),
                        ),
                        CommonTextFeild(
                          label: "",
                          hint: "Enter Display Name",
                          fullborder: true,
                          controller: homeProvider.getdisplayNameTxtController,
                          bordercolor: kPrimaryBoader,
                          fullbordercolor: kPrimaryBoader,
                          suffix: const Icon(
                            FontAwesomeIcons.user,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.only(top: 10, left: 25, right: 25),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Select category",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: Colors.black45,
                        ),
                      ),
                      CommonMultipleDropDownBtn(
                        btnText: "Select  category",
                        titleValue: "Select category",
                        icon: const Icon(
                          FontAwesomeIcons.filter,
                          color: Colors.black54,
                        ),
                        items: homeProvider.getMultiSelectItems(),
                        onConfirm: (selectedItems) {
                          homeProvider.selectedValues = selectedItems
                              .map((item) => item.toString())
                              .toList();
                          // homeProvider.onConfirmSelection(p0);
                        },
                      ),
                      if (homeProvider.selectedValues.isNotEmpty)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(top: 10),
                              child: Text(
                                "Selected my category",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.black45,
                                ),
                              ),
                            ),
                            Text(
                              homeProvider.selectedValues.isNotEmpty
                                  ? homeProvider.selectedValues.join(', ')
                                  : 'No categories selected',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w800,
                                color: Colors.blue.shade900,
                              ),
                            )
                          ],
                        )
                    ],
                  ),
                ),
                homeProvider.getloadProfileData
                    ? CircularProgressIndicator()
                    : Padding(
                        padding:
                            const EdgeInsets.only(top: 10, left: 25, right: 25),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CommonButton(
                              onPress: () {
                                homeProvider.uplodeProfileData(
                                  context,
                                  email:
                                      signUpProvide.getsingEmail.toString() ??
                                          signUpProvide.user!.email,
                                  displayname:
                                      signUpProvide.user?.displayName ??
                                          homeProvider
                                              .getdisplayNameTxtController.text,
                                );
                              },
                              backgroundColor: kButtonColors,
                              buttonName: "Save My Profile",
                              textColor: Colors.white,
                            )
                          ],
                        ),
                      ),
                if (signUpProvide.user != null ||
                    signUpProvide.singEmail != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 50),
                    child: Center(
                        child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Padding(
                          padding: const EdgeInsets.only(left: 25),
                          child: Text(
                            "sign out",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: Colors.black45,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            signUpProvide.googleLogOut(context);
                          },
                          icon: const FaIcon(
                            FontAwesomeIcons.rightFromBracket,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    )),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}

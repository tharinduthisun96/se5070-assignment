import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gossip_app/pages/filter_screen.dart/filter_screen.dart';
import 'package:gossip_app/pages/post_screen.dart/add_new_post/add_new_post.dart';
import 'package:gossip_app/pages/post_screen.dart/post_screen.dart';
import 'package:gossip_app/pages/sign_in/sign_in_screen.dart';
import 'package:gossip_app/pages/user_proflie_screen.dart/user_profile_screen.dart';
import 'package:gossip_app/provider/home_provider.dart';
import 'package:gossip_app/provider/sign_up_provider.dart';
import 'package:gossip_app/utils/colors_const.dart';
import 'package:gossip_app/utils/main_body.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final signUpProvide = Provider.of<SignUpProvide>(context, listen: false);
      Provider.of<SignUpProvide>(context, listen: false)
          .loadUserData(context)
          .then(
        (value) {
          return Provider.of<HomeProvider>(context, listen: false)
              .loadProfileRecords(
            context,
            email: signUpProvide.getsingEmail.toString(),
          );
        },
      );
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MainBody(
      appBarbackgroundColor: kAppbarColors,
      toolbarHeight: 95,
      appBarTitle: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "Gossip",
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
          Consumer2<SignUpProvide, HomeProvider>(
            builder: (context, signUpProvide, homeProvider, child) {
              if (signUpProvide.loadHomePageData ||
                  homeProvider.getloadProfileRecordsValues) {
                return const CircularProgressIndicator();
              }
              return Column(
                children: [
                  IconButton(
                    onPressed: () {
                      if (signUpProvide.user != null ||
                          signUpProvide.getsingEmail != "") {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => UserProfileScreen(
                              userEmail: signUpProvide.getsingEmail.toString(),
                            ),
                          ),
                        );
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SignInScreen(),
                          ),
                        );
                      }
                    },
                    icon: signUpProvide.user != null &&
                            signUpProvide.user!.photoUrl!.isNotEmpty
                        ? Column(
                            children: [
                              ClipOval(
                                child: ClipOval(
                                  child: CachedNetworkImage(
                                    imageUrl:
                                        ("${signUpProvide.user?.photoUrl}"),
                                    width: 50,
                                    height: 50,
                                    placeholder: (context, url) =>
                                        const CircularProgressIndicator(),
                                    errorWidget: (context, url, error) =>
                                        const Center(
                                      child: Image(
                                        image: AssetImage(
                                            "assets/images/def_user.png"),
                                        height: 65,
                                        width: 65,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        : const Icon(
                            Icons.person_sharp,
                            size: 40,
                            color: Colors.white,
                          ),
                  ),
                  const Text(
                    "My Profile",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  )
                ],
              );
            },
          )
        ],
      ),
      centerTitle: false,
      container: Column(
        children: [
          Consumer<SignUpProvide>(
            builder: (context, signUpProvide, child) {
              return Padding(
                padding: const EdgeInsets.only(top: 15, left: 25, bottom: 20),
                child: Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // InkWell(
                    //   onTap: () {
                    //     if (signUpProvide.getsingEmail != "") {
                    //       Navigator.push(
                    //         context,
                    //         MaterialPageRoute(
                    //           builder: (context) {
                    //             return AddNewPostScreen(
                    //               userName: signUpProvide.getsingEmail!,
                    //             );
                    //           },
                    //         ),
                    //       );
                    //     } else {
                    //       final snackBar = SnackBar(
                    //         backgroundColor: Colors.grey,
                    //         content: Text(
                    //           "Please Sign and add new post",
                    //           style: TextStyle(
                    //             color: Colors.red.shade900,
                    //           ),
                    //         ),
                    //         action: SnackBarAction(
                    //           label: 'undo',
                    //           onPressed: () {},
                    //         ),
                    //       );

                    //       ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    //     }
                    //   },
                    //   child: const Row(
                    //     children: [
                    // FaIcon(
                    //   FontAwesomeIcons.images,
                    //   color: Colors.black54,
                    // ),
                    //       Padding(
                    //         padding: EdgeInsets.all(8.0),
                    //         child: Text(
                    //           "Add New Post",
                    //           textAlign: TextAlign.start,
                    //           style: TextStyle(
                    //             fontSize: 12,
                    //             color: Colors.black54,
                    //             fontWeight: FontWeight.bold,
                    //           ),
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    if (signUpProvide.user != null ||
                        signUpProvide.getsingEmail != "")
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return const FilterScreen();
                                },
                              ),
                            );
                          },
                          child: const Row(
                            children: [
                              FaIcon(
                                FontAwesomeIcons.filter,
                                color: Colors.black54,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "Filter",
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.black54,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
          const Expanded(
            child: PostScreen(),
          ),
        ],
      ),
    );
  }
}

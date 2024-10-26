import 'package:flutter/material.dart';
import 'package:gossip_app/provider/home_provider.dart';
import 'package:gossip_app/provider/sign_up_provider.dart';
import 'package:gossip_app/utils/colors_const.dart';
import 'package:gossip_app/utils/main_body.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gossip_app/widgets/common_input.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class CommentScreen extends StatefulWidget {
  const CommentScreen({
    super.key,
    required this.messageId,
  });

  final String messageId;
  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<HomeProvider>(context, listen: false).clearData();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> commentStream = FirebaseFirestore.instance
        .collection('comment')
        .orderBy('serverdate')
        .snapshots();
    final formattedDate = DateFormat('MM/dd/yyyy').format(DateTime.now());
    final formattedTime12Hour = DateFormat('hh:mm:ss a').format(DateTime.now());
    return MainBody(
      automaticallyImplyLeading: true,
      floatingActionButton: Consumer<HomeProvider>(
        builder: (context, homeProvider, child) {
          return FloatingActionButton.small(
            backgroundColor: kButtonColors,
            onPressed: () {
              if (homeProvider.getshowTxtFeil == true) {
                homeProvider.setshowTxtFeil(false);
                homeProvider.setshowTxtFeildIcon(false);
                homeProvider.getcommentController.clear();
              } else {
                homeProvider.setshowTxtFeil(true);
              }
            },
            child: const Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                FaIcon(
                  FontAwesomeIcons.solidComments,
                  color: Colors.white,
                ),
              ],
            ),
          );
        },
      ),
      container: Consumer2<HomeProvider, SignUpProvide>(
        builder: (context, homeProvider, signUpProvider, child) {
          return Column(
            children: [
              Expanded(
                child: StreamBuilder(
                  stream: commentStream,
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return Text("Somting wrong ${snapshot.hasError}");
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    return ListView.builder(
                      itemBuilder: (context, index) {
                        QueryDocumentSnapshot qds = snapshot.data!.docs[index];
                        return qds['postId'] == widget.messageId
                            ? Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Builder(builder: (context) {
                                  return Card(
                                    color: Colors.white,
                                    shape: ContinuousRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              if (qds['profilePic'] != null)
                                                ClipOval(
                                                  child: Image.network(
                                                    "${qds['profilePic']}",
                                                    fit: BoxFit.cover,
                                                    width: 50,
                                                    height: 50,
                                                    loadingBuilder: (BuildContext
                                                            context,
                                                        Widget child,
                                                        ImageChunkEvent?
                                                            loadingProgress) {
                                                      if (loadingProgress ==
                                                          null) return child;
                                                      return Center(
                                                        child:
                                                            CircularProgressIndicator(
                                                          value: loadingProgress
                                                                      .expectedTotalBytes !=
                                                                  null
                                                              ? loadingProgress
                                                                      .cumulativeBytesLoaded /
                                                                  loadingProgress
                                                                      .expectedTotalBytes!
                                                              : null,
                                                        ),
                                                      );
                                                    },
                                                    errorBuilder:
                                                        (BuildContext context,
                                                            Object error,
                                                            StackTrace?
                                                                stackTrace) {
                                                      return const Padding(
                                                        padding:
                                                            EdgeInsets.all(8.0),
                                                        child: FaIcon(
                                                          FontAwesomeIcons
                                                              .solidUser,
                                                          color: Colors.black45,
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "${qds['username']}",
                                                      style: const TextStyle(
                                                        fontSize: 12,
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    Row(
                                                      children: [
                                                        Text(
                                                          "${qds['date']} |",
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 10,
                                                            color:
                                                                Colors.black45,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                          ),
                                                        ),
                                                        Text(
                                                          " ${qds['time']}",
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 10,
                                                            color:
                                                                Colors.black45,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 25, top: 10),
                                            child: Text(
                                              "${qds['comment']}",
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }),
                              )
                            : SizedBox();
                      },
                      itemCount: snapshot.data!.docs.length,
                      // physics: NeverScrollableScrollPhysics(),
                    );
                  },
                ), // Fills the space above the text field
              ),
              Padding(
                padding: const EdgeInsets.only(
                    bottom: 75, left: 15, right: 15, top: 15),
                child: Column(
                  children: [
                    if (homeProvider.getshowTxtFeil == true)
                      CommonTextFeild(
                        label: "",
                        hint: "Enter Your Comment",
                        fullborder: true,
                        fullbordercolor: Colors.black,
                        bordercolor: Colors.black,
                        maxLine: null,
                        textInputAction: TextInputAction.newline,
                        keyboardType: TextInputType.multiline,
                        controller: homeProvider.getcommentController,
                        onChanged: (p0) {
                          if (homeProvider.getcommentController.text.isEmpty) {
                            homeProvider.setshowTxtFeildIcon(false);
                          } else {
                            homeProvider.setshowTxtFeildIcon(true);
                          }
                          setState(() {});
                        },
                        suffix: IconButton(
                          onPressed: () {
                            if (homeProvider
                                .getcommentController.text.isNotEmpty) {
                              homeProvider.firebaseFirestore
                                  .collection("comment")
                                  .doc()
                                  .set({
                                "comment": homeProvider
                                    .getcommentController.text
                                    .trim(),
                                "serverdate": DateTime.now(),
                                "time": formattedTime12Hour,
                                "date": formattedDate,
                                "profilePic":
                                    '${signUpProvider.user?.photoUrl ?? ''}',
                                "postId": widget.messageId,
                                "username":
                                    '${signUpProvider.user?.displayName ?? signUpProvider.getsingEmail!.replaceAll('@gmail.com', '')}',
                              });
                              // dev.log(
                              //     'image URL: ${profileProvider.getUserDataModel?.message.profilepic ?? ''} ');
                              homeProvider.getcommentController.clear();
                              homeProvider.setshowTxtFeildIcon(false);
                            }
                          },
                          icon: Column(
                            children: [
                              if (homeProvider.getshowTxtFeildIcon)
                                const FaIcon(
                                  FontAwesomeIcons.paperPlane,
                                  color: Colors.black54,
                                ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

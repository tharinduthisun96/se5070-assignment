import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:developer' as dev;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gossip_app/pages/post_screen.dart/comment_screen/comment_screen.dart';
import 'package:gossip_app/pages/sign_in/sign_in_screen.dart';
import 'package:gossip_app/provider/home_provider.dart';
import 'package:gossip_app/provider/sign_up_provider.dart';
import 'package:provider/provider.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({super.key});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> postStreamStream = FirebaseFirestore.instance
        .collection('Post')
        .orderBy('time')
        .snapshots();

    return StreamBuilder(
      stream: postStreamStream,
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        dev.log("Snapshot Error: ${snapshot.hasError}");

        if (snapshot.hasError) {
          return Text("Error: ${snapshot.error}");
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          dev.log("Loading data...");
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          dev.log("No data in snapshot.");
          return const Center(child: Text("No posts available"));
        }

        dev.log("Data loaded successfully.");

        return Consumer<HomeProvider>(
          builder: (context, homeProvider, child) {
            // final selectedValues = homeProvider.selectedValues.join(', ');
            // Getting the selected values
            List<String> selectedValues = homeProvider.selectedValues;

            // Join selected values into a single string separated by spaces
            String selectedValuesDisplay = selectedValues.join(' ');
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                QueryDocumentSnapshot qds = snapshot.data!.docs[index];
                String postId = qds['postId'];

                dev.log(selectedValuesDisplay.toString());
                String postCategory = qds['category'] ?? '';
                bool shouldDisplayPost = selectedValues.isEmpty ||
                    selectedValues.any((selected) => selected == postCategory);
                if (!shouldDisplayPost) {
                  return SizedBox.shrink(); // Skip this post
                }
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      width: MediaQuery.of(context).size.width / 1.1,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 251, 253, 255),
                        border: Border.all(
                          color: Colors.blue.shade200,
                        ),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              ClipOval(
                                child: CachedNetworkImage(
                                  imageUrl: (qds['profilePic']),
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
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${qds['username']}",
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      "${qds['date']}",
                                      style: const TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    if (qds['category'] != '')
                                      Text(
                                        "${qds['category']}",
                                        style: const TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "${qds['discription']}",
                                  textAlign: TextAlign.start,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CachedNetworkImage(
                              imageUrl: ("${qds['imagePath']}"),
                              width: MediaQuery.of(context).size.width,
                              placeholder: (context, url) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              },
                              errorWidget: (context, url, error) =>
                                  const Center(
                                child: Image(
                                  image: AssetImage(
                                      "assets/images/No_Image_Available.jpg"),
                                  height: 65,
                                  width: 65,
                                ),
                              ),
                            ),
                          ),
                          Consumer<HomeProvider>(
                              builder: (context, homeProvider, child) {
                            return FutureBuilder<int>(
                              future: homeProvider
                                  .getLikesCount(postId), // Get the likes count
                              builder: (context, likesSnapshot) {
                                if (likesSnapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const CircularProgressIndicator(); // Show loading while fetching
                                }

                                if (likesSnapshot.hasError) {
                                  return Text("Error: ${likesSnapshot.error}");
                                }

                                final likesCount = likesSnapshot.data ??
                                    0; // Get the likes count

                                return StreamBuilder(
                                  stream: FirebaseFirestore.instance
                                      .collection('Postlike')
                                      .doc(postId)
                                      .snapshots(),
                                  builder: (context, likesSnapshot) {
                                    if (likesSnapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const Text(
                                        "Loading Likes...",
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.blue,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      );
                                    }
                                    if (likesSnapshot.hasError) {
                                      return const Text(
                                        "Error",
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.blue,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      );
                                    } // Get likes count from the likes document
                                    final likesData =
                                        likesSnapshot.data?.data();
                                    int likesCount = 0;
                                    if (likesData != null &&
                                        likesData['likedBy'] != null) {
                                      likesCount =
                                          (likesData['likedBy'] as List).length;
                                    }
                                    return Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            homeProvider.likePost(
                                              context,
                                              postId: qds['postId'],
                                            );
                                          },
                                          child: Row(
                                            children: [
                                              const FaIcon(
                                                FontAwesomeIcons.thumbsUp,
                                                color: Colors.blue,
                                              ),
                                              Text(
                                                " Like ${homeProvider.formatLikesCount(likesCount)}", // Show likes count
                                                textAlign: TextAlign.start,
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.blue,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Consumer<SignUpProvide>(
                                          builder:
                                              (context, signUpProvide, child) {
                                            return InkWell(
                                              onTap: () {
                                                if (signUpProvide.user !=
                                                        null ||
                                                    signUpProvide.singEmail !=
                                                        '') {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) {
                                                        return CommentScreen(
                                                          messageId: postId,
                                                        );
                                                      },
                                                    ),
                                                  );
                                                } else {
                                                  final snackBar = SnackBar(
                                                    backgroundColor:
                                                        Colors.grey,
                                                    content: Text(
                                                      "Please sign in to comment",
                                                      style: TextStyle(
                                                        color:
                                                            Colors.red.shade900,
                                                      ),
                                                    ),
                                                    action: SnackBarAction(
                                                      label: 'Sign In',
                                                      onPressed: () {
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (context) {
                                                              return const SignInScreen();
                                                            },
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                  );

                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(snackBar);
                                                }
                                              },
                                              child: const Row(
                                                children: [
                                                  FaIcon(
                                                    FontAwesomeIcons.comment,
                                                    color: Colors.blue,
                                                  ),
                                                  Text(
                                                    "Comment",
                                                    textAlign: TextAlign.start,
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.blue,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                            );
                          }),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}

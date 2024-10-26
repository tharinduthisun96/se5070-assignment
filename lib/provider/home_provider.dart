import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gossip_app/pages/homepage/home_page.dart';
import 'package:intl/intl.dart';
import 'dart:developer' as dev;

import 'package:multi_select_flutter/util/multi_select_item.dart';

class HomeProvider extends ChangeNotifier {
  bool showTxtFeil = false;
  bool get getshowTxtFeil => showTxtFeil;
  setshowTxtFeil(val) {
    showTxtFeil = val;
    notifyListeners();
  }

  clearData() async {
    getcommentController.clear();
    setshowTxtFeil(false);
    setshowTxtFeildIcon(false);
  }

  TextEditingController commentController = TextEditingController();
  TextEditingController get getcommentController => commentController;

  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  TextEditingController newPostDiscriptionController = TextEditingController();
  TextEditingController get getnewPostDiscriptionController =>
      newPostDiscriptionController;
  TextEditingController newPostuserNameController = TextEditingController();
  TextEditingController get getnewPostuserNameController =>
      newPostuserNameController;

  TextEditingController categoryTxtController = TextEditingController();
  TextEditingController get getcategoryTxtController => categoryTxtController;

  TextEditingController displayNameTxtController = TextEditingController();
  TextEditingController get getdisplayNameTxtController =>
      displayNameTxtController;

  List<String> categoryList = [
    'Vehicle',
    'Sports',
    'gossip',
    'News',
    'Funny',
    "Technology",
    "Entertainment",
    "Lifestyle",
    "Health",
    "Travel",
    "Others",
  ];
  List<String> get getCategoryList => categoryList;
  void setCategoryList(List<String> newCategoryList) {
    categoryList = newCategoryList;
    getcategoryTxtController.clear();
    notifyListeners();
  }

  Future<void> loadNewPostData(context, {String? userName}) async {
    newPostuserNameController.text = userName.toString();
    generatePostId();
    notifyListeners();
  }

  //new post ID
  String newPostId = '';
  String get getnewPostId => newPostId;
  setnewPostId(val) {
    newPostId = val;
    notifyListeners();
  }

  Future<void> generatePostId() async {
    // Get the current date and time
    DateTime now = DateTime.now();

    String formattedDateTime = DateFormat('yyMMddHHmmss').format(now);

    String randomDigits = (Random().nextInt(900) + 100).toString();
    // Combine formatted date and random digits
    String postId = '$formattedDateTime$randomDigits';

    // Ensure the ID does not exceed 12 characters
    if (postId.length > 12) {
      postId = postId.substring(0, 12);
    }

    // Set the new post ID
    setnewPostId(postId);
    dev.log(postId);
    notifyListeners();

    // return formattedDateTime;
  }

  bool showTxtFeildIcon = false;
  bool get getshowTxtFeildIcon => showTxtFeildIcon;
  setshowTxtFeildIcon(val) {
    showTxtFeildIcon = val;
    notifyListeners();
  }

  //filter values
  TextEditingController categoryFilterController = TextEditingController();
  TextEditingController get getcategoryFilterController =>
      categoryFilterController;

  // Function to like a post
  Future<void> likePost(context, {required String postId}) async {
    final userId = auth.currentUser?.uid;
    dev.log("Post ID: $postId");

    if (userId == null) {
      dev.log("User is not logged in.");
      final snackBar = SnackBar(
        backgroundColor: Colors.grey,
        content: Text(
          "Please sign in and like",
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
      return;
    }

    final postRef = firebaseFirestore.collection('Postlike').doc(postId);
    await postRef.set({
      'likedBy': FieldValue.arrayUnion([userId]),
    }, SetOptions(merge: true));
    dev.log("User $userId liked the post: $postId");
    final snackBar = SnackBar(
      backgroundColor: Colors.grey.shade50,
      content: const Text(
        "Thank you for your like",
        style: TextStyle(
          color: Colors.blue,
        ),
      ),
      action: SnackBarAction(
        label: '',
        onPressed: () {},
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  // Function to get the likes count for a post
  Future<int> getLikesCount(String postId) async {
    final postRef = firebaseFirestore.collection('Postlike').doc(postId);
    final postSnapshot = await postRef.get();

    if (postSnapshot.exists) {
      final postData = postSnapshot.data();
      if (postData != null && postData['likedBy'] != null) {
        return (postData['likedBy'] as List).length;
      }
    }
    return 0;
  }

  String formatLikesCount(int count) {
    if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}K'; // Converts to K format
    }
    return count.toString(); // Return as is if less than 1000
  }

  //selected value
  List<MultiSelectItem<dynamic>> getMultiSelectItems() {
    List<MultiSelectItem<dynamic>> items = categoryList
        .map(
          (category) => MultiSelectItem<dynamic>(
              category, category), // Only passing `category`
        )
        .toList();
    return items;
  }

  List<String> selectedValues = [];

  // Function to update selectedValues when user confirms selections
  void onConfirmSelection(List<Object?> selectedItems) {
    selectedValues = selectedItems.map((item) => item.toString()).toList();
    dev.log("Selected values after confirmation: $selectedValues");
    notifyListeners();
  }

  Future<void> uplodeProfileData(
    BuildContext context, {
    required String email,
    required String displayname,
  }) async {
    try {
      setloadProfileData(true);

      QuerySnapshot existingProfile = await FirebaseFirestore.instance
          .collection('profileDetails')
          .where('email', isEqualTo: email)
          .get();

      Map<String, dynamic> profileData = {
        'email': email,
        'createTime': DateTime.now(),
        'displayname': displayname,
        'selectedCategory': selectedValues,
      };

      if (existingProfile.docs.isNotEmpty) {
        await FirebaseFirestore.instance
            .collection('profileDetails')
            .doc(existingProfile.docs.first.id)
            .update(profileData);

        dev.log('Profile updated: $profileData');

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Profile data updated successfully!"),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
          (route) => false,
        );
      } else {
        await FirebaseFirestore.instance
            .collection('profileDetails')
            .add(profileData);

        dev.log('Profile created: $profileData');

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Profile data uploaded successfully!"),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
          (route) => false,
        );
      }
    } catch (e) {
      dev.log(e.toString());

      // Show error snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Failed to upload profile data. Please try again."),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
    } finally {
      setloadProfileData(false);
    }
  }

  bool loadProfileData = false;
  bool get getloadProfileData => loadProfileData;
  setloadProfileData(val) {
    loadProfileData = val;
    notifyListeners();
  }

  // Load existing profile data from Firestore
  bool loadProfileRecordsValues = false;
  bool get getloadProfileRecordsValues => loadProfileRecordsValues;
  setloadProfileRecordsValues(val) {
    loadProfileRecordsValues = val;
    notifyListeners();
  }

  Future<void> loadProfileRecords(BuildContext context,
      {required String email}) async {
    dev.log("Login email: $email");
    try {
      setloadProfileRecordsValues(true);
      QuerySnapshot profileSnapshot = await FirebaseFirestore.instance
          .collection('profileDetails')
          .where('email', isEqualTo: email)
          .get();
      dev.log(profileSnapshot.docs.first.data().toString());
      if (profileSnapshot.docs.isNotEmpty) {
        var profileData =
            profileSnapshot.docs.first.data() as Map<String, dynamic>;

        // Update the selected values with the loaded profile data
        selectedValues =
            List<String>.from(profileData['selectedCategory'] ?? []);
        getdisplayNameTxtController.text = profileData['displayname'];
        dev.log("Loaded selected categories: $selectedValues" ?? '');
        notifyListeners(); // Notify listeners after updating selectedValues
      }
    } catch (e) {
      dev.log("Error loading profile data: ${e.toString()}");
    } finally {
      setloadProfileRecordsValues(false);
    }
  }
}

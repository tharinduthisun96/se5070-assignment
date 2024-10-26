import 'package:flutter/material.dart';
import 'dart:developer' as dev;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gossip_app/pages/homepage/home_page.dart';
import 'package:gossip_app/provider/home_provider.dart';
import 'package:gossip_app/utils/common_message.dart';
import 'package:gossip_app/utils/shared_data.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:gossip_app/firebase_config/firbase_auth_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

class SignUpProvide extends ChangeNotifier {
  FirebaseAuthServices auth = FirebaseAuthServices();
  final storage = new FlutterSecureStorage();

  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  TextEditingController nameConteroller = TextEditingController();
  TextEditingController get getnameConteroller => nameConteroller;

  TextEditingController emailConteroller = TextEditingController();
  TextEditingController get getemailConteroller => emailConteroller;

  TextEditingController passwordConteroller = TextEditingController();
  TextEditingController get getpasswordConteroller => passwordConteroller;

  TextEditingController conformPasswordConteroller = TextEditingController();
  TextEditingController get getconformPasswordConteroller =>
      conformPasswordConteroller;

  TextEditingController loginEmailConteroller = TextEditingController();
  TextEditingController get getloginEmailConteroller => loginEmailConteroller;

  TextEditingController loginPasswordConteroller = TextEditingController();
  TextEditingController get getloginPasswordConteroller =>
      loginPasswordConteroller;

//        loginEmailConteroller.text;
// loginPasswordConteroller.text;

  //validate user registration data
  bool loadingSignProcess = false;
  bool get getloadingSignProcess => loadingSignProcess;
  setloadingSignProcess(val) {
    loadingSignProcess = val;
    notifyListeners();
  }

  Future<void> validateSignUpData(context) async {
    RegExp passregex =
        RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
    try {
      setloadingSignProcess(true);
      if (getpasswordConteroller.text.trim() !=
          getconformPasswordConteroller.text.trim()) {
        final snackBar = SnackBar(
          backgroundColor: Colors.grey,
          content: Text(
            "Enter Password and Conform Password Mismatch",
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
      } else {
        if (passregex.hasMatch(getpasswordConteroller.text)) {
          await singUpProcess(context);
          dev.log("validated");
        } else {
          final snackBar = SnackBar(
            backgroundColor: Colors.grey,
            content: Text(
              "password length is short",
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
        }
      }
    } catch (e) {
      dev.log("$e");
    } finally {
      setloadingSignProcess(false);
    }
  }

  //registration process
  Future<void> singUpProcess(context) async {
    String username = getnameConteroller.text;
    String email = getemailConteroller.text;
    String password = getpasswordConteroller.text;
    try {
      setloadingSignProcess(true);
      User? user = await auth.signUpWithEmailAndPassword(
        email,
        password,
        username,
      );
      if (user != null) {
        CommonMessage(context,
            errorTxt: "User Registartion Success",
            btnType: 3,
            buttons: [
              DialogButton(
                child: Text("Okay"),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
              )
            ]).show();
      } else {
        final snackBar = SnackBar(
          backgroundColor: Colors.grey,
          content: Text(
            "The email address is already in use by another account please Try again",
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
      }
    } catch (e) {
      dev.log("$e");
    } finally {
      setloadingSignProcess(false);
    }
  }

  //user login
  bool loadingLoginProcess = false;
  bool get getloadingLoginProcess => loadingLoginProcess;
  setloadingLoginProcess(val) {
    loadingLoginProcess = val;
    notifyListeners();
  }

  Future<void> loginProcess(context) async {
    String email = getloginEmailConteroller.text;
    String password = getloginPasswordConteroller.text;
    dev.log("Login Email $email");

    try {
      setloadingLoginProcess(true);
      User? user = await auth.loginWithEmailAndPassword(email, password);
      if (user != null) {
        storage.write(key: kEmail, value: loginEmailConteroller.text);
        setsingEmail(loginEmailConteroller.text);
        CommonMessage(
          context,
          errorTxt: "Login Success",
          btnType: 3,
          buttons: [
            DialogButton(
              child: Text("Done"),
              onPressed: () {
                storage.write(key: kEmail, value: loginEmailConteroller.text);
                storage.write(key: kLoginType, value: "email");
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return const HomePage();
                    },
                  ),
                  (route) => false,
                );
              },
            )
          ],
        ).show();
      } else {
        CommonMessage(context,
            errorTxt: "Login failed please Try again",
            btnType: 3,
            buttons: [
              DialogButton(
                child: Text("Okay"),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ]).show();
      }
    } catch (e) {
      dev.log("$e");
    } finally {
      setloadingLoginProcess(false);
    }
  }

  //google authentication
  //sign in google account
  final GoogleSignIn googleSignIn = GoogleSignIn();

  GoogleSignInAccount? _user;

  GoogleSignInAccount? get user => _user;
  set_user(val) {
    _user = val;
    notifyListeners();
  }

  bool loadinGoogleSingIn = false;
  bool get getloadinGoogleSingIn => loadinGoogleSingIn;
  setloadinGoogleSingIn(val) {
    loadinGoogleSingIn = val;
    notifyListeners();
  }

  Future<void> googleLogin(BuildContext context) async {
    try {
      setloadinGoogleSingIn(true);

      // Initiate Google Sign-In
      final googleUser = await googleSignIn.signIn();
      if (googleUser == null) return;
      set_user(googleUser);

      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);

      // Save the user session details securely
      await storage.write(key: 'accessToken', value: googleAuth.accessToken);
      await storage.write(key: 'idToken', value: googleAuth.idToken);
      dev.log("ID token :${googleAuth.idToken}");
      dev.log("Access token :${googleAuth.accessToken}");
      CommonMessage(
        context,
        errorTxt: "Login Success",
        btnType: 3,
        buttons: [
          DialogButton(
            child: Text("Done"),
            onPressed: () {
              storage.write(key: kEmail, value: _user!.email);
              storage.write(key: kLoginType, value: "google");
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const HomePage()),
                (route) => false,
              );
            },
          )
        ],
      ).show();

      notifyListeners();
    } catch (error) {
      setloadinGoogleSingIn(false);
      dev.log("Error during Google Sign-In: $error");
    } finally {
      setloadinGoogleSingIn(false);
    }
  }

  String? singEmail = '';
  String? get getsingEmail => singEmail;
  setsingEmail(String val) {
    singEmail = val;
    notifyListeners();
  }

  Future<void> loadUserData(BuildContext context) async {
    String? userEmail = await storage.read(key: kEmail);
    setsingEmail(userEmail!);
    // getsingEmail == userEmail;
    if (userEmail != '') {
      dev.log("User email -- $userEmail");
    } else {
      dev.log("User email -- Blank");
    }

    notifyListeners();
  }

  //google authenticated user log out
  Future<void> googleLogOut(context) async {
    String? userEmail = await storage.read(key: kEmail);
    String? loginType = await storage.read(key: kLoginType);
    final homeProvider = Provider.of<HomeProvider>(context, listen: false);

    try {
      if (loginType == 'email') {
        await FirebaseAuth.instance.signOut();
      } else {
        await googleSignIn.disconnect();
      }
      _user = null;
      if (_user == null) {
        CommonMessage(
          context,
          errorTxt: "Log out success \n${userEmail != '' ? userEmail : ''}",
          btnType: 3,
          buttons: [
            DialogButton(
              child: Text("Done"),
              onPressed: () async {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return const HomePage();
                    },
                  ),
                  (route) => false,
                );
              },
            )
          ],
        ).show();
        setsingEmail('');
        homeProvider.selectedValues = [];
        storage.write(key: kEmail, value: '');
        await storage.deleteAll();
        notifyListeners();
      } else {
        final snackBar = SnackBar(
          backgroundColor: Colors.grey,
          content: Text(
            "Error during Google Sign-Out",
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
      }
      await storage.deleteAll();
      notifyListeners();
    } catch (error) {
      dev.log("Error during Google Sign-Out: $error");
      // Handle sign-out errors here
    }
  }

  // Check authentication state on app startup
  bool isActive = false;
  void markActive(bool status) {
    isActive = status;
  }

  Future<void> checkLoginStatus(BuildContext context) async {
    final FirebaseAuth auth = FirebaseAuth.instance;

    try {
      setloadHomePageData(true);
      // Attempt to retrieve saved credentials
      String? accessToken = await storage.read(key: 'accessToken');
      String? idToken = await storage.read(key: 'idToken');
      dev.log("Splash Access token :${accessToken}");
      dev.log("Splash ID token :${idToken}");
      if (accessToken != null && idToken != null) {
        final credential = GoogleAuthProvider.credential(
          accessToken: accessToken,
          idToken: idToken,
        );

        // Try automatic sign-in with valid credentials
        await auth.signInWithCredential(credential);
        if (isActive) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomePage()),
          );
        }
      } else {
        dev.log("No credentials found; proceeding to login.");
      }
    } catch (e) {
      dev.log("Session expired or error during auto-login: $e");
      await storage.deleteAll(); // Clear stored credentials if invalid
    } finally {
      setloadHomePageData(false);
    }
  }

  bool loadHomePageData = false;
  bool get getloadHomePageData => loadHomePageData;
  setloadHomePageData(val) {
    loadHomePageData = val;
    notifyListeners();
  }
}

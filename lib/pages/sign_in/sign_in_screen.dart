import 'package:flutter/material.dart';
import 'package:gossip_app/pages/sign_up/sign_up_screen.dart';
import 'package:gossip_app/provider/sign_up_provider.dart';
import 'package:gossip_app/utils/colors_const.dart';
import 'package:gossip_app/utils/main_body.dart';
import 'package:gossip_app/widgets/common_button.dart';
import 'package:gossip_app/widgets/common_input.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return MainBody(
      automaticallyImplyLeading: true,
      container: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Consumer<SignUpProvide>(
            builder: (context, signUpProvide, child) {
              return Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image(
                        image: AssetImage("assets/images/loginImage.png"),
                        height: 120,
                        width: 120,
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        left: 30,
                        right: 30,
                        top: MediaQuery.of(context).size.height / 40),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding:
                              EdgeInsets.only(left: 30, right: 30, top: 30),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Sign In",
                                style: TextStyle(
                                    color: kDefTextColor,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          "Email",
                          style: TextStyle(
                              color: kDefTextColor,
                              fontSize: 14,
                              fontWeight: FontWeight.bold),
                        ),
                        CommonTextFeild(
                          label: "",
                          hint: "Enter your Email",
                          fullborder: true,
                          backgroundcolor: kPrimaryBoader,
                          fullbordercolor: kPrimaryBoader,
                          controller: signUpProvide.getloginEmailConteroller,
                          isValidate: true,
                          suffix: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: FaIcon(FontAwesomeIcons.envelope),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 30, right: 30, top: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Password",
                          style: TextStyle(
                            color: kDefTextColor,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        CommonTextFeild(
                          label: "",
                          hint: "Enter your Password",
                          fullborder: true,
                          backgroundcolor: kPrimaryBoader,
                          fullbordercolor: kPrimaryBoader,
                          isValidate: true,
                          controller: signUpProvide.getloginPasswordConteroller,
                          isPassword: true,
                          suffix: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: FaIcon(FontAwesomeIcons.key),
                          ),
                        ),
                      ],
                    ),
                  ),
                  signUpProvide.getloadingLoginProcess
                      ? CircularProgressIndicator()
                      : Padding(
                          padding:
                              EdgeInsets.only(left: 30, right: 30, top: 12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width / 1,
                                child: CommonButton(
                                  backgroundColor: kButtonColors,
                                  onPress: () {
                                    if (formKey.currentState!.validate()) {
                                      signUpProvide.loginProcess(context);
                                    }
                                  },
                                  buttonName: "Login",
                                  textColor: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                  const Padding(
                    padding: EdgeInsets.only(left: 30, right: 30, top: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "- OR -",
                          style: TextStyle(
                              color: kDefTextColor,
                              fontSize: 14,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  signUpProvide.getloadinGoogleSingIn
                      ? CircularProgressIndicator()
                      : Padding(
                          padding:
                              EdgeInsets.only(left: 30, right: 30, top: 12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              InkWell(
                                onTap: () {
                                  signUpProvide.googleLogin(context);
                                },
                                child: Container(
                                  padding: EdgeInsets.all(15),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    color: Colors.blue.shade800,
                                  ),
                                  child: FaIcon(
                                    FontAwesomeIcons.google,
                                    color: Colors.white,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                  Padding(
                    padding: EdgeInsets.only(left: 30, right: 30, top: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const SignUpScreen(),
                              ),
                            );
                          },
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Don't have an Account? ",
                                style: TextStyle(
                                    color: kDefTextColor,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400),
                              ),
                              Text(
                                "Sign Up ",
                                style: TextStyle(
                                  color: kDefTextColor,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

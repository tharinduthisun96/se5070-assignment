import 'package:flutter/material.dart';
import 'package:gossip_app/provider/sign_up_provider.dart';
import 'package:gossip_app/utils/colors_const.dart';
import 'package:gossip_app/utils/main_body.dart';
import 'package:gossip_app/widgets/common_button.dart';
import 'package:gossip_app/widgets/common_input.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
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
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image(
                        image: AssetImage("assets/images/singup.png"),
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
                        const Padding(
                          padding: EdgeInsets.only(
                              left: 30, right: 30, top: 30, bottom: 10),
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
                        const Text(
                          "Full Name",
                          style: TextStyle(
                              color: kDefTextColor,
                              fontSize: 14,
                              fontWeight: FontWeight.bold),
                        ),
                        CommonTextFeild(
                          isValidate: true,
                          label: "",
                          hint: "Enter your name",
                          fullborder: true,
                          controller: signUpProvide.getnameConteroller,
                          backgroundcolor: kPrimaryBoader,
                          fullbordercolor: kPrimaryBoader,
                          suffix: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: FaIcon(FontAwesomeIcons.user),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 30, right: 30, top: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Email",
                          style: TextStyle(
                              color: kDefTextColor,
                              fontSize: 14,
                              fontWeight: FontWeight.bold),
                        ),
                        CommonTextFeild(
                          label: "",
                          isValidate: true,
                          hint: "Enter your Email",
                          controller: signUpProvide.getemailConteroller,
                          fullborder: true,
                          backgroundcolor: kPrimaryBoader,
                          fullbordercolor: kPrimaryBoader,
                          suffix: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: FaIcon(FontAwesomeIcons.envelope),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 30, right: 30, top: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Password",
                          style: TextStyle(
                              color: kDefTextColor,
                              fontSize: 14,
                              fontWeight: FontWeight.bold),
                        ),
                        CommonTextFeild(
                          label: "",
                          hint: "Enter your Password",
                          isValidate: true,
                          fullborder: true,
                          controller: signUpProvide.getpasswordConteroller,
                          backgroundcolor: kPrimaryBoader,
                          fullbordercolor: kPrimaryBoader,
                          isPassword: true,
                          suffix: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: FaIcon(FontAwesomeIcons.key),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 30, right: 30, top: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Conform Password",
                          style: TextStyle(
                              color: kDefTextColor,
                              fontSize: 14,
                              fontWeight: FontWeight.bold),
                        ),
                        CommonTextFeild(
                          label: "",
                          hint: "Enter your Conform Password",
                          fullborder: true,
                          backgroundcolor: kPrimaryBoader,
                          isPassword: true,
                          isValidate: true,
                          controller:
                              signUpProvide.getconformPasswordConteroller,
                          fullbordercolor: kPrimaryBoader,
                          suffix: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: FaIcon(FontAwesomeIcons.key),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 30, right: 30, top: 12),
                    child: signUpProvide.getloadingSignProcess
                        ? CircularProgressIndicator(
                            backgroundColor: Colors.blue,
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width / 1,
                                child: CommonButton(
                                  backgroundColor: kButtonColors,
                                  onPress: () {
                                    if (formKey.currentState!.validate()) {
                                      signUpProvide.validateSignUpData(context);
                                    }
                                  },
                                  buttonName: "Register",
                                  textColor: Colors.white,
                                ),
                              ),
                            ],
                          ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 30, right: 30, top: 12, bottom: 25),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Have an Account? ",
                                style: TextStyle(
                                    color: kDefTextColor,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400),
                              ),
                              Text(
                                "Sign in",
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

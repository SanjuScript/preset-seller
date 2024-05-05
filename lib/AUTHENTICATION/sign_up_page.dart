// ignore_for_file: use_build_context_synchronously

import 'dart:ui';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:seller_app/CONSTANTS/fonts.dart';
import 'package:seller_app/FUNCTIONS/login_auth_functions.dart';
import 'package:seller_app/PROVIDERS/auth_page_controller_provider.dart';
import 'package:seller_app/PROVIDERS/policy_status_checking_provider.dart';
import 'package:seller_app/WIDGETS/BUTTONS/login_buttons.dart';
import 'package:seller_app/WIDGETS/Texts/helper_texts.dart';
import 'package:seller_app/WIDGETS/custom_textfield.dart';
import 'package:seller_app/WIDGETS/textfield_containers.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();

  bool isCheck = false;
  final _formKey = GlobalKey<FormState>();
  Future<bool?> getFieldData() async {
    if (emailController.text.isEmpty ||
        passwordController.text.isEmpty ||
        firstNameController.text.isEmpty ||
        lastNameController.text.isEmpty) {
      Fluttertoast.showToast(
          msg: "Please fill in all required fields before signing up");
      return false;
    } else {
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    final status = Provider.of<PolicyStatusProvider>(context, listen: false);
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: size.height * 0.05,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 50, left: 15),
                child: Text(
                  'Sign Up Here',
                  style: TextStyle(
                    fontSize: size.width * 0.12,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontFamily: 'rounder',
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                height: size.height * 0.05,
              ),
              ClipRRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                  child: Container(
                    height: size.height * .60,
                    width: size.width,
                    margin: const EdgeInsets.all(10),
                    padding: const EdgeInsets.only(top: 10, left: 10),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.white.withOpacity(.2),
                          Colors.white.withOpacity(.3),
                        ],
                        begin: AlignmentDirectional.topStart,
                        end: AlignmentDirectional.bottomEnd,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        width: 1.5,
                        color: Colors.white.withOpacity(0.2),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextFieldContainer(
                                widget: CustomTextField(
                                  textInputType: TextInputType.name,
                                  hintText: 'Enter your First Name',
                                  prefixIcon: Icons.person_2_rounded,
                                  isObscure: false,
                                  showSuffix: false,
                                  textInputAction: TextInputAction.next,
                                  textEditingController: firstNameController,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter you name';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              TextFieldContainer(
                                widget: CustomTextField(
                                  textInputType: TextInputType.name,
                                  hintText: 'Enter your Last Name',
                                  prefixIcon: Icons.person_2_rounded,
                                  isObscure: false,
                                  showSuffix: false,
                                  textInputAction: TextInputAction.next,
                                  textEditingController: lastNameController,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter you last name';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              TextFieldContainer(
                                widget: CustomTextField(
                                  textInputType: TextInputType.emailAddress,
                                  hintText: 'Enter your email',
                                  prefixIcon: Icons.mail_outline_rounded,
                                  isObscure: false,
                                  showSuffix: false,
                                  textInputAction: TextInputAction.next,
                                  textEditingController: emailController,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter you email';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              TextFieldContainer(
                                widget: CustomTextField(
                                  textInputType: TextInputType.visiblePassword,
                                  hintText: 'Password',
                                  prefixIcon: Icons.lock_outline_rounded,
                                  isObscure: true,
                                  showSuffix: true,
                                  textInputAction: TextInputAction.go,
                                  textEditingController: passwordController,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter you password';
                                    } else if (value.length < 6) {
                                      return 'Password Must be greater than 6 characters';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        Consumer<PolicyStatusProvider>(
                            builder: (context, status, child) {
                          return Row(
                            children: [
                              IconButton(
                                onPressed: () {
                                  status.toggleStatus();
                                },
                                icon: Icon(
                                  status.accepted
                                      ? Icons.check_box_rounded
                                      : Icons.check_box_outline_blank_rounded,
                                ),
                              ),
                              Expanded(
                                child: Text.rich(
                                  TextSpan(
                                    text: "By continuing you accept our ",
                                    style: const TextStyle(
                                      fontFamily: Getfont.rounder,
                                      color: Colors.black54,
                                      fontWeight: FontWeight.w200,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: "Privacy Policy",
                                        style: const TextStyle(
                                          decoration: TextDecoration.underline,
                                        ),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () {
                                            print("navigate to web");
                                          },
                                      ),
                                      const TextSpan(
                                        text: " and ",
                                      ),
                                      TextSpan(
                                        text: "terms of use",
                                        style: const TextStyle(
                                          decoration: TextDecoration.underline,
                                        ),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () {
                                            print("navigate to web");
                                          },
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          );
                        }),
                        AuthenticationButton(
                          onTap: () async {
                            final fieldData = await getFieldData();
                            if (fieldData != null && fieldData) {
                              if (status.accepted) {
                                LoginAuth.doSignUP(
                                    context: context,
                                    email: emailController.text,
                                    pass: passwordController.text,
                                    firstName: firstNameController.text,
                                    lastName: lastNameController.text);
                              } else {
                                Fluttertoast.showToast(
                                    msg: "Accept privacy policy before you go");
                              }
                            }
                          },
                          text: "Sign Up",
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Expanded(
                                  child: Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 5),
                                color: Colors.grey,
                                height: 1,
                              )),
                              const Text('Or'),
                              Expanded(
                                  child: Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 5),
                                color: Colors.grey,
                                height: 1,
                              )),
                            ],
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Provider.of<AuthPageControllerProvider>(context,
                                    listen: false)
                                .navigateToPage(0);
                          },
                          child: const HelperText1(
                              decoration: TextDecoration.underline,
                              text: 'Already Have an account? Sign in',
                              fontSize: 15,
                              color: Colors.black54),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: size.height * 0.01,
              )
            ]),
      ),
    );
  }
}

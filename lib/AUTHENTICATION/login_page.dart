// ignore_for_file: use_build_context_synchronously
import 'dart:developer';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:seller_app/CONSTANTS/assets.dart';
import 'package:seller_app/CONSTANTS/fonts.dart';
import 'package:seller_app/CONTROLLER/network_controller.dart';
import 'package:seller_app/CONTROLLER/user_auth_controller.dart';
import 'package:seller_app/FUNCTIONS/login_auth_functions.dart';
import 'package:seller_app/PROVIDERS/auth_page_controller_provider.dart';
import 'package:seller_app/WIDGETS/BUTTONS/login_buttons.dart';
import 'package:seller_app/WIDGETS/DIALOGUE/network_error_dialogue.dart';
import 'package:seller_app/WIDGETS/Texts/helper_texts.dart';
import 'package:seller_app/WIDGETS/custom_textfield.dart';
import 'package:seller_app/WIDGETS/textfield_containers.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  FocusNode emailFocusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();
  Future<bool?> getFieldData() async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      Fluttertoast.showToast(
          msg: "Please fill  all required fields for signing in");
      return false; // or return null;
    } else {
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);

    final authProvider = Provider.of<LoginAuthProvider>(context, listen: false);
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
                  'Login Here',
                  style: TextStyle(
                    fontSize: size.width * 0.12,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontFamily: 'monuse',
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
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                child: HelperText1(
                                  text: 'Email',
                                  color: Colors.black26,
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
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                child: HelperText1(
                                  text: 'Password',
                                  color: Colors.black26,
                                ),
                              ),
                              TextFieldContainer(
                                widget: CustomTextField(
                                  textInputType: TextInputType.visiblePassword,
                                  hintText: 'Password',
                                  prefixIcon: Icons.lock_outline_rounded,
                                  isObscure: true,
                                  showSuffix: true,
                                  textInputAction: TextInputAction.done,
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
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              print('Forgotton button pressed');
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text('Forgot Password'),
                                    content: TextField(
                                      controller: emailController,
                                      decoration: const InputDecoration(
                                        labelText: 'Enter your email',
                                      ),
                                    ),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text('Cancel'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          AuthController.resetpPassword(
                                              emailController.text);
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text('Reset Password'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            child: const HelperText1(
                              text: 'Forgot password?',
                              fontSize: 15,
                              color: Colors.black45,
                            ),
                          ),
                        ),
                        AuthenticationButton(
                          onTap: () async {
                            if (10 > 2) {
                               Fluttertoast.showToast(
                                      msg: "Unable to process. Please use google signing method",
                                      backgroundColor: Colors.red[300]);
                              return;
                            }
                            final fieldData = await getFieldData();
                            if (fieldData != null && fieldData) {
                              if (await NetworkInterceptor
                                  .isNetworkAvailable()) {
                                if (fieldData != null && fieldData) {
                                  authProvider.doSignIn(
                                    context,
                                    emailController.text,
                                    passwordController.text,
                                  );
                                } else {
                                  Fluttertoast.showToast(
                                      msg: "PLease fill the necessary details");
                                }
                              } else {
                                showDialog(
                                  barrierDismissible: false,
                                  context: context,
                                  builder: (_) => NetworkErrorDialog(
                                    onPressed: () async {
                                      if (!await NetworkInterceptor
                                          .isNetworkAvailable()) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(const SnackBar(
                                                content: Text(
                                                    'Please turn on your wifi or mobile data')));
                                      } else {
                                        Navigator.pop(context);
                                      }
                                    },
                                  ),
                                );
                              }
                            }
                          },
                          text: "Login",
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
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              const Spacer(),
                              InkWell(
                                onTap: () async {
                                  showGLoading();
                                  try {
                                    await authProvider.doGoogleSignIn(context);
                                  } catch (e) {
                                    log(e.toString());
                                  } finally {
                                    Navigator.pop(context);
                                  }
                                },
                                child: SvgPicture.asset(
                                  GetAssetFile.googleIcon,
                                  width: 35,
                                  height: 35,
                                ),
                              ),
                              const SizedBox(
                                width: 15,
                              ),
                              InkWell(
                                onTap: () {
                                  Fluttertoast.showToast(
                                    msg:
                                        'Facebook login is currently not available. Please use Google Sign-In or sign up using email.',
                                  );
                                },
                                child: SvgPicture.asset(
                                  GetAssetFile.fbIcon,
                                  width: 35,
                                  height: 35,
                                ),
                              ),
                              const Spacer()
                            ],
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Provider.of<AuthPageControllerProvider>(context,
                                    listen: false)
                                .navigateToPage(1);
                          },
                          child: const HelperText1(
                              decoration: TextDecoration.underline,
                              text: 'Create a new account',
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

  void showGLoading() {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent user from dismissing dialog
      builder: (BuildContext context) {
        return const AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 10),
              Text('Logging in...'),
            ],
          ),
        );
      },
    );
  }
}

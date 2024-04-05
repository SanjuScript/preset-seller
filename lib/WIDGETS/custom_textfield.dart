import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seller_app/PROVIDERS/password_visibility_provider.dart';

class CustomTextField extends StatelessWidget {
  final TextInputType textInputType;
  final String hintText;
  final IconData prefixIcon;
  final TextInputAction textInputAction;
  final TextEditingController textEditingController;
  final FormFieldValidator? validator;
  final ValueChanged<String>? onChanged;
  final bool isObscure;
  final bool showSuffix;
  const CustomTextField(
      {super.key,
      required this.textInputType,
      required this.hintText,
      required this.prefixIcon,
      required this.isObscure,
      required this.showSuffix,
      required this.textInputAction,
      required this.textEditingController,
      this.validator,
      this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Consumer<PasswordVisibilityProvider>(builder: (context, value, _) {
      return TextFormField(
        keyboardType: textInputType,
        textInputAction: textInputAction,
        onChanged: onChanged,
        validator: validator,
        controller: textEditingController,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
          // fontFamily: 'optica',
        ),
        obscureText: isObscure ? value.isShown : false,
        decoration: InputDecoration(
          hintText: hintText,
          
          border: InputBorder.none,
          suffixIcon: showSuffix
              ? InkWell(
                  onTap: () {
                    value.toggleVisibility();
                  },
                  child: value.isShown
                      ? const Icon(Icons.remove_red_eye)
                      : const Icon(
                          Icons.remove_red_eye_outlined,
                        ),
                )
              : const SizedBox(),
          prefixIcon: Icon(
            prefixIcon,
            color: Colors.grey,
          ),
          hintStyle: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(74, 59, 59, 59),
            fontFamily: 'hando',
          ),
        ),
      );
    });
  }
}



// Widget customTextFieldSignUp(
  //     {required String text,
  //     required BuildContext context,
  //     required void Function(bool?) onChanged,
  //     required bool value}) {
  //   final ht = MediaQuery.of(context).size.height;
  //   final wt = MediaQuery.of(context).size.width;
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       const Padding(
  //           padding: EdgeInsets.symmetric(horizontal: 10),
  //           child: HelperText1(text: 'Name')),
  //       _textFieldContainer(
  //         keyboardType: TextInputType.name,
  //         context: context,
  //         hintText: 'Your name',
  //         icon: Icons.edit,
  //       ),
  //       const Padding(
  //           padding: EdgeInsets.symmetric(horizontal: 10),
  //           child: HelperText1(text: 'Email')),
  //       _textFieldContainer(
  //         keyboardType: TextInputType.emailAddress,
  //         context: context,
  //         hintText: 'example@gmail.com',
  //         icon: Icons.mail_outline_rounded,
  //       ),
  //       Align(
  //         alignment: Alignment.centerRight,
  //         child: Padding(
  //           padding: const EdgeInsets.only(left: 10, bottom: 5, right: 10),
  //           child: HelperText1(
  //               text: 'OR Register with phone number',
  //               color: Colors.blue[300]!,
  //               fontSize: 13),
  //         ),
  //       ),
  //       const Padding(
  //           padding: EdgeInsets.symmetric(horizontal: 10),
  //           child: HelperText1(text: 'Password')),
  //       _textFieldContainer(
  //         keyboardType: TextInputType.visiblePassword,
  //         context: context,
  //         hintText: 'Password',
  //         icon: Icons.remove_red_eye_outlined,
  //       ),
  //       const Padding(
  //           padding: EdgeInsets.symmetric(horizontal: 10),
  //           child: HelperText1(text: 'Retype - Password')),
  //       _textFieldContainer(
  //         context: context,
  //         keyboardType: TextInputType.visiblePassword,
  //         hintText: 'Re-enter password',
  //         icon: Icons.lock_outline_rounded,
  //       ),
  //       Row(
  //         children: [
  //           Checkbox(
  //             value: value,
  //             onChanged: onChanged,
  //           ),
  //           RichText(
  //               text: TextSpan(children: [
  //             TextSpan(
  //                 text: 'I agree to the ',
  //                 style:
  //                     TextStyle(color: Colors.grey[800], fontFamily: 'hando')),
  //             TextSpan(
  //                 text: 'Terms and Conditions',
  //                 style:
  //                     TextStyle(color: Colors.blue[300], fontFamily: 'hando')),
  //           ])),
  //         ],
  //       )
  //     ],
  //   );
  // }
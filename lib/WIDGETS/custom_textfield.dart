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
          fontWeight: FontWeight.normal,
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
          hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Colors.black45,
          )
        ),
      );
    });
  }
}


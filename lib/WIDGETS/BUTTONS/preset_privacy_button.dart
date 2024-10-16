import 'package:flutter/material.dart';
import 'package:seller_app/CUSTOM/font_controller.dart';
import 'package:seller_app/EXTENSION/capitalize.dart';
import 'package:seller_app/SCREENS/PRESET_UPLOADING/preset_uploading_policy.dart';

class PresetPrivacy extends StatelessWidget {
  const PresetPrivacy({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);

    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return const PresetUploadPolicy();
        }));
      },
      child: Container(
        height: size.height * .05,
        width: size.width * .8,
        padding: const EdgeInsets.all(5),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(
            Radius.circular(30),
          ),
        ),
        child: FittedBox(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.privacy_tip_rounded,
                color: Colors.blue[400],
                size: size.width * .06,
              ),
              const SizedBox(
                width: 10,
              ),
              Text(
                  "See this rules before uploading presets !!"
                      .capitalizeFirstLetterOfEachWord(),
                  style: PerfectTypogaphy.regular.copyWith()),
            ],
          ),
        ),
      ),
    );
  }
}

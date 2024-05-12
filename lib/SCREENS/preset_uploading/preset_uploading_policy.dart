import 'package:flutter/material.dart';
import 'package:seller_app/CONSTANTS/fonts.dart';
import 'package:seller_app/EXTENSION/capitalize.dart';
import 'package:seller_app/HELPERS/color_helper.dart';
import 'package:seller_app/WIDGETS/Texts/helper_texts.dart';

class PresetUploadPolicy extends StatelessWidget {
  const PresetUploadPolicy({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: HelperText1(
          text: "Preset Upload Policy".capitalizeFirstLetterOfEachWord(),
          color: Colors.black87,
          fontSize: 22,
        ),
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.white,
        elevation: 5,
        shadowColor: Colors.black12,
      ),
      backgroundColor: getColor("#f2f2f2"),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle("Preset Upload Policy"),
            const SizedBox(height: 20),
            _buildPolicyItem(
              "Preset Format:",
              "Presets should be in DNG format.",
            ),
            _buildPolicyItem(
              "File Size Limit:",
              "Presets should be less than 5 MB in size.",
            ),
            _buildPolicyItem(
              "Content Guidelines:",
              "Presets must not contain any violated content, including nudity or any other inappropriate material. Accounts found violating this policy will be banned.",
            ),
            _buildPolicyItem(
              "Legitimacy of Presets:",
              "Only legal and legitimate presets are allowed. Presets should not infringe on any copyrights or trademarks.",
            ),
            _buildPolicyItem(
              yes: true,
              "Company Share:",
              "The company will retain 15% of the amount paid by users for purchasing presets.",
            ),
            _buildPolicyItem(
              "Originality:",
              "Users must not upload presets that are copied from others. Presets should be original creations.",
            ),
            _buildSectionTitle("Additional Policies"),
            const SizedBox(height: 20),
            _buildPolicyItem(
              "Usage Rights:",
              "By uploading presets, users grant the platform non-exclusive rights to distribute, modify, and use the presets for promotional purposes.",
            ),
            _buildPolicyItem(
              "Quality Control:",
              "The platform reserves the right to reject presets that do not meet quality standards or violate any policies.",
            ),
            _buildPolicyItem(
              "User Accounts:",
              "Users are responsible for maintaining the security of their accounts and must not share login credentials with others.",
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 24,
          fontFamily: Getfont.rounder,
          fontWeight: FontWeight.normal,
        ),
      ),
    );
  }

  Widget _buildPolicyItem(String title, String description,
      {bool yes = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
                fontSize: 18,
                fontFamily: Getfont.mauline,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
                letterSpacing: 1.2),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: TextStyle(
                fontSize: 16, backgroundColor: yes ? Colors.yellow : null),
          ),
        ],
      ),
    );
  }
}

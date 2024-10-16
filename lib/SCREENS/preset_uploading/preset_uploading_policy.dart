import 'package:flutter/material.dart';
import 'package:seller_app/CONSTANTS/fonts.dart';
import 'package:seller_app/CUSTOM/font_controller.dart';
import 'package:seller_app/EXTENSION/capitalize.dart';
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
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle("Preset Upload Policy", Icons.policy),
            const SizedBox(height: 10),
            _buildImportantNotice(
                "Before uploading, ensure your presets meet the following criteria."),
            const SizedBox(height: 10),
            _buildPolicyItem(
              "Preset Format:",
              "Presets should be in DNG format.",
              icon: Icons.insert_drive_file,
            ),
            _buildPolicyItem(
              "File Size Limit:",
              "Presets should be less than 2 MB in size and preset applied images size should be less than 1 MB.",
              icon: Icons.data_usage,
            ),
            _buildPolicyItem(
              "Content Guidelines:",
              "Presets must not contain any violated content, including nudity or other inappropriate material. Accounts found violating this policy will be banned.",
              icon: Icons.warning,
            ),
            _buildPolicyItem(
              "Legitimacy of Presets:",
              "Only legal and legitimate presets are allowed. Presets should not infringe on any copyrights or trademarks.",
              icon: Icons.verified,
            ),
            _buildHighlightedPolicy(
              "Company Share:",
              "The company will retain 10% of the amount paid by users for purchasing presets.",
              icon: Icons.monetization_on,
              color: Colors.yellow[100],
            ),
            _buildPolicyItem(
              "Originality:",
              "Users must not upload presets that are copied from others. Presets should be original creations.",
              icon: Icons.lightbulb,
            ),
            const SizedBox(height: 30),
            _buildSectionTitle("Technical Requirements", Icons.settings),
            const SizedBox(height: 20),
            _buildPolicyItem(
              "Square Ratio:",
              "Presets must be in a 1:1 square ratio.",
              icon: Icons.aspect_ratio,
            ),
            _buildPolicyItem(
              "Resolution Limit:",
              "Presets should be under 2 MP in resolution.",
              icon: Icons.high_quality,
            ),
            const SizedBox(height: 30),
            _buildSectionTitle("Additional Policies", Icons.more_horiz),
            const SizedBox(height: 20),
            _buildPolicyItem(
              "Usage Rights:",
              "By uploading presets, users grant the platform non-exclusive rights to distribute, modify, and use the presets for promotional purposes.",
              icon: Icons.lock_open,
            ),
            _buildPolicyItem(
              "Quality Control:",
              "The platform reserves the right to reject presets that do not meet quality standards or violate any policies.",
              icon: Icons.verified_user,
            ),
            _buildPolicyItem(
              "User Accounts:",
              "Users are responsible for maintaining the security of their accounts and must not share login credentials with others.",
              icon: Icons.security,
            ),
              _buildPolicyItem(
              "Editing Capabilities:",
              "Users can edit the preset name, price, description, MRP, and offer details. They can also change or remove cover images, but preset images can be removed but cant be changed.",
              icon: Icons.edit,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, size: 28, color: Colors.black87),
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 24,
              fontFamily: Getfont.rounder,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPolicyItem(String title, String description, {IconData? icon}) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.blueAccent, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                
                    style: PerfectTypogaphy.regular.copyWith(
                      fontSize: 18,
                      color: Colors.black87,

                      letterSpacing: .2,
                    )),
                const SizedBox(height: 8),
                Text(description,
                    style: PerfectTypogaphy.regular.copyWith(
                      fontSize: 13,
                      color: Colors.black54,
                      letterSpacing: .2,
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImportantNotice(String message) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.orange[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline, color: Colors.orange, size: 28),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.orange,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHighlightedPolicy(String title, String description,
      {IconData? icon, Color? color}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color ?? Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.green, size: 20),
          const SizedBox(width: 8),
          Expanded(
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
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 16,
                    fontFamily: Getfont.rounder,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

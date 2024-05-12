import 'package:flutter/material.dart';
import 'package:seller_app/EXTENSION/capitalize.dart';
import 'package:seller_app/EXTENSION/color_extension.dart';
import 'package:seller_app/WIDGETS/Texts/helper_texts.dart';

class WithdrawalHelpPage extends StatelessWidget {
  const WithdrawalHelpPage({super.key,});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: "#f2f2f2".toColor(),
      appBar: AppBar(
        title: HelperText1(
          text: "Help here".capitalizeFirstLetterOfEachWord(),
          color: Colors.black87,
          fontSize: 25,
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            _buildSectionTitle('Withdrawal Process Help'),
            const SizedBox(height: 20),
            _buildHelpItem(
              'Ensure you have sufficient balance in your wallet before initiating a withdrawal.',
            ),
            _buildHelpItem(
              'Double-check the UPI ID or phone number you enter for withdrawal. Make sure it is correct to avoid any transfer errors.',
            ),
            _buildHelpItem(
              'Withdrawals may take some time to process depending on the payment gateway used. Please be patient.',
            ),
            _buildHelpItem(
              'Contact customer support if you encounter any issues or have questions regarding the withdrawal process.',
            ),
            _buildHelpItem(
              'Once the withdrawal is processed, you will receive a notification.',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildHelpItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.circle,
            size: 12,
            color: Colors.black87,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}

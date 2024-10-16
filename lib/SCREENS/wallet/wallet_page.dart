import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:seller_app/CONSTANTS/fonts.dart';
import 'package:seller_app/EXTENSION/capitalize.dart';
import 'package:seller_app/EXTENSION/color_extension.dart';
import 'package:seller_app/FUNCTIONS/wallet_access_function.dart';
import 'package:seller_app/HELPERS/date_helper.dart';
import 'package:seller_app/MODEL/wallet_data_model.dart';
import 'package:seller_app/WIDGETS/BUTTONS/preset_uploading.button.dart';
import 'package:seller_app/WIDGETS/BUTTONS/wallet_help_popmenu.dart';
import 'package:seller_app/WIDGETS/Texts/helper_texts.dart';
import 'package:seller_app/WIDGETS/editing_fields.dart';

class WalletPage extends StatelessWidget {
  WalletPage({super.key});

  final TextEditingController upiController = TextEditingController();
  final TextEditingController amountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Scaffold(
      appBar: AppBar(
        title: HelperText1(
          text: "Wallet".capitalizeFirstLetterOfEachWord(),
          color: Colors.black87,
          fontSize: 25,
        ),
        actions: [
          HelpPopupMenu(context: context),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: size.height * .20,
                width: size.width * .85,
                child: Card(
                  elevation: 4,
                  color: Colors.white,
                  surfaceTintColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: StreamBuilder<WalletModel?>(
                      stream: WalletController.getWalletDataStream(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(
                              color: Colors.black87,
                            ),
                          );
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else {
                          final walletData = snapshot.data;
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                             const HelperText1(
                                text: "Current Balance in INR",
                                color: Colors.black87,
                                fontSize: 23,
                              ),
                              Text(
                                '${walletData?.balance ?? 0}', // Replace with actual balance
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontFamily: Getfont.rounder,
                                  color: Colors.black87,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Text(
                                'Last Updated',
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                DataFormateHelper.formateDateWithHrs(
                                  walletData?.lastUpdated,
                                ),
                                style: const TextStyle(
                                  fontSize: 15,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                '(A 2% Tax is Applicable on Transactions)',
                                style: TextStyle(
                                  fontSize: size.width * .03,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          );
                        }
                      },
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8, right: 8, left: 8),
                child: Text(
                  'Enter correct details',
                  style: TextStyle(
                      fontSize: size.width * .04,
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                      wordSpacing: 1.2),
                ),
              ),
              SizedBox(height: 15),
              ProfileEditingFields(
                isNeed: false,
                isDesc: false,
                color: const Color.fromARGB(10, 0, 0, 0),
                textInputType: TextInputType.text,
                controller: upiController,
                upText: "",
                hintText: "Enter your UPI ID",
                isInsta: false,
              ),
              SizedBox(height: 15),
              ProfileEditingFields(
                isNeed: false,
                isDesc: false,
                color: const Color.fromARGB(10, 0, 0, 0),
                textInputType: TextInputType.number,
                controller: amountController,
                upText: "",
                hintText: "Enter the amount",
                isInsta: false,
              ),
              const SizedBox(
                height: 15,
              ),
              StreamBuilder<WalletModel?>(
                  stream: WalletController.getWalletDataStream(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Text(
                          'Withdrawel not possible now: ${snapshot.error}');
                    } else {
                      final walletData = snapshot.data;

                      if (snapshot.hasData && walletData != null) {
                        if (walletData.isWithrawing!) {
                          return const Text(
                            'Withdrawal Successful!\n\n'
                            'Your withdrawal request has been successfully processed. The withdrawn amount will be credited to your account within 7 days due to the rush of withdrawals.\n\n'
                            'Please note that you can initiate another withdrawal after receiving the withdrawn amount in your account. If you encounter any issues or have questions, feel free to contact our customer support team.\n\n'
                            'Thank you for using our service!',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16.0,
                              color: Colors.black87,
                              fontWeight: FontWeight.normal,
                            ),
                          );
                        } else {
                          return GetPresetUploadingButton(
                            textColor: Colors.white70,
                            onPressed: () async {
                              double? amount =
                                  double.tryParse(amountController.text);

                              if (upiController.text.isNotEmpty) {
                                if (amount != null &&
                                    amount > 0 &&
                                    amount <= walletData.balance!) {
                                  double newBalance =
                                      walletData.balance! - amount;
                                  try {
                                    newBalance = double.parse(
                                        newBalance.toStringAsFixed(2));
                                    await WalletController.updateIsWithdrawing(
                                        isWithdrawing: true,
                                        amount: newBalance);
                                    Navigator.pop(context);
                                    Fluttertoast.showToast(
                                      msg: "Withdrawal successful",
                                      gravity: ToastGravity.BOTTOM,
                                      backgroundColor: Colors.green,
                                      textColor: Colors.white,
                                    );
                                  } catch (e) {
                                    log(e.toString());
                                  }
                                } else {
                                  Fluttertoast.showToast(
                                    msg:
                                        "Invalid amount or insufficient balance",
                                  );
                                }
                              } else {
                                Fluttertoast.showToast(
                                    msg: "Please enter a valid UPI ID");
                              }
                            },
                            text: "Withdraw",
                          );
                        }
                      } else {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    }
                  }),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Dear User, please note that you are initiating a withdrawal. Ensure that you enter the correct UPI ID for withdrawal. The app owners are not responsible for any issues that may arise due to incorrect entry. Thank you for your understanding.",
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                    fontSize: size.width * .03,
                    color: Colors.black,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:seller_app/EXTENSION/color_extension.dart';
import 'package:seller_app/FUNCTIONS/payment_upload_functions.dart';
import 'package:seller_app/WIDGETS/BUTTONS/preset_uploading.button.dart';
import 'package:seller_app/WIDGETS/editing_fields.dart';

class PaymentDetailsPage extends StatelessWidget {
  PaymentDetailsPage({super.key});

  final TextEditingController accountNumber = TextEditingController();
  final TextEditingController accountHolderName = TextEditingController();
  final TextEditingController accountIFSC = TextEditingController();
  final TextEditingController upiID = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Scaffold(
      backgroundColor: "#f2f2f2".toColor(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5.0),
                  child: Text(
                    'Please provide accurate payment details below to ensure smooth transactions in the future:',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                  child: Text(
                    'You can provide payment details only once.Please fill all fields carefully.',
                    maxLines: 2,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.red[200],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20)),
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      ProfileEditingFields(
                        isNeed: false,
                        isDesc: false,
                        color: const Color.fromARGB(10, 0, 0, 0),
                        textInputType: TextInputType.number,
                        controller: accountNumber,
                        upText: "",
                        hintText: "Bank Account Number",
                        isInsta: false,
                      ),
                      ProfileEditingFields(
                        isNeed: false,
                        isDesc: false,
                        color: const Color.fromARGB(10, 0, 0, 0),
                        textInputType: TextInputType.name,
                        controller: accountHolderName,
                        upText: "",
                        hintText: "Account Holder Name",
                        isInsta: false,
                      ),
                      const SizedBox(height: 10),
                      ProfileEditingFields(
                        isNeed: false,
                        isDesc: false,
                        color: const Color.fromARGB(10, 0, 0, 0),
                        textInputType: TextInputType.text,
                        controller: accountIFSC,
                        upText: "",
                        hintText: "IFSC code",
                        isInsta: false,
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Expanded(
                                child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 5),
                              color: Colors.grey,
                              height: 1,
                            )),
                            const Text('Or'),
                            Expanded(
                                child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 5),
                              color: Colors.grey,
                              height: 1,
                            )),
                          ],
                        ),
                      ),
                      ProfileEditingFields(
                        isNeed: false,
                        isDesc: false,
                        color: const Color.fromARGB(10, 0, 0, 0),
                        textInputType: TextInputType.text,
                        controller: upiID,
                        upText: "",
                        hintText: "UPI Number or ID",
                        isInsta: false,
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Note: We securely store your payment details for future transactions.',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: 15),
                GetPresetUploadingButton(
                  onPressed: () async {
                   try {
                      if (accountNumber.text.isNotEmpty &&
                        accountHolderName.text.isNotEmpty &&
                        accountIFSC.text.isNotEmpty &&
                        upiID.text.isEmpty) {
                      // await PaymentDataController.uploadPaymentDetails(
                      //   bankAccountNumber: accountNumber.text,
                      //   accountHolderName: accountHolderName.text,
                      //   ifscCode: accountIFSC.text,
                      //   upiNumberOrId: upiID.text,
                      // );
                      if (FocusNode().hasFocus) {
                        FocusNode().unfocus();
                        Navigator.pop(context);
                      }
                      Navigator.pop(context);
                    } else if (accountNumber.text.isNotEmpty &&
                        upiID.text.isNotEmpty) {
                      Fluttertoast.showToast(
                        msg:
                            'Please provide only one of Bank Account Number or UPI Number or ID',
                      );
                    } else if (accountNumber.text.isEmpty &&
                        accountHolderName.text.isEmpty &&
                        accountIFSC.text.isEmpty &&
                        upiID.text.isNotEmpty) {
                      // await PaymentDataController.uploadPaymentDetails(
                      //   bankAccountNumber: accountNumber.text,
                      //   accountHolderName: accountHolderName.text,
                      //   ifscCode: accountIFSC.text,
                      //   upiNumberOrId: upiID.text,
                      // );
                    } else {
                      Fluttertoast.showToast(
                        msg: 'Please fill the necessary fields',
                      );
                    }
                   } catch (e) {
                      log('Error during navigation: $e');
                   }
                  },
                  text: "Submit",
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

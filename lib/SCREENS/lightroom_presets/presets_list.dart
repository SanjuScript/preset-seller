import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:seller_app/API/auth_api.dart';
import 'package:seller_app/FUNCTIONS/admin_data_controller_unit.dart';
import 'package:seller_app/MODEL/preset_data_model.dart';
import 'package:seller_app/SCREENS/lightroom_presets/preset_view_page.dart';
import 'package:seller_app/SCREENS/preset_uploading/preset_pack_uploading_page.dart';
import 'package:seller_app/SCREENS/preset_uploading/preset_uploading_page.dart';
import 'package:seller_app/WIDGETS/BUTTONS/preset_upload_button.dart';
import 'package:seller_app/WIDGETS/CARD/preset_card.dart';
import 'package:seller_app/WIDGETS/DIALOGUE/DIALOGUE_UTILS/dialogue_utils.dart';
import 'package:seller_app/WIDGETS/Texts/helper_texts.dart';
import 'package:seller_app/WIDGETS/pop_menu_button.dart';

class PresetListPage extends StatefulWidget {
  const PresetListPage({super.key});

  @override
  State<PresetListPage> createState() => _PresetListPageState();
}

class _PresetListPageState extends State<PresetListPage> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: HelperText1(
          text: "Your Presets",
          color: Colors.black87,
          fontSize: size.width * .07,
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('admins')
                  .doc(AuthApi.auth.currentUser!.uid)
                  .collection('lightroom_presets')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                      child: HelperText1(
                    text: "No presets available",
                    color: Colors.black87,
                  ));
                }

                final documents = snapshot.data!.docs;
                log(documents[0].data().toString());

                return ListView.builder(
                  itemCount: documents.length,
                  itemBuilder: (context, index) {
                    final data =
                        documents[index].data() as Map<String, dynamic>;
                    final presetModel = PresetModel.fromJson(data);
                    return PresetCard(
                      color: presetModel.status == "rejected"
                          ? Colors.red[400]!
                          : Colors.white,
                      isPaid: presetModel.isPaid!,
                      length: presetModel.presets?.length ?? 0,
                      isListed: presetModel.isList!,
                      url: presetModel.presets!.first ?? '',
                      presetName: presetModel.name.toString(),
                      price: presetModel.price.toString(),
                      status: presetModel.status.toString(),
                      tag: presetModel.presets.toString(),
                      onLongPress: () {
                        DialogueUtils.showDialogue(context, 'pDelete',
                            arguments: [presetModel.docId.toString()]);
                      },
                      onTap: () {
                        // log(presetModel.toJson().toString());
                        if (presetModel.status != "rejected") {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return PresetViewPage(presetModel: presetModel);
                          }));
                        } else {
                          // DataController.downloadDNGFile(
                          //     presetModel.presets!.last, "${presetModel.name}");
                          Fluttertoast.showToast(
                            msg: "See notification tab for more details",
                            backgroundColor: Colors.red,
                          );
                          // log(presetModel.presets!.last);
                        }
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: UploadPresetButton(
        onUpload: (p0) {
          if (AuthApi.auth.currentUser!.emailVerified) {
            if (p0 == 'single') {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const SinglePresetUploadingPage()));
            } else {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const PresetPackUploadingPage()));
            }
          } else {
            Fluttertoast.showToast(
              msg: "Please verify your email",
              backgroundColor: Colors.red,
            );
          }
        },
      ),
    );
  }
}

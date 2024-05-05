import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:seller_app/API/auth_api.dart';
import 'package:seller_app/FUNCTIONS/admin_data_controller_unit.dart';
import 'package:seller_app/HELPERS/color_helper.dart';
import 'package:seller_app/MODEL/preset_data_model.dart';
import 'package:seller_app/SCREENS/lightroom_presets/preset_view_page.dart';
import 'package:seller_app/SCREENS/preset_pack_uploading_page.dart';
import 'package:seller_app/SCREENS/preset_uploading_page.dart';
import 'package:seller_app/WIDGETS/CARD/preset_card.dart';
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
      backgroundColor: getColor("#f2f2f2"),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: HelperText1(
          text: "Your Presets",
          color: Colors.black87,
          fontSize: size.width * .07,
        ),
        surfaceTintColor: Colors.transparent,
        // backgroundColor: Colors.transparent,
        actions: [
          CustomPopupMenuButton(
            text2: "Preset Pack",
            text1: 'Single Preset',
            iconData1: Icons.file_upload,
            iconData2: Icons.file_upload,
            mainIcon: Icons.add,
            onItemSelected: (p0) async {
              if (p0 == 'Single Preset') {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            const SinglePresetUploadingPage()));
              } else {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const PresetPackUploadingPage()));
              }
            },
          ),
        ],
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
                  return const Center(child: Text('No presets available'));
                }

                final documents = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: documents.length,
                  itemBuilder: (context, index) {
                    final data =
                        documents[index].data() as Map<String, dynamic>;
                    // log(data.toString());

                    final presetModel = PresetModel.fromJson(data);

                    return PresetCard(
                      length: presetModel.presets?.length ?? 0,
                      isListed: presetModel.isList!,
                      url: presetModel.presets!.first ?? '',
                      presetName: presetModel.name.toString(),
                      price: presetModel.price.toString(),
                      status: presetModel.status.toString(),
                      tag: presetModel.presets.toString(),
                      onTap: () {
                        if (presetModel.status != "rejected") {
                          Navigator.pushNamed(context, "/presetView",
                              arguments: {
                                "presetModel": presetModel,
                              });

                          // DataController.deleteDocument(
                          //     presetModel.docId.toString());
                        } else {
                          // DataController.downloadDNGFile(
                          //     presetModel.presets!.last, "${presetModel.name}");
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
    );
  }
}

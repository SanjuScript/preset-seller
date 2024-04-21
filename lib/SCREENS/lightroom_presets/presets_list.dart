import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:seller_app/API/auth_api.dart';
import 'package:seller_app/FUNCTIONS/admin_data_controller_unit.dart';
import 'package:seller_app/FUNCTIONS/files_upload_auth_functions.dart';
import 'package:seller_app/HELPERS/color_helper.dart';
import 'package:seller_app/MODEL/preset_data_model.dart';
import 'package:seller_app/SCREENS/lightroom_presets/preset_view_page.dart';
import 'package:seller_app/SCREENS/preset_uploading_page.dart';
import 'package:seller_app/WIDGETS/CARD/preset_card.dart';
import 'package:seller_app/WIDGETS/Texts/helper_texts.dart';

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
      body: Column(
        children: [
          const SizedBox(height: 50),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              "Your Presets",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
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

                    log(presetModel.presets!.first.toString());
                    // return Image.network(presetModel.presets![index]);

                    // if (presetModel.presets != null) {
                    // Handling for list presets
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
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PresetViewPage(
                                presetModel: presetModel,
                                docId: documents[index].id,
                              ),
                            ),
                          );
                        } else {
                          DataController.downloadDNGFile(
                              presetModel.presets!.last, "${presetModel.name}");
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
      floatingActionButton: InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const SinglePresetUploadingPage()));
        },
        child: Container(
          height: size.height * .10,
          width: size.width * .40,
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                offset: Offset(2, -2),
                blurRadius: 10,
              ),
              BoxShadow(
                color: Colors.black26,
                offset: Offset(-2, 2),
                blurRadius: 10,
              ),
            ],
          ),
          child: Center(
            child: Icon(
              Icons.add_rounded,
              size: size.width * .10,
              color: Colors.black87,
            ),
          ),
        ),
      ),
    );
  }
}

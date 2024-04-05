import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:seller_app/API/auth_api.dart';
import 'package:seller_app/FUNCTIONS/files_upload_auth_functions.dart';
import 'package:seller_app/HELPERS/color_helper.dart';
import 'package:seller_app/MODEL/preset_data_model.dart';
import 'package:seller_app/SCREENS/lightroom_presets/preset_view_page.dart';
import 'package:seller_app/WIDGETS/CARD/preset_card.dart';

class PresetListPage extends StatefulWidget {
  const PresetListPage({Key? key}) : super(key: key);

  @override
  State<PresetListPage> createState() => _PresetListPageState();
}

class _PresetListPageState extends State<PresetListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: getColor("#f2f2f2"),
      body: Column(
        children: [
          SizedBox(height: 50),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
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
                  return Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(child: Text('No presets available'));
                }

                final documents = snapshot.data!.docs;

                // Separate list and single presets
                // List<Map<String, dynamic>> listPresets = [];
                // List<Map<String, dynamic>> singlePresets = [];

                // for (var document in documents) {
                //   final data = document.data() as Map<String, dynamic>;
                //   if (data['presets'] is List) {
                //     listPresets.add(data);
                //   } else {
                //     singlePresets.add(data);
                //   }
                // }

                return ListView.builder(
                  itemCount: documents.length,
                  itemBuilder: (context, index) {
                    final data =
                        documents[index].data() as Map<String, dynamic>;
                    final presetModel = PresetModel.fromJson(data);
                    if (presetModel.presets != null) {
                      // Handling for list presets
                      return PresetCard(
                        length: presetModel.presets?.length ??
                            0, // Check if presets is null
                        isListed: presetModel.presets != null,
                        url: presetModel.presets?.first ??
                            '', // Check if presets is null
                        presetName: presetModel.name.toString(),
                        price: presetModel.price.toString(),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PresetViewPage(
                                presetModel: presetModel,
                                docId: documents[index].id,
                              ),
                            ),
                          );
                          log(presetModel.name!);
                        },
                      );
                    } else {
                      // Handling for single presets
                      return PresetCard(
                        length: presetModel.preset!.length.toInt(),
                        isListed: presetModel.presets != null,
                        url: presetModel.preset.toString(),
                        presetName: presetModel.name.toString(),
                        price: presetModel.price.toString(),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PresetViewPage(
                                presetModel: presetModel,
                                docId: documents[index].id,
                              ),
                            ),
                          );
                          log(presetModel.name!);
                        },
                      );
                    }
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

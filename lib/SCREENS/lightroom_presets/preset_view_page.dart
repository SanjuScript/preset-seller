import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:seller_app/EXTENSION/capitalize.dart';
import 'package:seller_app/FUNCTIONS/files_upload_auth_functions.dart';
import 'package:seller_app/HELPERS/color_helper.dart';
import 'package:seller_app/MODEL/preset_data_model.dart';
import 'package:seller_app/WIDGETS/CARD/list_of_presets_card.dart';
import 'package:seller_app/WIDGETS/CARD/preset_card.dart';

class PresetViewPage extends StatefulWidget {
  final PresetModel presetModel;
  final String docId;
  const PresetViewPage({super.key, required this.presetModel,required this.docId});

  @override
  State<PresetViewPage> createState() => _PresetViewPageState();
}

class _PresetViewPageState extends State<PresetViewPage> {
  final PageController pageController = PageController(viewportFraction: .8);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);

    return Scaffold(
      backgroundColor: getColor("#f2f2f2"),
      body: Center(
        child: Column(
          children: [
            const SizedBox(
              height: 50,
            ),
            Container(
              height: size.height * 0.70,
              width: size.width * 0.90,
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey[300]!,
                    offset: const Offset(3, -3),
                    blurRadius: 10,
                  ),
                  BoxShadow(
                    color: Colors.grey[300]!,
                    offset: const Offset(-3, 3),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Column(
                children: [
                  SizedBox(
                      height: size.height * 0.31,
                      width: size.width * 0.90,
                      child: widget.presetModel.presets != null
                          ? PageView.builder(
                              controller: pageController,
                              itemCount: widget.presetModel.presets != null
                                  ? widget.presetModel.presets!.length
                                  : 1,
                              itemBuilder: (context, index) {
                                return Column(
                                  children: [
                                    InkWell(
                                      onLongPress: () {
                                        // DataUploadAdmin.deletePreset(widget.presetModel.presets![index]);
                                      },
                                      child: ListOfPresets(
                                        url: widget.presetModel.presets![index],
                                        onTap: () {},
                                      ),
                                    ),
                                    Text(
                                      "${index + 1}/${widget.presetModel.presets!.length}"
                                          .toString()
                                          .capitalizeFirstLetterOfEachWord(),
                                      style: TextStyle(
                                        fontSize: size.width * 0.05,
                                        overflow: TextOverflow.ellipsis,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                );
                              },
                            )
                          : PageView(
                              children: [
                                Column(
                                  children: [
                                    InkWell(
                                      onLongPress: () {
                                        // DataUploadAdmin.deletePreset(widget.presetModel.presets![index]);
                                      },
                                      child: ListOfPresets(
                                        url: widget.presetModel.preset
                                                .toString() ??
                                            '',
                                        onTap: () {},
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            )),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    widget.presetModel.name
                        .toString()
                        .capitalizeFirstLetterOfEachWord(),
                    style: TextStyle(
                      fontSize: size.width * 0.06,
                      overflow: TextOverflow.ellipsis,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontFamily: 'hando',
                    ),
                  ),
                  Text(
                    "${widget.presetModel.price} RS"
                        .toString()
                        .capitalizeFirstLetterOfEachWord(),
                    style: TextStyle(
                      fontSize: size.width * 0.06,
                      overflow: TextOverflow.ellipsis,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontFamily: 'rounder',
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      if (widget.presetModel.presets != null) {
                        DataUploadAdmin.addMoreImagesToPresetList(widget.docId);
                      }
                    },
                    child: Container(
                      height: size.height * 0.20,
                      width: size.width * 0.90,
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(
                            color: Colors.black.withOpacity(.5), width: 3),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey[300]!,
                            offset: const Offset(3, -3),
                            blurRadius: 10,
                          ),
                          BoxShadow(
                            color: Colors.grey[300]!,
                            offset: const Offset(-3, 3),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      child: Center(
                        child: Icon(Icons.add),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ignore_for_file: use_build_context_synchronously

import 'dart:developer';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:seller_app/CONSTANTS/fonts.dart';
import 'package:seller_app/EXTENSION/capitalize.dart';
import 'package:seller_app/FUNCTIONS/admin_data_controller_unit.dart';
import 'package:seller_app/FUNCTIONS/files_upload_auth_functions.dart';
import 'package:seller_app/HELPERS/color_helper.dart';
import 'package:seller_app/MODEL/preset_data_model.dart';
import 'package:seller_app/PROVIDERS/page_view_controller_provider.dart';
import 'package:seller_app/SCREENS/preset_metadata_edit.dart';
import 'package:seller_app/WIDGETS/BUTTONS/preset_metadata_edit_buttons.dart';
import 'package:seller_app/WIDGETS/CARD/list_of_presets_card.dart';
import 'package:seller_app/WIDGETS/CARD/multi_preset_view.dart';
import 'package:seller_app/WIDGETS/DIALOGUE/delete_single_preset.dart';
import 'package:seller_app/WIDGETS/DIALOGUE/deletion_dialogue.dart';
import 'package:seller_app/WIDGETS/Texts/helper_text2.dart';
import 'package:seller_app/WIDGETS/Texts/preset_name_price_text.dart';
import 'package:seller_app/WIDGETS/Texts/preset_page_helper_text.dart';
import 'package:seller_app/WIDGETS/Texts/preset_page_read_more_text.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class PresetViewPage extends StatefulWidget {
  const PresetViewPage({super.key});

  @override
  State<PresetViewPage> createState() => _PresetViewPageState();
}

class _PresetViewPageState extends State<PresetViewPage> {
  late PageController pageController;
  bool currentStatus = false;
  void onPageChange(int index) {
    final provider = context.read<PresetsPageViewContollerProvider>();
    provider.selectedIndex = index;
  }

  ScrollController scrollController = ScrollController();
// Function to pick images from device storage

  List<File> selectedImages = [];
  Future<void> pickImages() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        compressionQuality: 35,
        allowMultiple: true,
        allowedExtensions: ['jpg', 'jpeg'],
      );
      final xfilePicks = result!.xFiles;

      setState(() {
        // Add newly selected images to the list
        if (xfilePicks != null) {
          for (var i = 0; i < xfilePicks.length; i++) {
            selectedImages.add(File(xfilePicks[i].path));
          }
        } else {
          Fluttertoast.showToast(msg: 'Nothing is selected');
        }
      });
    } catch (e) {
      print('Error picking images: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    final provider = context.read<PresetsPageViewContollerProvider>();
    pageController = provider.createPageController();
    // currentStatus = presetModel.status == "approved";
  }

  @override
void didChangeDependencies() {
  super.didChangeDependencies();
  final Map<String, dynamic> arguments =
      ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
  final PresetModel presetModel = arguments['presetModel'];
  if (presetModel != null) {
    setState(() {
      currentStatus = presetModel.status == "approved";
    });
  } else {
    // Handle the case where presetModel is null
    // For example, show an error message or navigate back
    Navigator.pop(context);
  }
}

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // log(widget.presetModel.presets.toString());
    Size size = MediaQuery.sizeOf(context);
    final provider = Provider.of<PresetsPageViewContollerProvider>(context);
    final Map<String, dynamic> arguments =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
   final PresetModel presetModel = arguments['presetModel'];

    return Scaffold(
      backgroundColor: getColor("#f2f2f2"),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: getColor("#f2f2f2"),
        elevation: 1,
        shadowColor: Colors.grey,
        surfaceTintColor: Colors.transparent,
        title: Text(
          "Lightroom Presets - ${presetModel.presets!.length.toString()}",
          style: TextStyle(
            fontSize: size.width * 0.06,
            overflow: TextOverflow.ellipsis,
            color: Colors.black,
            fontFamily: 'rounder',
          ),
        ),
      ),
      body: SingleChildScrollView(
        controller: scrollController,
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            Column(
              children: [
                SizedBox(
                  height: size.height * 0.40,
                  width: size.width * 0.98,
                  child: Stack(
                    children: [
                      PageView.builder(
                        controller: pageController,
                        itemCount: presetModel.presets!.length +
                            presetModel.coverImages!.length,
                        onPageChanged: onPageChange,
                        itemBuilder: (context, index) {
                          if (index < presetModel.presets!.length) {
                            return ListOfPresets(
                              url: presetModel.presets![index],
                            );
                          } else {
                            int coverIndex =
                                index - presetModel.presets!.length;
                            return ListOfPresets(
                              url: presetModel.coverImages![coverIndex],
                            );
                          }
                        },
                      ),
                      if (!currentStatus)
                        Align(
                          alignment: Alignment.center,
                          child: Container(
                            height: size.height * 0.40,
                            width: size.width * 0.98,
                            decoration: BoxDecoration(
                                color: Colors.white.withOpacity(.8),
                                borderRadius: BorderRadius.circular(20)),
                            child: Center(
                              child: Text(
                                "In review".capitalizeFirstLetterOfEachWord(),
                                style: TextStyle(
                                  fontSize: size.width * 0.04,
                                  overflow: TextOverflow.ellipsis,
                                  color: Colors.black54,
                                  fontFamily: Getfont.rounder,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 15),
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            height: size.height * .02,
                            width: size.width * .25,
                            decoration: BoxDecoration(
                                color: Colors.grey.withOpacity(0),
                                borderRadius: BorderRadius.circular(20)),
                            child: Center(
                              child: SmoothPageIndicator(
                                controller: pageController, // PageController
                                count: presetModel.presets!.length +
                                    presetModel.coverImages!.length,
                                effect: const WormEffect(
                                  dotWidth: 8,
                                  dotColor: Colors.white,
                                  activeDotColor: Colors.black87,
                                  dotHeight: 8,
                                ),
                                onDotClicked: (index) {
                                  provider.navigateToPage(
                                      pageController, index);
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: size.height * .11,
                  width: size.width * .90,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: presetModel.presets!.length +
                        presetModel.coverImages!.length +
                        2,
                    itemBuilder: (context, index) {
                      if (index < presetModel.presets!.length) {
                        return PresetAndCoverImageView(
                          onTap: () {
                            provider.navigateToPage(pageController, index);
                          },
                          index: index,
                          imgUrl: presetModel.presets![index],
                        );
                      } else if (index == presetModel.presets!.length) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 15),
                          child: VerticalDivider(
                            thickness: 2,
                          ),
                        );
                      } else if (index ==
                          presetModel.presets!.length +
                              presetModel.coverImages!.length +
                              1) {
                        return SizedBox(
                          height: size.height * .10,
                          width: size.width * .26,
                          child: InkWell(
                            onTap: () async {
                              DataUploadAdmin.addMoreCoverImages(
                                  docId: presetModel.docId.toString(),
                                  isListedPreset: presetModel.isList!);
                            },
                            child: Container(
                                margin: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.grey[350],
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(Icons.add_a_photo_rounded)),
                          ),
                        );
                      } else {
                        int coverIndex =
                            index - presetModel.presets!.length - 1;
                        return PresetAndCoverImageView(
                          onLongPress: () async {
                            log(coverIndex.toString());
                            if (currentStatus) {
                              bool confirm =
                                  await showSingleImageDeleteDialogue(
                                      context: context,
                                      imageUrl: presetModel
                                          .coverImages![coverIndex]);

                              if (confirm) {
                                DataController.deleteCoverImageByUrl(
                                    docId: presetModel.docId.toString(),
                                    coverImageUrl: presetModel.coverImages![coverIndex]);
                              }
                            }
                          },
                          onTap: () {
                            provider.navigateToPage(pageController, index - 1);
                          },
                          index: index - 1,
                          imgUrl: presetModel.coverImages![coverIndex],
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            GetPresetNameGiver(
              presetName: presetModel.name.toString(),
              price: presetModel.price.toString(),
            ),
            GetReadMoreText(text: presetModel.description.toString()),
            GetPresetEditButton(
              onPressed: () {
                if (currentStatus) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PresetMetadataEditingPage(
                                presetModel: presetModel,
                              )));
                } else {
                  Fluttertoast.showToast(
                      msg: "You can perform this action after reviewing");
                }
              },
              status: currentStatus,
              isDeleteButton: false,
            ),
            const SizedBox(
              height: 20,
            ),
            GetPresetEditButton(
              onPressed: () async {
                if (currentStatus) {
                  bool confirmDelete = await showDeletionDialogue(
                      context: context,
                      text:
                          "Are you sure you want to delete this preset pack? This action cannot be undone.");
                  if (confirmDelete) {
                    DataController.deleteDocument(presetModel.docId.toString());
                    Navigator.pop(context);
                    // print("object");
                  }
                }
              },
              status: currentStatus,
              isDeleteButton: true,
            ),
            const SizedBox(
              height: 20,
            ),
            const Padding(
              padding: EdgeInsets.only(left: 20.0),
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: GetText1(text: "Details")),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              height: size.height * .15,
              width: size.width * .90,
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GetText1(
                          text: "people purchased"
                              .capitalizeFirstLetterOfEachWord()),
                      GetText1(
                          text:
                              presetModel.presetsBoughtCount.toString())
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GetText1(text: "Likes".capitalizeFirstLetterOfEachWord()),
                      GetText1(text: presetModel.likeCount.toString())
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GetText1(
                          text: "Shares".capitalizeFirstLetterOfEachWord()),
                      GetText1(text: presetModel.shares.toString())
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            if (!currentStatus)
              const HelperText2(
                text:
                    "Please note that our review process may take up to 7 days due to the high volume of submissions we receive",
                color: Colors.black45,
              ),
            const SizedBox(
              height: 30,
            ),
          ],
        ),
      ),
    );
  }
}

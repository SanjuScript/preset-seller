import 'dart:developer';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:seller_app/EXTENSION/capitalize.dart';
import 'package:seller_app/FUNCTIONS/files_upload_auth_functions.dart';
import 'package:seller_app/HELPERS/color_helper.dart';
import 'package:seller_app/WIDGETS/BUTTONS/preset_privacy_button.dart';
import 'package:seller_app/WIDGETS/BUTTONS/preset_uploading.button.dart';
import 'package:seller_app/WIDGETS/BUTTONS/verification_widget.dart';
import 'package:seller_app/WIDGETS/Texts/helper_texts.dart';
import 'dart:math' as math;

import 'package:seller_app/WIDGETS/editing_fields.dart';

class SinglePresetUploadingPage extends StatefulWidget {
  const SinglePresetUploadingPage({super.key});

  @override
  State<SinglePresetUploadingPage> createState() =>
      _SinglePresetUploadingPageState();
}

class _SinglePresetUploadingPageState extends State<SinglePresetUploadingPage> {
  File? _image;
  List<File> selectedImages = [];
  List<File> presetAdd = [];
  ScrollController scrollController = ScrollController();
  TextEditingController presetNameController = TextEditingController();
  TextEditingController presetPriceController = TextEditingController();
  TextEditingController presetDescriptionController = TextEditingController();

  Future<void> getListOfImages() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      compressionQuality: 35,
      allowMultiple: true,
      allowedExtensions: ['jpg', 'jpeg'],
    );

    final xfilePicks = result!.xFiles;

    setState(() {
      if (xfilePicks != null) {
        for (var i = 0; i < xfilePicks.length; i++) {
          if (selectedImages.length < 4) {
            selectedImages.add(File(xfilePicks[i].path));
          } else {
            break;
          }
        }
      } else {
        Fluttertoast.showToast(msg: 'Nothing is selected');
      }
    });
  }

  Future<void> getImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      compressionQuality: 0,
      allowCompression: false,
      allowedExtensions: [
        'dng',
      ],
    );

    if (result!.xFiles.single.path != null) {
      final File imageFile = File(result.xFiles.single.path);
      final fileLength = await imageFile.length();
      if (fileLength <= 5 * 1024 * 1024) {
        setState(() {
          _image = File(result.xFiles.single.path);
          presetAdd.clear();
          presetAdd.add(File(result.xFiles.single.path));
        });
      } else {
        Fluttertoast.showToast(msg: "File size must be less tha 5Mb");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    log(presetAdd.length.toString());
    log(selectedImages.length.toString());

    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: HelperText1(
          text: " Upload Preset ".capitalizeFirstLetterOfEachWord(),
          color: Colors.black87,
          fontSize: 22,
        ),
        surfaceTintColor: Colors.white,
        elevation: 5,
        shadowColor: Colors.black12,
        backgroundColor: Colors.white,
      ),
      backgroundColor: getColor("#f2f2f2"),
      body: SingleChildScrollView(
        controller: scrollController,
        child: Column(
          children: [
            SizedBox(
              height: size.height * 0.02,
            ),
           const PresetPrivacy(),
            const SizedBox(
              height: 15,
            ),
            Center(
              child: InkWell(
                onTap: getImage,
                child: Container(
                  height: size.height * 0.35,
                  width: size.width * 0.85,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      width: 2,
                      color: Colors.black54,
                    ),
                  ),
                  child: _image == null
                      ? const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.add_photo_alternate,
                                color: Colors.black54,
                              ),
                              HelperText1(
                                text: "Add Your Preset file here",
                                color: Colors.black54,
                              )
                            ],
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.all(3),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.file(_image!, fit: BoxFit.cover),
                          ),
                        ),
                ),
              ),
            ),
            SizedBox(
              height: size.height * 0.02,
            ),
            if (_image != null)
              GetPresetUploadingButton(
                  onPressed: () {
                    getImage();
                  },
                  text: 'Change selection'),
            SizedBox(
              height: size.height * 0.02,
            ),
            Center(
              child: InkWell(
                onTap: () {
                  if (selectedImages.isEmpty) {
                    getListOfImages();
                  } else if (selectedImages.isNotEmpty &&
                      selectedImages.length < 4) {
                    getListOfImages().then((_) {
                      setState(
                        () {},
                      );
                    });
                  } else {
                    Fluttertoast.showToast(
                        msg: "Please clear the selected items first");
                  }
                },
                child: Container(
                  height: size.height * 0.10,
                  width: size.width * 0.85,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      width: 2,
                      color: Colors.black54,
                    ),
                  ),
                  child: const Center(
                    child: FittedBox(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            HelperText3(
                              text: "Add cover images for your preset image ",
                              color: Colors.black54,
                            ),
                            Text(
                              'Choose up to 4 images',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontWeight: FontWeight.w200,
                                color: Colors.black45,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            if (selectedImages.isNotEmpty)
              SizedBox(
                height: size.height * 0.45,
                width: size.width * 0.85,
                child: GridView.builder(
                  controller: scrollController,
                  itemCount: 4, // Always display 4 items
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 5,
                    mainAxisSpacing: 5,
                  ),
                  itemBuilder: (context, index) {
                    // Check if index is within the range of selectedImages
                    if (index < selectedImages.length) {
                      return Padding(
                        padding: const EdgeInsets.all(3),
                        child: Stack(
                          fit: StackFit.passthrough,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.file(
                                selectedImages[index],
                                fit: BoxFit.cover,
                              ),
                            ),
                            Positioned(
                              top: 0,
                              right: 0,
                              child: IconButton(
                                onPressed: () {
                                  setState(() {
                                    selectedImages.removeAt(index);
                                  });
                                },
                                icon: Icon(
                                  Icons.remove_circle,
                                  color: Colors.red[200],
                                ),
                              ),
                            )
                          ],
                        ),
                      );
                    } else {
                      // Render empty container
                      return InkWell(
                        onTap: () {
                          if (selectedImages.length < 4) {
                            getListOfImages().then((_) {
                              setState(
                                  () {}); // Refresh the UI after selecting new images
                            });
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black54, width: 2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Center(
                            child: Icon(Icons.add_photo_alternate,
                                color: Colors.black54),
                          ),
                        ),
                      );
                    }
                  },
                ),
              ),
            const SizedBox(
              height: 15,
            ),
            Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
                  child: HelperText1(
                    text: "Enter Preset Details",
                    color: Colors.black54,
                    fontSize: size.width * .06,
                  ),
                )),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              child: Column(
                children: [
                  ProfileEditingFields(
                    isNeed: false,
                    isDesc: false,
                    textInputType: TextInputType.name,
                    controller: presetNameController,
                    upText: "Preset Name",
                    hintText: "Preset Name",
                    isInsta: false,
                  ),
                  ProfileEditingFields(
                    isNeed: false,
                    isDesc: false,
                    textInputType: TextInputType.number,
                    controller: presetPriceController,
                    upText: "Preset Price",
                    hintText: "Preset Price",
                    isInsta: false,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  DescriptionWidget(controller: presetDescriptionController),
                ],
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            GetPresetUploadingButton(
              onPressed: () {
                final String presetName = presetNameController.text.trim();
                final String presetDescription =
                    presetDescriptionController.text.trim();
                final String presetPriceText =
                    presetPriceController.text.trim();

                if (presetAdd.isEmpty) {
                  Fluttertoast.showToast(
                      msg: "Please Select Your Preset Before Uploading");
                } else if (selectedImages.isEmpty) {
                  Fluttertoast.showToast(
                      msg: "Please Select Cover Images For Your Preset");
                } else if (presetName.isEmpty ||
                    presetDescription.isEmpty ||
                    presetPriceText.isEmpty) {
                  Fluttertoast.showToast(
                      msg: "Please Fill the necessary fields");
                } else {
                  final int? parsedPrice = int.tryParse(presetPriceText);
                  if (parsedPrice == null) {
                    Fluttertoast.showToast(msg: "Invalid Price");
                  } else {
                    DataUploadAdmin.uploadPreset(
                      name: presetName,
                      price: parsedPrice,
                      description: presetDescription,
                      presetData: presetAdd,
                      coverImages: selectedImages,
                    );
                    Future.delayed(const Duration(milliseconds: 800), () {
                      Navigator.pop(context);
                    });
                  }
                }
              },
              text: 'Upload Preset',
            ),
            SizedBox(
              height: size.height * .10,
            ),
          ],
        ),
      ),
    );
  }
}

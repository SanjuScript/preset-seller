import 'dart:developer';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:seller_app/FUNCTIONS/files_upload_auth_functions.dart';
import 'package:seller_app/HELPERS/color_helper.dart';
import 'package:seller_app/WIDGETS/BUTTONS/preset_uploading.button.dart';
import 'package:seller_app/WIDGETS/Texts/helper_texts.dart';
import 'dart:math' as math;

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

  Future<void> getListOfImages() async {
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

  // Future<File?> pickXMPFile() async {
  //   FilePickerResult? result = await FilePicker.platform.pickFiles(
  //     type: FileType.custom,

  //     allowedExtensions: ['dng',],
  //   );

  //   if (result != null) {
  //     File file = File(result.files.single.path!);
  //     return file;
  //   } else {
  //     // User canceled the picker
  //     return null;
  //   }
  // }

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
      backgroundColor: getColor("#f2f2f2"),
      body: SingleChildScrollView(
        controller: scrollController,
        child: Column(
          children: [
            SizedBox(
              height: size.height * 0.06,
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
                  // if (selectedImages.isEmpty) {

                  if (selectedImages.isEmpty) {
                    getListOfImages();
                  } else if (selectedImages.isNotEmpty &&
                      selectedImages.length < 4) {
                    getListOfImages().then((_) {
                      setState(
                        () {},
                      ); // Refresh the UI after selecting new images
                    });
                  } else {
                    Fluttertoast.showToast(
                        msg: "Please clear the selected items first");
                  }

                  // }
                  // selectedImages.clear();
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
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 5,
                    mainAxisSpacing: 5,
                  ),
                  itemBuilder: (context, index) {
                    // Check if index is within the range of selectedImages
                    if (index < selectedImages.length) {
                      return InkWell(
                        onLongPress: () {
                          setState(() {
                            selectedImages.removeAt(index);
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(3),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.file(
                              selectedImages[index],
                              fit: BoxFit.cover,
                            ),
                          ),
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
                          child: Center(
                            child: Icon(Icons.add_photo_alternate,
                                color: Colors.black54),
                          ),
                        ),
                      );
                    }
                  },
                ),
              ),
            if (selectedImages.isNotEmpty)
              GetPresetUploadingButton(
                  onPressed: () {
                    DataUploadAdmin.uploadPreset(
                        name: "Brown preset",
                        price: 340,
                        description:
                            "inActivity@643c71b will call onBackPressedged_boost_gpu_freq, level 100, eOrigin 2, final_idx 42, oppidx_max 42, oppidx_min 0",
                        presetData: presetAdd,
                        coverImages: selectedImages);
                  },
                  text: 'Clear All'),
            SizedBox(
              height: 30,
            ),
            SizedBox(
              height: size.height * .14,
            )
          ],
        ),
      ),
    );
  }
}

import 'dart:developer';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:seller_app/EXTENSION/capitalize.dart';
import 'package:seller_app/FUNCTIONS/PRESET_CONTROLLER/preset_uploader.dart';
import 'package:seller_app/WIDGETS/BUTTONS/preset_privacy_button.dart';
import 'package:seller_app/WIDGETS/BUTTONS/preset_uploading.button.dart';
import 'package:seller_app/WIDGETS/Texts/helper_texts.dart';
import 'dart:math' as math;

import 'package:seller_app/WIDGETS/editing_fields.dart';

class PresetPackUploadingPage extends StatefulWidget {
  const PresetPackUploadingPage({super.key});

  @override
  State<PresetPackUploadingPage> createState() =>
      _PresetPackUploadingPageState();
}

class _PresetPackUploadingPageState extends State<PresetPackUploadingPage> {
  List<File> selectedImages = [];
  List<File> presetAdd = [];
  ScrollController scrollController = ScrollController();
  TextEditingController presetNameController = TextEditingController();
  TextEditingController presetPriceController = TextEditingController();
  TextEditingController presetDescriptionController = TextEditingController();
  TextEditingController presetMRPController = TextEditingController();

  Future<void> getPresetImages() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.any,
      compressionQuality: 35,
      allowMultiple: true,
    );

    final xfilePicks = result?.xFiles;

    setState(() {
      if (xfilePicks != null) {
        for (var xfile in xfilePicks) {
          if (presetAdd.length >= 10) {
            Fluttertoast.showToast(msg: 'You can only add up to 10 images.');
            break;
          }

          if (xfile.name.toLowerCase().endsWith('.dng')) {
            final fileSizeInMB = File(xfile.path).lengthSync() / (1024 * 1024);

            if (fileSizeInMB < 2) {
              presetAdd.add(File(xfile.path));
            } else {
              Fluttertoast.showToast(
                  msg:
                      'File ${xfile.name} is too large. Please select a file under 2 MB.');
            }
          } else {
            Fluttertoast.showToast(
                msg: 'File ${xfile.name} is not a DNG file.');
          }
        }
      } else {
        Fluttertoast.showToast(msg: 'Nothing is selected');
      }
    });
  }

  Future<void> getCoverImages() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowMultiple: true,
      allowedExtensions: ['jpg', 'jpeg'],
    );

    if (result != null && result.files.isNotEmpty) {
      setState(() {
        for (var file in result.files) {
          if (selectedImages.length < 12) {
            // Allow up to 12 images
            final File imageFile = File(file.path!);

            imageFile.length().then((fileSize) {
              if (fileSize <= 1 * 1024 * 1024) {
                // Limit file size to 1MB
                selectedImages.add(imageFile);
              } else {
                Fluttertoast.showToast(
                    msg: "${file.name} is larger than 1MB and was not added");
              }
            });
          } else {
            break;
          }
        }
      });
    } else {
      Fluttertoast.showToast(msg: 'Nothing is selected');
    }
  }

  bool isPaid = true;
  @override
  Widget build(BuildContext context) {
    log(presetAdd.length.toString());
    log(selectedImages.length.toString());

    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: HelperText1(
          text: " Upload Preset pack ".capitalizeFirstLetterOfEachWord(),
          color: Colors.black87,
          fontSize: 22,
        ),
      ),
      // backgroundColor: getColor("#f2f2f2"),
      body: SingleChildScrollView(
        controller: scrollController,
        child: Column(
          children: [
            SizedBox(
              height: size.height * 0.02,
            ),
            PresetPrivacy(),
            SizedBox(
              height: size.height * 0.02,
            ),
            Center(
              child: InkWell(
                onTap: () {
                  if (presetAdd.isEmpty) {
                    getPresetImages();
                  } else if (presetAdd.isNotEmpty && presetAdd.length != 10) {
                    getPresetImages().then((_) {
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
                              text: "Add preset images",
                              color: Colors.black54,
                            ),
                            Text(
                              'Choose up to 10 images',
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
            SizedBox(
              height: size.height * 0.02,
            ),
            Center(
              child: InkWell(
                onTap: () {
                  if (presetAdd.isEmpty) {
                    getPresetImages();
                  } else if (presetAdd.isNotEmpty && presetAdd.length != 10) {
                    getPresetImages().then((_) {
                      setState(
                        () {},
                      );
                    });
                  } else {
                    Fluttertoast.showToast(
                        msg: "Please clear the selected items first");
                  }
                },
                child: presetAdd.isEmpty && presetAdd == null
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
                    : SizedBox(
                        height: size.height * 0.45,
                        width: size.width * 0.85,
                        child: GridView.builder(
                          controller: scrollController,
                          scrollDirection: Axis.horizontal,
                          itemCount: 10,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 5,
                            mainAxisSpacing: 5,
                          ),
                          itemBuilder: (context, index) {
                            // Check if index is within the range of selectedImages
                            if (index < presetAdd.length) {
                              return Stack(
                                children: [
                                  InkWell(
                                    child: Padding(
                                      padding: const EdgeInsets.all(3),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Image.file(
                                          height: size.height * 0.45,
                                          width: size.width * 0.85,
                                          presetAdd[index],
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    right: 8,
                                    top: 8,
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          presetAdd.removeAt(index);
                                        });
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.red.withOpacity(
                                              0.7), // Semi-transparent red
                                        ),
                                        child: const Padding(
                                          padding: EdgeInsets.all(4.0),
                                          child: Icon(
                                            Icons.remove,
                                            color: Colors.white,
                                            size: 18,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            } else {
                              return InkWell(
                                onTap: () {
                                  if (presetAdd.length != 10) {
                                    getPresetImages().then((_) {
                                      setState(() {});
                                    });
                                  }
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.black54, width: 2),
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
              ),
            ),
            SizedBox(
              height: size.height * 0.02,
            ),
            Center(
              child: InkWell(
                onTap: () {
                  if (selectedImages.isEmpty) {
                    getCoverImages();
                  } else if (selectedImages.isNotEmpty &&
                      selectedImages.length < 12) {
                    getCoverImages().then((_) {
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
                              'Choose up to 12 images',
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
            SizedBox(height: 10),
            if (selectedImages.isNotEmpty)
              SizedBox(
                height: size.height * 0.45,
                width: size.width * 0.85,
                child: GridView.builder(
                  controller: scrollController,
                  scrollDirection: Axis.horizontal,
                  itemCount: 12, // Always display 12 items
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 5,
                    mainAxisSpacing: 5,
                  ),
                  itemBuilder: (context, index) {
                    // Check if index is within the range of selectedImages
                    if (index < selectedImages.length) {
                      return Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(3),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.file(
                                selectedImages[index],
                                height: size.height * 0.45,
                                width: size.width * 0.85,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Positioned(
                            right: 8,
                            top: 8,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedImages.removeAt(index);
                                });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.red
                                      .withOpacity(0.7), // Semi-transparent red
                                ),
                                child: const Padding(
                                  padding: EdgeInsets.all(4.0),
                                  child: Icon(
                                    Icons.remove,
                                    color: Colors.white,
                                    size: 18,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    } else {
                      return InkWell(
                        onTap: () {
                          if (selectedImages.length < 4) {
                            getCoverImages().then((_) {
                              setState(() {});
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
                  Row(
                    children: [
                      Expanded(
                        child: RadioListTile<bool>.adaptive(
                          useCupertinoCheckmarkStyle: true,
                          activeColor: Colors.black87,
                          title: const Text('Free'),
                          value: false,
                          groupValue: isPaid,
                          onChanged: (value) {
                            setState(() {
                              isPaid = value!;
                              if (!isPaid) {
                                presetPriceController.clear();
                              }
                            });
                          },
                        ),
                      ),
                      Expanded(
                        child: RadioListTile<bool>.adaptive(
                          activeColor: Colors.black87,
                          title: const Text('Paid'),
                          value: true,
                          groupValue: isPaid,
                          onChanged: (value) {
                            setState(() {
                              isPaid = value!;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  if (isPaid) ...[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: Row(
                        children: [
                          Expanded(
                            child: ProfileEditingFields(
                              isNeed: false,
                              isDesc: false,
                              textInputType: TextInputType.number,
                              controller: presetPriceController,
                              upText: "Preset Price",
                              hintText: "Preset Price",
                              isInsta: false,
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: ProfileEditingFields(
                              isNeed: false,
                              isDesc: false,
                              textInputType: TextInputType.number,
                              controller: presetMRPController,
                              upText: "Preset selling Price"
                                  .capitalizeFirstLetterOfEachWord(),
                              hintText: "Preset selling Price"
                                  .capitalizeFirstLetterOfEachWord(),
                              isInsta: false,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
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
                final String presetMRPPriceText =
                    presetMRPController.text.trim();
                bool needOfPrice = isPaid
                    ? presetPriceText.isEmpty && presetMRPPriceText.isEmpty
                    : presetPriceText.isNotEmpty &&
                        presetMRPPriceText.isNotEmpty;

                if (presetAdd.isEmpty) {
                  Fluttertoast.showToast(
                      msg: "Please Select Your Preset Before Uploading");
                } else if (selectedImages.isEmpty) {
                  Fluttertoast.showToast(
                      msg: "Please Select Cover Images For Your Preset");
                } else if (presetName.isEmpty ||
                    presetDescription.isEmpty ||
                    needOfPrice) {
                  Fluttertoast.showToast(
                      msg: "Please Fill the necessary fields");
                } else {
                  final int? parsedPrice =
                      isPaid ? int.tryParse(presetPriceText) : -1;
                  final int? parsedMRPPrice =
                      isPaid ? int.tryParse(presetMRPPriceText) : -1;

                  if (isPaid) {
                    if (parsedPrice == null ||
                        parsedPrice <= 0 ||
                        parsedMRPPrice == null ||
                        parsedMRPPrice <= 0) {
                      Fluttertoast.showToast(msg: "Invalid Price");
                    } else {
                      PresetUploader.uploadPresetList(
                        name: presetName,
                        isPaid: isPaid,
                        price: parsedPrice,
                        priceMRP: parsedMRPPrice,
                        description: presetDescription,
                        presetFiles: presetAdd,
                        coverImages: selectedImages,
                      );
                    }
                    Future.delayed(const Duration(milliseconds: 800), () {
                      Navigator.pop(context);
                    });
                  } else {
                    PresetUploader.uploadPresetList(
                      name: presetName,
                      isPaid: isPaid,
                      price: parsedPrice ?? -1,
                      priceMRP: parsedMRPPrice ?? -1,
                      description: presetDescription,
                      presetFiles: presetAdd,
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
              height: size.height * .02,
            ),
            Padding(
              padding: EdgeInsets.all(15),
              child: Text(
                'After uploading your preset, you can easily make adjustments, edits, or add information to enhance its settings. Whether you want to refine details, update descriptions, or control parameters, managing your presets is simple. Customize them further to ensure they meet your needs perfectly!👍',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.blueGrey,
                    ),
                textAlign: TextAlign.justify,
              ),
            ),
            SizedBox(
              height: size.height * .05,
            ),
          ],
        ),
      ),
    );
  }
}

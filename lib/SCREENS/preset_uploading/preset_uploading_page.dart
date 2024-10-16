import 'dart:developer';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:seller_app/EXTENSION/capitalize.dart';
import 'package:seller_app/FUNCTIONS/PRESET_CONTROLLER/preset_uploader.dart';
import 'package:seller_app/WIDGETS/BUTTONS/preset_privacy_button.dart';
import 'package:seller_app/WIDGETS/BUTTONS/preset_uploading.button.dart';
import 'package:seller_app/WIDGETS/Texts/helper_texts.dart';
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
  TextEditingController presetMRPController = TextEditingController();
  TextEditingController presetDescriptionController = TextEditingController();

 Future<void> getListOfImages() async {
  FilePickerResult? result = await FilePicker.platform.pickFiles(
    type: FileType.custom,
    allowMultiple: true,
    allowedExtensions: ['jpg', 'jpeg'],
  );

  if (result != null && result.files.isNotEmpty) {
    List<File> tempImages = [];

    for (var file in result.files) {
      if (tempImages.length < 4 && selectedImages.length + tempImages.length < 4) {
        final File imageFile = File(file.path!);

        int fileSize = await imageFile.length(); // Synchronously check the size
        if (fileSize <= 1 * 1024 * 1024) {
          tempImages.add(imageFile);
        } else {
          Fluttertoast.showToast(
              msg: "${file.name} is larger than 1MB and was not added");
        }
      } else {
        break; // Exit if already reached the limit of 4 images
      }
    }

    setState(() {
      selectedImages.addAll(tempImages); // Add only valid images
    });
  } else {
    Fluttertoast.showToast(msg: 'Nothing is selected');
  }
}


  Future<void> getDNGImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.any,
      allowMultiple: false,
    );

    if (result != null && result.files.isNotEmpty) {
      final File imageFile = File(result.files.single.path!);
      final fileExtension = imageFile.path.split('.').last.toLowerCase();

      if (fileExtension == 'dng') {
        final fileLength = await imageFile.length();

        if (fileLength <= 2 * 1024 * 1024) {
          setState(() {
            _image = imageFile;
            presetAdd.clear();
            presetAdd.add(imageFile);
          });
        } else {
          Fluttertoast.showToast(msg: "File size must be less than 2MB");
        }
      } else {
        Fluttertoast.showToast(msg: "Only DNG files are accepted");
      }
    } else {
      Fluttertoast.showToast(msg: 'No file selected');
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
          text: " Upload Preset ".capitalizeFirstLetterOfEachWord(),
          color: Colors.black87,
          fontSize: 22,
        ),
        elevation: 5,
      ),
      body: SingleChildScrollView(
        controller: scrollController,
        child: Column(
          children: [
            SizedBox(height: size.height * 0.02),
            const PresetPrivacy(),
            const SizedBox(height: 15),
            Center(
              child: InkWell(
                onTap: getDNGImage,
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
                    getDNGImage();
                  },
                  text: 'Change selection'),
            SizedBox(
              height: size.height * 0.01,
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
            const SizedBox(
              height: 10,
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
                    showDrop: true,
                    textInputType: TextInputType.name,
                    controller: presetNameController,
                    upText: "Preset Name",
                    hintText: "Preset Name/Type",
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
                      Fluttertoast.showToast(msg: "Invalid Price values");
                    } else {
                      PresetUploader.uploadPreset(
                        name: presetName,
                        price: parsedPrice,
                        priceMRP: parsedMRPPrice!,
                        description: presetDescription,
                        presetData: presetAdd,
                        isPaid: isPaid,
                        coverImages: selectedImages,
                      );
                      Future.delayed(const Duration(milliseconds: 800), () {
                        Navigator.pop(context);
                      });
                    }
                  } else {
                    PresetUploader.uploadPreset(
                      name: presetName,
                      price: parsedPrice ?? -1,
                      priceMRP: parsedMRPPrice ?? -1,
                      description: presetDescription,
                      presetData: presetAdd,
                      isPaid: isPaid,
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

// ignore: must_be_immutable
class CustomRadioButtons extends StatefulWidget {
  bool isPaid;
  final void Function() free;
  final void Function() paid;
  final void Function(bool?)? onChanged1;
  final void Function(bool?)? onChanged2;
  CustomRadioButtons(
      {super.key,
      required this.onChanged1,
      required this.onChanged2,
      required this.isPaid,
      required this.free,
      required this.paid});

  @override
  _CustomRadioButtonsState createState() => _CustomRadioButtonsState();
}

class _CustomRadioButtonsState extends State<CustomRadioButtons> {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    return SizedBox(
      height: size.height * .10,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: widget.free,
                  child: Container(
                    height: size.height * .08,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: widget.isPaid
                          ? Colors.grey.shade300
                          : Colors.blueAccent,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color:
                            widget.isPaid ? Colors.black87 : Colors.transparent,
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 5,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Radio<bool>(
                            activeColor: Colors.black87,
                            value: false,
                            groupValue: widget.isPaid,
                            onChanged: widget.onChanged1),
                        const Text(
                          'Free',
                          style: TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16), // Space between buttons
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      widget.isPaid = true;
                    });
                  },
                  child: Container(
                    height: size.height * .08,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: widget.isPaid
                          ? Colors.blueAccent
                          : Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: widget.isPaid
                            ? Colors.transparent
                            : Colors.blueAccent,
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 5,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Radio<bool>(
                            activeColor: Colors.black87,
                            value: true,
                            groupValue: widget.isPaid,
                            onChanged: widget.onChanged2),
                        const Text(
                          'Paid',
                          style: TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

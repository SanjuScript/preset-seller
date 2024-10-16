import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:seller_app/FUNCTIONS/PRESET_CONTROLLER/preset_meta_updater.dart';
import 'package:seller_app/FUNCTIONS/admin_data_controller_unit.dart';
import 'package:seller_app/HELPERS/is_newmeric.dart';
import 'package:seller_app/MODEL/preset_data_model.dart';
import 'package:seller_app/WIDGETS/CARD/preset_metadata_editing_view.dart';
import 'package:seller_app/WIDGETS/DIALOGUE/DIALOGUE_UTILS/dialogue_utils.dart';
import 'package:seller_app/WIDGETS/DIALOGUE/photo_permission_dialogue.dart';
import 'package:seller_app/WIDGETS/PLACEHILDERS/preset_meta_placeholder.dart';
import 'package:seller_app/WIDGETS/Texts/helper_text2.dart';

class PresetMetadataEditingPage extends StatefulWidget {
  final PresetModel presetModel;
  const PresetMetadataEditingPage({super.key, required this.presetModel});

  @override
  State<PresetMetadataEditingPage> createState() =>
      _PresetMetadataEditingPageState();
}

class _PresetMetadataEditingPageState extends State<PresetMetadataEditingPage> {
  late TextEditingController nameController;
  late TextEditingController priceController;
  String isList = '';
  late TextEditingController mrppriceController;
  late TextEditingController descriptionController;
  List<File> selectedImages = [];
  late bool isPaid;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.presetModel.name);
    isList = widget.presetModel.isList! ? "12" : "4";
    isPaid = widget.presetModel.isPaid!;

    descriptionController =
        TextEditingController(text: widget.presetModel.description);
    mrppriceController = TextEditingController(
      text: (widget.presetModel.mrp != null && widget.presetModel.mrp != -1)
          ? widget.presetModel.mrp.toString()
          : '0',
    );
    log(widget.presetModel.price!.toString());
    priceController = TextEditingController(
      text: (widget.presetModel.price != null && widget.presetModel.price != -1)
          ? widget.presetModel.price.toString()
          : '0',
    );
  }

  Future<void> getCoverImages() async {
    bool isPhotoPermimssionGranted = await checkPhotoGalleryPermission();

    if (!isPhotoPermimssionGranted) {
      await showDialog(
        context: context,
        builder: (context) => const PhotoPermissionDialog(),
      );
      return;
    }

    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      compressionQuality: 35,
      allowMultiple: true,
      allowedExtensions: ['jpg', 'jpeg'],
    );

    final xfilePicks = result?.xFiles;

    setState(() {
      if (xfilePicks != null) {
        final int currentLength = widget.presetModel.coverImages!.length;
        final int maxImages =
            widget.presetModel.isList! ? 12 - currentLength : 4 - currentLength;

        int currentImagesCount = selectedImages.length;

        for (var xfile in xfilePicks) {
          final fileSizeInMB = File(xfile.path).lengthSync() / (1024 * 1024);

          if (currentImagesCount < maxImages && fileSizeInMB < 1) {
            selectedImages.add(File(xfile.path));
            currentImagesCount++;
          } else if (fileSizeInMB >= 1) {
            Fluttertoast.showToast(
                msg:
                    'File ${xfile.name} is too large. Please select a file under 1 MB.');
          } else {
            Fluttertoast.showToast(
                msg: 'Maximum number of images reached. Cannot add more.');
          }
        }
      } else {
        Fluttertoast.showToast(msg: 'Nothing is selected');
      }
    });
    setState(() {});
  }

  @override
  void dispose() {
    nameController.dispose();
    priceController.dispose();
    mrppriceController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    log(selectedImages.length.toString());
    Size size = MediaQuery.sizeOf(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Edit Preset Metadata",
          style: Theme.of(context)
              .textTheme
              .displayMedium
              ?.copyWith(fontSize: size.width * 0.06),
        ),
        actions: [
          IconButton(
            onPressed: () {
              DialogueUtils.showDialogue(context, 'ppdelete',
                  arguments: [widget.presetModel.docId]);
            },
            icon: const Icon(Icons.folder_delete),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment
                  .spaceBetween, // Evenly distribute space between items
              children: [
                Row(
                  children: [
                    const Text(
                      'Hide Offer',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Switch.adaptive(
                      value: widget.presetModel.hideOffer ??
                          false, // Use false as default if null
                      onChanged: (value) {
                        setState(() {
                          widget.presetModel.hideOffer = value;
                        });

                        UpdatePresetData.updateHideOffer(
                          docId: widget.presetModel.docId!,
                          hideOffer: value,
                        );
                      },
                      activeColor: Colors.green, // Customize the active color
                      inactiveThumbColor:
                          Colors.grey, // Customize the inactive thumb color
                      inactiveTrackColor: Colors.red.withOpacity(
                          0.5), // Customize the inactive track color
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Text(
                      'Show MRP',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Switch.adaptive(
                      value: widget.presetModel.showMRP ?? false,
                      onChanged: (value) {
                        setState(() {
                          widget.presetModel.showMRP = value;
                        });
                        UpdatePresetData.updateShowMRP(
                          docId: widget.presetModel.docId!,
                          showMRP: value,
                        );
                      },
                      activeColor: Colors.blue, // Customize the active color
                      inactiveThumbColor:
                          Colors.grey, // Customize the inactive thumb color
                      inactiveTrackColor: Colors.red.withOpacity(
                          0.5), // Customize the inactive track color
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 15),

            _buildInputField("Preset Name", nameController, size),

            const SizedBox(height: 20),

            Row(
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        isPaid = true; // Update to Paid
                        UpdatePresetData.updateSellingType(
                          docId: widget.presetModel.docId!,
                          isPaid: isPaid,
                        );
                      });
                    },
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                      decoration: BoxDecoration(
                        color: isPaid ? Colors.green : Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Text(
                        "Paid",
                        style: TextStyle(
                          color: isPaid ? Colors.white : Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        isPaid = false; // Update to Free
                        UpdatePresetData.updateSellingType(
                          docId: widget.presetModel.docId!,
                          isPaid: isPaid,
                        );
                      });
                    },
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                      decoration: BoxDecoration(
                        color: !isPaid ? Colors.blue : Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Text(
                        "Free",
                        style: TextStyle(
                          color: !isPaid ? Colors.white : Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(
              height: 15,
            ),

            if (isPaid)
              Row(
                children: [
                  Expanded(
                    child: _buildInputField("Price", priceController, size,
                        isNumeric: true),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: _buildInputField(
                        "selling price", mrppriceController, size,
                        isNumeric: true),
                  ),
                ],
              ),
            const SizedBox(height: 20),

            // Description Input
            Align(
                alignment: Alignment.centerLeft,
                child: GetText1(text: "Description", size: size.width * 0.05)),
            const SizedBox(height: 10),

            TextField(
              textInputAction: TextInputAction.newline,
              controller: descriptionController,
              textAlign: TextAlign.left,
              maxLength: 400,
              maxLines: null,
              keyboardType: TextInputType.multiline,
              inputFormatters: [LengthLimitingTextInputFormatter(400)],
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Theme.of(context).primaryColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                      color: Theme.of(context).primaryColor, width: 2),
                ),
              ),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.black87,
                  ),
            ),

            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () async {
                  String presetName = nameController.text.trim();
                  String price = priceController.text.trim();
                  String sellingPrice = mrppriceController.text.trim();
                  String description = descriptionController.text.trim();

                  Map<String, dynamic> updateData =
                      {}; // Create a map for the update data

                  // Check if name and description are not empty
                  if (presetName.isEmpty) {
                    Fluttertoast.showToast(
                      msg: 'Name cannot be empty.',
                      backgroundColor: Colors.red,
                    );
                    return;
                  }

                  if (description.isEmpty) {
                    Fluttertoast.showToast(
                      msg: 'Description cannot be empty.',
                      backgroundColor: Colors.red,
                    );
                    return;
                  }

                  if (isPaid) {
                    if (!CheckNum.isNumeric(price) ||
                        !CheckNum.isNumeric(sellingPrice)) {
                      Fluttertoast.showToast(
                        msg:
                            'Please enter valid numeric values for price and MRP.',
                        backgroundColor: Colors.red,
                      );
                      return;
                    }

                    int priceValue = int.parse(price);
                    int sellingPriceValue = int.parse(sellingPrice);

                    if (priceValue <= 0 ||
                        priceValue > 10000 ||
                        sellingPriceValue <= 0 ||
                        sellingPriceValue > 10000) {
                      Fluttertoast.showToast(
                        msg: 'Price and MRP must be between 1 and 10,000.',
                        backgroundColor: Colors.red,
                      );
                      return;
                    }

                    updateData['price'] = priceValue;
                    updateData['mrp'] = sellingPriceValue;
                  } else {
                    updateData['name'] = presetName;
                    updateData['description'] = description;
                  }

                  if (updateData.isNotEmpty) {
                    await UpdatePresetData.updateMainPresetData(
                      updateData: updateData,
                      docId: widget.presetModel.docId!,
                    );
                  } else {
                    Fluttertoast.showToast(
                      msg: 'No changes to update.',
                      backgroundColor: Colors.orange,
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black87,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Text(
                  'Apply Changes',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
            ),

            // Select Images Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GetText1(text: "Cover Images", size: size.width * 0.05),
                TextButton(
                  onPressed: getCoverImages,
                  child: Text(
                    "Pick Images",
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
              ],
            ),
            Text(
              "To change the cover image, remove existing images if there are more than $isList.",
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: Colors.red[300]),
            ),
            const SizedBox(height: 5),

            GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
              ),
              scrollDirection: Axis.vertical,
              itemCount: widget.presetModel.isList! ? 12 : 4,
              itemBuilder: (context, index) {
                // Calculate total images (cover images + selected images)
                final totalImages = widget.presetModel.coverImages!.length +
                    selectedImages.length;

                // Show existing cover images
                if (index < widget.presetModel.coverImages!.length) {
                  return PresetMetaDataEditingView(
                    fromDB: true,
                    onCDelete: () async {
                      DialogueUtils.showDialogue(context, 'cdelete',
                          arguments: [
                            widget.presetModel.docId,
                            widget.presetModel.coverImages,
                            index
                          ]);
                      setState(() {});
                    },
                    imgUrl: widget.presetModel.coverImages![index],
                  );
                }
                // Show selected images
                else if (index < totalImages) {
                  final selectedIndex =
                      index - widget.presetModel.coverImages!.length;

                  return PresetMetaDataEditingView(
                    file: selectedImages[selectedIndex],
                    fromDB: false,
                    onIremove: () {
                      selectedImages.removeAt(selectedIndex);
                      setState(() {});
                    },
                  );
                } else {
                  return PresetMetaPlaceHolder(onTap: () {
                    getCoverImages();
                  });
                }
              },
            ),

            const SizedBox(height: 30),

            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () async {
                  if (selectedImages.isNotEmpty) {
                    if (widget.presetModel.isList!) {
                      if ((widget.presetModel.coverImages!.length) +
                              (selectedImages.length) <
                          13) {
                        Navigator.pop(context);
                        Fluttertoast.showToast(
                          msg: 'Your files are uploading...',
                          backgroundColor: Colors.green,
                        );
                        await UpdatePresetData.updateCoverImages(
                            docId: widget.presetModel.docId!,
                            newCoverImages: selectedImages,
                            oldCoverImagesUrls:
                                widget.presetModel.coverImages!);
                      }
                    } else if ((widget.presetModel.coverImages!.length) +
                            (selectedImages.length) <
                        5) {
                      Navigator.pop(context);
                      Fluttertoast.showToast(
                        msg: 'Your files are uploading...',
                        backgroundColor: Colors.green,
                      );
                      await UpdatePresetData.updateCoverImages(
                          docId: widget.presetModel.docId!,
                          newCoverImages: selectedImages,
                          oldCoverImagesUrls: widget.presetModel.coverImages!);
                    }
                  } else {
                    Fluttertoast.showToast(
                      msg: 'Atleast select one image',
                      backgroundColor: Colors.orange,
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black87,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Text(
                  'Update Images',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField(
      String label, TextEditingController controller, Size size,
      {bool isNumeric = false, bool isMultiLine = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GetText1(text: label, size: size.width * 0.05),
        const SizedBox(height: 10),
        TextField(
          controller: controller,
          keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
          maxLines: isMultiLine ? 3 : 1,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Theme.of(context).primaryColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide:
                  BorderSide(color: Theme.of(context).primaryColor, width: 2),
            ),
            hintText: "Enter $label",
            hintStyle: const TextStyle(color: Colors.grey),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          ),
        ),
      ],
    );
  }
}

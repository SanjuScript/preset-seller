import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:seller_app/DATA/admin_data.dart';
import 'package:seller_app/DATA/update_data.dart';
import 'package:seller_app/FUNCTIONS/files_upload_auth_functions.dart';
import 'package:seller_app/HELPERS/color_helper.dart';
import 'package:seller_app/MODEL/admin_data_model.dart';
import 'package:seller_app/WIDGETS/BUTTONS/preset_uploading.button.dart';
import 'package:seller_app/WIDGETS/DIALOGUE/reset_password_dialogue.dart';
import 'package:seller_app/WIDGETS/Texts/helper_texts.dart';
import 'package:seller_app/WIDGETS/editing_fields.dart';
import 'package:seller_app/WIDGETS/pop_menu_button.dart';

class ProfileEditingPage extends StatefulWidget {
  final AdminProfile adminData;
  const ProfileEditingPage({super.key, required this.adminData});

  @override
  State<ProfileEditingPage> createState() => _ProfileEditingPageState();
}

class _ProfileEditingPageState extends State<ProfileEditingPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController lastController = TextEditingController();
  TextEditingController instagramController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  CroppedFile? _croppedFile;
  File? _pickedFile;

  Future<void> _uploadImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowMultiple: false,
      allowedExtensions: ['jpg', 'jpeg'],
      compressionQuality: 35,
      allowCompression: true,
    );

    if (result!.xFiles.single.path != null) {
      File imageFile = File(result.xFiles.single.path);
      setState(() {
        _pickedFile = imageFile;
      });
      await _cropImage(_pickedFile!);
    }
  }

  Future<void> _cropImage(File imageFile) async {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: imageFile.path,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
      ],
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Crop Image',
          toolbarColor: Colors.deepOrange,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset
              .square, // Set initial aspect ratio to square
          lockAspectRatio: true, // Lock aspect ratio to prevent changes
        ),
        IOSUiSettings(
          title: 'Crop Image',
        ),
      ],
    );
    if (croppedFile != null) {
      setState(() {
        _croppedFile = croppedFile;
      });
      await DataUploadAdmin.uploadProfilePicture(File(croppedFile.path));
    }
  }

  @override
  void initState() {
    super.initState();
    instagramController.text = widget.adminData.instagram.toString() ?? '';
    descriptionController.text = widget.adminData.description.toString() ?? '';
  }

  @override
  Widget build(BuildContext context) {
    log(widget.adminData.userProfileUrl.toString());
    Size size = MediaQuery.sizeOf(context);
    return Scaffold(
      appBar: AppBar(
          title: HelperText1(
            text: "Edit Profile",
            color: Colors.black87,
            fontSize: size.width * .06,
          ),
          surfaceTintColor: Colors.transparent,
          backgroundColor: Colors.transparent,
          actions: [
            CustomPopupMenuButton(
              iconData1: Icons.save,
              iconData2: Icons.refresh_outlined,
              mainIcon: Icons.more_vert_rounded,
              text2: 'Reset Password',
              onItemSelected: (p0) async {
                if (p0 == 'Reset Password') {
                  await showResetPasswordDialogue(
                      context: context,
                      text: widget.adminData.email.toString());
                } else {
                  await saveChanges();
                }
              },
              text1: "Save",
            ),
          ]),
      backgroundColor: getColor("#f2f2f2"),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: InkWell(
                onTap: () {
                  // DataUploadAdmin.uploadProfilePicture();
                  _uploadImage();
                },
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey[300],
                  ),
                  child: InkWell(
                    onTap: () {
                      _uploadImage();
                    },
                    child: Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.grey[300],
                        ),
                        child: Stack(
                          fit: StackFit.passthrough,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: CachedNetworkImage(
                                
                                imageUrl: widget.adminData.userProfileUrl !=
                                            null &&
                                        widget.adminData.userProfileUrl!
                                            .isNotEmpty
                                    ? widget.adminData.userProfileUrl.toString()
                                    : "https://as2.ftcdn.net/v2/jpg/00/65/77/27/1000_F_65772719_A1UV5kLi5nCEWI0BNLLiFaBPEkUbv5Fv.jpg",
                                fit: BoxFit.cover,
                                filterQuality: FilterQuality.low,
                                placeholder: (context, url) =>
                                    const CircularProgressIndicator(),
                                errorWidget: (context, url, error) => Center(
                                  child: Icon(
                                    Icons.add_a_photo,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                            ),
                            widget.adminData.userProfileUrl!.isEmpty ||
                                    widget.adminData.userProfileUrl == null
                                ? SizedBox()
                                : const Positioned(
                                    bottom: 10,
                                    right: 0,
                                    child: Icon(Icons.add_a_photo_rounded))
                          ],
                        )),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ProfileEditingFields(
              isNeed: false,
              isDesc: false,
              textInputType: TextInputType.name,
              controller: nameController,
              upText: 'First Name',
              hintText: "First Name",
              isInsta: false,
            ),
            ProfileEditingFields(
              isDesc: false,
              isNeed: false,
              textInputType: TextInputType.name,
              controller: lastController,
              upText: 'Last Name',
              hintText: "Last Name",
              isInsta: false,
            ),
            ProfileEditingFields(
              isNeed: true,
              isDesc: false,
              textInputType: TextInputType.url,
              controller: instagramController,
              upText: 'Instagram',
              hintText: "Your instagram link",
              isInsta: true,
            ),
            ProfileEditingFields(
              isNeed: true,
              isDesc: true,
              textInputType: TextInputType.multiline,
              controller: descriptionController,
              upText: 'Description',
              hintText: "Description about your profile",
              isInsta: false,
            ),
            const SizedBox(
              height: 20,
            ),
            Center(
              child: GetPresetUploadingButton(
                onPressed: () async {
                  await saveChanges();
                },
                text: "Save",
              ),
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> saveChanges() async {
    bool changesMade = false;

    if (nameController.text.isNotEmpty) {
      await UpdateAdminData.updateFirstName(nameController.text.trim());
      changesMade = true;
    }

    if (lastController.text.isNotEmpty) {
      await UpdateAdminData.updateLastName(lastController.text.trim());
      changesMade = true;
    }

    if (instagramController.text.isNotEmpty) {
      await UpdateAdminData.addInstagramLink(
          instagramLink: instagramController.text.trim());
      changesMade = true;
    }

    if (descriptionController.text.isNotEmpty) {
      await UpdateAdminData.updateDescription(
          description: descriptionController.text.trim());
      changesMade = true;
    }

    if (changesMade) {
      Fluttertoast.showToast(msg: 'Changes saved successfully');
    } else {
      Fluttertoast.showToast(msg: 'No changes detected');
    }
  }
}

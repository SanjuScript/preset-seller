import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:seller_app/API/auth_api.dart';
import 'package:seller_app/CONSTANTS/assets.dart';
import 'package:seller_app/FUNCTIONS/files_upload_auth_functions.dart';
import 'package:seller_app/FUNCTIONS/profile_auth_functions.dart';
import 'package:seller_app/HELPERS/color_helper.dart';
import 'package:seller_app/HELPERS/date_helper.dart';
import 'package:seller_app/HELPERS/url_launcher_helper.dart';
import 'package:seller_app/MODEL/admin_data_model.dart';
import 'package:seller_app/PROVIDERS/permission_provider.dart';
import 'package:seller_app/WIDGETS/Texts/description_widget.dart';
import 'package:seller_app/WIDGETS/profile_element.dart';
import 'package:image/image.dart' as img;

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late User? _user;
  late Stream<AdminProfile> _userProfileStream;
  bool isStoragePermission = false;
  bool isPhotosPermission = false;
  bool gotPermission = false;
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController instaController = TextEditingController();
  @override
  void initState() {
    super.initState();
    _user = AuthApi.auth.currentUser;
    _userProfileStream = _getUserProfileStream();
  }

  void onDescriptionChanged() {
    if (descriptionController.text.length >= 450) {
      Fluttertoast.showToast(
        msg: 'Maximum character limit reached',
      );
    }
  }

  Stream<AdminProfile> _getUserProfileStream() {
    return FirebaseFirestore.instance
        .collection('admins')
        .doc(_user!.uid)
        .snapshots()
        .map((snapshot) => AdminProfile.fromMap(snapshot.data() ?? {}));
  }

  void getPermission(PermissionProvider permissionProvider) async {
    try {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;

      if (androidInfo.version.sdkInt >= 33) {
        var photosStatus = await Permission.photos.status;
        if (photosStatus.isGranted) {
          permissionProvider.isPhotosPermission = true;
        } else {
          var photosPermissionStatus = await Permission.photos.request();
          if (photosPermissionStatus.isGranted) {
            permissionProvider.isPhotosPermission = true;
          }
        }
      } else {
        var storageStatus = await Permission.storage.status;
        if (storageStatus.isGranted) {
          permissionProvider.isStoragePermission = true;
        } else {
          var storagePermissionStatus = await Permission.storage.request();
          if (storagePermissionStatus.isGranted) {
            permissionProvider.isStoragePermission = true;
          }
        }
      }

      if (permissionProvider.isStoragePermission ||
          permissionProvider.isPhotosPermission) {
        setState(() {});
      } else {
        showPermissionDeniedDialog();
      }
    } catch (e) {
      print('Error getting permission: $e');

      showErrorDialog();
    }
  }

  void showPermissionDeniedDialog() {
    Fluttertoast.showToast(msg: 'permission denied');
    openAppSettings();
  }

  void showErrorDialog() {
    Fluttertoast.showToast(msg: 'permission error');
  }

  @override
  Widget build(BuildContext context) {
    final permissionProvider = Provider.of<PermissionProvider>(context);

    Size size = MediaQuery.sizeOf(context);
    return Scaffold(
      backgroundColor: getColor("#f2f2f2"),
      body: StreamBuilder<AdminProfile>(
        stream: _userProfileStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final userProfile = snapshot.data!;
            // log(userProfile.description!.length.toString());
            descriptionController.addListener(onDescriptionChanged);

            return SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: size.height * .05,
                  ),
                  Container(
                    height: size.height * .28,
                    width: size.width * .90,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.all(
                        Radius.circular(25),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: getColor("#dddddd"),
                          offset: const Offset(2, -2),
                          blurRadius: 10,
                        ),
                        BoxShadow(
                          color: getColor("#dddddd"),
                          offset: const Offset(-2, 2),
                          blurRadius: 10,
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        SizedBox(
                          // color: Colors.green,
                          width: size.width * .90,
                          height: size.height * .17,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              InkWell(
                                onTap: () {
                                  print(permissionProvider.isPhotosPermission
                                      .toString());
                                  if (!permissionProvider.isPhotosPermission) {
                                    getPermission(permissionProvider);
                                  } else {
                                    AuthController.uploadProfilePicture();
                                  }
                                },
                                child: CachedNetworkImage(
                                  imageUrl:
                                      userProfile.userProfileUrl.toString(),
                                  imageBuilder: (context, imageProvider) =>
                                      Container(
                                    height: size.height * .25,
                                    width: size.width * .25,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                        image: imageProvider,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  placeholder: (context, url) =>
                                      const CircularProgressIndicator(),
                                  errorWidget: (context, url, error) => Icon(
                                    Icons.person_2_rounded,
                                    size: size.height * .09,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              Container(
                                color: Colors.transparent,
                                height: size.height * .09,
                                width: size.width * .50,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${userProfile.firstName ?? ''} ${userProfile.lastName ?? ''}",
                                      style: TextStyle(
                                        fontSize: size.width * 0.06,
                                        overflow: TextOverflow.ellipsis,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                        fontFamily: 'rounder',
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    Text(
                                      userProfile.email ?? '',
                                      style: TextStyle(
                                        fontSize: size.width * 0.04,
                                        overflow: TextOverflow.ellipsis,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    const Spacer(),
                                    Text(
                                      "Joined on ${formatDate(AuthApi.auth.currentUser!.metadata.creationTime)}",
                                      style: TextStyle(
                                        fontSize: size.width * 0.04,
                                        overflow: TextOverflow.ellipsis,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black54,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: size.height * .11,
                          width: size.width * .90,
                          child: const FittedBox(
                            child: Row(
                              children: [
                                ProfileElement(
                                  text: "Posts",
                                  count: "20",
                                  rradius: 0,
                                ),
                                ProfileElement(
                                  text: "Likes",
                                  count: "200k",
                                  rradius: 0,
                                  ladius: 0,
                                ),
                                ProfileElement(
                                  text: "Earned",
                                  count: "16.3k",
                                  ladius: 0,
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  userProfile.instagram == null ||
                          userProfile.instagram!.isEmpty
                      ? const SizedBox()
                      : Container(
                          height: size.height * .08,
                          width: size.width * .90,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: const BorderRadius.all(
                              Radius.circular(25),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey[200]!,
                                offset: const Offset(2, -2),
                                blurRadius: 5,
                              ),
                              BoxShadow(
                                color: Colors.grey[200]!,
                                offset: const Offset(-2, 2),
                                blurRadius: 5,
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                SvgPicture.asset(
                                  GetAssetFile.instaIcon,
                                  height: size.height * 0.04,
                                  width: size.width * 0.04,
                                ),
                                const SizedBox(width: 10),
                                Flexible(
                                  child: InkWell(
                                    onTap: () {
                                      UrlLaunch.launchurl(
                                          context, userProfile.instagram);
                                    },
                                    child: Text(
                                      userProfile.instagram ?? '',
                                      maxLines: 2,
                                      style: TextStyle(
                                        fontSize: size.width * 0.04,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                        fontFamily: 'hando',
                                      ),
                                      textAlign: TextAlign.start,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                  const SizedBox(height: 20),
                  userProfile.description == null ||
                          userProfile.description!.isEmpty
                      ? SizedBox()
                      : DescriptionText(
                          description: userProfile.description ?? '',
                          ontap: () {
                            print('object');
                          },
                        ),
                  ElevatedButton(
                    onPressed: () async {
                      // DataUploadAdmin.uploadPreset(
                      //     name: "moody yellow preset",
                      //     price: 440,
                      //     description: "Please buy our new preset for just 654");
                    },
                    child: const Text('Upload preset'),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      // DataUploadAdmin.uploadPresetList(
                      //   name: "London preset",
                      //   price: 250,
                      //   description:
                      //       "THis preset is for you only please buy it",
                      // );
                    },
                    child: const Text('Upload List of preset'),
                  ),
                  TextField(
                    controller: descriptionController,

                    decoration: InputDecoration(
                      labelText: 'New Description',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: null, // Allow multiline input
                    maxLength: 450,
                  ),
                  const SizedBox(height: 10),
                  // Button to update description
                  ElevatedButton(
                    onPressed: () async {
                      String newDescription = descriptionController.text.trim();
                      if (newDescription.isNotEmpty) {
                        await AuthController.updateDescription(
                          description: newDescription,
                        );
                        Fluttertoast.showToast(
                          msg: 'Description updated successfully',
                        );
                        descriptionController.clear();
                      } else {
                        Fluttertoast.showToast(
                          msg: 'Please enter a description',
                        );
                      }
                    },
                    child: const Text('Update Description'),
                  ),
                  TextField(
                    controller: instaController,
                    decoration: InputDecoration(
                      labelText: 'Add instalink',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: null, // Allow multiline input
                    maxLength: 450,
                  ),
                  const SizedBox(height: 10),
                  // Button to update description
                  ElevatedButton(
                    onPressed: () async {
                      String instaLink = instaController.text.trim();
                      if (instaLink.isNotEmpty) {
                        if (userProfile.instagram != null) {
                          if (instaLink == userProfile.instagram) {
                            Fluttertoast.showToast(
                              msg: 'New link cannot be same',
                            );
                          } else {
                            await AuthController.addInstagramLink(
                              instagramLink: instaLink,
                            );
                            Fluttertoast.showToast(
                              msg: 'Description updated successfully',
                            );
                            instaController.clear();
                          }
                        }
                      } else {
                        Fluttertoast.showToast(
                          msg: 'Please enter a insta link',
                        );
                      }
                    },
                    child: Text(userProfile.instagram == null
                        ? "Add  insta "
                        : "update insta"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // AuthController.signOut(context);
                      // AuthController.transferData();\
                      // AuthController.updateAdminName(
                      //   newFirstName: 'John',
                      //   newLastName: 'Doe',
                      // AuthController.signOut(context);
                      // AuthController.deleteAdminAccount(context);
                      // showModalBottomSheet(
                      //   isScrollControlled: true,
                      //   showDragHandle: true,
                      //   context: context,
                      //   builder: (context) {
                      //     return LoginPage();
                      //   },
                      // );
                      AuthController.signOut(context);
                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (context) => AuthenticationPage()));
                      // AuthController.updateDescription(
                      //     description:
                      //         "An administrator (admin) is a user role or account type within a system or organization that typically holds elevated privileges and responsibilities compared to regular users. Administrators are tasked with managing various aspects of the system or organization, such as user accounts, permissions, settings, and content. They often have the authority to configure system-wide settings, perform maintenance tasks, enforce security policies, and resolve issues. Admins play a crucial role.");
                      // log(userProfile.description!.length);
                      // AuthController.addInstagramLink(
                      //     instagramLink:
                      //         "https://www.instagram.com/_____sanjay.____?igsh=bGZoYmttajdmNGY=");
                      // AuthController.deleteCurrentAdminAccount();
                      // );
                      // AuthController.deleteInstagramLink();
                      // DataUploadAdmin.uploadPreset(name: "Moddy",price: 300);
                    },
                    child: const Text('Logout'),
                  ),
                  SizedBox(
                    height: 50,
                  )
                ],
              ),
            );
          }
        },
      ),
    );
  }
}

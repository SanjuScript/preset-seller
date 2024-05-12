
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:seller_app/API/auth_api.dart';
import 'package:seller_app/CONSTANTS/assets.dart';
import 'package:seller_app/CONSTANTS/fonts.dart';
import 'package:seller_app/DATA/update_data.dart';
import 'package:seller_app/FUNCTIONS/wallet_access_function.dart';
import 'package:seller_app/HELPERS/color_helper.dart';
import 'package:seller_app/HELPERS/date_helper.dart';
import 'package:seller_app/MODEL/admin_data_model.dart';
import 'package:seller_app/PROVIDERS/user_profile_provider.dart';
import 'package:seller_app/SCREENS/profile_editing_page.dart';
import 'package:seller_app/SCREENS/wallet/wallet_page.dart';
import 'package:seller_app/WIDGETS/BUTTONS/preset_uploading.button.dart';
import 'package:seller_app/WIDGETS/BUTTONS/verification_widget.dart';
import 'package:seller_app/WIDGETS/profile_element.dart';
import 'package:seller_app/WIDGETS/profile_image.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with AutomaticKeepAliveClientMixin {
  late UserProfileProvider userProfile;
  bool isVerified = AuthApi.auth.currentUser!.emailVerified;
  @override
  void initState() {
    super.initState();
    userProfile = Provider.of<UserProfileProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    Size size = MediaQuery.sizeOf(context);
    return Scaffold(
      backgroundColor: getColor("#f2f2f2"),
      body: StreamBuilder<AdminProfile>(
        stream: userProfile.getUserProfileStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final adminProfile = snapshot.data!;
            int? uploadedCount = userProfile.uploadedCount;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: size.height * .05,
                  ),
                  Center(
                    child: SizedBox(
                      height: size.height * .28,
                      width: size.width,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            AdminImage(
                                url: adminProfile.userProfileUrl.toString()),
                            const Spacer(),
                            Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    // color: Colors.purple[200],
                                    height: size.height * .20,
                                    width: size.width * .54,
                                    child: Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "${adminProfile.firstName ?? ''} ${adminProfile.lastName ?? ''}",
                                            style: TextStyle(
                                              fontSize: size.width * 0.06,
                                              overflow: TextOverflow.ellipsis,
                                              fontWeight: FontWeight.normal,
                                              color: Colors.black87,
                                              fontFamily: Getfont.rounder,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                          Text(
                                            "Joined on ${DataFormateHelper.formatDate(AuthApi.auth.currentUser!.metadata.creationTime)}",
                                            style: TextStyle(
                                                fontSize: size.width * 0.03,
                                                overflow: TextOverflow.ellipsis,
                                                fontWeight: FontWeight.w100,
                                                color: Colors.black45,
                                                fontFamily: Getfont.rounder),
                                            textAlign: TextAlign.center,
                                          ),
                                          Text(
                                            adminProfile.email ?? '',
                                            style: TextStyle(
                                                fontSize: size.width * 0.034,
                                                overflow: TextOverflow.ellipsis,
                                                fontWeight: FontWeight.w100,
                                                color: Colors.black38,
                                                fontFamily: Getfont.rounder),
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  if (!isVerified)
                    const Center(
                      child: EmailNotverified(),
                    ),
                  SizedBox(
                    height: size.height * .11,
                    width: size.width * .90,
                    child: FittedBox(
                      child: Row(
                        children: [
                          ProfileElement(
                            text: "Posts",
                            count: (uploadedCount ?? '0').toString(),
                            rradius: 0,
                          ),
                          ProfileElement(
                            text: "Likes",
                            count: (adminProfile.likes ?? '0').toString(),
                            rradius: 0,
                            ladius: 0,
                          ),
                          ProfileElement(
                            text: "Earned",
                            count: (adminProfile.earned ?? '0').toString(),
                            ladius: 0,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Center(
                    child: SizedBox(
                      width: size.width * .85,
                      child: GetPresetUploadingButton(
                        onPressed: () {
                          WalletController.createWalletCollection(
                              adminProfile.uid.toString());
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ProfileEditingPage(
                                      adminData: adminProfile)));
                        },
                        text: "Edit Profile",
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Center(
                    child: SizedBox(
                      width: size.width * .85,
                      child: GetPresetUploadingButton(
                        color: Colors.white,
                        textColor: Colors.black87,
                        onPressed: () {
                          // WalletController.createWalletCollection(
                          //     adminProfile.uid.toString());

                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>  WalletPage()));
                        },
                        text: "Your Balance \$",
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  adminProfile.instagram == null ||
                          adminProfile.instagram!.isEmpty
                      ? const SizedBox()
                      : ListTile(
                          onTap: () async {
                            // log(adminProfile.instagram.toString());
                            if (await canLaunchUrl(
                                Uri.parse(adminProfile.instagram.toString()))) {
                              await launchUrl(
                                  Uri.parse(adminProfile.instagram.toString()));
                            }
                          },
                          title: const Text("Instagram"),
                          leading: SvgPicture.asset(
                            GetAssetFile.instaIcon,
                            height: size.height * 0.04,
                            width: size.width * 0.04,
                          ),
                          subtitle: Text(
                            adminProfile.instagram ?? '',
                            maxLines: 1,
                            style: const TextStyle(
                              // fontSize: size.width * 0.034,
                              overflow: TextOverflow.ellipsis,
                              fontWeight: FontWeight.w100,
                              color: Colors.black54,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                  adminProfile.description == null ||
                          adminProfile.description!.isEmpty
                      ? const SizedBox()
                      : ListTile(
                          title: const Text("Description"),
                          leading: Icon(
                            Icons.description_rounded,
                            color: Colors.green[300],
                          ),
                          subtitle: Text(
                            adminProfile.description ?? '',
                            maxLines: 1,
                            style: const TextStyle(
                              overflow: TextOverflow.ellipsis,
                              fontWeight: FontWeight.w100,
                              color: Colors.black54,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                  const SizedBox(height: 10),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      UpdateAdminData.signOut(context);
                    },
                    child: const Text('Logout'),
                  ),
                  const SizedBox(
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

  @override
  bool get wantKeepAlive => true;
}

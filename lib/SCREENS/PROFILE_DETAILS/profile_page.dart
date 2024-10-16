import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:seller_app/API/auth_api.dart';
import 'package:seller_app/CONSTANTS/assets.dart';
import 'package:seller_app/CUSTOM/font_controller.dart';
import 'package:seller_app/EXTENSION/capitalize.dart';
import 'package:seller_app/EXTENSION/color_extension.dart';
import 'package:seller_app/MODEL/admin_data_model.dart';
import 'package:seller_app/PROVIDERS/user_profile_provider.dart';
import 'package:seller_app/SCREENS/PROFILE_DETAILS/profile_editing_page.dart';
import 'package:seller_app/SCREENS/WALLET/wallet_page.dart';
import 'package:seller_app/WIDGETS/BUTTONS/verification_widget.dart';
import 'package:seller_app/WIDGETS/DIALOGUE/DIALOGUE_UTILS/dialogue_utils.dart';
import 'package:seller_app/WIDGETS/PROFILE_AREA/profile_list.dart';
import 'package:seller_app/WIDGETS/Texts/helper_texts.dart';
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
      extendBodyBehindAppBar: false,
      appBar: AppBar(
        title: HelperText1(
          text: "User Profile".capitalizeFirstLetterOfEachWord(),
          color: Colors.black87,
          fontSize: 25,
        ),
        actions: [
          StreamBuilder<AdminProfile>(
              stream: userProfile.getUserProfileStream(),
              builder: (context, snapshot) {
                return IconButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return ProfileEditingPage(adminData: snapshot.data!);
                    }));
                  },
                  icon: const Icon(Icons.settings),
                );
              }),
        ],
        backgroundColor: Colors.white,
      ),
      backgroundColor: "#F0F8FF".toColor(),
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
                    height: size.height * .02,
                  ),
                  Center(
                    child: SizedBox(
                      height: size.height * .25,
                      width: size.width,
                      child: AdminImage(
                          url: adminProfile.userProfileUrl.toString()),
                    ),
                  ),
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          // color: Colors.purple[200],
                          height: size.height * .10,
                          width: size.width * .54,
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "${adminProfile.firstName ?? ''} ${adminProfile.lastName ?? ''}",
                                  style: PerfectTypogaphy.bold.copyWith(
                                    color: Colors.black87,
                                    overflow: TextOverflow.ellipsis,
                                    fontSize: size.width * 0.06,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                Text(
                                  adminProfile.email ?? '',
                                  style: PerfectTypogaphy.regular.copyWith(
                                    color: Colors.black87,
                                    overflow: TextOverflow.ellipsis,
                                    fontSize: size.width * 0.034,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (!isVerified)
                    const Center(
                      child: EmailNotverified(),
                    ),
                  SizedBox(
                    height: size.height * .14,
                    width: size.width,
                    child: Padding(
                      padding: const EdgeInsets.all(1),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment
                              .spaceEvenly, // Ensure equal spacing
                          crossAxisAlignment:
                              CrossAxisAlignment.center, // Aligns vertically
                          children: [
                            Expanded(
                              child: Center(
                                child: ProfileElement(
                                  text: "Posts",
                                  count: (uploadedCount ?? '0').toString(),
                                  rradius: 0,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Center(
                                child: ProfileElement(
                                  text: "Likes",
                                  count: (adminProfile.likes ?? '0').toString(),
                                  rradius: 0,
                                  ladius: 0,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Center(
                                child: ProfileElement(
                                  text: "Earned",
                                  count:
                                      (adminProfile.earned ?? '0').toString(),
                                  ladius: 0,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  ProfileListViewer(
                    desc: "Tap to see your wallet details",
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return WalletPage();
                      }));
                    },
                    text: "Wallet",
                    leading: Icon(
                      Icons.wallet,
                      color: "#eff3fc".toColor(),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  adminProfile.instagram == null ||
                          adminProfile.instagram!.isEmpty
                      ? const SizedBox()
                      : ProfileListViewer(
                          desc: adminProfile.instagram!,
                          onTap: () async {
                           
                          },
                          text: "Instagram",
                          leading: Image.asset(
                            scale: size.height * .050,
                            GetAssetFile.instaIcon,
                          ),
                        ),
                  const SizedBox(
                    height: 5,
                  ),
                  adminProfile.description == null ||
                          adminProfile.description!.isEmpty
                      ? const SizedBox()
                      : ProfileListViewer(
                          desc: adminProfile.description!,
                          onTap: () {},
                          text: "Description",
                          leading: Icon(
                            Icons.description_rounded,
                            color: "#eff3fc".toColor(),
                          ),
                        ),
                  const SizedBox(height: 10),
                  const SizedBox(height: 20),
                  LogoutButton(
                    onPressed: () {
                      DialogueUtils.showDialogue(context, 'logout');
                    },
                  ),
                  const SizedBox(
                    height: 80,
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


class LogoutButton extends StatelessWidget {
  final VoidCallback onPressed;

  const LogoutButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Colors.redAccent, Colors.deepOrangeAccent],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(25),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            offset: Offset(0, 5),
            blurRadius: 10,
          ),
        ],
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
        onPressed: onPressed,
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.logout, color: Colors.white),
            SizedBox(width: 10),
            Text(
              'Logout',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:seller_app/CONSTANTS/assets.dart';
import 'package:seller_app/CONSTANTS/fonts.dart';
import 'package:seller_app/CUSTOM/font_controller.dart';
import 'package:seller_app/EXTENSION/capitalize.dart';
import 'package:seller_app/SCREENS/lightroom_presets/presets_list.dart';
import 'package:seller_app/SCREENS/notification_message_area.dart';
import 'package:seller_app/WIDGETS/Texts/helper_texts.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  ScrollController scrollController = ScrollController();
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: HelperText1(
          text: "Category List".capitalizeFirstLetterOfEachWord(),
          color: Colors.black87,
          fontSize: 25,
        ),
        leadingWidth: 40,
       actions: [
          InkWell(
            onTap: () {
               Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const NotificationPage()),
              );
            },
            child: Stack(
              clipBehavior: Clip.none, // This allows overflow
              children: [
                const Icon(Icons.notifications_on_rounded, size: 30),
                if (true)
                  Positioned(
                    right: 0,
                    top: -3,
                    child: Container(
                      height: 12,
                      width: 12,
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Menu',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: ListView(
        controller: scrollController,
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: ListView.builder(
              itemCount: 1,
              controller: scrollController,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const PresetListPage()),
                    );
                  },
                  child: Container(
                    height: size.height * .25,
                    margin: const EdgeInsets.symmetric(vertical: 10.0),
                    decoration: BoxDecoration(
                      color: Colors.black87.withOpacity(.8),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 15,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Stack(
                        children: [
                          Image.asset(
                            GetAssetFile.presetImg,
                            fit: BoxFit.cover,
                            height: size.height * .30,
                            width: size.width,
                            color: Colors.black.withOpacity(0.3),
                            colorBlendMode: BlendMode.darken,
                          ),
                          Center(
                            child: Text(
                              'Lightroom Presets'
                                  .capitalizeFirstLetterOfEachWord(),
                              style: PerfectTypogaphy.regular.copyWith(
                                color: Colors.white,
                                fontSize: 28,
                                shadows: [
                                  Shadow(
                                      color: Colors.black.withOpacity(0.7),
                                      blurRadius: 8),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}



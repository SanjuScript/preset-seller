import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:seller_app/CONSTANTS/assets.dart';
import 'package:seller_app/CONSTANTS/fonts.dart';
import 'package:seller_app/EXTENSION/capitalize.dart';
import 'package:seller_app/EXTENSION/color_extension.dart';
import 'package:seller_app/HELPERS/color_helper.dart';
import 'package:seller_app/SCREENS/lightroom_presets/presets_list.dart';
import 'package:seller_app/WIDGETS/Texts/helper_texts.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // List<Color> getColors = [
  //   Colors.red[300]!,
  //   Colors.blue[300]!,
  //   Colors.teal[300]!,
  //   Colors.purple[300]!,
  //   Colors.green[300]!,
  // ];
  ScrollController scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);

    return Scaffold(
        appBar: AppBar(
          title: HelperText1(
            text: "Catogory list".capitalizeFirstLetterOfEachWord(),
            color: Colors.black87,
            fontSize: 25,
          ),
          backgroundColor: Colors.white,
        ),
        backgroundColor: "#f2f2f2".toColor(),
        body: ListView(
          controller: scrollController,
          children: [
            SizedBox(
              width: size.width * 85,
              child: ListView.builder(
                itemCount: 1,
                controller: scrollController,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const PresetListPage()));
                      },
                      child: Container(
                        height: size.height * .25,
                        width: size.width * 85,
                        decoration: BoxDecoration(
                            color: Colors.black87.withOpacity(.9),
                            border: Border.all(color: Colors.black87, width: 2),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black87.withOpacity(.9),
                                  spreadRadius: 2,
                                  offset: const Offset(2, -2)),
                              const BoxShadow(
                                  color: Colors.black87,
                                  blurRadius: 8,
                                  spreadRadius: 2,
                                  offset: Offset(-2, 2)),
                              BoxShadow(
                                  color: Colors.white12.withOpacity(.5),
                                  spreadRadius: 2,
                                  blurRadius: 30,
                                  offset: const Offset(2, -2)),
                              BoxShadow(
                                  color: Colors.white12.withOpacity(.5),
                                  spreadRadius: 2,
                                  blurRadius: 30,
                                  offset: const Offset(-2, -2)),
                            ]),
                        child: Stack(
                          children: [
                            Center(
                              child: SizedBox(
                                height: size.height * .25,
                                width: size.width * 85,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: Image.asset(
                                    gaplessPlayback: true,
                                    GetAssetFile.presetImg,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              height: size.height * .25,
                              width: size.width * 85,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Colors.transparent,
                                      Colors.black54,
                                      Colors.transparent
                                    ],
                                  )),
                            ),
                            Center(
                              child: Text(
                                'Lightroom presets'
                                    .capitalizeFirstLetterOfEachWord(),
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 35,
                                  fontFamily: Getfont.mauline,
                                  fontWeight: FontWeight.bold,
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
        ));
  }
}

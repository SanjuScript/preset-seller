// ignore_for_file: use_build_context_synchronously

import 'dart:developer';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:seller_app/EXTENSION/capitalize.dart';
import 'package:seller_app/FUNCTIONS/PRESET_CONTROLLER/preset_uploader.dart';
import 'package:seller_app/MODEL/preset_data_model.dart';
import 'package:seller_app/MODEL/review_data_model.dart';
import 'package:seller_app/PROVIDERS/page_view_controller_provider.dart';
import 'package:seller_app/SCREENS/preset_metadata_edit.dart';
import 'package:seller_app/SCREENS/review_page.dart';
import 'package:seller_app/WIDGETS/BUTTONS/preset_metadata_edit_buttons.dart';
import 'package:seller_app/WIDGETS/CARD/list_of_presets_card.dart';
import 'package:seller_app/WIDGETS/CARD/multi_preset_view.dart';
import 'package:seller_app/WIDGETS/Texts/helper_text2.dart';
import 'package:seller_app/WIDGETS/Texts/preset_name_price_text.dart';
import 'package:seller_app/WIDGETS/Texts/preset_page_helper_text.dart';
import 'package:seller_app/WIDGETS/Texts/preset_page_read_more_text.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

enum STATUS { approved, rejected, pending }

class PresetViewPage extends StatefulWidget {
  final PresetModel presetModel;
  const PresetViewPage({super.key, required this.presetModel});

  @override
  State<PresetViewPage> createState() => _PresetViewPageState();
}

class _PresetViewPageState extends State<PresetViewPage> {
  late PageController pageController;
  bool currentStatus = false;
  void onPageChange(int index) {
    final provider = context.read<PresetsPageViewContollerProvider>();
    provider.selectedIndex = index;
  }

  ScrollController scrollController = ScrollController();
// Function to pick images from device storage

  List<File> selectedImages = [];
  Future<void> pickImages() async {
    try {
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
            selectedImages.add(File(xfilePicks[i].path));
          }
        } else {
          Fluttertoast.showToast(msg: 'Nothing is selected');
        }
      });
    } catch (e) {
      print('Error picking images: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    final provider = context.read<PresetsPageViewContollerProvider>();
    pageController = provider.createPageController();
    // currentStatus = presetModel.status == "approved";
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final PresetModel presetModel = widget.presetModel!;
    if (presetModel != null) {
      setState(() {
        currentStatus = presetModel.status == "approved";
      });
    } else {
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // log(widget.presetModel.presets.toString());
    Size size = MediaQuery.sizeOf(context);
    final provider = Provider.of<PresetsPageViewContollerProvider>(context);

    final PresetModel presetModel = widget.presetModel;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Lightroom Presets - ${presetModel.presets!.length.toString()}",
          style: Theme.of(context)
              .textTheme
              .displayMedium
              ?.copyWith(fontSize: size.width * .07),
        ),
      ),
      body: SingleChildScrollView(
        controller: scrollController,
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            Column(
              children: [
                SizedBox(
                  height: size.height * 0.40,
                  width: size.width * 0.98,
                  child: Stack(
                    children: [
                      PageView.builder(
                        controller: pageController,
                        itemCount: presetModel.presets!.length +
                            presetModel.coverImages!.length,
                        onPageChanged: onPageChange,
                        itemBuilder: (context, index) {
                          if (index < presetModel.presets!.length) {
                            return ListOfPresets(
                              url: presetModel.presets![index],
                            );
                          } else {
                            int coverIndex =
                                index - presetModel.presets!.length;
                            return ListOfPresets(
                              url: presetModel.coverImages![coverIndex],
                            );
                          }
                        },
                      ),
                      if (!currentStatus)
                        Align(
                          alignment: Alignment.center,
                          child: Container(
                            height: size.height * 0.40,
                            width: size.width * 0.98,
                            decoration: BoxDecoration(
                                color: Colors.white.withOpacity(.8),
                                borderRadius: BorderRadius.circular(20)),
                            child: Center(
                              child: Text(
                                "In review".capitalizeFirstLetterOfEachWord(),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(color: Colors.black87),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 15),
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            height: size.height * .02,
                            width: size.width * .25,
                            decoration: BoxDecoration(
                                color: Colors.grey.withOpacity(0),
                                borderRadius: BorderRadius.circular(20)),
                            child: Center(
                              child: SmoothPageIndicator(
                                controller: pageController, // PageController
                                count: presetModel.presets!.length +
                                    presetModel.coverImages!.length,
                                effect: const WormEffect(
                                  dotWidth: 8,
                                  dotColor: Colors.white,
                                  activeDotColor: Colors.black87,
                                  dotHeight: 8,
                                ),
                                onDotClicked: (index) {
                                  provider.navigateToPage(
                                      pageController, index);
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: size.height * .11,
                  width: size.width * .90,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: presetModel.presets!.length +
                        presetModel.coverImages!.length +
                        2,
                    itemBuilder: (context, index) {
                      if (index < presetModel.presets!.length) {
                        return PresetAndCoverImageView(
                          onTap: () {
                            provider.navigateToPage(pageController, index);
                          },
                          index: index,
                          imgUrl: presetModel.presets![index],
                        );
                      } else if (index == presetModel.presets!.length) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 15),
                          child: VerticalDivider(
                            thickness: 2,
                          ),
                        );
                      } else if (index ==
                          presetModel.presets!.length +
                              presetModel.coverImages!.length +
                              1) {
                        return SizedBox(
                          height: size.height * .10,
                          width: size.width * .26,
                          child: InkWell(
                            onTap: () async {
                              PresetUploader.addMoreCoverImages(
                                  docId: presetModel.docId.toString(),
                                  isListedPreset: presetModel.isList!);
                            },
                            child: Container(
                                margin: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.grey[350],
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(Icons.add_a_photo_rounded)),
                          ),
                        );
                      } else {
                        int coverIndex =
                            index - presetModel.presets!.length - 1;
                        return PresetAndCoverImageView(
                          onTap: () {
                            provider.navigateToPage(pageController, index - 1);
                          },
                          index: index - 1,
                          imgUrl: presetModel.coverImages![coverIndex],
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            GetPresetNameGiver(
              presetName: presetModel.name.toString(),
              price: presetModel.isPaid!
                  ? "${presetModel.price.toString()} RS"
                  : "FREE",
            ),
            GetReadMoreText(text: presetModel.description.toString()),
            const SizedBox(height: 10),
            GetPresetEditButton(
              onPressed: () {
                log(currentStatus.toString());
                if (currentStatus) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PresetMetadataEditingPage(
                                presetModel: presetModel,
                              )));
                } else {
                  Fluttertoast.showToast(
                      msg: "You can perform this action after reviewing");
                }
              },
              status: currentStatus,
            ),
            const SizedBox(
              height: 15,
            ),
            Padding(
              padding: EdgeInsets.only(left: 20.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: GetText1(text: "Details", size: size.width * 0.07),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              height: size.height * .23,
              width: size.width * .90,
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  buildInfoRow(
                    icon: Icons.shopping_bag,
                    label: "People Purchased",
                    value: presetModel.presetsBoughtCount.toString(),
                    size: size.width * 0.05,
                  ),
                  const Divider(),
                  buildInfoRow(
                    icon: Icons.favorite,
                    label: "Saves",
                    value: presetModel.likeCount.toString(),
                    size: size.width * 0.05,
                  ),
                  const Divider(),
                  buildInfoRow(
                    icon: Icons.share,
                    label: "Shares",
                    value: presetModel.shares.toString(),
                    size: size.width * 0.05,
                  ),
                  const Divider(),
                  InkWell(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return ReviewPage(reviews: fakeReviews);
                      }));
                    },
                    child: buildInfoRow(
                      icon: Icons.reviews,
                      label: "See Reviews",
                      value: presetModel.shares.toString(),
                      showValue: false,
                      size: size.width * 0.05,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            if (!currentStatus)
              const HelperText2(
                text:
                    "Please note that our review process may take up to 7 days due to the high volume of submissions we receive",
                color: Colors.black45,
              ),
            const SizedBox(
              height: 30,
            ),
          ],
        ),
      ),
    );
  }
}

List<ReviewModel> fakeReviews = [
  ReviewModel(
    userName: "John Doe",
    rating: 5,
    comment: "Amazing product! Exceeded my expectations.",
    date: "2024-09-28",
    profilUrl: "https://randomuser.me/api/portraits/men/1.jpg",
  ),
  ReviewModel(
    userName: "Jane Smith",
    rating: 4,
    comment: "Very good, but there’s some room for improvement.",
    date: "2024-09-26",
    profilUrl: "https://randomuser.me/api/portraits/women/2.jpg",
  ),
  ReviewModel(
    userName: "David Brown",
    rating: 3,
    comment: "It’s okay, but I had higher expectations.",
    date: "2024-09-25",
    profilUrl: "https://randomuser.me/api/portraits/men/3.jpg",
  ),
  ReviewModel(
    userName: "Emily Clark",
    rating: 5,
    comment: "Absolutely love it! Will recommend to everyone.",
    date: "2024-09-24",
    profilUrl: "https://randomuser.me/api/portraits/women/4.jpg",
  ),
  ReviewModel(
    userName: "Michael Johnson",
    rating: 2,
    comment: "Not worth the price. Disappointed with the quality.",
    date: "2024-09-23",
    profilUrl: "https://randomuser.me/api/portraits/men/5.jpg",
  ),
  ReviewModel(
    userName: "Sophia Davis",
    rating: 4,
    comment: "Good product overall, happy with my purchase.",
    date: "2024-09-22",
    profilUrl: "https://randomuser.me/api/portraits/women/6.jpg",
  ),
  ReviewModel(
    userName: "Daniel Wilson",
    rating: 3,
    comment: "It’s fine, but there are better options available.",
    date: "2024-09-21",
    profilUrl: "https://randomuser.me/api/portraits/men/7.jpg",
  ),
  ReviewModel(
    userName: "Olivia Martinez",
    rating: 5,
    comment: "Fantastic product! I use it every day.",
    date: "2024-09-20",
    profilUrl: "https://randomuser.me/api/portraits/women/8.jpg",
  ),
];

Widget buildInfoRow(
    {required IconData icon,
    required String label,
    required String value,
    required double size,
    bool showValue = true}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Row(
        children: [
          Icon(icon, color: Colors.black87),
          SizedBox(width: 8),
          GetText1(
            text: label.capitalizeFirstLetterOfEachWord(),
            size: size,
          ),
        ],
      ),
      if (showValue)
        GetText1(
          text: value,
          size: size,
        ),
    ],
  );
}

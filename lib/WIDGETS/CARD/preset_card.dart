import 'dart:developer';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:seller_app/CUSTOM/font_controller.dart';
import 'package:seller_app/EXTENSION/capitalize.dart';
import 'package:seller_app/WIDGETS/STATUS_WIDGET/status_widget.dart';
import 'package:seller_app/WIDGETS/Texts/helper_texts.dart';

class PresetCard extends StatelessWidget {
  final String url;
  final String presetName;
  final String price;
  final String tag;
  final int length;
  final void Function() onTap;
  final bool isListed;
  final String status;
  final bool isPaid;
  final void Function()? onLongPress;
  final Color color;
  const PresetCard(
      {super.key,
      required this.url,
      required this.tag,
      required this.presetName,
      required this.price,
      this.onLongPress,
      this.color = Colors.white,
      required this.onTap,
      required this.isListed,
      required this.length,
      required this.isPaid,
      required this.status});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return InkWell(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        height: size.height * 0.32,
        width: size.width * 0.90,
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const SizedBox(height: 5),
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Hero(
                    tag: url,
                    child: CachedNetworkImage(
                      width: size.width * .90,
                      height: size.height * .25,
                      imageUrl: url,
                      fit: BoxFit.cover,
                      placeholder: (context, url) =>
                          const CircularProgressIndicator(),
                      errorWidget: (context, url, error) {
                        log(error.toString());
                        return const Icon(
                          Icons.error,
                          color: Colors.red,
                        );
                      },
                    ),
                  ),
                ),
                if (status != "approved") ...[
                  StatusDisplayer(status: status),
                ],
              ],
            ),
            const SizedBox(height: 5),
            SizedBox(
              height: size.height * .055,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    isPaid ? '$price RS' : "FREE",
                    style: PerfectTypogaphy.bold.copyWith(
                      fontSize: size.width * 0.06,
                      overflow: TextOverflow.ellipsis,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    presetName.capitalizeFirstLetterOfEachWord(),
                    style: PerfectTypogaphy.regular.copyWith(
                      fontSize: size.width * 0.06,
                      overflow: TextOverflow.ellipsis,
                      fontWeight: FontWeight.normal,
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.right,
                  ),
                  isListed
                      ? Container(
                          height: 30,
                          width: 30,
                          margin: const EdgeInsets.only(bottom: 10),
                          decoration: const BoxDecoration(
                            color: Colors.black87,
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            length.toString(),
                            style: TextStyle(
                              fontSize: size.width * 0.06,
                              overflow: TextOverflow.ellipsis,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontFamily: 'monuse',
                            ),
                            textAlign: TextAlign.center,
                          ),
                        )
                      : const SizedBox()
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

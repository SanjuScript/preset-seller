import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:seller_app/CONSTANTS/assets.dart';
import 'package:seller_app/EXTENSION/capitalize.dart';

class PresetCard extends StatelessWidget {
  final String url;
  final String presetName;
  final String price;
  final String tag;
  final int length;
  final void Function() onTap;
  final bool isListed;
  final String status;
  const PresetCard(
      {super.key,
      required this.url,
      required this.tag,
      required this.presetName,
      required this.price,
      required this.onTap,
      required this.isListed,
      required this.length,
      required this.status});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return InkWell(
      onTap: onTap,
      child: Container(
        height: size.height * 0.25,
        width: size.width * 0.90,
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          boxShadow: const [
            BoxShadow(
              color: Colors.white,
              offset: Offset(3, -3),
              blurRadius: 10,
            ),
            BoxShadow(
              color: Colors.white,
              offset: Offset(-3, 3),
              blurRadius: 10,
            ),
          ],
        ),
        child: Stack(
          fit: StackFit.passthrough,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: Hero(
                tag: url,
                child: CachedNetworkImage(
                  imageUrl: url,
                  fit: BoxFit.cover,
                  placeholder: (context, url) =>
                      const CircularProgressIndicator(),
                  errorWidget: (context, url, error) => const Icon(
                    Icons.error,
                    color: Colors.red,
                  ),
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.0),
                    Colors.transparent,
                    Colors.black.withOpacity(.8),
                  ],
                ),
              ),
              child: Stack(
                children: [
                  Container(
                    height: size.height * .04,
                    width: size.width * .95,
                    decoration: BoxDecoration(
                      color: status == "pending"
                          ? Colors.blue.withOpacity(.5)
                          : status == "rejected"
                              ? Colors.red.withOpacity(.5)
                              : Colors.transparent,
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(25),
                          topRight: Radius.circular(25)),
                    ),
                    child: status == "approved"
                        ? Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                              height: size.height * .04,
                              width: size.width * .30,
                              margin: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                color: Colors.white,
                              ),
                              child: Image.asset(GetAssetFile.approvedIcon)
                            ),
                          )
                        : Center(
                            child: Row(
                              // mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  width: 20,
                                ),
                                Icon(
                                  Icons.timelapse_rounded,
                                  color: Colors.white,
                                  size: size.width * 0.05,
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  status == "rejected"
                                      ? "Rejected"
                                      : "In review",
                                  style: TextStyle(
                                    fontSize: size.width * 0.03,
                                    overflow: TextOverflow.ellipsis,
                                    color: Colors.white,
                                    fontFamily: 'hando',
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 10),
                        child: Align(
                          alignment: Alignment.bottomRight,
                          child: Text(
                            '$price RS',
                            style: TextStyle(
                              fontSize: size.width * 0.06,
                              overflow: TextOverflow.ellipsis,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontFamily: 'rounder',
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 20),
                        child: Align(
                          alignment: Alignment.bottomRight,
                          child: Text(
                            presetName.capitalizeFirstLetterOfEachWord(),
                            style: TextStyle(
                              fontSize: size.width * 0.06,
                              overflow: TextOverflow.ellipsis,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontFamily: 'hando',
                            ),
                            textAlign: TextAlign.right,
                          ),
                        ),
                      ),
                      isListed
                          ? Align(
                              alignment: Alignment.bottomRight,
                              child: Container(
                                height: 30,
                                width: 30,
                                margin: const EdgeInsets.only(bottom: 10),
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                child: Text(
                                  length.toString(),
                                  style: TextStyle(
                                    fontSize: size.width * 0.06,
                                    overflow: TextOverflow.ellipsis,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                    fontFamily: 'rounder',
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            )
                          : const SizedBox()
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

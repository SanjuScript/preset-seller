import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:seller_app/EXTENSION/capitalize.dart';
import 'package:seller_app/HELPERS/color_helper.dart';

class ListOfPresets extends StatelessWidget {
  final String url;

  final void Function() onTap;
  const ListOfPresets(
      {super.key,
      required this.url,
     
      required this.onTap});

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
          boxShadow: [
            BoxShadow(
              color: Colors.white,
              offset: const Offset(3, -3),
              blurRadius: 10,
            ),
            BoxShadow(
              color: Colors.white,
              offset: const Offset(-3, 3),
              blurRadius: 10,
            ),
          ],
        ),
        child: ClipRRect(
              borderRadius: BorderRadius.circular(25),
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
    );
  }
}

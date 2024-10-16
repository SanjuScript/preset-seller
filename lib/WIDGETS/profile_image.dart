import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:seller_app/EXTENSION/color_extension.dart';

class AdminImage extends StatelessWidget {
  final String url;
  const AdminImage({super.key, required this.url});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
          color:"#f2f2f2".toColor(),
          shape: BoxShape.circle,
          boxShadow: const [
            BoxShadow(
                color: Colors.grey, spreadRadius: 2, offset: Offset(2, -2)),
            BoxShadow(color: Colors.grey, blurRadius: 8, offset: Offset(-2, 2))
          ]),
      // padding: const EdgeInsets.all(5),
      child: url != null
          ? Center(
              child: Hero(
                tag: "$url-2",
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: CachedNetworkImage(
                    imageUrl: url,
                    fit: BoxFit.cover,
                    placeholder: (context, url) =>
                        const CircularProgressIndicator(),
                    errorWidget: (context, url, error) => const Icon(
                      Icons.add_a_photo,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
            )
          : const Icon(
              Icons.add_a_photo,
              color: Colors.grey,
            ),
    );
  }
}

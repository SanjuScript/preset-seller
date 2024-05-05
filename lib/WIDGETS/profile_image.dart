import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:seller_app/HELPERS/color_helper.dart';

class AdminImage extends StatelessWidget {
  final String url;
  const AdminImage({super.key,required this.url});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Container(
      height: size.height * .22,
      width: size.width * .35,
      decoration: BoxDecoration(
          color: getColor("#f2f2f2"),
          borderRadius: BorderRadius.circular(14),
          boxShadow: const [
            BoxShadow(
                color: Colors.grey, spreadRadius: 2, offset: Offset(2, -2)),
            BoxShadow(color: Colors.grey, blurRadius: 8, offset: Offset(-2, 2))
          ]),
      padding: const EdgeInsets.all(5),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: url != null ? CachedNetworkImage(
          imageUrl:url,
          fit: BoxFit.cover,
          placeholder: (context, url) => const CircularProgressIndicator(),
          errorWidget: (context, url, error) => const Icon(
            Icons.add_a_photo,
            color: Colors.grey,
          ),
        ) : const Icon(
            Icons.add_a_photo,
            color: Colors.grey,
          ),
      ),
    );
  }
}

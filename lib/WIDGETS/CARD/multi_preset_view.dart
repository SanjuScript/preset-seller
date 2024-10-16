import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seller_app/PROVIDERS/page_view_controller_provider.dart';

class PresetAndCoverImageView extends StatelessWidget {
  final void Function() onTap;
  final int index;
  final String imgUrl;
  const PresetAndCoverImageView(
      {super.key,
      required this.onTap,
      required this.index,
      required this.imgUrl});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return InkWell(
      onTap: onTap,
      child: SizedBox(
          height: size.height * .10,
          width: size.width * .26,
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Consumer<PresetsPageViewContollerProvider>(
                builder: (context, value, child) {
              return Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                      color: value.selectedIndex == index
                          ? Colors.grey[600]!
                          : Colors.transparent,
                      width: 3),
                ),
                child: Stack(
                  fit: StackFit.passthrough,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: CachedNetworkImage(
                        imageUrl: imgUrl,
                        fit: BoxFit.cover,
                        placeholder: (context, url) =>
                            const CircularProgressIndicator(),
                        errorWidget: (context, url, error) => const Icon(
                          Icons.error,
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
          )),
    );
  }
}

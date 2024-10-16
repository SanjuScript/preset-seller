import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PresetMetaDataEditingView extends StatelessWidget {
  final String? imgUrl;
  final void Function()? onCDelete;
  final void Function()? onIremove;
  final bool fromDB;
  final File? file;

  const PresetMetaDataEditingView({
    super.key,
    this.file,
    this.onIremove,
    required this.fromDB,
    this.imgUrl,
    this.onCDelete,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return InkWell(
      child: SizedBox(
        height: size.height * .15,
        width: size.width * .26,
        child: Padding(
          padding: const EdgeInsets.all(5),
          child: Stack(
            fit: StackFit.passthrough,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: fromDB
                    ? CachedNetworkImage(
                        imageUrl: imgUrl!,
                        fit: BoxFit.cover,
                        placeholder: (context, url) =>
                            const CircularProgressIndicator(),
                        errorWidget: (context, url, error) => const Icon(
                          Icons.error,
                          color: Colors.red,
                        ),
                      )
                    : Image.file(
                        file!,
                        fit: BoxFit.cover,
                      ),
              ),
              Positioned(
                top: -10,
                right: -5,
                child: IconButton.filled(
                  style: IconButton.styleFrom(backgroundColor: Colors.black54),
                  icon:  Icon(
                    Icons.delete,
                    color: fromDB ? Colors.blue[200]: Colors.white,
                  ),
                  onPressed: () {
                    if (fromDB) {
                      onCDelete!();
                    } else {
                      onIremove!();
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:seller_app/EXTENSION/capitalize.dart';

class DeleteImageDialog extends StatelessWidget {
  final String imageUrl;
  final String imageKey;

  const DeleteImageDialog({
    super.key,
    required this.imageUrl,
    required this.imageKey,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return AlertDialog(
      title: Text('Delete image'.capitalizeFirstLetterOfEachWord()),
      content: SizedBox(
        height: size.height * .32,
        width: size.width * .45,
        child: Column(
          children: [
            Text(
              "Are you sure you want to delete this preset ? This action cannot be undone.",
            ),
            SizedBox(
              height: 15,
            ),
            SizedBox(
              height: size.height * .22,
              width: size.width * .50,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: CachedNetworkImage(
                  fit: BoxFit.cover,
                  imageUrl: imageUrl,
                  key: ValueKey(imageKey), // Use imageKey for unique caching
                  placeholder: (context, url) =>
                      const CircularProgressIndicator(),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () async {
            Navigator.of(context).pop(false);
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(true);
          },
          child: const Text(
            'Delete',
            style: TextStyle(color: Colors.red),
          ),
        ),
      ],
    );
  }
}

Future<bool> showSingleImageDeleteDialogue(
    {required BuildContext context, required String imageUrl}) async {
  String imageKey = imageUrl;
  return await showDialog(
    context: context,
    builder: (context) => DeleteImageDialog(
      imageUrl: imageUrl,
      imageKey: imageKey,
    ),
  );
}

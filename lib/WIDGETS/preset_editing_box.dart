import 'package:flutter/material.dart';
import 'package:seller_app/WIDGETS/Texts/helper_texts.dart';

class PresetEditingBox extends StatelessWidget {
  final void Function() onTap;
  final TextEditingController nameEditingController;
  final TextEditingController priceEditingController;
  final TextEditingController descEditingController;
  const PresetEditingBox(
      {super.key,
      required this.onTap,
      required this.nameEditingController,
      required this.priceEditingController,
      required this.descEditingController});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      height: size.height * 0.60,
      width: size.width * 0.95,
      alignment: Alignment.center,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20), color: Colors.grey[300]),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            const HelperText1(
              text: "Name",
              color: Colors.black54,
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(10)),
              child: TextFormField(
                controller: nameEditingController,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.done,
                decoration: const InputDecoration(
                  hintText: 'Name',
                  border: InputBorder.none,
                  hintStyle: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black38,
                    fontFamily: 'hando',
                  ),
                ),
              ),
            ),
            const SizedBox(height: 15),
            const HelperText1(
              text: "Price",
              color: Colors.black54,
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(10)),
              child: TextFormField(
                controller: priceEditingController,
                keyboardType: const TextInputType.numberWithOptions(),
                textInputAction: TextInputAction.done,
                decoration: const InputDecoration(
                  hintText: 'Price',
                  border: InputBorder.none,
                  hintStyle: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black38,
                    fontFamily: 'hando',
                  ),
                ),
              ),
            ),
            const SizedBox(height: 15),
            const HelperText1(
              text: "Description",
              color: Colors.black54,
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(10)),
              child: TextFormField(
                maxLength: 450,
                maxLines: 3,
                controller: descEditingController,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.done,
                decoration: const InputDecoration(
                  hintText: 'Description',
                  border: InputBorder.none,
                  hintStyle: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black38,
                    fontFamily: 'hando',
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            InkWell(
              onTap: onTap,
              child: Container(
                height: size.height * .09,
                width: size.width * .90,
                decoration: BoxDecoration(
                  color: Colors.black87,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Center(
                  child: Text(
                    "Save ",
                    style: TextStyle(
                      fontSize: size.width * 0.06,
                      overflow: TextOverflow.ellipsis,
                      color: Colors.white,
                      fontFamily: 'hando',
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

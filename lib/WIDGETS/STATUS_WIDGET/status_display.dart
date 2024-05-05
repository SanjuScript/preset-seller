import 'package:flutter/material.dart';
import 'package:seller_app/CONSTANTS/assets.dart';
import 'package:seller_app/WIDGETS/Texts/helper_texts.dart';

class RejectedDisplay extends StatelessWidget {
  const RejectedDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Align(
      alignment: Alignment.topLeft,
      child: SizedBox(
        height: size.height * .06,
        width: size.width * .30,
        child: SizedBox(
          height: size.height * .06,
          width: size.width * .20,
          child: Image.asset(
            GetAssetFile.rejectedIcon,
            gaplessPlayback: true,
          ),
        ),
      ),
    );
  }
}

class ApprovedDisplay extends StatelessWidget {
  const ApprovedDisplay({super.key});

  @override
  Widget build(BuildContext context) {
      Size size = MediaQuery.of(context).size;
    return Align(
      alignment: Alignment.topLeft,
      child: SizedBox(
        height: size.height * .07,
        width: size.width * .30,
        child: FittedBox(
          child: Row(
            children: [
              SizedBox(
                height: size.height * .06,
                width: size.width * .20,
                child: Image.asset(
                  GetAssetFile.approvedIcon,
                  gaplessPlayback: true,
                ),
              ),
              const HelperText1(text: "Approved")
            ],
          ),
        ),
      ),
    );
  }
}

class ReviewDisplay extends StatelessWidget {
  const ReviewDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Align(
      alignment: Alignment.topLeft,
      child: SizedBox(
        height: size.height * .07,
        width: size.width * .30,
        child: FittedBox(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 5),
            child: Row(
              children: [
                Icon(
                  Icons.access_time_filled_rounded,
                  size: size.height * .04,
                  color: Colors.blue[600],
                ),
                const SizedBox(
                  width: 10,
                ),
                const HelperText1(text: "In review")
              ],
            ),
          ),
        ),
      ),
    );
  }
}

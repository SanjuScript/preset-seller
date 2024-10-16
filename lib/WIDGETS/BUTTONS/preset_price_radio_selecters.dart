// ignore: must_be_immutable
import 'package:flutter/material.dart';

class CustomRadioButtons extends StatefulWidget {
  bool isPaid;
  final void Function() free;
  final void Function() paid;
  final void Function(bool?)? onChanged1;
  final void Function(bool?)? onChanged2;
  CustomRadioButtons(
      {super.key,
      required this.onChanged1,
      required this.onChanged2,
      required this.isPaid,
      required this.free,
      required this.paid});

  @override
  _CustomRadioButtonsState createState() => _CustomRadioButtonsState();
}

class _CustomRadioButtonsState extends State<CustomRadioButtons> {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    return SizedBox(
      height: size.height * .10,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: widget.free,
                  child: Container(
                    height: size.height * .08,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color:
                          widget.isPaid ? Colors.grey.shade300 : Colors.black87,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color:
                            widget.isPaid ? Colors.black87 : Colors.transparent,
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 5,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Radio<bool>(
                            activeColor: !widget.isPaid ?  Colors.white : Colors.black87,
                            value: false,
                            groupValue: widget.isPaid,
                            onChanged: widget.onChanged1),
                        Text('Free',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(color: !widget.isPaid ?  Colors.white : Colors.black87,)),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      widget.isPaid = true;
                    });
                  },
                  child: Container(
                    height: size.height * .08,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color:
                          widget.isPaid ? Colors.black87 : Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color:
                            widget.isPaid ? Colors.transparent : Colors.black87,
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 5,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Radio<bool>(
                            activeColor:
                                widget.isPaid ? Colors.white : Colors.black87,
                            value: true,
                            groupValue: widget.isPaid,
                            onChanged: widget.onChanged2),
                        Text('Paid',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                    color: widget.isPaid
                                        ? Colors.white
                                        : Colors.black87),),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

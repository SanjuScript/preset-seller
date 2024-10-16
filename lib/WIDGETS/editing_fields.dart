import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:seller_app/CONSTANTS/preset_lists.dart';

class ProfileEditingFields extends StatefulWidget {
  final bool isDesc;
  final bool isInsta;
  final TextEditingController controller;
  final String upText;
  final Color color;
  final TextInputType textInputType;
  final String hintText;
  final bool isNeed;
  final bool showDrop;
  ProfileEditingFields({
    super.key,
    required this.isDesc,
    required this.controller,
    required this.isNeed,
    this.showDrop = false,
    this.color = Colors.white,
    required this.textInputType,
    required this.upText,
    required this.hintText,
    required this.isInsta,
  });

  @override
  State<ProfileEditingFields> createState() => _ProfileEditingFieldsState();
}

class _ProfileEditingFieldsState extends State<ProfileEditingFields> {
  String? _selectedPreset;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: TextField(
              controller: widget.controller,
              textAlign: TextAlign.justify,
              maxLength: widget.isDesc ? 450 : (widget.isInsta ? 130 : null),
              maxLines: widget.isDesc ? null : 1,
              keyboardType: widget.textInputType,
              inputFormatters: [LengthLimitingTextInputFormatter(450)],
              decoration: InputDecoration(
                hintText: widget.hintText,
                hintStyle: TextStyle(
                  color: Colors.grey.shade600,
                ),
                border: InputBorder.none,
              ),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.black87,
                  ),
            ),
          ),
          if (widget.showDrop)
            SizedBox(
              width: size.width * .2,
              child: IconButton.filled(
                style: IconButton.styleFrom(backgroundColor: Colors.black12),
                icon: const Icon(
                  Icons.arrow_drop_down,
                  color: Colors.black87,
                ),
                onPressed: () {
                  _showPopupMenu(size);
                },
              ),
            ),
        ],
      ),
    );
  }

  void _showPopupMenu(Size size) async {
    final selectedPreset = await showMenu<String>(
      surfaceTintColor: Colors.transparent,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      context: context,
      position: const RelativeRect.fromLTRB(100, 100, 100, 100),
      items: presetNames.map((String value) {
        return PopupMenuItem<String>(
          value: value,
          child: SizedBox(
            width: size.width * .5,
            child: Text(value,
            maxLines: 1,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.black87,
              fontSize: size.width *.04,
              overflow: TextOverflow.ellipsis
            ),
            ),
          ),
        );
      }).toList(),
    );

    if (selectedPreset != null) {
      setState(() {
        _selectedPreset = selectedPreset;
        widget.controller.text = selectedPreset;
      });
    }
  }
}

class DescriptionWidget extends StatelessWidget {
  final TextEditingController controller;

  const DescriptionWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: TextField(
        textInputAction: TextInputAction.newline,
        controller: controller,
        textAlign: TextAlign.left,
        maxLength: 400,
        maxLines: null,
        keyboardType: TextInputType.multiline,
        inputFormatters: [LengthLimitingTextInputFormatter(400)],
        decoration: InputDecoration(
          hintText: "Enter description here...",
          hintStyle: TextStyle(
            color: Colors.grey[500],
          ),
          border: InputBorder.none,
        ),
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.black87,
            ),
      ),
    );
  }
}

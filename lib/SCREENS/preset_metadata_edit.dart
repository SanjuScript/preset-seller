
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:seller_app/FUNCTIONS/admin_data_controller_unit.dart';
import 'package:seller_app/HELPERS/color_helper.dart';
import 'package:seller_app/MODEL/preset_data_model.dart';
import 'package:seller_app/WIDGETS/preset_editing_box.dart';

class PresetMetadataEditingPage extends StatefulWidget {
  final PresetModel presetModel;
  const PresetMetadataEditingPage({super.key, required this.presetModel});

  @override
  State<PresetMetadataEditingPage> createState() =>
      _PresetMetadataEditingPageState();
}

class _PresetMetadataEditingPageState extends State<PresetMetadataEditingPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // log(widget.presetModel.docId.toString());
    nameController.text = widget.presetModel.name ?? '';
    priceController.text = widget.presetModel.price?.toString() ?? '';
    descriptionController.text = widget.presetModel.description ?? '';
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: getColor("#f2f2f2"),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              PresetEditingBox(
                onTap: () {
                  int? parsedPrice = int.tryParse(priceController.text);
                  if (parsedPrice != null) {
                    if (nameController.text.isNotEmpty &&
                        descriptionController.text.isNotEmpty) {
                      DataController.editPreset(
                        docId: widget.presetModel.docId.toString(),
                        name: nameController.text.trim(),
                        price: parsedPrice,
                        description: descriptionController.text.trim(),
                      );
                    } else {
                      Fluttertoast.showToast(
                        msg: "Dont make the field empty",
                      );
                    }
                  } else {
                    // Handle invalid price input
                    Fluttertoast.showToast(
                      msg: 'Invalid price input',
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                    );
                  }
                },
                nameEditingController: nameController,
                priceEditingController: priceController,
                descEditingController: descriptionController,
              )
            ],
          ),
        ),
      ),
    );
  }
}

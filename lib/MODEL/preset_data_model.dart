class PresetModel {
  List<String>? presets;
  int? price;
  String? name;
  String? ownerData;
  String? preset; // New field for single preset data

  PresetModel({this.presets, this.price, this.name, this.ownerData, this.preset});

  factory PresetModel.fromJson(Map<String, dynamic> json) {
    if (json.containsKey('presets')) {
      // Handling for list presets
      return PresetModel(
        presets: json['presets'] != null ? List<String>.from(json['presets']) : [],
        price: json['price'],
        name: json['name'],
        ownerData: json['owner_data'],
      );
    } else {
      // Handling for single presets
      return PresetModel(
        preset: json['preset'],
        price: json['price'],
        name: json['name'],
        ownerData: json['owner_data'],
      );
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (presets != null) {
      data['presets'] = presets;
    } else {
      data['preset'] = preset;
    }
    data['price'] = price;
    data['name'] = name;
    data['owner_data'] = ownerData;
    return data;
  }
}

class SinglePresetModel {
  String? preset;
  int? price;
  String? name;
  String? ownerData;

  SinglePresetModel({this.preset, this.price, this.name, this.ownerData});

  factory SinglePresetModel.fromJson(Map<String, dynamic> json) {
    return SinglePresetModel(
      preset: json['preset'],
      price: json['price'],
      name: json['name'],
      ownerData: json['owner_data'],
    );
  }
}

class PresetModel {
  List<String>? presets;
  List<String>? coverImages;
  int? price;
  String? name;
  bool? isList;
  String? ownerData;
  String? status;
  String? description;
  int? likeCount;
  int? shares;
  int? presetsBoughtCount;
  String? docId;

  PresetModel({
    this.presets,
    this.coverImages,
    this.price,
    this.name,
    this.isList,
    this.ownerData,
    this.status,
    this.description,
    this.likeCount,
    this.shares,
    this.presetsBoughtCount,
    this.docId,
  });

  factory PresetModel.fromJson(Map<String, dynamic> json) {
    return PresetModel(
      presets:
          json['presets'] != null ? List<String>.from(json['presets']) : [],
      coverImages: json['coverImages'] != null
          ? List<String>.from(json['coverImages'])
          : [],
      price: json['price'],
      isList: json['isList'],
      name: json['name'],
      ownerData: json['owner_data'],
      status: json['status'],
      description: json['description'],
      likeCount: json['likeCount'],
      shares: json['shares'],
      presetsBoughtCount: json['presetsBoughtCount'],
      docId: json['docId'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (presets != null) {
      data['presets'] = presets;
    }
    if (coverImages != null) {
      data['coverImages'] = coverImages;
    }
    data['price'] = price;
    data['name'] = name;
    data['owner_data'] = ownerData;
    data['isList'] = isList;
    data['status'] = status;
    data['description'] = description;
    data['likeCount'] = likeCount;
    data['shares'] = shares;
    data['presetsBoughtCount'] = presetsBoughtCount;
    data['docId'] = docId;
    return data;
  }
}


// class SinglePresetModel {
//   String? preset;
//   int? price;
//   String? name;
//   String? ownerData;

//   SinglePresetModel({this.preset, this.price, this.name, this.ownerData});

//   factory SinglePresetModel.fromJson(Map<String, dynamic> json) {
//     return SinglePresetModel(
//       preset: json['preset'],
//       price: json['price'],
//       name: json['name'],
//       ownerData: json['owner_data'],
//     );
//   }
// }

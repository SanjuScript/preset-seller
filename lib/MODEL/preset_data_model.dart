import 'package:seller_app/MODEL/review_data_model.dart';

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
  int? mrp;
  bool? showMRP;
  int? shares;
  int? presetsBoughtCount;
  String? docId;
  bool? hideOffer;
  String? id;
  bool? isPaid;
  List<ReviewModel>? reviews;

  PresetModel({
    this.presets,
    this.coverImages,
    this.price,
    this.name,
    this.isList,
    this.mrp,
    this.showMRP,
    this.hideOffer,
    this.isPaid,
    this.ownerData,
    this.status,
    this.description,
    this.id,
    this.likeCount,
    this.shares,
    this.presetsBoughtCount,
    this.docId,
    this.reviews,
  });

  factory PresetModel.fromJson(Map<String, dynamic> json) {
    return PresetModel(
      presets:
          json['presets'] != null ? List<String>.from(json['presets']) : [],
      coverImages: json['coverImages'] != null
          ? List<String>.from(json['coverImages'])
          : [],
      price: json['price'],
      hideOffer: json['hideOffer'],
      mrp: json['mrp'],
      showMRP: json['showMRP'],
      id: json['id'],
      isPaid: json['isPaid'],
      isList: json['isList'],
      name: json['name'],
      ownerData: json['owner_data'],
      status: json['status'],
      description: json['description'],
      likeCount: json['likeCount'],
      shares: json['shares'],
      presetsBoughtCount: json['presetsBoughtCount'],
      docId: json['docId'],
      reviews: json['reviews'] != null
          ? List<ReviewModel>.from(
              json['reviews'].map((x) => ReviewModel.fromJson(x)))
          : [],
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
    data['mrp'] = mrp;
    data['showMRP'] = showMRP;
    data['hideOffer'] = hideOffer;
    data['name'] = name;
    data['isPaid'] = isPaid;
    data['owner_data'] = ownerData;
    data['id'] = id;
    data['isList'] = isList;
    data['status'] = status;
    data['description'] = description;
    data['likeCount'] = likeCount;
    data['shares'] = shares;
    data['presetsBoughtCount'] = presetsBoughtCount;
    data['docId'] = docId;
    if (reviews != null) {
      data['reviews'] = reviews!.map((x) => x.toJson()).toList();
    }
    return data;
  }
}

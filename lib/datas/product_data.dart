import 'package:cloud_firestore/cloud_firestore.dart';

class ProductData {
  String category;
  String id;
  String title;
  String description;
  List prices;
  List images;
  List options;
  String optionTitle;

  int optionSelected = 0;
  int imageSelected = 0;

  double get price {
    return prices != null ? prices[optionSelected ?? 0] + 0.0 : 0.0;
  }

  String get image {
    return images != null ? images[imageSelected ?? 0] : "";
  }

  String get option {
    return options != null ? options[optionSelected ?? 0] : "";
  }

  ProductData.fromDocument(DocumentSnapshot snapshot) {
    id = snapshot.documentID;
    title = snapshot.data["title"];
    description = snapshot.data["description"];
    prices = snapshot.data["prices"];
    images = snapshot.data["images"];
    options = snapshot.data["options"];
    optionTitle = snapshot.data["optionTitle"];
  }

  Map<String, dynamic> toResumeMap() {
    return {
      "title": title,
      "desciption": description,
      "price": price,
    };
  }
}


import '../ShopUser/accountShop.dart';

class Product {
  String id;
  String name;
  String content;
  double cost;
  String imageList;
  accountShop owner;

  Product({required this.id, required this.name, required this.content, required this.owner, required this.cost, required this.imageList});

  Map<dynamic, dynamic> toJson() => {
    'id' : id,
    'name' : name,
    'content' : content,
    'cost' : cost,
    'owner' : owner.toJson(),
    'imageList' : imageList,
  };

  factory Product.fromJson(Map<dynamic, dynamic> json) {
    return Product(
      id: json['id'].toString(),
      name: json['name'].toString(),
      content: json['content'].toString(),
      owner: accountShop.fromJson(json['owner']),
      cost: double.parse(json['cost'].toString()),
      imageList: json['imageList'].toString(),
    );
  }
}
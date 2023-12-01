
import '../ShopUser/accountShop.dart';
import '../Tool/Time.dart';

class Product {
  String id;
  String name;
  String content;
  double cost;
  String imageList;
  Time createTime;
  accountShop owner;

  Product({required this.id, required this.name, required this.content, required this.owner, required this.cost, required this.imageList, required this.createTime});

  Map<dynamic, dynamic> toJson() => {
    'id' : id,
    'name' : name,
    'content' : content,
    'cost' : cost,
    'owner' : owner.toJson(),
    'imageList' : imageList,
    'createTime' : createTime.toJson()
  };

  factory Product.fromJson(Map<dynamic, dynamic> json) {
    return Product(
        id: json['id'].toString(),
        name: json['name'].toString(),
        content: json['content'].toString(),
        owner: accountShop.fromJson(json['owner']),
        cost: double.parse(json['cost'].toString()),
        imageList: json['imageList'].toString(),
        createTime: Time.fromJson(json['createTime'])
    );
  }
}
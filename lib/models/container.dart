import 'package:uuid/uuid.dart';
import 'item.dart';

class StorageContainer {
  final String id;
  String name;
  List<Item> items;
  String qrCode;

  StorageContainer({
    String? id,
    required this.name,
    List<Item>? items,
  }) : 
    this.id = id ?? Uuid().v4(),
    this.items = items ?? [],
    this.qrCode = id ?? Uuid().v4(); // QR 코드 생성

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'items': items.map((i) => i.toJson()).toList(),
    'qrCode': qrCode,
  };

  factory StorageContainer.fromJson(Map<String, dynamic> json) {
    return StorageContainer(
      id: json['id'],
      name: json['name'],
      items: (json['items'] as List)
          .map((i) => Item.fromJson(i))
          .toList(),
    );
  }
}
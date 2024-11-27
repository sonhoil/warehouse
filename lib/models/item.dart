import 'package:uuid/uuid.dart';

class Item {
  final String id;
  String name;
  int quantity;
  String? note;

  Item({
    String? id,
    required this.name,
    required this.quantity,
    this.note,
  }) : id = id ?? Uuid().v4();

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'quantity': quantity,
    'note': note,
  };

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      id: json['id'],
      name: json['name'],
      quantity: json['quantity'],
      note: json['note'],
    );
  }
}

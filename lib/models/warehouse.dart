import 'package:uuid/uuid.dart';
import 'container.dart';

class Warehouse {
  final String id;
  String name;
  List<String> userIds;
  List<StorageContainer> containers;

  Warehouse({
    String? id,
    required this.name,
    List<String>? userIds,
    List<StorageContainer>? containers,
  }) : 
    this.id = id ?? Uuid().v4(),
    this.userIds = userIds ?? [],
    this.containers = containers ?? [];

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'userIds': userIds,
    'containers': containers.map((c) => c.toJson()).toList(),
  };

  factory Warehouse.fromJson(Map<String, dynamic> json) {
    return Warehouse(
      id: json['id'],
      name: json['name'],
      userIds: List<String>.from(json['userIds']),
      containers: (json['containers'] as List)
          .map((c) => StorageContainer.fromJson(c))
          .toList(),
    );
  }
}

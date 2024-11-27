import 'package:flutter/foundation.dart';
import '../models/warehouse.dart';
import '../models/container.dart';
import '../models/item.dart';

class WarehouseProvider with ChangeNotifier {
  List<Warehouse> _warehouses = [];

  List<Warehouse> get warehouses => _warehouses;

  void addWarehouse(Warehouse warehouse) {
    _warehouses.add(warehouse);
    notifyListeners();
  }

  void addContainer(String warehouseId, StorageContainer container) {
    final warehouse = _warehouses.firstWhere((w) => w.id == warehouseId);
    warehouse.containers.add(container);
    notifyListeners();
  }

  void addItem(String warehouseId, String containerId, Item item) {
    final warehouse = _warehouses.firstWhere((w) => w.id == warehouseId);
    final container = warehouse.containers.firstWhere((c) => c.id == containerId);
    container.items.add(item);
    notifyListeners();
  }

  void inviteUser(String warehouseId, String userId) {
    final warehouse = _warehouses.firstWhere((w) => w.id == warehouseId);
    if (!warehouse.userIds.contains(userId)) {
      warehouse.userIds.add(userId);
      notifyListeners();
    }
  }

  StorageContainer? findContainerByQR(String qrCode) {
    for (var warehouse in _warehouses) {
      final container = warehouse.containers.firstWhere(
        (c) => c.qrCode == qrCode,
        orElse: () => null as StorageContainer,
      );
      if (container != null) return container;
    }
    return null;
  }
}

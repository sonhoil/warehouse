import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../models/warehouse.dart';
import '../models/container.dart';
import '../models/item.dart';
import '../providers/warehouse_provider.dart';

class ContainerDetailScreen extends StatelessWidget {
  final Warehouse warehouse;
  final StorageContainer container;

  const ContainerDetailScreen({
    Key? key,
    required this.warehouse,
    required this.container,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
  title: Text(container.name),
  actions: [
    IconButton(
      icon: const Icon(Icons.qr_code),
      onPressed: () => _showQRCode(context), // 이 부분이 호출되는지 확인
    ),
  ],
),
      body: Consumer<WarehouseProvider>(
        builder: (context, provider, child) {
          // 컨테이너의 물품 리스트를 가져옵니다.
          final items = provider.warehouses
              .firstWhere((w) => w.id == warehouse.id)
              .containers
              .firstWhere((c) => c.id == container.id)
              .items;

          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return ListTile(
                title: Text(item.name),
                subtitle: Text('수량: ${item.quantity}${item.note != null ? '\n비고: ${item.note}' : ''}'),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddItemDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showQRCode(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('QR 코드'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            width: 200.0,
            height: 200.0,
            child: QrImageView(
              data: container.qrCode, // 컨테이너의 QR 코드 데이터
              version: QrVersions.auto,
              size: 200.0,
            ),
          ),
          const SizedBox(height: 20),
          Text('컨테이너 이름: ${container.name}'),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('닫기'),
        ),
      ],
    ),
  );
}

  void _showAddItemDialog(BuildContext context) {
    final nameController = TextEditingController();
    final quantityController = TextEditingController();
    final noteController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('새 물품 추가'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: '물품 이름'),
            ),
            TextField(
              controller: quantityController,
              decoration: const InputDecoration(labelText: '수량'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: noteController,
              decoration: const InputDecoration(labelText: '비고'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () {
              if (nameController.text.isNotEmpty && quantityController.text.isNotEmpty) {
                final item = Item(
                  name: nameController.text,
                  quantity: int.parse(quantityController.text),
                  note: noteController.text.isEmpty ? null : noteController.text,
                );
                context.read<WarehouseProvider>().addItem(
                  warehouse.id,
                  container.id,
                  item,
                );
                Navigator.pop(context);
              }
            },
            child: const Text('추가'),
          ),
        ],
      ),
    );
  }
}
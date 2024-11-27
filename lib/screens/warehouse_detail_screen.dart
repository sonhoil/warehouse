import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/warehouse.dart';
import '../models/container.dart';
import '../providers/warehouse_provider.dart';
import 'container_detail_screen.dart';

class WarehouseDetailScreen extends StatelessWidget {
  final Warehouse warehouse;

  const WarehouseDetailScreen({Key? key, required this.warehouse}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(warehouse.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add),
            onPressed: () => _showInviteDialog(context),
          ),
        ],
      ),
      body: Consumer<WarehouseProvider>(
        builder: (context, provider, child) {
          // warehouse의 컨테이너 리스트를 가져옵니다.
          final containers = provider.warehouses.firstWhere((w) => w.id == warehouse.id).containers;

          return ListView.builder(
            itemCount: containers.length,
            itemBuilder: (context, index) {
              final container = containers[index];
              return ListTile(
                title: Text(container.name),
                subtitle: Text('물품 수: ${container.items.length}'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ContainerDetailScreen(
                        warehouse: warehouse,
                        container: container,
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddContainerDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddContainerDialog(BuildContext context) {
    final nameController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('새 컨테이너 추가'),
        content: TextField(
          controller: nameController,
          decoration: const InputDecoration(labelText: '컨테이너 이름'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () {
              if (nameController.text.isNotEmpty) {
                final container = StorageContainer(name: nameController.text);
                context.read<WarehouseProvider>().addContainer(warehouse.id, container);
                Navigator.pop(context);
              }
            },
            child: const Text('추가'),
          ),
        ],
      ),
    );
  }

  void _showInviteDialog(BuildContext context) {
    final userIdController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('사용자 초대'),
        content: TextField(
          controller: userIdController,
          decoration: const InputDecoration(labelText: '사용자 ID'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () {
              if (userIdController.text.isNotEmpty) {
                context.read<WarehouseProvider>().inviteUser(
                  warehouse.id,
                  userIdController.text,
                );
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('초대가 완료되었습니다')),
                );
              }
            },
            child: const Text('초대'),
          ),
        ],
      ),
    );
  }
}
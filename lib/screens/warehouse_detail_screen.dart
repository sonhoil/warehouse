import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import '../models/warehouse.dart';
import '../models/container.dart';
import '../providers/warehouse_provider.dart';
import 'container_detail_screen.dart';

class WarehouseDetailScreen extends StatelessWidget {
  final Warehouse warehouse;

  const WarehouseDetailScreen({Key? key, required this.warehouse})
      : super(key: key);

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
          final containers = provider.warehouses
              .firstWhere((w) => w.id == warehouse.id)
              .containers;

          return ListView.builder(
            itemCount: containers.length,
            itemBuilder: (context, index) {
              final container = containers[index];
              return Card(
                margin:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                elevation: 4,
                child: InkWell(
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 200, // 카드의 높이 설정
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: container.imageUrl != null
                                ? NetworkImage(container.imageUrl!)
                                : const AssetImage(
                                        'assets/images/default_image.png')
                                    as ImageProvider, // 기본 이미지
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          container.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text('물품 수: ${container.items.length}'),
                      ),
                    ],
                  ),
                ),
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

  void _showAddContainerDialog(BuildContext context) async {
    final nameController = TextEditingController();
    final ImagePicker _picker = ImagePicker();
    XFile? image;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('새 컨테이너 추가'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: '컨테이너 이름'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () async {
                image = await _picker.pickImage(source: ImageSource.camera);
                if (image != null) {
                  // 이미지가 선택되면 추가적인 작업을 수행할 수 있습니다.
                }
              },
              child: const Text('사진 촬영'),
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
              if (nameController.text.isNotEmpty) {
                final container = StorageContainer(
                  name: nameController.text,
                  imageUrl: image?.path,
                );
                context
                    .read<WarehouseProvider>()
                    .addContainer(warehouse.id, container);
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

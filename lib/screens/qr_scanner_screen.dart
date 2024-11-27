import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:provider/provider.dart';
import '../providers/warehouse_provider.dart';
import 'container_detail_screen.dart';

class QRScannerScreen extends StatefulWidget {
  const QRScannerScreen({Key? key}) : super(key: key);

  @override
  State<QRScannerScreen> createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  bool isProcessing = false;

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      if (!isProcessing && scanData.code != null) {
        isProcessing = true;
        _processQRCode(scanData.code!);
      }
    });
  }

  void _processQRCode(String code) {
    final provider = context.read<WarehouseProvider>();
    final container = provider.findContainerByQR(code);

    if (container != null) {
      // QR 코드에 해당하는 컨테이너를 찾았을 때의 처리
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ContainerDetailScreen(
            warehouse: provider.warehouses.firstWhere(
              (w) => w.containers.contains(container),
            ),
            container: container,
          ),
        ),
      );
    } else {
      // QR 코드에 해당하는 컨테이너를 찾지 못했을 때의 처리
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('유효하지 않은 QR 코드입니다')),
      );
      isProcessing = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('QR 코드 스캔')),
      body: QRView(
        key: qrKey,
        onQRViewCreated: _onQRViewCreated,
        overlay: QrScannerOverlayShape(
          borderColor: Colors.blue,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: 300,
        ),
      ),
    );
  }
} 
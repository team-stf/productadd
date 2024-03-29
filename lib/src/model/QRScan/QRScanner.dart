import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:productadd/src/model/QRScan/QRScannerOverlay.dart';
import 'dart:io';

class MobilerScaner extends StatefulWidget {
  const MobilerScaner({Key? key}) : super(key: key);

  @override
  State<MobilerScaner> createState() => _MobilerScanerState();
}

class _MobilerScanerState extends State<MobilerScaner> {
  int count = 0;
  MobileScannerController cameraController = MobileScannerController();
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _willPopCallback(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Mobile Scanner'),
          actions: [
            IconButton(
              color: Colors.white,
              icon: ValueListenableBuilder(
                valueListenable: cameraController.torchState,
                builder: (context, state, child) {
                  switch (state as TorchState) {
                    case TorchState.off:
                      return const Icon(Icons.flash_off, color: Colors.grey);
                    case TorchState.on:
                      return const Icon(Icons.flash_on, color: Colors.yellow);
                  }
                },
              ),
              iconSize: 32.0,
              onPressed: () => cameraController.toggleTorch(),
            ),
            IconButton(
              color: Colors.white,
              icon: ValueListenableBuilder(
                valueListenable: cameraController.cameraFacingState,
                builder: (context, state, child) {
                  switch (state as CameraFacing) {
                    case CameraFacing.front:
                      return const Icon(Icons.camera_front);
                    case CameraFacing.back:
                      return const Icon(Icons.camera_rear);
                  }
                },
              ),
              iconSize: 32.0,
              onPressed: () => cameraController.switchCamera(),
            ),
          ],
        ),
        body: Stack(
          children: [
            MobileScanner(
              allowDuplicates: false,
              controller: cameraController,
              onDetect: (barcode, args) {
                //複数スキャンするのでカウントする。
                count++;
                if (count == 1) {
                  final String? code = barcode.rawValue;
                  try {
                    int barnum = int.parse(code!);
                    Navigator.pop(context, barnum);
                  } catch (e) {
                    cameraController.stop();
                    count = 0;
                    debugPrint('URL???NotINT! $code');
                    sleep(Duration(seconds: 1));
                    cameraController.start();
                    debugPrint('URL???GPpppppp! $code');
                  }
                }
              },
            ),
            QRScannerOverlay(overlayColour: Colors.black.withOpacity(0.5)),
          ],
        ),
      ),
    );
  }

  Future<bool> _willPopCallback() async {
    print('QRSCANNER終了');
    // cameraController.dispose();
    return true;
  }
}

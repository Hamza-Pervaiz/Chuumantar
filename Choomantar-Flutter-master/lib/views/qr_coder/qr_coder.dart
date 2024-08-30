import 'dart:developer';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import '../../widgets/button_widget.dart';

class QrCoderView extends StatefulWidget {
  const QrCoderView({super.key});

  @override
  State<StatefulWidget> createState() => _QrCoderViewState();
}

class _QrCoderViewState extends State<QrCoderView> {
  Barcode? result;
  bool showReScan = false;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  bool permissionDeniedShown =
      false; // Added to track if permission denial message is shown

  @override
  void initState() {
    super.initState();
    _checkCameraPermission();
  }

  void _checkCameraPermission() async {
    var status = await Permission.camera.status;
    if (!status.isGranted && !status.isPermanentlyDenied) {
      await Permission.camera.request();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(child: _buildQrView(context)),
        ],
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 150.0
        : 300.0;

    return Stack(
      alignment: Alignment.center,
      children: [
        QRView(
          key: qrKey,
          onQRViewCreated: _onQRViewCreated,
          overlay: QrScannerOverlayShape(
              borderColor: Colors.red,
              borderRadius: 10,
              borderLength: 30,
              borderWidth: 10,
              cutOutSize: scanArea),
          onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
        ),
        Visibility(
          visible: showReScan,
          child: Positioned(
              bottom: 100,
              child: ButtonWidget(
                  onTap: () {
                    controller?.resumeCamera();
                    setState(() {
                      showReScan = false;
                    });
                  },
                  text: 'Re-Scan'.tr())),
        ),
      ],
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
        if (result?.format == BarcodeFormat.qrcode && result?.code != null) {
          Fluttertoast.showToast(
              msg: result!.code!, toastLength: Toast.LENGTH_LONG);
          controller.pauseCamera();
          setState(() {
            showReScan = true;
          });
        }
        //  print("QR Result: ${result}");
      });
    });
  }

  Future<void> _onPermissionSet(
      BuildContext context, QRViewController ctrl, bool p) async {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p && !permissionDeniedShown) {
      permissionDeniedShown =
          true; // Set to true to track that message is shown

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: const Text('No Permission').tr()),
      );

      var status = Permission.camera.status;
      if (await status.isPermanentlyDenied) {
        // Guide the user to the app settings to enable the permission manually
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Permission Required').tr(),
              content: const Text(
                      'To use this feature, please enable camera access in the app settings.')
                  .tr(),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    openAppSettings();
                  },
                  child: const Text('Open Settings').tr(),
                ),
              ],
            );
          },
        );
      } else {
        // Schedule a callback to hide the snackbar after 1 second
        Future.delayed(const Duration(seconds: 1), () {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
        });
      }
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}

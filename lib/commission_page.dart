import 'package:commission_mtr2/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class CommissionPage extends StatelessWidget {
  final String? qrString, manualCode;
  final CommissionController c;

  CommissionPage({Key? key, this.qrString, this.manualCode})
      : c = Get.put(CommissionController()),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(c.appbar),
      ),
    );
  }
}

class CommissionController extends GetxController {
  final String? qrString, manualCode;
  final appbar = "Commission Device";
  final waitTime = const Duration(seconds: 2);

  CommissionController({this.qrString, this.manualCode});

  @override
  void onInit() async {
    super.onInit();
    await Future.delayed(waitTime);
    await startCommission();
  }

  Future<void> startCommission() async {
    try {
      final cResult = await platform.invokeMethod("startCms", qrString);
    } on PlatformException catch (e) {
      print("Start commission failed: ${e.message}");
    }
  }
}

import 'package:commission_mtr2/constants.dart';
import 'package:commission_mtr2/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class CommissionPage extends StatelessWidget {
  final String? qrString, manualCode;
  final CommissionController c;

  CommissionPage({Key? key, this.qrString, this.manualCode})
      : c = Get.put(
      CommissionController(qrString: qrString, manualCode: manualCode)),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(c.appbar),
      ),
      body: Obx(() {
        if (c.pageState.value == 0) {
          return _loading();
        } else if (c.pageState.value == 1) {
          return _success();
        } else {
          return _error();
        }
      }),
    );
  }

  _loading() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Text(
            "Please wait while device is being commissioned",
            style: HomePage.tStyle2,
            textAlign: TextAlign.center,
          ),
          HomePage.verS10,
          CircularProgressIndicator()
        ],
      ),
    );
  }

  _error() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Text("Error while commissioning, please see log",
            style: HomePage.tStyle2, textAlign: TextAlign.center,)
        ],
      ),
    );
  }

  _success() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Text("Successfully commissioned device", style: HomePage.tStyle2, textAlign: TextAlign.center,),
        ],
      ),
    );
  }
}

class CommissionController extends GetxController {
  final String? qrString, manualCode;
  final appbar = "Commission Device";
  final waitTime = const Duration(seconds: 2);
  final isCommissioned = false.obs;
  final pageState = 0.obs; // --> 0 loading, 1 success, 2 error

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
      if (cResult == "OK") {
        pageState.value = 1;
      } else if (cResult == "FAILED") {
        pageState.value = 2;
      }
    } on PlatformException catch (e) {
      print("Start commission failed: ${e.message}");
    }
  }
}

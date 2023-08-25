import 'dart:convert';

import 'package:commission_mtr2/commission_failed.dart';
import 'package:commission_mtr2/commission_page.dart';
import 'package:commission_mtr2/constants.dart';
import 'package:commission_mtr2/home_page.dart';
import 'package:commission_mtr2/model/device_payload_details.dart';
import 'package:commission_mtr2/support_commissioned.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class DetailsPage extends StatelessWidget {
  final String? qrString, manualCode;
  final DetailsController c;

  DetailsPage({Key? key, this.qrString, this.manualCode})
      : c = Get.put(
            DetailsController(qrString: qrString, manualCode: manualCode)),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(c.appbar),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const Text(
                      " Matter Device Details",
                      style: HomePage.tStyle1,
                      textAlign: TextAlign.center,
                    ),
                    HomePage.verS15,
                    Obx(() {
                      return Text(
                        "Discriminator: ${c.details.value.discriminator}\n"
                        "Product ID: ${c.details.value.prodId}\n"
                        "Serial Number: ${c.details.value.serNum}\n"
                        "Setup Code: ${c.details.value.setupPCode}\n"
                        "Vendor ID: ${c.details.value.vendId}\n"
                        "Version: ${c.details.value.vers}",
                        style: const TextStyle(fontSize: 20),
                      );
                    }),
                  ],
                ),
              ),
            ),
            Column(
              children: [
                Center(
                    child: ElevatedButton(
                        onPressed: () => c.sCommission(),
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text("Start Commission"),
                        ))),
                HomePage.verS10,
                Text(
                  "OR",
                  style: HomePage.tStyle2,
                ),
                HomePage.verS10,
                ElevatedButton(
                    onPressed: () => c.mSupport(),
                    child: const Text("Use Matter Support")),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class DetailsController extends GetxController {
  final String? qrString, manualCode;
  final scannedEnter = ''.obs;
  final Rx<int> pSum = 0.obs;
  final vId = 0.obs;
  final Rx<DevicePayloadDetails> details = DevicePayloadDetails(
          discriminator: 0,
          prodId: 0,
          serNum: "",
          setupPCode: 0,
          vendId: 0,
          vers: 0)
      .obs;

  DetailsController({this.qrString, this.manualCode});

  @override
  void onInit() async {
    super.onInit();
    await parseAll();
  }

  final appbar = "Device Details";

  Future<void> sCommission() async {
    Get.to(() => CommissionPage(qrString: qrString, manualCode: manualCode));
  }

  Future<void> mSupport() async => Get.to(() => SupportCommissionedPage());

  Future<void> parseAll() async {
    try {
      final res = await platform.invokeMethod("parseAll", qrString);
      if (res != null) {
        Map<String, dynamic> jsonMap = jsonDecode(res);
        details.value = DevicePayloadDetails.fromJson(jsonMap);
      }
    } on PlatformException catch (e) {
      print("Failed with error: ${e.message}");
    }
  }
}

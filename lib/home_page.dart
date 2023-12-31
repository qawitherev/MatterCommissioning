import 'package:commission_mtr2/commission_failed.dart';
import 'package:commission_mtr2/support_commissioned.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import 'constants.dart';
import 'details_page.dart';

class HomePage extends StatelessWidget {
  final HomeController c;
  HomePage({Key? key}) : c = Get.put(HomeController()), super(key: key);

  static const verS10 = SizedBox(
    height: 15,
  );
  static const verS15 = SizedBox(
    height: 15,
  );
  static const tStyle1 = TextStyle(
    fontSize: 30,
    fontWeight: FontWeight.bold,
  );
  static const tStyle2 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.normal,
  );

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(c.appbar),
        ),
        body: Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      verS10,
                      Center(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: SizedBox(
                            width: 300,
                            height: 300,
                            child: MobileScanner(
                              controller: c.sController,
                              onDetect: (capture) => c.qrScanned(capture),
                            ),
                          ),
                        ),
                      ),
                      verS10,
                      const Text(
                        "Scan QR code on your Matter device",
                        style: tStyle2,
                        textAlign: TextAlign.center,
                      ),
                      verS15,
                      const Text(
                        "OR",
                        style: tStyle1,
                      ),
                      verS15,
                      const Text(
                        "Enter manual pairing code that can be found along with the QR code provided",
                        style: tStyle2,
                        textAlign: TextAlign.center,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: TextField(
                          controller: c.tController,
                          autocorrect: false,
                          decoration: const InputDecoration(
                            labelText: "Enter manual pairing code here",
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    ElevatedButton(onPressed: () => c.pairManual(),
                        child: const Text("Commission using Manual Code")),
                    verS10,
                    // ElevatedButton(onPressed: () => c.mSupport(), child: const Text("Matter Support"))
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class HomeController extends GetxController {
  final appbar = "Commission Device";
  final tController = TextEditingController();
  final sController = MobileScannerController(
    autoStart: true,
    detectionSpeed: DetectionSpeed.normal,
    torchEnabled: false,
  );

  @override
  void onInit() {
    super.onInit();
    print("oninit");
    sController.start();
  }

  final sBar = const SnackBar(content: Text("Pairing code cannot be empty"),
    duration: Duration(seconds: 2),);

  void qrScanned(BarcodeCapture capture) {
    final List<Barcode> barcodes = capture.barcodes;
    final qrString = barcodes[0].rawValue;
    // sController.stop();
    Get.to(() => DetailsPage(qrString: qrString,));
  }

  void pairManual() {
    // if (tController.text.isEmpty) {
    //   ScaffoldMessenger.of(Get.context!).showSnackBar(sBar);
    //   return;
    // }
    final manualCode = tController.text;
    sController.stop();
    // Get.to(() => DetailsPage(manualCode: manualCode,));
    Get.to(() => SupportCommissionedPage());
  }

  // Future<void> mSupport() async {
  //   try {
  //     await platform.invokeMethod("mSupport");
  //   } on PlatformException catch (e) {
  //     print("mSupport() errored: ${e.message}");
  //   }
  // }
}

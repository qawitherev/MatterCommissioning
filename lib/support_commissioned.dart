import 'package:commission_mtr2/constants.dart';
import 'package:commission_mtr2/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

//TODO: for status update overtime, we can use eventChannel
// https://api.flutter.dev/flutter/services/EventChannel-class.html

class SupportCommissionedPage extends StatelessWidget {
  final SupportCommissionedController c;

  SupportCommissionedPage({Key? key})
      : c = Get.put(SupportCommissionedController()),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(c.appbar),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Obx(() {
          switch (c.pageState.value) {
            case 0:
              return _loading();
            case 1:
              return _success();
            case 2:
              return _failed();
            case 3:
              return _timeout();
            default:
              return const Text("Not implemented");
          }
        })
      )
    );
  }

  _loading() {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("Commissioning Device", style: HomePage.tStyle1, textAlign: TextAlign.center,),
          HomePage.verS15,
          Lottie.asset("assets/lottie/cat_loading.json"),
        ],
      ),
    );
  }

  _success() {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Device Commissioned", textAlign: TextAlign.center, style: HomePage.tStyle1,),
            Lottie.asset("assets/lottie/cute_cat.json"),
          ],
        ),
      ),
    );
  }

  _failed() {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Commission Process Failed", style: HomePage.tStyle1, textAlign: TextAlign.center,),
            Lottie.asset("assets/lottie/failed_dog.json", repeat: false),
          ],
        ),
      ),
    );
  }

  _timeout() {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Commission Timeout", style: HomePage.tStyle1, textAlign: TextAlign.center),
            Lottie.asset("assets/lottie/cat_timeout.json", repeat: true)
          ],
        ),
      ),
    );
  }
}

class SupportCommissionedController extends GetxController {
  final appbar = "Device Commission";
  final pageState = 0.obs; // 0: loading, 1: success, 2: error, 3: timeout

  @override
  void onInit() {
    super.onInit();
    startMtrSupport();
  }

  Future<void> startMtrSupport() async {
    try {
      final res = await platform.invokeMethod("mSupport").timeout(timeoutDuration);
      if (res == "OK") {
        pageState.value = 1;
      } else {
        pageState.value = 2;
      }
    } on PlatformException catch (e) {
      pageState.value = 2;
      print("mSupport() errored: ${e.message}");
    }
  }
}

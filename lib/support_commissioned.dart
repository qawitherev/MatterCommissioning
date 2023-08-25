import 'package:commission_mtr2/home_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

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
        padding: const EdgeInsets.only(top: 10),
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: Column(
                  children: const [
                    Text("Device details", style: HomePage.tStyle1,),
                  ],
                ),
              ),
            ),
            Lottie.asset("assets/lottie/cute_cat.json"),
          ],
        ),
      ),
    );
  }
}

class SupportCommissionedController extends GetxController {
  final appbar = "Device Commissioned";
}

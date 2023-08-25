import 'package:commission_mtr2/home_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class CommissionFailedPage extends StatelessWidget {
  final CommissionFailedController c;
  CommissionFailedPage({Key? key})
      : c = Get.put(CommissionFailedController()),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(c.appbar),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Commission Failed", style: HomePage.tStyle1,),
              Lottie.asset("assets/lottie/failed_dog.json"),
              ElevatedButton(onPressed: () => c.tryAgain(), child: const Padding(
                padding: EdgeInsets.all(8),
                child: Text("Try Again", style: TextStyle(fontSize: 20),),
              ))
            ],
          ),
        ),
      )
    );
  }
}

class CommissionFailedController extends GetxController{
  final appbar = "Commission Failed";

  void tryAgain() {
    Get.offAll(() => HomePage());
  }
}

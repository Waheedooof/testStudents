import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testmaker_student/core/constant/approutes.dart';
import 'package:testmaker_student/core/function/checkinternet.dart';
import 'package:testmaker_student/core/services/services.dart';
import 'package:testmaker_student/data/model/filrModel.dart';
import '../core/class/statusrequest.dart';
import '../core/function/handlingdata.dart';
import '../data/datasource/remote/home/login.dart';

class AuthController extends GetxController {
  bool showText = true;

  TextEditingController passwordController = TextEditingController();

  late GlobalKey<FormState> formState = GlobalKey<FormState>();

  StatusRequest? statusRequest = StatusRequest.none;
  final LoginData loginData = LoginData(Get.find());
  MyServices myServices = Get.find();

  @override
  void onInit() {
    super.onInit();
  }

  auth() async {
    statusRequest = StatusRequest.loading;
    update();
    Timer(const Duration(seconds: 2), () {
      statusRequest = StatusRequest.success;
      update();
      myServices.sharedPreferences.setString('auth', 'password');
      Get.offNamed(AppRoute.homePage);
    });
  }

  changeShowText() {
    showText = !showText;
    update();
  }

  Future<bool> login(FileModel assetsFile) async {
    if (await checkInternet()) {
      statusRequest = StatusRequest.loading;
      update();

      var response = await loginData.loginData(
        getCreate: DateTime.now().toString(),
        password: passwordController.text,
        teacherCode: assetsFile.teacher_code

      );
      print('${assetsFile.name}\n $response');
      if (response['status'] == 'success') {
        statusRequest = StatusRequest.success;
      } else {
        statusRequest = StatusRequest.failure;
      }
      update();
      print('===========login=========');
      print(statusRequest);
    } else {
      statusRequest = StatusRequest.serverExp;
    }
    if (statusRequest == StatusRequest.success) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> logout() async {
    // await myServices.sharedPreferences.remove('auth');
    // await myServices.sharedPreferences.remove('tablePath');
    // ExamController().reset();
    // Get.offNamed(AppRoute.authPage);
  }
}

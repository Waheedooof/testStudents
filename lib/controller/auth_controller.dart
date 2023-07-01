import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_bar_code_scanner_dialog/qr_bar_code_scanner_dialog.dart';
import 'package:testmaker_student/core/function/checkinternet.dart';
import 'package:testmaker_student/core/services/services.dart';
import 'package:testmaker_student/data/model/filrModel.dart';
import '../core/class/statusrequest.dart';
import '../data/datasource/remote/home/login.dart';
import 'home_controllers/files_contoller.dart';

class AuthController extends GetxController {
  bool showText = true;

  TextEditingController passwordController = TextEditingController();

  late GlobalKey<FormState> formState = GlobalKey<FormState>();

  StatusRequest? statusRequest = StatusRequest.none;
  final LoginData loginData = LoginData(Get.find());
  MyServices myServices = Get.find();
  FilesController filesController = Get.find();

  @override
  Future<void> onInit() async {
    if (await filesController
        .isFileOpenedAndLater(filesController.fileToOpen.path)) {
      filesController.openFilePath(filesController.fileToOpen);
    }

    super.onInit();
  }

  changeShowText() {
    showText = !showText;
    update();
  }

  setFileOpened(String fileCreatePath) {
    myServices.sharedPreferences
        .setString(fileCreatePath, DateTime.now().year.toString());
  }

  Future<void> scan(BuildContext context) async {
    try {
      QrBarCodeScannerDialog().getScannedQrBarCode(
          context: context,
          onCode: (code) async {
            print(code);
            passwordController.text = code!;
            if (await login(filesController.fileToOpen)) {
              filesController.openFilePath(filesController.fileToOpen);
            }
          });
    } catch (e) {
      // Handle any scanning errors
    }
  }
  Future<bool> login(FileModel assetsFile) async {
    if (await filesController.isFileOpenedAndLater(assetsFile.path)) {
      return true;
    } else {
      if (await checkInternet()) {
        statusRequest = StatusRequest.loading;
        update();

        try {
          var response = await loginData.loginData(
            getCreate: DateTime.now().toString(),
            password: passwordController.text,
            teacherCode: assetsFile.teacherCode,
            // fileCreate: '0',
          );
          print('${assetsFile.name}\n $response');
          if (response['status'] == 'success') {
            statusRequest = StatusRequest.success;
            setFileOpened(assetsFile.path);
          } else {
            statusRequest = StatusRequest.failure;
          }
        } catch (e) {
          print('===========login catch=========');
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
  }

  Future<void> logout() async {
    // await myServices.sharedPreferences.remove('auth');
    // await myServices.sharedPreferences.remove('tablePath');
    // ExamController().reset();
    // Get.offNamed(AppRoute.authPage);
  }
}

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testmaker_student/controller/auth_controller.dart';
import 'package:testmaker_student/controller/home_controllers/exam_cont.dart';
import 'package:testmaker_student/controller/home_controllers/excel_file_cont.dart';
import 'package:testmaker_student/controller/home_controllers/files_contoller.dart';
import 'package:testmaker_student/core/class/handelingview.dart';
import 'package:testmaker_student/view/widget/appbar.dart';
import 'package:testmaker_student/view/widget/apptextfield.dart';

class PasswordPage extends StatelessWidget {
  const PasswordPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(AuthController());
    FilesController filesController = Get.find();
    return Scaffold(
      body: AppCustomAppBar(
        actions: const [],
        title: const Text('auth').tr(),
        body: GetBuilder<AuthController>(builder: (authController) {
          return Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      filesController.fileToOpen.name,
                      style: TextStyle(
                        fontSize: 21,
                        color: Get.theme.primaryColor,
                      ),
                    ),
                    const SizedBox(
                      height: 11,
                    ),
                    Text(
                      '${filesController.fileToOpen.dateEnd} ${tr('day_yet')}',
                      style: TextStyle(
                        fontSize: 21,
                        color: Get.theme.primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
              AppTextField(
                type: tr('password'),
                iconData: Icons.password,
                inputType: TextInputType.visiblePassword,
                onChanged: (p0) {},
                validator: (p0) {
                  return null;
                },
                auto: true,
                obscureText: authController.showText,
                onTap: () {
                  authController.changeShowText();
                },
                textFieldController: authController.passwordController,
              ),
              const SizedBox(
                height: 20,
              ),
              HandelingRequest(
                statusRequest: authController.statusRequest!,
                widget: ElevatedButton(
                  onPressed: () async {
                    if (await authController
                        .login(filesController.fileToOpen)) {
                      ExcelFileController excelFileController = Get.find();
                      ExamController examController = Get.find();
                      excelFileController.pickFile(
                        filesController.fileToOpen.path,
                      );
                      examController.reset();
                      Get.back();
                      Get.back();
                    }
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: const Text('ok').tr(),
                  ),
                ),
              ),
            ],
          ));
        }),
      ),
    );
  }
}

import 'package:get/get.dart';
import 'package:testmaker_student/controller/home_controllers/home_page_cont.dart';
import 'package:testmaker_student/core/class/crud.dart';
import 'controller/home_controllers/exam_cont.dart';
import 'controller/home_controllers/excel_file_cont.dart';
import 'controller/home_controllers/files_contoller.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(HomeController());
    Get.put(Crud());
    Get.put(ExcelFileController());
    Get.put(FilesController());
    Get.put(ExamController());
  }
}

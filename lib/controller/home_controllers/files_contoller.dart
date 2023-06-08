import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:testmaker_student/core/constant/approutes.dart';
import 'package:testmaker_student/core/constant/assetsFiles.dart';
import 'package:testmaker_student/data/model/filrModel.dart';
import 'dart:io' as io;

import '../../core/class/statusrequest.dart';
import '../../core/function/handlingdata.dart';
import '../../core/services/services.dart';
import '../../data/datasource/remote/home/login.dart';
import 'exam_cont.dart';
import 'excel_file_cont.dart';

class FilesController extends GetxController {
  List<FileSystemEntity> files = [];

  List<int> deleteIndexFiles = [];

  TextEditingController searchController = TextEditingController();

  bool showFilesList = false;
  bool searchMode = false;

  late FileModel fileToOpen ;

  toPasswordPage(FileModel fileModel){
    fileToOpen = fileModel;
    Get.toNamed(AppRoute.passwordPage);

  }
  @override
  void onInit() {
    getListFiles();

    super.onInit();
  }

  changeShowList() {
    showFilesList = !showFilesList;
    update();
  }

  void getListFiles() async {
    files.clear();
    for (var element in AssetsFiles.assetsFiles) {
      files.add(File(element.path));
    }
    print(files.length);

    update();
  }

  // void getListFiles() async {
  //   final directory = await getExternalStorageDirectory();
  //
  //   print('============listOfFiles==============');
  //   print(directory!.path);
  //   files = io.Directory(directory.path).listSync();
  //   print(files.length);
  //
  //   update();
  // }

  String getPathFromFile(fil) {
    return fil.toString().split('\'')[1];
  }

  Future deleteFiles() async {
    ExcelFileController excelFileController = Get.find();

    for (int index in deleteIndexFiles) {
      await excelFileController.deleteFile(
        getPathFromFile(files[index]),
      );
    }
    deleteIndexFiles.clear();
    ExamController examController = Get.find();
    examController.reset();
    getListFiles();
    update();
  }

  selectedFiles(index) {
    if (deleteIndexFiles.contains(index)) {
      deleteIndexFiles.remove(index);
    } else {
      deleteIndexFiles.add(index);
    }
    // print(files[index]);
    for (int element in deleteIndexFiles) {
      print('============================');
      print(element);
      print(files.indexOf(files[element]));
    }

    update();
  }

  selectedFilesAll() {
    if (deleteIndexFiles.length != files.length) {
      for (var element in files) {
        if (!deleteIndexFiles.contains(files.indexOf(element))) {
          deleteIndexFiles.add(files.indexOf(element));
        }
      }
    } else {
      deleteIndexFiles.clear();
    }
    update();
  }

  void changeSearchMode() {
    searchMode = !searchMode;
    update();
  }

  void closeSearch() {
    if (searchController.text.isNotEmpty) {
      searchController.clear();
    } else {
      searchMode = false;
    }
    update();
  }




}

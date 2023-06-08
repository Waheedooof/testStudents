import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:testmaker_student/core/constant/assetsFiles.dart';
import '../../controller/home_controllers/exam_cont.dart';
import '../../controller/home_controllers/excel_file_cont.dart';
import '../../controller/home_controllers/files_contoller.dart';
import '../../core/constant/approutes.dart';
import '../../core/theme/themes.dart';
import '../widget/appbar.dart';

class FilesPage extends StatelessWidget {
  FilesPage({Key? key}) : super(key: key);

  ExcelFileController excelFileController = Get.find();
  ExamController examController = Get.find();
  FilesController filesController = Get.find();

  String getPathFromFile(fil) {
    return fil.toString().split('\'')[1];
  }

  String getFirstName(String last) {
    if (last.length >= 33) {
      return last.replaceRange(33, last.length, '...');
    } else {
      return last;
    }
  }

  filesList() {
    return GetBuilder<FilesController>(
      builder: (filesBuilderController) => filesBuilderController.files.isEmpty
          ? Center(
              child: Text(
                'dont_have',
                style: Get.textTheme.bodyText1,
              ).tr(),
            )
          : ListView.builder(
              reverse: false,
              shrinkWrap: true,
              primary: false,
              itemCount: filesBuilderController.files.length,
              itemBuilder: (context, index) {
                if (filesBuilderController.searchController.text.isNotEmpty) {
                  if (getFirstName(
                    getPathFromFile(
                      filesBuilderController.files[index],
                    ).split('/').last,
                  ).isCaseInsensitiveContainsAny(
                      filesBuilderController.searchController.text)) {
                    return fileWidget(index);
                  } else {
                    return Container();
                  }
                } else {
                  return fileWidget(index);
                }
              },
            ),
    );
  }

  fileWidget(int index) {
    return InkWell(
      // onLongPress: () {
      //   filesController.selectedFiles(index);
      // },
      onTap: () async {
        if (filesController.deleteIndexFiles.isEmpty) {
          // await filesController.login(AssetsFiles.assetsFiles[index],'121212');
          filesController.toPasswordPage(AssetsFiles.assetsFiles[index]);
          Get.toNamed(AppRoute.passwordPage);
          // if(await filesController.login()){
          //   excelFileController.pickFile(
              print(getPathFromFile(filesController.files[index]));
          //   );
          //   examController.reset();
          //   Get.back();
          //   Get.back();
          // }

        } else {
          filesController.selectedFiles(index);
        }
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: getPathFromFile(filesController.files[index]) ==
                  excelFileController.fileTitle
              ? Get.theme.primaryColor.withOpacity(0.7)
              : null,
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Text(
                (filesController.files.length - index).toString(),
                style: TextStyle(color: Get.theme.highlightColor, fontSize: 18),
              ),
              Expanded(child: Container()),
              Text(
                AssetsFiles.assetsFiles[index].name,
                style: TextStyle(
                    color: getPathFromFile(filesController.files[index]) ==
                            excelFileController.fileTitle
                        ? Get.theme.scaffoldBackgroundColor
                        : Get.theme.highlightColor,
                    fontSize: 18),
                textAlign: TextAlign.center,
              ),
              Expanded(
                child: Container(),
              ),
              Text(
                '${AssetsFiles.assetsFiles[index].dateEnd}  ${tr('day_yet')}',
                style: TextStyle(
                  color: getPathFromFile(filesController.files[index]) ==
                          excelFileController.fileTitle
                      ? Get.theme.scaffoldBackgroundColor
                      : Get.theme.highlightColor,
                ),
                textAlign: TextAlign.center,
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 800),
                margin: filesController.deleteIndexFiles.contains(index)
                    ? const EdgeInsets.symmetric(horizontal: 8)
                    : const EdgeInsets.symmetric(horizontal: 0),
                child: filesController.deleteIndexFiles.contains(index)
                    ? CircleAvatar(
                        radius: 10,
                        backgroundColor: Get.theme.primaryColor,
                      )
                    : Container(),
              )
            ],
          ),
        ),
      ),
    );
  }

  actionBtn(context) {
    return GetBuilder<FilesController>(
      builder: (controller) {
        if (filesController.deleteIndexFiles.isNotEmpty) {
          return Row(
            children: [
              filesController.searchMode
                  ? IconButton(
                      onPressed: () async {
                        filesController.closeSearch();
                      },
                      icon: Icon(
                        Icons.close,
                        color: Get.theme.primaryColor,
                      ),
                    )
                  : IconButton(
                      onPressed: () async {
                        await filesController.selectedFilesAll();
                      },
                      icon: Icon(
                        Icons.select_all,
                        color: Get.theme.primaryColor,
                      ),
                    ),
              IconButton(
                onPressed: () async {
                  showDialog(
                    context: context,
                    builder: (context) => Theme(
                      data: ThemeApp().getDialogTheme(),
                      child: AlertDialog(
                        titlePadding: const EdgeInsets.all(10),
                        title: Text(
                          tr('delete?'),
                          textAlign: TextAlign.center,
                        ),
                        content: ElevatedButton(
                          onPressed: () async {
                            await filesController.deleteFiles();
                            Get.back();
                          },
                          child: const Text('ok').tr(),
                        ),
                      ),
                    ),
                  );
                },
                icon: Icon(
                  Icons.delete_outline,
                  color: Get.theme.primaryColor,
                ),
              ),
              IconButton(
                onPressed: () async {
                  await excelFileController.onShareFiles();
                },
                icon: Icon(
                  Icons.share,
                  color: Get.theme.primaryColor,
                ),
              ),
            ],
          );
        } else {
          return AnimatedContainer(
            duration: const Duration(seconds: 1),
            width: filesController.searchMode ? Get.width / 8 : Get.width / 5,
            child: filesController.searchMode
                ? IconButton(
                    onPressed: () async {
                      filesController.closeSearch();
                    },
                    icon: Icon(
                      Icons.close,
                      color: Get.theme.primaryColor,
                    ),
                  )
                : IconButton(
                    onPressed: () async {
                      filesController.changeSearchMode();
                    },
                    icon: Icon(
                      Icons.search,
                      color: Get.theme.primaryColor,
                    ),
                  ),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    filesController.deleteIndexFiles = [];

    return GestureDetector(
      onVerticalDragEnd: (details) {
        if (details.primaryVelocity! > 1000) {
          examController.reset();
        }
      },
      onHorizontalDragEnd: (DragEndDetails details) {
        if (details.primaryVelocity! > 100) {
          Get.back();
        }
      },
      child: Scaffold(
        // floatingActionButton: FloatingActionButton(
        //   child: const Icon(Icons.add),
        //   onPressed: () {
        //     Get.toNamed(AppRoute.writeFilePage);
        //   },
        // ),
        body: AppCustomAppBar(
          title: GetBuilder<FilesController>(
            builder: (controller) {
              if (controller.searchMode) {
                return CupertinoTextField(
                  controller: controller.searchController,
                  autofocus: true,
                  onChanged: (value) {
                    controller.update();
                    print(controller.searchController.text);
                  },
                  textAlign: TextAlign.center,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Get.theme.primaryColor,
                    ),
                    color: Colors.grey.withOpacity(0.2),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                  style: Get.textTheme.bodyText1,
                );
              } else {
                return const Text('recently').tr();
              }
            },
          ),
          actions: [
            actionBtn(context),
          ],
          body: filesList(),
        ),
      ),
    );
  }
}

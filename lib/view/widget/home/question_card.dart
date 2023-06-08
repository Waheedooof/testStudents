import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testmaker_student/controller/home_controllers/exam_cont.dart';
import 'package:testmaker_student/controller/home_controllers/excel_file_cont.dart';
import 'package:testmaker_student/core/constant/approutes.dart';
import '../../../core/theme/app_dimentions.dart';

class QuestionCard extends StatelessWidget {
  QuestionCard({super.key, required this.questionColumnIndex});

  int questionColumnIndex;

  ExamController examController = Get.find();
  ExcelFileController excelController = Get.find();

  Color getSideSelectedColor(int indexInRow) {
    return examController.isSelectedHistory(questionColumnIndex, indexInRow)
        ? Get.theme.primaryColor
        : Get.theme.scaffoldBackgroundColor;
  }

  double getSideSelectedWidth(int indexInRow) {
    return examController.isSelectedHistory(questionColumnIndex, indexInRow)
        ? 2
        : 0;
  }

  getTextColor(int indexInRow) {
    return examController.isCorrect(questionColumnIndex) == null &&
            examController.isChoose(questionColumnIndex, indexInRow)
        ? Get.theme.scaffoldBackgroundColor
        : examController.isCorrect(questionColumnIndex) != null &&
                excelController.csvTable[questionColumnIndex][6]
                    .toString()
                    .contains(indexInRow.toString())
            ? Get.theme.highlightColor
            : Get.theme.highlightColor;
  }

  Color getAnswersColor(int indexInRow) {
    return examController.isCorrect(questionColumnIndex) == null &&
            examController.isChoose(questionColumnIndex, indexInRow)
        ? Get.theme.primaryColor.withOpacity(0.8)
        : examController.isCorrect(questionColumnIndex) != null &&
                excelController.csvTable[questionColumnIndex][6]
                    .toString()
                    .contains(indexInRow.toString())
            ? Colors.greenAccent.withOpacity(0.8)
            : Get.theme.scaffoldBackgroundColor;
  }

  Color getCorrectAnswersColor(int indexInRow) {
    return excelController.csvTable[questionColumnIndex][6]
            .toString()
            .contains(indexInRow.toString())
        ? Colors.greenAccent.withOpacity(0.8)
        : Get.theme.scaffoldBackgroundColor;
  }

  likeWidget() {
    return GestureDetector(
      onTap: () {
        // excelController.editLikeDataFile(
        //   editRowIndex: questionColumnIndex,
        // );
        Get.toNamed(AppRoute.favoritePage);

      },
      onLongPress: () {
        Get.toNamed(AppRoute.favoritePage);
      },
      child: excelController.csvTable[questionColumnIndex].length == 8
          ? const Padding(
              padding: EdgeInsets.all(3.0),
              child: Icon(
                Icons.favorite,
                color: Colors.red,
              ),
            )
          : const Padding(
              padding: EdgeInsets.all(3.0),
              child: Icon(Icons.favorite_border),
            ),
    );
  }

  Widget sureBtn() {
    return questionColumnIndex == examController.choose1.keys.first
        ? IconButton(
            onPressed: () {
              examController.add(questionColumnIndex);
            },
            icon: const Icon(
              Icons.done_outline_outlined,
            ),
          )
        : IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.done_outline_outlined,
            ),
          );
  }

  infoWidget() {
    return IconButton(
      onPressed: () {
        infoSnackBar();
      },
      icon: const Icon(CupertinoIcons.info),
    );
  }

  Widget questionWidget() {
    return SizedBox(
      // width: Get.width - 20,
      child: Card(
        color: Get.theme.scaffoldBackgroundColor,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(AppDims.corners),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
          child: Center(
            child: Row(
              children: [
                questionIndex(),
                questionLabel(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  questionLabel() {
    return Expanded(
      child: InkWell(
        onTap: () async {
          await Get.toNamed(
            AppRoute.questionData,
            arguments: excelController.csvTable[questionColumnIndex],
          );
          examController.reset();
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 8.0,
            horizontal: 10,
          ),
          child: Text(
            excelController.csvTable[questionColumnIndex][0].toString(),
            textAlign: Get.locale?.languageCode == 'en'
                ? TextAlign.left
                : TextAlign.right,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Get.theme.highlightColor,
              fontSize: 13,
            ),
          ),
        ),
      ),
    );
  }

  Widget answersWidget() {
    return Column(
      children: List.generate(
        excelController.csvTable[questionColumnIndex].length,
        growable: false,
        (indexInRow) {
          List notAnswers = [0, 5, 6, 7];

          if (notAnswers.contains(indexInRow) ||
              excelController.csvTable[questionColumnIndex][indexInRow]
                      .toString() ==
                  '') {
            return Container();
          } else {
            return InkWell(
              onTap: () {
                examController.chooseAnswerIndex(
                  questionColumnIndex,
                  indexInRow,
                );
              },
              child: Padding(
                padding: const EdgeInsets.only(top: 10, left: 4, right: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    answerIndex(indexInRow),
                    const SizedBox(
                      width: 5,
                    ),
                    answerLabel(indexInRow),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }

  answerLabel(indexInRow) {
    return Expanded(
      flex: 8,
      child: Card(
        margin: EdgeInsets.zero,
        elevation: 0,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            width: getSideSelectedWidth(indexInRow),
            color: getSideSelectedColor(indexInRow),
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(AppDims.corners),
          ),
        ),
        color: excelController.readMode?getCorrectAnswersColor(indexInRow): getAnswersColor(indexInRow),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
          child: Text(
            '${excelController.csvTable[questionColumnIndex][indexInRow]}',
            style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 11,
              color: getTextColor(indexInRow),
            ),
          ),
        ),
      ),
    );
  }

  answerIndex(indexInRow) {
    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(AppDims.corners),
        ),
      ),
      color: getAnswersColor(indexInRow),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 10,
        ),
        child: Text(
          indexInRow.toString(),
          textAlign: TextAlign.center,
          style: TextStyle(
            color: getTextColor(indexInRow),
          ),
        ),
      ),
    );
  }

  deleteSnackBar() {
    return Get.showSnackbar(
      GetSnackBar(
        duration: const Duration(seconds: 2),
        animationDuration: const Duration(milliseconds: 100),
        borderColor: Colors.grey,
        backgroundColor: Get.theme.scaffoldBackgroundColor,
        titleText: Text(
          'delete?',
          style: Get.textTheme.bodyText1,
        ).tr(),
        messageText: ElevatedButton(
          onPressed: () async {
            await excelController.deleteFromFile(
              deletedRowIndex: questionColumnIndex,
            );
            Get.back();
          },
          child: const Text('ok').tr(),
        ),
      ),
    );
  }

  infoSnackBar() {
    String value = excelController.csvTable[questionColumnIndex][5].toString();
    return Get.showSnackbar(
      GetSnackBar(
        animationDuration: const Duration(milliseconds: 100),
        borderColor: Colors.grey,
        backgroundColor: Get.theme.scaffoldBackgroundColor,
        titleText: Text(
          'info',
          style: Get.textTheme.bodyText1,
        ).tr(),
        messageText: ElevatedButton(
          onPressed: () async {
            if (value == '') {
              // Get.toNamed(
              //   AppRoute.questionData,
              //   arguments: excelController.csvTable[questionColumnIndex],
              // );
              Get.back();
            } else {
              Get.back();
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              value == '' ? 'noInfo' : value,
              style: TextStyle(color: Get.theme.scaffoldBackgroundColor),
            ).tr(),
          ),
        ),
      ),
    );
  }

  Widget questionIndex() {
    return InkWell(
      onTap: () async {
        await Get.toNamed(
          AppRoute.questionData,
          arguments: excelController.csvTable[questionColumnIndex],
        );
        examController.reset();
      },
      child: SizedBox(
        width: Get.width / 18,
        child: CircleAvatar(
          foregroundColor: Get.theme.scaffoldBackgroundColor,
          backgroundColor: Get.theme.primaryColor.withOpacity(0.7),
          child: Center(
            child: Text(
              (questionColumnIndex + 1).toString(),
              style: const TextStyle(fontSize: 10),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onLongPress: () {
        deleteSnackBar();
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Card(
                elevation: 5,
                shadowColor: Get.theme.primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(AppDims.corners),
                  ),
                ),
                color: examController.isCorrect(questionColumnIndex) == true
                    ? Colors.green.withOpacity(0.8)
                    : examController.isCorrect(questionColumnIndex) == false
                        ? Colors.red.withOpacity(0.8)
                        : Get.theme.primaryColor.withOpacity(0.8),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 5.0, vertical: 4),
                  child: Column(
                    children: [
                      questionWidget(),
                      answersWidget(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          infoWidget(),
                          sureBtn(),
                          likeWidget(),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

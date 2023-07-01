import 'package:testmaker_student/data/model/filrModel.dart';

class AssetsFiles {
  static List<FileModel> assetsFiles = [
    FileModel(
      path: 'assets/files/جغرافيا 1-2023.csv',
      dateEnd: DateTime(2024, 2, 1).difference(DateTime.now()).inDays,
      teacherCode: '0',
      name: 'جغرافيا 1-2023',
    ),
    FileModel(
      path: 'assets/files/file1-2023.csv',
      dateEnd: DateTime(2024, 1, 1).difference(DateTime.now()).inDays,
      teacherCode: '1',
      name: 'file1-2023',
    ),
    FileModel(
      path: 'assets/files/file2-2023.csv',
      dateEnd: DateTime(2024, 5, 1).difference(DateTime.now()).inDays,
      teacherCode: '2',
      name: 'file2-2023',
    ),
    FileModel(
      path: 'assets/files/file3-2023.csv',
      dateEnd: DateTime(2024, 6, 1).difference(DateTime.now()).inDays,
      teacherCode: '2',
      name: 'file3-2023',
    ),
    FileModel(
      path: 'assets/files/test-2023 (5).csv',
      dateEnd: DateTime(2023, 6, 25).difference(DateTime.now()).inDays,
      teacherCode: '2',
      name: 'test-2023 (5)',
    ),
  ];
}

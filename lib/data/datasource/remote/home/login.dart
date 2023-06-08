import '../../../../../core/class/crud.dart';
import '../../../../../links.dart';

class LoginData {
  Crud crud;

  LoginData(this.crud);

  loginData({
    required String password,
    required String getCreate,
    required String teacherCode,
  }) async {
    var response = await crud.postData(
      AppLinks.loginLink,
      {
        'file_code': password,
        'get_create': getCreate,
        'teacher_code': teacherCode,
      },
    );
    return response.fold((l) => l, (r) => r);
  }
}

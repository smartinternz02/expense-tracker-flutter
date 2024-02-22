import 'package:expense_app/models/UserDetails.model.dart';
import 'package:expense_app/models/UserLogin.model.dart';
import 'package:expense_app/models/dtos/user.dto.dart';
import 'package:expense_app/models/register_user.model.dart';
import 'package:expense_app/services/database/app_database.dart';

class LoginService {
  Future<UserDetails?> loginUser(UserLogin userLogin) async {
    UserDetails? userDetails;
    if (await AppDatabase.exists('User', where: "username = '${userLogin.username}' AND password = '${userLogin.password}'")) {
      userDetails = await getUserDetails(userLogin.username);
    }

    return userDetails;
  }

  Future<bool> isUsernameExists(String username) async {
    return AppDatabase.exists('User', where: "username = '$username'");
  }

  Future<bool> registerUser(RegisterUser user) async {
    var registrationDateTime = DateTime.now();
    var registerUserDTO = UserDTO(name: user.name, password: user.password, createdOn: registrationDateTime);
    return await AppDatabase.insert(registerUserDTO) > 0;
  }

  Future<UserDetails?> getUserDetails(String username) async {
    UserDetails? userDetails;
    var result = await AppDatabase.get('User', where: "username = '$username'");
    if (result != null && result.isNotEmpty) {
      userDetails = UserDetails(name: result[0]['Name'] as String, username: result[0]['Username'] as String);
    }

    return userDetails;
  }
}

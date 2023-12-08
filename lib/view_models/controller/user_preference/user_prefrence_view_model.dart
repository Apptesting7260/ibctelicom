// import 'package:get/get_state_manager/get_state_manager.dart';
// import 'package:nauman/global_variables.dart';
// // import 'package:getx_mvvm/models/login/user_model.dart';
// import 'package:nauman/models/login/user_model.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class UserPreference {
//   Future<bool> saveUser(String token) async {
//     SharedPreferences sp = await SharedPreferences.getInstance();
//     // sp.setString('token', responseModel.token.toString());
//     // sp.setString('token', Tokenid.toString());
//     sp.setString('token', token);
//     // sp.setBool('isLogin', responseModel.isLogin!);

//     return true;
//   }

//   Future<UserModel> getUser() async {
//     SharedPreferences sp = await SharedPreferences.getInstance();
//     String? token = sp.getString('token');
//     bool? isLogin = sp.getBool('isLogin');

//     return UserModel(token: token, isLogin: isLogin);
//   }

//   Future<bool> removeUser() async {
//     SharedPreferences sp = await SharedPreferences.getInstance();
//     sp.clear();
//     return true;
//   }
// }
import 'package:nauman/global_variables.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserPreference {
  Future<void> setToken(String token) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    await sp.setString('token', token);
    Tokenid = sp.getString('token');
  }

  Future<String?> getToken() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    String? token = sp.getString('token');
    print("Calling getToken $token");
    return token;
  }

  Future<bool> logOutUserTokenDelete() async {
    SharedPreferences Steppre = await SharedPreferences.getInstance();
    Steppre.clear();
    Tokenid = null;
    print("CALL LOGOUT FUNCTION ${Steppre.getString('token')}");
    return true;
  }

  Future<void> setStep(String step) async {
    SharedPreferences Steppre = await SharedPreferences.getInstance();
    await Steppre.setString('step', step);
    Step = Steppre.getString('step');
  }

  Future<String?> getStep() async {
    SharedPreferences Steppre = await SharedPreferences.getInstance();
    String? step = Steppre.getString('step');
    print("Calling step $step");
    return step;
  }

  Future<bool> deleteStep() async {
    SharedPreferences Steppre = await SharedPreferences.getInstance();
    Steppre.clear();
    Step = null;
    print("CALL Step Delete FUNCTION ${Steppre.getString('step')}");
    return true;
  }
}

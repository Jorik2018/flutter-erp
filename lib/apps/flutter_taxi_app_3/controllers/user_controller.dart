import 'package:flutter_erp/models/user.dart' as app_user;

class UserController {
  static app_user.User getUser() {
    return app_user.User(
      name: "Bhavneet Singh",
      phoneNumber: "+911234567890",
      photoUrl: "https://avatars0.githubusercontent.com/u/31070108?s=460&v=4",
    );
  }
}

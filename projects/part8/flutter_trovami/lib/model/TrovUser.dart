import 'DocItem.dart';

class TrovUser extends DocItem{
  
  static const String FLD_EMAIL = "email";
  
  String? email;

  TrovUser();

  TrovUser.fromJson(Map value){
    id = value[DocItem.FLD_ID];
    name=value[DocItem.FLD_NAME];
    email=value[FLD_EMAIL];
  }

  Map toJson(){
    return {DocItem.FLD_ID: id, DocItem.FLD_NAME: name, FLD_EMAIL: email};
  }

  @override
  fromMap(Map<String, Object> data) {
    TrovUser user = TrovUser();
    user.id = data[DocItem.FLD_ID] as String;
    user.name = data[DocItem.FLD_NAME] as String;
    user.email = data[FLD_EMAIL] as String;
    return user;
  }

}

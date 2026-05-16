import 'package:firebase_database/firebase_database.dart';

final usrRef = FirebaseDatabase.instance.ref('users');
final groupsRef = FirebaseDatabase.instance.ref('groups');

getUsers(){
  print('getUsers11');
  return usrRef.get();//.once(DatabaseEventType.value);
}

getUserById(id)async{
  dynamic resp=await usrRef.child(id).once();
  print("user: ${resp.value}");
  return resp;
}

getGroupsIamIn(userId)async{
  return await usrRef.child(userId).child("groupsIamin").once();
}

getGroups()async{
//  groupsRef.
//  var url="https://fir-trovami.firebaseio.com/groups.json";
//  var response=await _httpClient.get(url);
//  return _jsonCodec2.decode(response.body);

  dynamic resp=await groupsRef.orderByKey().once();
  return resp;
}

getAGroupAndAMember(groupKey,memberIndex)async{
  return await groupsRef.child(groupKey).child("members").once();
}
getGroupMembers(groupName){

}

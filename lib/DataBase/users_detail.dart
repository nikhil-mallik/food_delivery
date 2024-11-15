
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  Future AddUserDetails(Map<String, dynamic> userInfoMap, String Id) async {
  
    return await FirebaseFirestore.instance
        .collection("users")
        .doc(Id)
        .set(userInfoMap);     
  }

  addFoodItem(Map<String, dynamic> addItem) {}
  
}

import 'package:flutter_fundraising_goal_chart/models/fundraising_model.dart';
import 'package:flutter_fundraising_goal_chart/models/user_model.dart';

abstract class FirestoreDbBase {
  Future<bool?> saveUser(UserModel userModel);
  Future<UserModel?> getUserData(String userID);
  Future<bool?> updateUserProfile(String userID, Map<String,dynamic> updatedFields);
  Future<bool?> createFundraising(Map<String, dynamic> fundraisingModel, String fundraisingID, String userID);
  Future<List?> fetchFundraisingCommunity(String userID);


}
import 'package:flutter_fundraising_goal_chart/models/fundraising_model.dart';
import 'package:flutter_fundraising_goal_chart/models/user_model.dart';
import 'package:flutter_fundraising_goal_chart/view_models/fundraising_view_models.dart';

abstract class FirestoreDbBase {
  Future<bool?> saveUser(UserModel userModel);
  Future<UserModel?> getUserData(String userID);
  Future<bool?> updateUserProfile(String userID, Map<String,dynamic> updatedFields);
  Future<bool?> createFundraising(Map<String, dynamic> fundraisingModel, String fundraisingID, String userID);
  Future<List?> fetchFundraisingCommunity(String userID);
  Future<List<FundraisingModel>?> fetchFundraising(String userID);
  Future<bool?> saveDonation(String userID, String fundraisingID,String communityName, String donorName, double donationAmount);
  Future<String?> getFundraisingIDByCommunityName(String userID, String communityName);

  Future<FundraisingModel?> getFundraiser(String userID,String fundraisingID);
  Future<void> deleteFundraising(String userID, String fundraisingID);


}
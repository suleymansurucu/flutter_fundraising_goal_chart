import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_fundraising_goal_chart/models/fundraising_model.dart';
import 'package:flutter_fundraising_goal_chart/models/user_model.dart';
import 'package:flutter_fundraising_goal_chart/services/firestore_db_base.dart';

class FirestoreDbService implements FirestoreDbBase {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  @override
  Future<UserModel?> getUserData(String userID) async {
    try {
      DocumentSnapshot _readUser =
          await _firebaseFirestore.doc('users/$userID').get();

      Map<String, dynamic>? _readUserInformationMap =
          _readUser.data() as Map<String, dynamic>;

      debugPrint('ben readuserdayim ${_readUserInformationMap.toString()}');

      return UserModel.fromMap(_readUserInformationMap);
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  @override
  Future<bool?> saveUser(UserModel userModel) async {
    try {
      await _firebaseFirestore
          .collection('users')
          .doc(userModel.userID)
          .set(userModel.toMap(), SetOptions(merge: true));
      debugPrint(userModel.toMap().toString());
      DocumentSnapshot documentSnapshot =
          await _firebaseFirestore.doc('users/${userModel.userID}').get();
      Map<String, dynamic>? _readUserMap =
          documentSnapshot.data() as Map<String, dynamic>;
      UserModel readUserModel = UserModel.fromMap(_readUserMap);
      debugPrint('save user read' + readUserModel.toString());
      readUserModel.fullName;
      readUserModel.userID;
    } catch (e) {
      print(e.toString());
      return false;
    }
    return null;
  }

  @override
  Future<bool?> updateUserProfile(
      String userID, Map<String, dynamic> updatedFields) async {
    try {
      await _firebaseFirestore
          .collection('users')
          .doc(userID)
          .update(updatedFields);
      return true;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  @override
  Future<bool?> createFundraising(Map<String, dynamic> fundraisingModel,
      String fundraisingID, String userID) async {
    try {
      var result = await _firebaseFirestore
          .collection('users')
          .doc(userID)
          .collection('fundraiser')
          .doc(fundraisingID)
          .set(fundraisingModel);
      debugPrint('Create Fundraising Basarili');
      return true;
    } catch (e) {
      debugPrint('Hatayi takip et');
      debugPrint(e.toString());
      return false;
    }
  }

  @override
  Future<List<String>?> fetchFundraisingCommunity(String userID) async {
    try {
      QuerySnapshot querySnapshot = await _firebaseFirestore
          .collection('users')
          .doc(userID)
          .collection('fundraiser')
          .get();

      List<String> list = []; // Community isimlerini tutacak liste

      for (var doc in querySnapshot.docs) {
        var data = doc.data()
            as Map<String, dynamic>?; // Dokümanın map olduğunu doğrula

        if (data != null && data.containsKey('communities')) {
          // 'communities' alanı var mı kontrol et
          var communities = data['communities'];

          if (communities is List) {
            // Eğer communities bir listeyse
            for (var community in communities) {
              // Liste içindeki her öğeye eriş
              if (community is Map<String, dynamic> &&
                  community.containsKey('communityName')) {
                // Map olup olmadığını ve key olup olmadığını kontrol et
                list.add(community['communityName']
                    as String); // communityName değerini listeye ekle
              }
            }
          }
        }
      }

      debugPrint('FetchFundraisingCommunity deyim ....');
      debugPrint(list.toString());
      return list;
    } catch (e) {
      debugPrint('Error fetching fundraising community: $e');
    }
  }

  @override
  Future<bool?> saveDonation(String userID, String fundraisingID,
      String communityName, String donorName, double donationAmount) async {
    try {
      await _firebaseFirestore
          .collection('users')
          .doc(userID)
          .collection('fundraiser')
          .doc(fundraisingID)
          .collection('donations')
          .doc()
          .set({
        'userID': userID,
        'fundraisingID': fundraisingID,
        'communityName': communityName,
        'donorName': donorName,
        'donationAmount': donationAmount
      });
      debugPrint('Create Fundraising Basarili');
      return true;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  @override
  Future<List<FundraisingModel>?> fetchFundraising(String userID) async {
    try {
      // Firestore'dan kullanıcı ve fundraising bilgilerini çekiyoruz.
      var _fundraisers = await _firebaseFirestore
          .collection('users')
          .doc(userID) // Kullanıcı ID'si ile kullanıcıyı buluyoruz.
          .collection('fundraiser')
          .get();

      List<DocumentSnapshot<Map<String, dynamic>>> fundraiserDocs =
          _fundraisers.docs;

      // FundraisingModel listesi oluşturuyoruz
      List<FundraisingModel> sendList = [];
      for (var fundraiser in fundraiserDocs) {
        var data = fundraiser.data();
        if (data != null) {
          sendList.add(FundraisingModel.fromMap(data));
        }
      }

      for (var value in sendList) {
        print('Veri: $value');
      }

      return sendList;
    } catch (e) {
      debugPrint('Fundraising verileri alınamadı.');
      debugPrint(e.toString());
      return null;
    }
  }

  Future<String?> getFundraisingIDByCommunityName(
      String userID, String communityName) async {
    try {
      var _fundraisers = await _firebaseFirestore
          .collection('users')
          .doc(userID)
          .collection('fundraiser')
          .get();

      for (var fundraiser in _fundraisers.docs) {
        var data = fundraiser.data();

        if (data == null || !data.containsKey('communities')) continue;

        var communities = List.from(data['communities'] ?? []);

        for (var community in communities) {
          if (community is Map<String, dynamic> &&
              community.containsKey('communityName') &&
              community['communityName'] == communityName) {
            print('Eşleşen ID: ${data['fundraisingID']}');
            return data['fundraisingID'];
          }
        }
      }
    } catch (e) {
      print('Error fetching fundraising ID: $e');
    }
    return null; // Eğer bulunamazsa null dön
  }

  @override
  Future<FundraisingModel?> getFundraiser(
      String userID, String fundraisingID) async {
    try {
      DocumentSnapshot _readFundraiser = await _firebaseFirestore
          .doc('users/$userID/fundraiser/$fundraisingID')
          .get();

      Map<String, dynamic>? _readFundraiserMap =
          _readFundraiser.data() as Map<String, dynamic>;

      debugPrint('ben get Fundraiser ${_readFundraiserMap.toString()}');

      return FundraisingModel.fromMap(_readFundraiserMap);
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  Future<FundraisingModel?> getAllFundraiserTarget(
      String userID, String fundraisingID) async {
    var documentFundraiser = await _firebaseFirestore
        .doc('users/$userID/fundraiser/$fundraisingID')
        .get();

    Map<String, dynamic> mapFundraiser =
        documentFundraiser.data() as Map<String, dynamic>;

    FundraisingModel fundraisingModel = FundraisingModel.fromMap(mapFundraiser);
  }

  @override
  Future<void> deleteFundraising(String userID, String fundraisingID) async {
    try {
      _firebaseFirestore
          .collection('users')
          .doc(userID)
          .collection('fundraiser')
          .doc(fundraisingID)
          .delete();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<bool?> updateFundraising(String userID, String fundraisingID,
      Map<String, dynamic> updatedFields) async {
    try {
      await _firebaseFirestore
          .collection('users')
          .doc(userID)
          .collection('fundraiser')
          .doc(fundraisingID)
          .update(updatedFields);
      return true;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }
}

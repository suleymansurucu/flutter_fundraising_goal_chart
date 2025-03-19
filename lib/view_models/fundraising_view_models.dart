import 'package:flutter/material.dart';
import 'package:flutter_fundraising_goal_chart/core/utils/constants.dart';
import 'package:flutter_fundraising_goal_chart/core/utils/constants/build_elevated_button.dart';
import 'package:flutter_fundraising_goal_chart/locator.dart';
import 'package:flutter_fundraising_goal_chart/models/fundraising_model.dart';
import 'package:flutter_fundraising_goal_chart/services/user_repository.dart';
import 'package:flutter_fundraising_goal_chart/view_models/donation_view_models.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

enum ViewState { Busy, Idle }

class FundraisingViewModels with ChangeNotifier {
  final UserRepository userRepository = locator<UserRepository>();

  ViewState _viewState = ViewState.Idle;

  ViewState get state => _viewState;

  FundraisingModel? _fundraisingModel;

  FundraisingModel? get fundraisingModel => _fundraisingModel;
  List<String> _dropdownItems = [];
  String? _selectedValue;

  List<String> get dropdownItems => _dropdownItems;

  String? get selectedValue => _selectedValue;
  bool isLoading = false;

  @override
  Future<bool> createFundraising(Map<String, dynamic> fundraisingModel,
      String fundraisingID, String userID) async {
    try {
      _setState(ViewState.Busy);
      var createdFundraising = userRepository.createFundraising(
          fundraisingModel, fundraisingID, userID);

      _setState(ViewState.Idle);
      return true;
    } catch (e) {
      _setState(ViewState.Idle);
      return false;
    }
  }

  Future<List?> fetchFundraisingCommunity(String userID) async {
    try {
      _setState(ViewState.Busy);
      List<String> listName = await userRepository
          .fetchFundraisingCommunity(userID) as List<String>;

      _setState(ViewState.Idle);
      return listName;
    } catch (e) {
      _setState(ViewState.Idle);
      return null;
    }
  }

  void _setState(ViewState state) {
    _viewState = state;
    notifyListeners();
  }

  Future<List<FundraisingModel>?> fetchFundraising(String userID) async {
    try {
      _setState(ViewState.Busy);
      var result = await userRepository.fetchFundraising(userID);

      _setState(ViewState.Idle);
      return result;
    } catch (e) {
      _setState(ViewState.Idle);
      return null;
    }
  }

  Future<String?> getFundraisingIDByCommunityName(
      String userID, String communityName) async {
    try {
      _setState(ViewState.Busy);
      var result = await userRepository.getFundraisingIDByCommunityName(
          userID, communityName);

      _setState(ViewState.Idle);
      return result;
    } catch (e) {
      _setState(ViewState.Idle);
      return null;
    }
  }

  Future<bool?> saveDonation(String userID, String fundraisingID,
      String communityName, String donorName, double donationAmount) async {
    try {
      _setState(ViewState.Busy);
      var result = await userRepository.saveDonation(
          userID, fundraisingID, communityName, donorName, donationAmount);

      _setState(ViewState.Idle);
      return result;
    } catch (e) {
      _setState(ViewState.Idle);
      return null;
    }
  }

  Future<FundraisingModel?> getFundraiser(
      String userID, String fundraisingID) async {
    try {
      _setState(ViewState.Busy);
      var result = await userRepository.getFundraiser(userID, fundraisingID);

      _setState(ViewState.Idle);
      return result;
    } catch (e) {
      _setState(ViewState.Idle);
      return null;
    }
  }

  Future<double?> getAllFundraiserTarget(
      String userID, String fundraisingID) async {
    try {
      _setState(ViewState.Busy);
      var fundraisingModel =
          await userRepository.getFundraiser(userID, fundraisingID);
      double allCommunityFundraisingTarget = 0;
      for (var fundraiser in fundraisingModel!.communities) {
        allCommunityFundraisingTarget =
            fundraiser.goal + allCommunityFundraisingTarget;
      }
      _setState(ViewState.Idle);
      debugPrint(allCommunityFundraisingTarget.toString());
      return allCommunityFundraisingTarget;
    } catch (e) {
      _setState(ViewState.Idle);
      return null;
    }
  }

  String? _uniqueName;

  String? get uniqueName => _uniqueName;
  String? _slogan;

  String? get slogan => _slogan;
  String? _currency;

  String? get currency => _currency;

  String? _showDonorNames;

  String? get showDonorNames => _showDonorNames;
  String? _showDonorAmount;

  String? get showDonorAmount => _showDonorAmount;
  String? _graphicType;

  String? get graphicType => _graphicType;
  List<CommunityFundraising>? communities;

  int? _communityCount;

  int? get communityCount => _communityCount;

  double? _fundraiserTarget;

  double? get fundraiserTarget => _fundraiserTarget;
  String? _communityName;

  String? get communityName => _communityName;

  set communityName(String? newName) {
    if (_communityName != newName) {
      _communityName = newName;
      notifyListeners(); // UI'nin güncellenmesini sağlar!
    }
  }

  void getFundraisingScreen(String userID, String fundraisingID) async {
    var snapshot = await userRepository.getFundraiser(userID, fundraisingID);

    var generalFundraiserTarget =
        await getAllFundraiserTarget(userID, fundraisingID);

    _uniqueName = snapshot!.uniqueName;
    _currency = snapshot.currency;
    _showDonorNames = snapshot.showDonorNames;
    _showDonorAmount = snapshot.showDonorAmount;
    _graphicType = snapshot.graphicType;
    _fundraiserTarget = generalFundraiserTarget;
    _slogan = snapshot.slogan;

    _communityCount = snapshot.communities.length;
    _communityName = snapshot.uniqueName;

    notifyListeners();
  }

  Widget getCommunitiesButton(String userID, String fundraisingID) {
    return FutureBuilder<FundraisingModel?>(
      future: getFundraiser(userID, fundraisingID),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return CircularProgressIndicator();
        }

        List<Widget> buttons = snapshot.data!.communities.map((community) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 4),
            child: snapshot.data!.communities.length == 1
                ? SizedBox()
                : BuildElevatedButton(
                    paddingHorizontal: 10,
                    paddingVertical: 8,
                    buttonFontSize: 14,
                    borderRadius: 5,
                    onPressed: () {
                      _communityName = community.name;
                      _fundraiserTarget = community.goal;
                      final donationViewModel = Provider.of<DonationViewModels>(
                          context,
                          listen: false);
                      donationViewModel.listenToDonations(userID, fundraisingID,
                          _communityName!, communityCount!);
                    },
                    buttonText: community.name,
                    buttonColor: Colors.grey.shade100,
                    textColor: Constants.textColor,
                  ),
          );
        }).toList();

        if (snapshot.data!.communities.length > 1) {
          buttons.add(Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: BuildElevatedButton(
                paddingHorizontal: 10,
                paddingVertical: 8,
                buttonFontSize: 14,
                borderRadius: 5,
                onPressed: () async {
                  var allTarget =
                      await getAllFundraiserTarget(userID, fundraisingID);
                  _communityName = snapshot.data!.uniqueName;
                  _fundraiserTarget = allTarget;

                  final donationViewModel =
                      Provider.of<DonationViewModels>(context, listen: false);
                  donationViewModel.listenToDonations(
                      userID, fundraisingID, 'general', communityCount!);
                },
                buttonText: 'General',
                buttonColor: Colors.grey.shade100,
                textColor: Constants.textColor),
          ));
        }

        notifyListeners();

        return Container(
          height: 50, // Buton yüksekliğini sabit tut
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal, // Yatay kaydırma ekledik
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: buttons,
            ),
          ),
        );
      },
    );
  }

  List<String>? _list = [];

  List<String>? get list => _list;

  set list(List<String>? newList) {
    _list = newList;
    notifyListeners(); // Değişiklik olduğunda dinleyicileri bilgilendir
  }

  String? _thisFundraising;

  String? get thisFundraising => _thisFundraising;
  String? _fundraisingID;

  String? get fundraisingID => _fundraisingID;

  fetchData() async {
    isLoading = true;
    var userID = userRepository.firebaseAuthService.currentUser!.uid;

    List<String>? fetchedList =
        await fetchFundraisingCommunity(userID) as List<String>;

    if (fetchedList != null && fetchedList.isNotEmpty) {
      _list = fetchedList;
      _thisFundraising = _list![0]; // Default selection
    }

    var result =
        await getFundraisingIDByCommunityName(userID, _thisFundraising!);

    // Update the state with the fundraising ID
    _fundraisingID = result;
    isLoading = false;
    notifyListeners();
  }

// 🔹 Function to update dropdown selection
  Future<void> onFundraising(String value) async {
    _thisFundraising = value;
    var userID = userRepository.firebaseAuthService.currentUser!.uid;

    var result =
        await getFundraisingIDByCommunityName(userID, _thisFundraising!);
    _fundraisingID = result;
    notifyListeners();
  }
}

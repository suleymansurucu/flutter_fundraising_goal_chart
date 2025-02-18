class FundraisingModel {
  final String userID;
  final String? fundraisingID;
  final String uniqueName;
  final String slogan;
  final String currency;
  final bool showDonorNames;
  final bool showDonorAmount;

  @override
  String toString() {
    return 'FundraisingModel{userID: $userID, fundraisingID: $fundraisingID, uniqueName: $uniqueName, slogan: $slogan, currency: $currency, showDonorNames: $showDonorNames, showDonorAmount: $showDonorAmount, graphicType: $graphicType, communities: $communities}';
  }

  final String graphicType;
  final List<CommunityFundraising> communities;

  FundraisingModel(
   { this.fundraisingID,
     required this.userID,
     required this.uniqueName,
    required this.slogan,
    required this.currency,
    required this.showDonorNames,
    required this.showDonorAmount,
    required this.graphicType,
    required this.communities,
  });

  Map<String, dynamic> toMap() {
    return {
      'userID': userID,
      'fundraisingID': fundraisingID,
      'uniqueName' : uniqueName,
      'slogan': slogan,
      'currency': currency,
      'showDonorNames': showDonorNames,
      'showDonorAmount': showDonorAmount,
      'graphicType': graphicType,
      'communities': communities,
    };
  }

  factory FundraisingModel.fromMap(Map<String, dynamic> map) {
    return FundraisingModel(
      userID: map['userID'] as String,
      fundraisingID: map['fundraisingID'] != null ? map['fundraisingID'] as String : null,
      uniqueName: map['uniqueName'] as String,
      slogan: map['slogan'] as String,
      currency: map['currency'] as String,
      showDonorNames: map['showDonorNames'] as bool,
      showDonorAmount: map['showDonorAmount'] as bool,
      graphicType: map['graphicType'] as String,
      communities: map['communities'] as List<CommunityFundraising>,
    );
  }
}

class CommunityFundraising {
  String name;
  double goal;

  CommunityFundraising({required this.name, required this.goal});

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'goal': goal,
    };
  }

  factory CommunityFundraising.fromMap(Map<String, dynamic> map) {
    return CommunityFundraising(
      name: map['name'] as String,
      goal: map['goal'] as double,
    );
  }
}

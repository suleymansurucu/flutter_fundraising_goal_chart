class FundraisingModel {
  final String userID;
  final String? fundraisingID;
  final String uniqueName;
  final String slogan;
  final String currency;
  final String showDonorNames;
  final String showDonorAmount;

  @override
  String toString() {
    return 'FundraisingModel{userID: $userID, fundraisingID: $fundraisingID, uniqueName: $uniqueName, slogan: $slogan, currency: $currency, showDonorNames: $showDonorNames, showDonorAmount: $showDonorAmount, graphicType: $graphicType, communities: $communities}';
  }

  final String graphicType;
  final List<CommunityFundraising> communities;

  FundraisingModel({ this.fundraisingID,
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
      'uniqueName': uniqueName,
      'fundraisingSlogan': slogan,
      'currency': currency,
      'showDonorNames': showDonorNames,
      'showDonorAmount': showDonorAmount,
      'goalChartType': graphicType,
      'communities': communities,
    };
  }

  factory FundraisingModel.fromMap(Map<String?, dynamic> map) {
    return FundraisingModel(
      userID: map['userID'] as String,
      fundraisingID: map['fundraisingID'] != null
          ? map['fundraisingID'] as String
          : null,
      uniqueName: map['uniqueName'] as String? ?? '',
      // Null ise boş string kullan
      slogan: map['fundraisingSlogan'] as String? ?? '',
      // Null ise boş string kullan
      currency: map['currency'] as String? ?? '',
      // Null ise boş string kullan
      showDonorNames: map['showDonorNames'] as String? ?? '',
      // Null ise true kullan
      showDonorAmount: map['showDonorAmount'] as String? ?? '',
      // Null ise true kullan
      graphicType: map['goalChartType'] as String? ?? '',
      // Null ise boş string kullan
      communities: (map['communities'] as List<dynamic>?)
          ?.map((item) =>
          CommunityFundraising.fromMap(item as Map<String, dynamic>))
          .toList() ?? [], // Null ise boş liste kullan
    );
  }
}

class CommunityFundraising {
  String name;
  double goal;

  CommunityFundraising({required this.name, required this.goal});

  Map<String, dynamic> toJson() {
    return {
      'communityName': name,
      'communityGoal': goal,
    };
  }

  factory CommunityFundraising.fromMap(Map<String, dynamic> map) {
    return CommunityFundraising(
      name: map['communityName'] as String? ?? '',  // Null ise boş string kullan
      goal: map['communityGoal'] as double? ?? 0.0,  // Null ise 0.0 kullan
    );
  }
}

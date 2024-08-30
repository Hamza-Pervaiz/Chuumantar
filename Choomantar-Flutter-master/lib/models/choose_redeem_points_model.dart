
class ChooseRedeemPointsModel {
  final String points;
  final String image;
  final String pkr;

  ChooseRedeemPointsModel({
    required this.points,
    required this.image,
    required this.pkr,
  });


  factory ChooseRedeemPointsModel.fromMap(Map<String, dynamic> map) {
    return ChooseRedeemPointsModel(
      points: map['points'].toString(),
      image: map['image'].toString(),
      pkr: map['pkr'].toString(),
    );
  }
}

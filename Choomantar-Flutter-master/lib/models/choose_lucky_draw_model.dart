class ChooseLuckyDrawModel {
  final String id;
  final String name;
  final String inventoryimage;
  final String points;




  factory ChooseLuckyDrawModel.fromMap(Map<String, dynamic> map) {
    return ChooseLuckyDrawModel(
      points: map['points'].toString(),
      inventoryimage: map['inventoryimage'].toString(),
      id: map['id'].toString(),
      name: map['name'].toString(),

    );
  }

  ChooseLuckyDrawModel({required this.id, required this.name, required this.inventoryimage, required this.points});

}
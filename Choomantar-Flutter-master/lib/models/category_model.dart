class CategoryModel {
  final String name;
  final String image;
  int? amount;
  bool isSelect;

  CategoryModel(
      {required this.image,
      required this.name,
      required this.amount,
      this.isSelect = false});
}

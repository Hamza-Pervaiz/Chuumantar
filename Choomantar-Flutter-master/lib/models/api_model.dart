class ShowCatModel {
  List<Category> products;

  ShowCatModel({required this.products});

  factory ShowCatModel.fromJson(Map<String, dynamic> json) {
    var productList = json['products'] as List;
    List<Category> categories = productList
        .map((categoryJson) => Category.fromJson(categoryJson))
        .toList();

    return ShowCatModel(products: categories);
  }
}

class Category {
  String id;
  String name;
  String productImage;
  bool isSelect;

  Category(
      {required this.id,
      required this.name,
      required this.productImage,
      this.isSelect = false});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      name: json['name'],
      productImage: json['product_image'],
    );
  }
}

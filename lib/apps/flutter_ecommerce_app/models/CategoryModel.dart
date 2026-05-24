class CategoryModel {

  final String name;
  
  final String slug;
  
  final String imageUrl;

  CategoryModel({
    required this.name,
    required this.slug,
    required this.imageUrl,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      name: json['name'] ?? '',
      slug: json['slug'] ?? '',
      imageUrl: json['image_url'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'slug': slug,
      'image_url': imageUrl,
    };
  }
}
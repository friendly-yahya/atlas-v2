// Long-term: if categories gain complex nested data, migrate to @freezed.

class ActivityCategory {
  final String id;
  final String slug;
  final String name;
  final String? categoryGroup;
  final String? description;

  const ActivityCategory({
    required this.id,
    required this.slug,
    required this.name,
    this.categoryGroup,
    this.description,
  });

  factory ActivityCategory.fromJson(Map<String, dynamic> json) {
    return ActivityCategory(
      id: json['id'] as String,
      slug: json['slug'] as String,
      name: json['name'] as String,
      categoryGroup: json['category_group'] as String?,
      description: json['description'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'slug': slug,
    'name': name,
    'category_group': categoryGroup,
    'description': description,
  };
}
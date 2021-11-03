class ProductCategory {


  const ProductCategory({
    required this.name,
    required this.id,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProductCategory &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          id == other.id);

  @override
  int get hashCode => name.hashCode ^ id.hashCode;

  @override
  String toString() {
    return 'ProductCategory{' + ' name: $name,' + ' id: $id,' + '}';
  }

  ProductCategory copyWith({
    String? name,
    String? id,
  }) {
    return ProductCategory(
      name: name ?? this.name,
      id: id ?? this.id,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': this.name,
      'id': this.id,
    };
  }

  factory ProductCategory.fromMap(Map<String, dynamic> map) {
    return ProductCategory(
      name: map['name'] as String,
      id: map['id'] as String,
    );
  }

  final String name;
  final String id;
}

class ApiListResult<T> {
  final List<T> items;

  final int count;
  final int total;

  const ApiListResult({
    required this.items,
    required this.count,
    required this.total,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ApiListResult &&
          runtimeType == other.runtimeType &&
          items == other.items &&
          count == other.count &&
          total == other.total);

  @override
  int get hashCode => items.hashCode ^ count.hashCode ^ total.hashCode;

  @override
  String toString() {
    return 'ApiListResult{' +
        ' items: $items,' +
        ' count: $count,' +
        ' total: $total,' +
        '}';
  }

  ApiListResult copyWith({
    List<T>? items,
    int? count,
    int? total,
  }) {
    return ApiListResult(
      items: items ?? this.items,
      count: count ?? this.count,
      total: total ?? this.total,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'items': this.items,
      'count': this.count,
      'total': this.total,
    };
  }

}

class Customer {
  final String id;
  final String? avatar;
  final String name;
  final String? email;

  Customer({
    required this.id,
    this.avatar,
    required this.name,
    this.email,
  });
}

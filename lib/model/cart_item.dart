class CartItem {
  final int id;
  final String title;
  final String price;
  final String image;

  CartItem({
    required this.id,
    required this.title,
    required this.price,
    required this.image,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'price': price,
      'image': image,
    };
  }

  factory CartItem.fromMap(Map<String, dynamic> map) {
    return CartItem(
      id: map['id'],
      title: map['title'],
      price: map['price'],
      image: map['image'],
    );
  }
}

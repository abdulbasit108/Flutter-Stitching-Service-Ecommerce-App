import 'dart:convert';

class User {
  final String id;
  final String? name;
  final String? email;
  final String? phone;
  final List<dynamic> address;
  final List<dynamic> payment;
  final String type;
  final String token;
  final List<dynamic> cart;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
    required this.payment,
    required this.type,
    required this.token,
    required this.cart,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'address': address,
      'payment': payment,
      'type': type,
      'token': token,
      'cart': cart,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['_id'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      address: List<Map<String, dynamic>>.from(
        map['address']?.map(
          (x) => Map<String, dynamic>.from(x),
        ),
      ),
      payment: List<Map<String, dynamic>>.from(
        map['payment']?.map(
          (x) => Map<String, dynamic>.from(x),
        ),
      ),
      type: map['type'] ?? '',
      token: map['token'] ?? '',
      cart: List<Map<String, dynamic>>.from(
        map['cart']?.map(
          (x) => Map<String, dynamic>.from(x),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) => User.fromMap(json.decode(source));

  User copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    List<dynamic>? address,
    List<dynamic>? payment,
    String? type,
    String? token,
    List<dynamic>? cart,

  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      payment: payment ?? this.payment,
      type: type ?? this.type,
      token: token ?? this.token,
      cart: cart ?? this.cart,
    );
  }
}
import 'dart:convert';
import 'package:etailor/models/measurement.dart'; // Import your Measurement model
import 'package:etailor/models/product.dart';      // Import your Product model

class Order {
  final String id;
  final List<OrderProduct> products;
  final double totalPrice;
  final bool isQuick;
  final Address address;
  final Payment payment;
  final String userId;
  final int orderedAt;

  Order({
    required this.id,
    required this.products,
    required this.totalPrice,
    required this.isQuick,
    required this.address,
    required this.payment,
    required this.userId,
    required this.orderedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'products': products.map((x) => x.toMap()).toList(),
      'totalPrice': totalPrice,
      'isQuick': isQuick,
      'address': address.toMap(),
      'payment': payment.toMap(),
      'userId': userId,
      'orderedAt': orderedAt,
    };
  }

  factory Order.fromMap(Map<String, dynamic> map) {
    return Order(
      id: map['_id'] ?? '',
      products: List<OrderProduct>.from(
        map['products']?.map((x) => OrderProduct.fromMap(x)),
      ),
      totalPrice: map['totalPrice']?.toDouble() ?? 0.0,
      isQuick: map['isQuick'] ?? false,
      address: Address.fromMap(map['address']),
      payment: Payment.fromMap(map['payment']),
      userId: map['userId'] ?? '',
      orderedAt: map['orderedAt']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory Order.fromJson(String source) => Order.fromMap(json.decode(source));
}

class OrderProduct {
  final Product product;
  final Measurement measurement;
  final int quantity;
  final int neckStyle;
  final int sleeveStyle;
  final int trouserLength;
  final String instructions;
  final List<String> images;

  OrderProduct({
    required this.product,
    required this.measurement,
    required this.quantity,
    required this.neckStyle,
    required this.sleeveStyle,
    required this.trouserLength,
    required this.instructions,
    required this.images,
  });

  Map<String, dynamic> toMap() {
    return {
      'product': product.toMap(),
      'measurement': measurement.toMap(),
      'quantity': quantity,
      'neckStyle': neckStyle,
      'sleeveStyle': sleeveStyle,
      'trouserLength': trouserLength,
      'instructions': instructions,
      'images': images,
    };
  }

  factory OrderProduct.fromMap(Map<String, dynamic> map) {
    return OrderProduct(
      product: Product.fromMap(map['product']),
      measurement: Measurement.fromMap(map['measurement']),
      quantity: map['quantity'],
      neckStyle: map['neckStyle'],
      sleeveStyle: map['sleeveStyle'],
      trouserLength: map['trouserLength'],
      instructions: map['instructions'],
      images: List<String>.from(map['images']),
    );
  }
}

class Address {
  final String addressLabel;
  final String addressData;

  Address({
    required this.addressLabel,
    required this.addressData,
  });

  Map<String, dynamic> toMap() {
    return {
      'addressLabel': addressLabel,
      'addressData': addressData,
    };
  }

  factory Address.fromMap(Map<String, dynamic> map) {
    return Address(
      addressLabel: map['addressLabel'],
      addressData: map['addressData'],
    );
  }
}

class Payment {
  final String paymentLabel;
  final String paymentData;

  Payment({
    required this.paymentLabel,
    required this.paymentData,
  });

  Map<String, dynamic> toMap() {
    return {
      'paymentLabel': paymentLabel,
      'paymentData': paymentData,
    };
  }

  factory Payment.fromMap(Map<String, dynamic> map) {
    return Payment(
      paymentLabel: map['paymentLabel'],
      paymentData: map['paymentData'],
    );
  }
}

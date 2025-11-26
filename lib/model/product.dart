import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  final String? id;
  final String name;
  final String description;
  final String category;
  final String? imageUrl;
  final double price;
  final double rating;
  final int reviews;
  final String? createdBy;
  final String? createdById;
  final DateTime? createdAt;

  Product({
    this.id,
    required this.name,
    required this.description,
    required this.category,
    this.imageUrl,
    required this.price,
    required this.rating,
    required this.reviews,
     this.createdBy,
     this.createdById,
     this.createdAt,
  });

  factory Product.fromMap(Map<String, dynamic> map, String id) {
    return Product(
      id: id,
      name: map['name'] ?? '',
      description: map['description'] ?? 'No description available',
      category: map['category'] ?? '',
      imageUrl: map['imageUrl'] ?? 'https://via.placeholder.com/150',
      price: (map['price'] ?? 0).toDouble(),
      rating: (map['rating'] ?? 0).toDouble(),
      reviews: map['reviews'] ?? 0,
      createdBy: map['createdBy'] ?? '',
      createdById: map['createdById'] ?? '',
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }
  Map<String, dynamic> toMap({bool useServerTimestamp = false}) {
    return {
      'name': name,
      'description': description,
      'category': category,
      'imageUrl': imageUrl,
      'price': price,
      'rating': rating,
      'reviews': reviews,
      'createdBy': createdBy,
      'createdById': createdById,
      'createdAt': useServerTimestamp
          ? FieldValue.serverTimestamp()
          : createdAt,
    };
  }

}

import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/product.dart';

class ProductService {
  Future<void> addProduct({
    required String productName,
    required String category,
    required double price,
    required String description,
    required String imageUrl,
    required String sellerName,
    required String sellerId,

  }) async {
    try {
      final product = Product(
        name: productName,
        description: description,
        category: category,
        imageUrl: imageUrl,
        price: price,
        rating: 0.0,
        reviews: 0,
        createdBy: sellerName,
        createdById: sellerId,
        createdAt: null,
      );

      await FirebaseFirestore.instance
          .collection('products')
          .add(product.toMap(useServerTimestamp: true));

      print("✅ Product added successfully");
    } catch (e) {
      print("❌ Error adding product: $e");
      throw Exception("Failed to add product");
    }
  }

  Stream<List<Product>> streamProductsByCategory(String? category) {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;

    Query query = _firestore.collection('products');

    if (category != null && category != "All") {
      query = query.where('category', isEqualTo: category);
    }

    query = query.orderBy('createdAt', descending: true);

    return query.snapshots().map((snapshot) {
      return snapshot.docs.map(
            (doc) => Product.fromMap(doc.data() as Map<String, dynamic>, doc.id),
      ).toList();
    });
  }

  Stream<List<Product>> streamMyProductsByCategory(String category, String sellerId) {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;

    Query query = _firestore
        .collection('products')
        .where('createdById', isEqualTo: sellerId);

    if (category != "All") {
      query = query.where('category', isEqualTo: category);
    }

    query = query.orderBy('createdAt', descending: true);

    return query.snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => Product.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    });
  }

  Future<void> deleteProduct(String productId) async {
    try {
      await FirebaseFirestore.instance.collection('products').doc(productId).delete();
    } catch (e) {
      print("❌ Error deleting product: $e");
    }
  }
  Future<void> updateProduct({
    required String productId,
    required String productName,
    required String category,
    required double price,
    required String description,
    required String imageUrl,
  }) async {
    await FirebaseFirestore.instance.collection('products').doc(productId).update({
      'name': productName,
      'category': category,
      'price': price,
      'description': description,
      'imageUrl': imageUrl,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }


}

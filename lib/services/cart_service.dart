import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/cart.dart';

class CartService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> addToCart(String userId, CartItem item) async {
    final cartRef = _db.collection('carts').doc(userId).collection('items');
    await cartRef.add(item.toMap());
  }

  Stream<List<CartItem>> getCartItems(String userId) {
    return _db
        .collection('carts')
        .doc(userId)
        .collection('items')
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => CartItem.fromFirestore(doc.data(), doc.id))
        .toList());
  }

  Future<void> updateQuantity(String userId, String itemId, int newQty) async {
    await _db
        .collection('carts')
        .doc(userId)
        .collection('items')
        .doc(itemId)
        .update({'quantity': newQty});
  }

  Future<void> removeItem(String userId, String itemId) async {
    await _db
        .collection('carts')
        .doc(userId)
        .collection('items')
        .doc(itemId)
        .delete();
  }
}

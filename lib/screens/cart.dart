import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project/constants/app_colors.dart';
import 'package:project/widgets/custom_button.dart';
import 'package:project/widgets/custom_header_text.dart';
import 'package:project/widgets/gap.dart';
import '../cubits/profile/theme_cubit.dart';
import '../model/cart.dart';
import '../services/cart_service.dart';

class Cart extends StatelessWidget {
  final CartService _cartService = CartService();
  final userId = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = context.watch<ThemeCubit>().state;

    return StreamBuilder<List<CartItem>>(
      stream: _cartService.getCartItems(userId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.white),
          );
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
            child: Text(
              "Your cart is empty",
              style: TextStyle(color: AppColors.primaryTextColor(isDarkMode), fontSize: 18),
            ),
          );
        }

        final items = snapshot.data!;
        double total = items.fold(0, (sum, item) => sum + (item.price * item.quantity));

        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    color: AppColors.primaryColor(isDarkMode),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          item.imageUrl,
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                        ),
                      ),
                      title: Text(
                        item.name,
                        style: TextStyle(color: AppColors.primaryTextColor(isDarkMode)),
                      ),
                      subtitle: Text(
                        "\$${item.price}",
                        style: TextStyle(color: AppColors.secondaryTextColor(isDarkMode)),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove),
                            onPressed: () {
                              if (item.quantity > 1) {
                                _cartService.updateQuantity(userId, item.id, item.quantity - 1);
                              }
                            },
                          ),
                          Text(
                            '${item.quantity}',
                            style: const TextStyle(color: Colors.white),
                          ),
                          IconButton(
                            icon: const Icon(Icons.add),
                            onPressed: () {
                              _cartService.updateQuantity(userId, item.id, item.quantity + 1);
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              _cartService.removeItem(userId, item.id);
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.primaryColor(isDarkMode),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    offset: Offset(0, -2),
                    blurRadius: 8,
                  )
                ],
              ),
              child: SafeArea(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomHeaderText(text: "Total"),
                        CustomHeaderText(text: "\$${total.toStringAsFixed(2)}"),
                      ],
                    ),
                    Gap(h: 12),
                    CustomButton(
                      title: 'Complete Payment',
                      onPressed: () {
                        Navigator.pushNamed(context, '/check_out');
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

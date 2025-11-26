import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project/widgets/custom_button.dart';
import 'package:project/widgets/custom_message.dart';
import 'package:project/widgets/gap.dart';
import '../constants/app_colors.dart';
import '../cubits/profile/theme_cubit.dart';
import '../model/cart.dart';
import '../model/product.dart';
import '../services/auth_service.dart';
import '../services/cart_service.dart';

class ProductDetails extends StatefulWidget {
  final Product product;

  const ProductDetails({super.key, required this.product});

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  final CartService _cartService = CartService();
  final AuthService _authService = AuthService();
  User? user;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    user = _authService.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = context.watch<ThemeCubit>().state;

    return Scaffold(
      appBar: AppBar(elevation: 0),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              height: MediaQuery.of(context).size.height * 0.35,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              clipBehavior: Clip.hardEdge,
              child: Hero(
                tag: widget.product.name,
                child: Image.network(
                  widget.product.imageUrl ?? "",
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Image.asset(
                      "assets/images/vertical-banners-sales-promo.jpg",
                      fit: BoxFit.cover,
                    );
                  },
                ),
              ),
            ),



          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration:  BoxDecoration(color: AppColors.background(isDarkMode)),
              child: ListView(
                children: [
                  Text(widget.product.name,
                      style:  TextStyle(
                          color: AppColors.primaryTextColor(isDarkMode),
                          fontSize: 22,
                          fontWeight: FontWeight.bold)),
                  Gap(h: 6),
                  Text(widget.product.description,
                      style:  TextStyle(
                          color: AppColors.secondaryTextColor(isDarkMode), fontSize: 15)),
                  Gap(h: 10),
                  Text("\$${widget.product.price.toStringAsFixed(2)}",
                      style: const TextStyle(
                          color: AppColors.secondary,
                          fontSize: 20,
                          fontWeight: FontWeight.bold)),
                  Gap(h: 16),
                  const Divider(color: Colors.grey),
                  Gap(h: 10),
                   Text("Shipping & Returns",
                      style: TextStyle(
                          color: AppColors.primaryTextColor(isDarkMode), fontSize: 16)),
                  Gap(h: 8),
                   Text(
                    "Free shipping on all orders. Returns accepted within 14 days.",
                    style: TextStyle(
                        color: AppColors.secondaryTextColor(isDarkMode), fontSize: 14),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: CustomButton(
              title: "Add to Cart",
              isLoading: _loading
              ,
              onPressed: () async {
                 _loading = true;

                 await _cartService.addToCart(
                   user!.uid,
                   CartItem(
                     id: '',
                     name: widget.product.name,
                     price: widget.product.price,
                     quantity: 1,
                     imageUrl: widget.product.imageUrl.toString(),
                   ),
                 );
                ShowAwesomeDialog.success(
                  context,
                  "تم اضافة المنتج للعربة بنجاح.",
                  onOk: () {
                     _loading = false;

                    Navigator.pop(context);
                  },

                );
              },
            ),
          ),
          Gap(h: 35)
        ],
      ),
    );
  }
}

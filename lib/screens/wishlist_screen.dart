import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project/cubits/Wishlist/favorites_cubit.dart';

import '../cubits/product/products_cubit.dart';
import '../widgets/product_card.dart';

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({super.key});

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  void _loadWishlist() {
    context.read<FavoritesCubit>().loadWishlist(
    );
  }

  @override
  void initState() {
    super.initState();
    _loadWishlist();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FavoritesCubit, Set<String>>(
      builder: (context, favIds) {
        return BlocBuilder<ProductsCubit, ProductsState>(
          builder: (context, productsState) {
            if (productsState is ProductsLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (productsState is ProductsSuccess) {
              final wishlistProducts = productsState.products
                  .where((p) => favIds.contains(p.id))
                  .toList();

              if (wishlistProducts.isEmpty) {
                return const Center(child: Text("Wishlist is empty"));
              }

              return Padding(
                padding: const EdgeInsets.only(top:30),
                child: GridView.builder(
                  padding: const EdgeInsets.all(10),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.70,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: wishlistProducts.length,
                  itemBuilder: (context, index) {
                    final product = wishlistProducts[index];

                    return ProductCard(
                      imageUrl: product.imageUrl,
                      name: product.name,
                      rating: product.rating,
                      reviews: product.reviews,
                      price: product.price,
                      isFavorite: true,
                      onAddFav: () {
                        context
                            .read<FavoritesCubit>()
                            .toggleFavorite(product.id!);
                      },
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          '/details',
                          arguments: {'product': product},
                        );
                      },
                    );
                  },
                ),
              );
            }

            return const SizedBox();
          },
        );
      },
    );
  }
}
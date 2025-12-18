import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project/constants/app_colors.dart';
import 'package:project/cubits/product/products_cubit.dart';
import 'package:project/model/product.dart';
import 'package:project/services/product_service.dart';
import 'package:project/widgets/category_selector.dart';
import 'package:project/widgets/product_card.dart';

import '../cubits/Wishlist/favorites_cubit.dart';
import '../cubits/profile/theme_cubit.dart';


class HomePage extends StatefulWidget {
  final String searchQuery;
  final void Function(String)? onSearchChanged;

  const HomePage({super.key, required this.searchQuery, this.onSearchChanged});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {

  String selectedCategory = "All";

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  void _loadProducts() {
    context.read<ProductsCubit>().getProducts(
      category: selectedCategory,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = context.watch<ThemeCubit>().state;

    return Column(
      children: [
        CategorySelector(
          categories: const [
            "All",
            "Cables & Chargers",
            "Cases & Protection",
            "Headphones",
            "Screen Protectors",
            "Power Banks",
            "Car Accessories",
          ],
          onCategorySelected: (selected) {
            setState(() {
              selectedCategory = selected;
            });
            _loadProducts();
          },
        ),

        Expanded(

          child: BlocBuilder<ProductsCubit, ProductsState>(

            builder: (context, state) {
              if (state is ProductsLoading) {
                return const Center(child: CircularProgressIndicator());
              }else if(state is ProductsError) {
                return Center(child: Text(state.message));
              }

              else if(state is ProductsSuccess) {
                final filtered = state.products.where((p) =>
                    p.name.toLowerCase().contains(
                        widget.searchQuery.toLowerCase())
                ).toList();


                return GridView.builder(
                  padding: const EdgeInsets.all(10),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.75,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    final product = filtered[index];
                    final isFav = context.watch<FavoritesCubit>().isFavorite(product.id!);
                    return ProductCard(
                      imageUrl: product.imageUrl,
                      name: product.name,
                      rating: product.rating,
                      reviews: product.reviews,
                      price: product.price,
                      isFavorite: isFav,
                      onAddFav: () {
                        context.read<FavoritesCubit>().toggleFavorite(product.id!);
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
                );
              }
              return const SizedBox();
            },

          ),

        ),

      ],
    );

  }
}

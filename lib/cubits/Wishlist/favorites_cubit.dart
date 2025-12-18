import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../model/product.dart';
import '../../services/user_service.dart';

part 'favorites_state.dart';
class FavoritesCubit extends Cubit<Set<String>> {
  final UserService userService;

  FavoritesCubit(this.userService) : super({});

  Future<void> loadWishlist() async {
    final favs = await userService.getWishlist();
    emit(favs.toSet());
  }

  Future<void> toggleFavorite(String productId) async {
    await userService.toggleWishlist(productId);

    final updated = Set<String>.from(state);
    if (updated.contains(productId)) {
      updated.remove(productId);
    } else {
      updated.add(productId);
    }
    emit(updated);
  }

  bool isFavorite(String id) => state.contains(id);
}

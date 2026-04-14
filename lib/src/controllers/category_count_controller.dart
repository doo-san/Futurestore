import 'package:get/get.dart';
import '../servers/repository.dart';

/// Charge et met en cache le nombre de produits par catégorie
class CategoryCountController extends GetxController {
  // Map réactive : categoryId → nombre de produits
  final RxMap<int, int> counts = <int, int>{}.obs;
  final _loading = <int>{};

  /// Retourne le nombre de produits pour une catégorie.
  /// Lance la requête si pas encore chargée.
  int getCount(int categoryId) {
    if (!counts.containsKey(categoryId) && !_loading.contains(categoryId)) {
      _fetchCount(categoryId);
    }
    return counts[categoryId] ?? 0;
  }

  Future<void> _fetchCount(int categoryId) async {
    _loading.add(categoryId);
    final count = await Repository().getProductCountByCategory(categoryId);
    counts[categoryId] = count;
    _loading.remove(categoryId);
  }

  /// Précharge les comptes pour une liste de catégories d'un coup
  Future<void> prefetchCounts(List<int> categoryIds) async {
    final toFetch = categoryIds
        .where((id) => !counts.containsKey(id) && !_loading.contains(id))
        .toList();
    if (toFetch.isEmpty) return;
    await Future.wait(toFetch.map((id) => _fetchCount(id)));
  }
}

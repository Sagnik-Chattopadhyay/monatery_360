import 'package:flutter/material.dart';
import '../models/monastery_model.dart';
import '../models/archive_model.dart';
import '../models/tourism_service_model.dart';
import '../services/firestore_service.dart';

class MonasteryProvider extends ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();

  List<MonasteryModel> _monasteries = [];
  List<ArchiveModel> _archives = [];
  List<TourismServiceModel> _tourismServices = [];
  String _selectedCategoryFilter = 'All';
  String _searchQuery = '';
  bool _isLoading = false;

  MonasteryProvider() {
    loadData();
  }

  List<MonasteryModel> get monasteries {
    return _monasteries.where((m) {
      final matchesSearch = m.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          m.locationName.toLowerCase().contains(_searchQuery.toLowerCase());
      if (_selectedCategoryFilter == 'All' || _selectedCategoryFilter == 'All Sanctuaries') return matchesSearch;
      if (_selectedCategoryFilter == 'Historic' || _selectedCategoryFilter == 'Historic Gompas') {
        return matchesSearch && (m.era.contains('17th') || m.era.contains('18th') || m.era.contains('16th'));
      }
      if (_selectedCategoryFilter.contains('Nyingma')) {
        return matchesSearch && m.orderSect.contains('Nyingma');
      }
      if (_selectedCategoryFilter.contains('Kagyu')) {
        return matchesSearch && m.orderSect.contains('Kagyu');
      }
      if (_selectedCategoryFilter.contains('Alpine')) {
        return matchesSearch && m.isHighAltitude;
      }
      return matchesSearch && (m.orderSect.contains(_selectedCategoryFilter) || m.era.contains(_selectedCategoryFilter));
    }).toList();
  }


  List<MonasteryModel> get featuredMonasteries =>
      _monasteries.where((m) => m.isFeatured).toList();

  List<ArchiveModel> get archives => _archives;
  List<TourismServiceModel> get tourismServices => _tourismServices;
  bool get isLoading => _isLoading;
  String get selectedCategoryFilter => _selectedCategoryFilter;
  String get selectedCategory => _selectedCategoryFilter;

  Future<void> loadData() async {

    _isLoading = true;
    notifyListeners();
    _monasteries = await _firestoreService.getMonasteries();
    _archives = await _firestoreService.getArchives();
    _tourismServices = await _firestoreService.getTourismServices();
    _isLoading = false;
    notifyListeners();
  }

  void setCategoryFilter(String category) {
    _selectedCategoryFilter = category;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }
}

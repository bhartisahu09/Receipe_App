import 'package:flutter/material.dart';
import '../data/recipes.dart';

class RecipeProvider extends ChangeNotifier {
  final List<Recipe> _allRecipes = recipes;
  List<Recipe> _filteredRecipes = recipes;
  String _searchQuery = '';
  String _selectedCategory = 'All';
  bool _isLoading = false;

  List<Recipe> get allRecipes => _allRecipes;
  List<Recipe> get filteredRecipes => _filteredRecipes;
  String get searchQuery => _searchQuery;
  String get selectedCategory => _selectedCategory;
  bool get isLoading => _isLoading;

  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    _filterRecipes();
  }

  void setSelectedCategory(String category) {
    _selectedCategory = category;
    _filterRecipes();
  }

  void _filterRecipes() {
    List<Recipe> filtered = _allRecipes;

    // Filter by category
    if (_selectedCategory != 'All') {
      filtered = filtered.where((recipe) => recipe.category == _selectedCategory).toList();
    }

    // Filter by search query
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((recipe) => 
        recipe.name.toLowerCase().contains(_searchQuery.toLowerCase())
      ).toList();
    }

    _filteredRecipes = filtered;
    notifyListeners();
  }

  void clearFilters() {
    _searchQuery = '';
    _selectedCategory = 'All';
    _filteredRecipes = _allRecipes;
    notifyListeners();
  }
} 
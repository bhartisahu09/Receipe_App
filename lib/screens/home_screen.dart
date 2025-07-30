import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/recipe_provider.dart';
import '../widgets/recipe_card.dart';
import '../data/recipes.dart';
import 'recipe_detail_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Recipe App',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.orange[700],
        elevation: 0,
      ),
      body: Consumer<RecipeProvider>(
        builder: (context, recipeProvider, child) {
          return Column(
            children: [
              // Search and Filter Section
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.orange[700],
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
                child: Column(
                  children: [
                    // Search Bar
                    TextField(
                      onChanged: recipeProvider.setSearchQuery,
                      decoration: InputDecoration(
                        hintText: 'Search recipes...',
                        prefixIcon: const Icon(Icons.search, color: Colors.grey),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Category Filter
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: recipeProvider.selectedCategory,
                          isExpanded: true,
                          icon: const Icon(Icons.filter_list),
                          items: categories.map((String category) {
                            return DropdownMenuItem<String>(
                              value: category,
                              child: Text(category),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            if (newValue != null) {
                              recipeProvider.setSelectedCategory(newValue);
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Recipe Grid
              Expanded(
                child: recipeProvider.filteredRecipes.isEmpty
                    ? const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.search_off,
                              size: 64,
                              color: Colors.grey,
                            ),
                            SizedBox(height: 16),
                            Text(
                              'No recipes found',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      )
                    : GridView.builder(
                        padding: const EdgeInsets.all(16),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.75,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                        ),
                        itemCount: recipeProvider.filteredRecipes.length,
                        itemBuilder: (context, index) {
                          final recipe = recipeProvider.filteredRecipes[index];
                          return RecipeCard(
                            recipe: recipe,
                            onTap: () {
                              recipeProvider.setLoading(true);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => RecipeDetailScreen(
                                    recipe: recipe,
                                  ),
                                ),
                              ).then((_) {
                                recipeProvider.setLoading(false);
                              });
                            },
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
} 
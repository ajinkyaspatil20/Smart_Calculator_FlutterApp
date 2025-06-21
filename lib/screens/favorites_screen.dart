import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/favorites_provider.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final favoritesProvider = Provider.of<FavoritesProvider>(context);
    final favorites = favoritesProvider.favorites.toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Favorites'),
        actions: [
          if (favorites.isNotEmpty)
            IconButton(
              icon: Icon(Icons.delete_sweep),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('Clear All Favorites?'),
                    content: Text('This action cannot be undone.'),
                    actions: [
                      TextButton(
                        child: Text('Cancel'),
                        onPressed: () => Navigator.pop(context),
                      ),
                      TextButton(
                        child: Text('Clear'),
                        onPressed: () {
                          favoritesProvider.clearFavorites();
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
        ],
      ),
      body: favorites.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.favorite_border,
                    size: 64,
                    color: theme.disabledColor,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'No favorites yet',
                    style: theme.textTheme.titleLarge,
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Add formulas to favorites to see them here',
                    style: theme.textTheme.bodyMedium,
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: favorites.length,
              padding: EdgeInsets.all(16),
              itemBuilder: (context, index) {
                final formula = favorites[index];
                return Card(
                  child: ListTile(
                    title: Text(formula),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () =>
                          favoritesProvider.removeFavorite(formula),
                    ),
                  ),
                );
              },
            ),
    );
  }
}

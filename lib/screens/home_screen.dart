import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/product_provider.dart';
import '../widgets/product_card.dart';
import 'detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ProductProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Products')),
      body: Column(
        children: [
          Padding(
            // Softer fill and rounded focus states make search clearer without changing behavior.
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search products',
                prefixIcon: Icon(Icons.search),
                filled: true,
                fillColor: Theme.of(context).colorScheme.surfaceContainerHighest
                    .withValues(alpha: 0.45),
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.outlineVariant,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.primary,
                    width: 1.5,
                  ),
                ),
              ),
              onSubmitted: (q) => context.read<ProductProvider>().search(q),
            ),
          ),
          Expanded(child: _buildBody(provider)),
        ],
      ),
    );
  }

  Widget _buildBody(ProductProvider provider) {
    if (provider.error != null && provider.products.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Error: ${provider.error}'),
            TextButton(onPressed: provider.refresh, child: const Text('Retry')),
          ],
        ),
      );
    }
    if (provider.products.isEmpty && provider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (provider.products.isEmpty) {
      return const Center(child: Text('No products found'));
    }

    final width = MediaQuery.of(context).size.width;
    int crossAxisCount;
    double aspectRatio;
    if (width >= 900) {
      crossAxisCount = 4;
      aspectRatio = 0.7;
    } else if (width >= 600) {
      crossAxisCount = 3;
      aspectRatio = 0.7;
    } else {
      crossAxisCount = 1;
      aspectRatio = 1.4;
    }

    return RefreshIndicator(
      onRefresh: provider.refresh,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: ListView(
            // Align product content with the more spacious search field.
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            children: [
              if (provider.error != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Text(
                    'Could not load products: ${provider.error}',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                ),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  childAspectRatio: aspectRatio,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: provider.products.length,
                itemBuilder: (context, index) {
                  final product = provider.products[index];
                  return ProductCard(
                    product: product,
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => DetailScreen(product: product),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
              if (provider.isLoading)
                const Center(child: CircularProgressIndicator())
              else if (provider.hasMore && !provider.isSearching)
                Center(
                  child: ElevatedButton(
                    onPressed: () => context.read<ProductProvider>().loadMore(),
                    child: const Text('Load More'),
                  ),
                )
              else if (provider.products.isNotEmpty)
                const Center(child: Text('No more products')),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

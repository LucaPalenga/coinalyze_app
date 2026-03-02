import 'package:flutter/material.dart';

import '../../constants/sizes_config.dart';
import '../../data/models/models.dart';
import '../../extensions/build_context.dart';

/// Full-screen page for selecting a future market asset.
///
/// Returns the selected [FutureMarketInfoModel] via [Navigator.pop].
class AssetSelectionScreen extends StatefulWidget {
  final List<FutureMarketInfoModel> assets;
  final FutureMarketInfoModel? selectedAsset;

  const AssetSelectionScreen({super.key, required this.assets, this.selectedAsset});

  @override
  State<AssetSelectionScreen> createState() => _AssetSelectionScreenState();
}

class _AssetSelectionScreenState extends State<AssetSelectionScreen> {
  final _searchController = TextEditingController();
  List<FutureMarketInfoModel> _filtered = [];

  @override
  void initState() {
    super.initState();
    _filtered = widget.assets;
    _searchController.addListener(_onSearch);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearch() {
    final query = _searchController.text.toLowerCase().trim();
    setState(() {
      if (query.isEmpty) {
        _filtered = widget.assets;
      } else {
        _filtered = widget.assets.where((a) {
          final base = (a.baseAsset ?? '').toLowerCase();
          final quote = (a.quoteAsset ?? '').toLowerCase();
          final symbol = (a.symbol ?? '').toLowerCase();
          return base.contains(query) || quote.contains(query) || symbol.contains(query);
        }).toList();
      }
    });
  }

  String _displayName(FutureMarketInfoModel a) {
    final base = a.baseAsset ?? '';
    final quote = a.quoteAsset ?? '';
    final suffix = a.isPerpetual == true ? ' Perp' : '';
    return '$base/$quote$suffix';
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colorScheme;
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.select_asset)),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: SpacingSize.md,
              vertical: SpacingSize.sm,
            ),
            child: TextField(
              controller: _searchController,
              autofocus: true,
              decoration: InputDecoration(
                hintText: context.l10n.search_assets,
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                        },
                      )
                    : null,
                filled: true,
                fillColor: colors.surfaceContainerHigh,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(BorderRadiusSize.md),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: SpacingSize.md,
                  vertical: SpacingSize.sm,
                ),
              ),
              style: context.textTheme.bodyMedium,
            ),
          ),
          // Results
          Expanded(
            child: _filtered.isEmpty
                ? Center(
                    child: Text(
                      context.l10n.no_assets_found,
                      style: context.textTheme.bodyMedium?.copyWith(color: colors.onSurfaceVariant),
                    ),
                  )
                : ListView.builder(
                    itemCount: _filtered.length,
                    itemBuilder: (context, index) {
                      final asset = _filtered[index];
                      final isSelected = asset.symbol == widget.selectedAsset?.symbol;
                      final baseAsset = asset.baseAsset ?? '?';
                      return ListTile(
                        leading: Container(
                          width: 36,
                          height: 36,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: isSelected
                                ? colors.primary.withValues(alpha: 0.15)
                                : colors.surfaceContainerHighest,
                            borderRadius: BorderRadius.circular(BorderRadiusSize.xs),
                          ),
                          child: Text(
                            baseAsset.length > 3 ? baseAsset.substring(0, 3) : baseAsset,
                            style: context.textTheme.labelSmall?.copyWith(
                              color: isSelected ? colors.primary : colors.onSurfaceVariant,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        title: Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: _displayName(asset),
                                style: context.textTheme.bodyMedium?.copyWith(
                                  color: isSelected ? colors.primary : colors.onSurface,
                                ),
                              ),
                              const TextSpan(text: '  '),
                              TextSpan(
                                text: baseAsset,
                                style: context.textTheme.bodyMedium?.copyWith(
                                  color: isSelected ? colors.primary : colors.onSurfaceVariant,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        trailing: isSelected ? Icon(Icons.check, color: colors.primary) : null,
                        onTap: () => Navigator.of(context).pop(asset),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

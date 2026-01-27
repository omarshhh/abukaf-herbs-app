import 'dart:async';
import 'package:flutter/material.dart';

import 'package:mobile/cart/controller/cart_controller.dart';
import 'package:mobile/home/data/products_repo.dart';
import 'package:mobile/home/models/herb_product.dart';
import 'package:mobile/l10n/app_localizations.dart';
import 'package:mobile/home/products/product_details_page.dart';

class HomeSearchSheet extends StatefulWidget {
  const HomeSearchSheet({super.key, required this.repo, this.categoryId});

  final MobileProductsRepo repo;
  final String? categoryId;

  static Future<void> open(
    BuildContext context, {
    required MobileProductsRepo repo,
    String? categoryId,
  }) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      showDragHandle: true,
      builder: (_) => FractionallySizedBox(
        heightFactor: 0.85,
        child: HomeSearchSheet(repo: repo, categoryId: categoryId),
      ),
    );
  }

  @override
  State<HomeSearchSheet> createState() => _HomeSearchSheetState();
}

class _HomeSearchSheetState extends State<HomeSearchSheet> {
  final _ctrl = TextEditingController();
  Timer? _debounce;

  String _q = '';
  Future<List<HerbProduct>>? _future;

  @override
  void dispose() {
    _debounce?.cancel();
    _ctrl.dispose();
    super.dispose();
  }

  void _runSearch(String raw) {
    final v = raw.trim();
    setState(() {
      _q = v;
      _future = v.isEmpty
          ? null
          : widget.repo.searchProducts(
              query: v,
              categoryId: widget.categoryId,
              limit: 20,
            );
    });
  }

  void _onChanged(String v) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 250), () => _runSearch(v));
  }

  Future<void> _openProduct(HerbProduct p) async {
    if (!mounted) return;

    Navigator.pop(context); // اقفل الشيت

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ProductDetailsPage(
          product: p,
          onAddToCart: (product, qty) async {
            CartController.I.addOrMerge(product, qty: qty);
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    t.searchHint,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close_rounded),
                ),
              ],
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _ctrl,
              autofocus: true,
              onChanged: _onChanged,
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                hintText: t.searchHint,
                prefixIcon: const Icon(Icons.search_rounded),
                suffixIcon: _q.isEmpty
                    ? null
                    : IconButton(
                        icon: const Icon(Icons.close_rounded),
                        onPressed: () {
                          _ctrl.clear();
                          setState(() {
                            _q = '';
                            _future = null;
                          });
                        },
                      ),
              ),
            ),
            const SizedBox(height: 14),
            Expanded(
              child: _q.isEmpty
                  ? Center(
                      child: Text(
                        t.searchStartTyping,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurface.withOpacity(0.65),
                        ),
                      ),
                    )
                  : FutureBuilder<List<HerbProduct>>(
                      future: _future,
                      builder: (context, snap) {
                        if (snap.connectionState == ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        if (snap.hasError) {
                          return Center(
                            child: Text(
                              '${t.somethingWentWrong}: ${snap.error}',
                            ),
                          );
                        }

                        final items = snap.data ?? const [];

                        if (items.isEmpty) {
                          return Center(
                            child: Text(
                              t.searchNoResults,
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.w700,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onSurface.withOpacity(0.65),
                                  ),
                            ),
                          );
                        }

                        return ListView.separated(
                          itemCount: items.length,
                          separatorBuilder: (_, __) => const Divider(height: 1),
                          itemBuilder: (_, i) {
                            final p = items[i];
                            final title = _pickTitle(context, p);
                            final sub = _pickSub(context, p);

                            return ListTile(
                              leading: const CircleAvatar(
                                child: Icon(Icons.local_florist),
                              ),
                              title: HighlightText(text: title, query: _q),
                              subtitle: sub.isEmpty
                                  ? null
                                  : HighlightText(
                                      text: sub,
                                      query: _q,
                                      maxLines: 2,
                                      style: Theme.of(
                                        context,
                                      ).textTheme.bodySmall,
                                    ),
                              onTap: () => _openProduct(p),
                            );
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  String _pickTitle(BuildContext context, HerbProduct p) {
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    final s = isAr ? p.nameAr.trim() : p.nameEn.trim();
    return s.isEmpty ? p.nameAr.trim() : s;
  }

  String _pickSub(BuildContext context, HerbProduct p) {
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    return isAr ? p.shortDescAr.trim() : p.shortDescEn.trim();
  }
}

/// =========================
/// ✅ Highlight Widget
/// =========================
class HighlightText extends StatelessWidget {
  const HighlightText({
    super.key,
    required this.text,
    required this.query,
    this.maxLines = 1,
    this.style,
  });

  final String text;
  final String query;
  final int maxLines;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    final baseStyle = style ?? Theme.of(context).textTheme.bodyMedium;

    final q = query.trim();
    if (q.isEmpty) {
      return Text(
        text,
        maxLines: maxLines,
        overflow: TextOverflow.ellipsis,
        style: baseStyle,
      );
    }

    final words = q
        .split(RegExp(r'\s+'))
        .where((e) => e.trim().isNotEmpty)
        .toList();
    words.sort((a, b) => b.length.compareTo(a.length));
    final key = words.first;

    final lower = text.toLowerCase();
    final keyLower = key.toLowerCase();

    final idx = lower.indexOf(keyLower);
    if (idx < 0) {
      return Text(
        text,
        maxLines: maxLines,
        overflow: TextOverflow.ellipsis,
        style: baseStyle,
      );
    }

    final before = text.substring(0, idx);
    final match = text.substring(idx, idx + key.length);
    final after = text.substring(idx + key.length);

    final highlightStyle = baseStyle?.copyWith(
      fontWeight: FontWeight.w900,
      backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.15),
    );

    return RichText(
      maxLines: maxLines,
      overflow: TextOverflow.ellipsis,
      text: TextSpan(
        children: [
          TextSpan(text: before, style: baseStyle),
          TextSpan(text: match, style: highlightStyle),
          TextSpan(text: after, style: baseStyle),
        ],
      ),
    );
  }
}

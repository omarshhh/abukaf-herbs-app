import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mobile/l10n/app_localizations.dart';

class SearchResultsSheet extends StatelessWidget {
  const SearchResultsSheet({super.key, required this.queryListenable});

  final ValueListenable<String> queryListenable;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 42,
              height: 5,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(999),
                color: Theme.of(context).dividerColor,
              ),
            ),
            const SizedBox(height: 10),
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: Text(
                t.searchResultsTitle, 
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900),
              ),
            ),
            const SizedBox(height: 10),

            Flexible(
              child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: FirebaseFirestore.instance
                    .collection('products')
                    .where('isActive', isEqualTo: true)
                    .orderBy('createdAt', descending: true)
                    .limit(200)
                    .snapshots(),
                builder: (context, snap) {
                  if (snap.hasError) {
                    return Center(child: Text('Error: ${snap.error}'));
                  }
                  if (!snap.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final docs = snap.data!.docs;

                  return ValueListenableBuilder<String>(
                    valueListenable: queryListenable,
                    builder: (context, q, _) {
                      final query = q.trim().toLowerCase();

                      final filtered = query.isEmpty
                          ? docs.take(20).toList()
                          : docs
                                .where((d) {
                                  final m = d.data();
                                  final nameAr =
                                      (m['nameAr'] ?? m['name'] ?? '')
                                          .toString();
                                  final nameEn = (m['nameEn'] ?? '').toString();
                                  final x = '$nameAr $nameEn'.toLowerCase();
                                  return x.contains(query);
                                })
                                .take(30)
                                .toList();

                      if (filtered.isEmpty) {
                        return Center(child: Text(t.noResults));
                      }

                      return ListView.separated(
                        shrinkWrap: true,
                        itemCount: filtered.length,
                        separatorBuilder: (_, __) => const Divider(height: 1),
                        itemBuilder: (context, i) {
                          final m = filtered[i].data();
                          final title = (m['nameAr'] ?? m['name'] ?? '')
                              .toString();
                          final subtitle = (m['nameEn'] ?? '').toString();

                          return ListTile(
                            leading: const CircleAvatar(
                              child: Icon(Icons.local_florist),
                            ),
                            title: Text(
                              title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            subtitle: subtitle.trim().isEmpty
                                ? null
                                : Text(
                                    subtitle,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                            onTap: () {
                              Navigator.pop(context);
                            },
                          );
                        },
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
}

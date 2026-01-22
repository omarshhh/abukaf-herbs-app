import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mobile/l10n/app_localizations.dart';

class ForYouStrip extends StatefulWidget {
  const ForYouStrip({super.key, this.onTap});

  final VoidCallback? onTap;

  @override
  State<ForYouStrip> createState() => _ForYouStripState();
}

class _ForYouStripState extends State<ForYouStrip> {
  final _pc = PageController(viewportFraction: 0.92);
  Timer? _timer;
  int _i = 0;

  // Placeholder cards (لاحقاً نستبدلها بمنتجات Our Picks من Firestore)
  static const _items = [
    ('Honey Combo', 'خصم على باكج العسل اليوم'),
    ('Black Seed Oil', 'منتج مقترح لصحة المناعة'),
    ('Chamomile', 'مقترح لراحة النوم'),
  ];

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (!mounted) return;
      _i = (_i + 1) % _items.length;
      _pc.animateToPage(
        _i,
        duration: const Duration(milliseconds: 450),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          t.forYouTitle, // أضفها في arb
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 130,
          child: PageView.builder(
            controller: _pc,
            itemCount: _items.length,
            itemBuilder: (context, i) {
              final item = _items[i];
              return Padding(
                padding: const EdgeInsetsDirectional.only(end: 12),
                child: InkWell(
                  borderRadius: BorderRadius.circular(18),
                  onTap: widget.onTap,
                  child: Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Row(
                        children: [
                          Container(
                            width: 64,
                            height: 64,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              color: Theme.of(
                                context,
                              ).colorScheme.primary.withOpacity(0.12),
                            ),
                            child: const Icon(Icons.local_florist),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.$1,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context).textTheme.titleSmall
                                      ?.copyWith(fontWeight: FontWeight.w900),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  item.$2,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context).textTheme.bodyMedium
                                      ?.copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface
                                            .withOpacity(0.75),
                                        fontWeight: FontWeight.w700,
                                      ),
                                ),
                              ],
                            ),
                          ),
                          const Icon(Icons.chevron_right),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:mobile/l10n/app_localizations.dart';

import 'for_you_strip.dart';

class HomeHeaderSliver extends StatelessWidget {
  const HomeHeaderSliver({super.key, required this.firstName});

  final String firstName;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return SliverPadding(
      padding: const EdgeInsets.all(16),
      sliver: SliverToBoxAdapter(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (child, anim) {
                final offset = Tween<Offset>(
                  begin: const Offset(0, 0.20),
                  end: Offset.zero,
                ).animate(anim);

                return FadeTransition(
                  opacity: anim,
                  child: SlideTransition(position: offset, child: child),
                );
              },
              child: Align(
                key: ValueKey(firstName),
                alignment: AlignmentDirectional.centerStart,
                child: Text(
                  t.helloUser(firstName),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            ForYouStrip(
              onTap: () {
                // لاحقاً: فتح صفحة المنتج
              },
            ),
            const SizedBox(height: 14),
          ],
        ),
      ),
    );
  }
}

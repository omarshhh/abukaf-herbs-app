import 'package:flutter/material.dart';
import 'package:mobile/l10n/app_localizations.dart';

class HomeSliverAppBar extends StatelessWidget {
  const HomeSliverAppBar({super.key, required this.onSearchPressed});

  final VoidCallback onSearchPressed;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return SliverAppBar(
      floating: true,
      snap: true,
      pinned: false,

      toolbarHeight: 48,

      elevation: 0,
      scrolledUnderElevation: 0,
      backgroundColor: cs.surface,
      surfaceTintColor: Colors.transparent,

      titleSpacing: 12,

      iconTheme: IconThemeData(color: cs.onSurface),
      actionsIconTheme: IconThemeData(color: cs.onSurface),

      title: Text(
        t.navHome,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: theme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w900,
          height: 1.0, 
        ),
      ),

      actions: [
        Padding(
          padding: const EdgeInsetsDirectional.only(end: 6),
          child: IconButton(
            onPressed: onSearchPressed,
            tooltip: t.searchHint,

            padding: EdgeInsets.zero,
            visualDensity: VisualDensity.compact,
            constraints: const BoxConstraints.tightFor(width: 40, height: 40),

            icon: const Icon(Icons.search_rounded, size: 22),
          ),
        ),
      ],
    );
  }
}

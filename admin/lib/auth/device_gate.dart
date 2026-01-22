import 'package:admin/home/design_home.dart';
import 'package:flutter/material.dart';

class DeviceGate extends StatelessWidget {
  const DeviceGate({super.key});

  static const double _minWidthForAdmin = 900; 

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, c) {
        final w = c.maxWidth;

        if (w < _minWidthForAdmin) {
          return Directionality(
            textDirection: TextDirection.rtl,
            child: Scaffold(
              body: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 520),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                        side: BorderSide(
                          color: Theme.of(
                            context,
                          ).colorScheme.outlineVariant.withOpacity(0.6),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(18),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.desktop_windows_rounded,
                              size: 56,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'لوحة الإدارة تعمل على الكمبيوتر فقط',
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.titleLarge
                                  ?.copyWith(fontWeight: FontWeight.w900),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'لإضافة المنتجات وإدارة الطلبات بشكل صحيح، افتح لوحة الإدارة من جهاز كمبيوتر أو تابلت بشاشة واسعة.',
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(
                                    height: 1.5,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onSurface.withOpacity(0.75),
                                    fontWeight: FontWeight.w700,
                                  ),
                            ),
                            const SizedBox(height: 14),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 10,
                              ),
                              decoration: BoxDecoration(
                                color: Theme.of(context)
                                    .colorScheme
                                    .surfaceContainerHighest
                                    .withOpacity(0.55),
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.outlineVariant.withOpacity(0.6),
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.info_outline_rounded,
                                    size: 18,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'عرض الشاشة الحالي: ${w.toStringAsFixed(0)}px',
                                    style: Theme.of(context).textTheme.bodySmall
                                        ?.copyWith(fontWeight: FontWeight.w800),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        }

        return const DesignHome();
      },
    );
  }
}

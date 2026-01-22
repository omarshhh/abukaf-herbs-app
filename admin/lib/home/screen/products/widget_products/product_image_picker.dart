import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class PickedImage {
  final Uint8List bytes;
  final String fileName;
  PickedImage({required this.bytes, required this.fileName});
}

class ProductImagePicker extends StatelessWidget {
  const ProductImagePicker({
    super.key,
    required this.valueBytes,
    required this.valueFileName,
    required this.onChanged,
  });

  final Uint8List? valueBytes;
  final String? valueFileName;
  final ValueChanged<PickedImage?> onChanged;

  Future<void> _pick(BuildContext context) async {
    final res = await FilePicker.platform.pickFiles(
      type: FileType.image,
      withData: true,
    );
    if (res == null || res.files.isEmpty) return;

    final f = res.files.first;
    final bytes = f.bytes;
    if (bytes == null) return;

    onChanged(PickedImage(bytes: bytes, fileName: f.name));
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          height: 160,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: cs.outlineVariant.withOpacity(0.8)),
            color: cs.primary.withOpacity(0.05),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: valueBytes != null
                ? Image.memory(valueBytes!, fit: BoxFit.cover)
                : Center(
                    child: Icon(
                      Icons.image_outlined,
                      size: 44,
                      color: cs.primary.withOpacity(0.6),
                    ),
                  ),
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: Text(
                valueFileName == null || valueFileName!.isEmpty
                    ? 'No image selected'
                    : valueFileName!,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: cs.onSurface.withOpacity(0.75),
                ),
              ),
            ),
            const SizedBox(width: 10),
            OutlinedButton.icon(
              onPressed: () => _pick(context),
              icon: const Icon(Icons.upload_file),
              label: const Text('Choose'),
            ),
            const SizedBox(width: 8),
            IconButton(
              tooltip: 'Remove',
              onPressed: () => onChanged(null),
              icon: const Icon(Icons.close),
            ),
          ],
        ),
      ],
    );
  }
}

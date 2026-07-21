import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';
import 'package:atlas_paragliding_v2/features/operator/domain/operator_application_draft.dart';


class IdDocumentCaptureScreen extends StatefulWidget {
  final OperatorApplicationDraft draft;
  const IdDocumentCaptureScreen({super.key, required this.draft});

  @override
  State<IdDocumentCaptureScreen> createState() => _IdDocumentCaptureScreenState();
}

class _IdDocumentCaptureScreenState extends State<IdDocumentCaptureScreen> {
  File? _frontImage;
  File? _backImage;
  bool _busy = false;
  bool get _needsBack => widget.draft.idType == 'cin';

  Future<File?> _pickAndCompress(ImageSource source) async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: source, imageQuality: 90);
    if (picked == null) {
      return null;
    }
    final tempDir = await getTemporaryDirectory();
    final targetPath = '${tempDir.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';

    final compressed = await FlutterImageCompress.compressAndGetFile(
      picked.path,
      targetPath,
      quality: 70,
      minWidth: 1600,  
    );

    return compressed == null ? File(picked.path) : File(compressed.path);
  }

  Future<void> _capture({required bool isFront}) async {
    final source = await showModalBottomSheet<ImageSource>(
      context: context, 
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Take a photo'),
              onTap: () => Navigator.pop(context, ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Choose from gallery'),
              onTap: () => Navigator.pop(context, ImageSource.gallery),
            ),
          ],
        )
      )
    );
    if (source == null) return;
    setState(() => _busy =true);
    final file = await _pickAndCompress(source);
    setState(() {
      _busy = false;
      if (isFront) {
        _frontImage = file;
      } else {
        _backImage = file;
      }
    });
  }

  void _finish() {
    final ready = _frontImage != null && (!_needsBack || _backImage != null);
    if (!ready) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please capture all required sides')),
      );
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Captured — upload wiring comes next.')),
    );
  }

  Widget _slot({required String label, required File? image, required VoidCallback onTap}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(label, style: Theme.of(context).textTheme.labelLarge),
        const SizedBox(height: 8),
        AspectRatio(
          aspectRatio: 1.6,
          child: InkWell(
            onTap: onTap,
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Theme.of(context).colorScheme.outline),
                borderRadius: BorderRadius.circular(12),
              ),
              child: image == null
                  ? const Center(child: Icon(Icons.add_a_photo_outlined, size: 32))
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.file(image, fit: BoxFit.cover),
                    ),
            ),
            
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.draft.idType == 'cin' ? 'Scan your CIN' : 'Scan your passport';
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _slot(label: 'Front', image: _frontImage, onTap: _busy ? () {} : () => _capture(isFront: true)),
              if (_needsBack) ...[
                const SizedBox(height: 24),
                _slot(
                  label: 'Back',
                  image: _backImage,
                  onTap: _busy ? () {} : () => _capture(isFront: false),
                ),
              ],
              const SizedBox(height: 32),
              FilledButton(
                onPressed: _busy ? null : _finish,
                child: _busy
                    ? const SizedBox(
                        height: 20, width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Continue'),
              )
            ],
          )
          )
        ),
    );
  }
}
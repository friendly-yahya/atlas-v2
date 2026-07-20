import 'package:flutter/material.dart';
import 'package:atlas_paragliding_v2/l10n/generated/app_localizations.dart';
class BecomeOperatorScreen extends StatefulWidget {
  const BecomeOperatorScreen({super.key});

  @override
  State<BecomeOperatorScreen> createState() => _BecomeOperatorScreenState();
}

class _BecomeOperatorScreenState extends State<BecomeOperatorScreen> {
  
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _countryController = TextEditingController(text: 'Morocco');
  DateTime? _dateOfBirth;
  String _idType = 'cin';
  @override
  void dispose() {
    _nameController.dispose();
    _countryController.dispose();
    super.dispose();
  }

  Future<void> _pickDateOfBirth() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context, 
      initialDate: DateTime(now.year - 25, now.month, now.day),
      firstDate: DateTime(now.year - 100), 
      lastDate: DateTime(now.year - 18, now.month, now.day)
    );
    //is there a better way but ehh  doesn't matter that much
    if (picked != null) {
      setState(() => _dateOfBirth = picked);
    }
  }

  void _continue() {
    if (!_formKey.currentState!.validate()) return;
    if (_dateOfBirth == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select your date of birth'))
      );
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$_idType selected. Next: ID scan (coming soon).'))
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Become an Operator'),),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Tell us who you are',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                Text('LOCALE TEST: ${AppLocalizations.of(context)!.appTitle}'),
                const SizedBox(height: 8),
                Text(
                  "This must match your government ID exactly — it's checked during verification.",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText:  'Full legal name',
                    helperText: 'As it appears on your ID',
                  ),
                  validator: (value) => (value == null || value.trim().isEmpty) ? 'Full legal name is required' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _countryController,
                  decoration: const InputDecoration(labelText: 'Country'),
                  validator: (value) => (value == null || value.trim().isEmpty)
                      ? 'Country is required'
                      : null,
                ),
                const SizedBox(height: 16),
                InkWell(
                  onTap: _pickDateOfBirth,
                  child: InputDecorator(
                    decoration: const InputDecoration(labelText: 'Date of birth'),
                    child: Text(
                      _dateOfBirth == null ? 'Tap to select' : '${_dateOfBirth!.day}/${_dateOfBirth!.month}/${_dateOfBirth!.year}',
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Text('ID type', style: Theme.of(context).textTheme.labelLarge),
                const SizedBox(height: 8),
                SegmentedButton<String>(
                  segments: const [
                    ButtonSegment(value: 'cin', label: Text('National ID (CIN)')),
                    ButtonSegment(value: 'passport', label: Text('Passport')),
                  ],
                  selected: {_idType},
                  onSelectionChanged: (selection) {
                    setState(() => _idType = selection.first);
                  },
                ),
                const SizedBox(height: 32),
                FilledButton(
                  onPressed: _continue,
                  child: const Text('Continue'),
                ),
              ],
            )
          ),
        )
      ),
    );
  }
}

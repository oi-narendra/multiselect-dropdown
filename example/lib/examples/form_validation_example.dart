import 'package:flutter/material.dart';
import 'package:multi_dropdown/multi_dropdown.dart';

/// Demonstrates [MultiDropdown] within a [Form] with validation,
/// `maxSelections` limit, and a submit flow.
class FormValidationExample extends StatefulWidget {
  const FormValidationExample({super.key});

  @override
  State<FormValidationExample> createState() => _FormValidationExampleState();
}

class _FormValidationExampleState extends State<FormValidationExample> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  bool _submitted = false;
  List<String> _selectedSkills = [];

  final _skillItems = [
    DropdownItem(label: 'Dart', value: 'dart'),
    DropdownItem(label: 'Flutter', value: 'flutter'),
    DropdownItem(label: 'Firebase', value: 'firebase'),
    DropdownItem(label: 'GraphQL', value: 'graphql'),
    DropdownItem(label: 'REST APIs', value: 'rest'),
    DropdownItem(label: 'State Management', value: 'state'),
    DropdownItem(label: 'CI/CD', value: 'cicd'),
    DropdownItem(label: 'Testing', value: 'testing'),
    DropdownItem(label: 'UI/UX Design', value: 'uiux'),
  ];

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Form Validation'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.green.withAlpha(40),
                  Colors.teal.withAlpha(30),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                const Icon(Icons.verified_outlined, color: Colors.green),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Embed MultiDropdown in a Form with validation. '
                    'Max 4 skills allowed. Submit to see the results.',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurface,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),

          Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Name field
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Full Name',
                    hintText: 'Enter your name',
                    prefixIcon: const Icon(Icons.person_outline),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(
                        color: Colors.green.shade400,
                        width: 2,
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Name is required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Skills dropdown with validation
                MultiDropdown<String>(
                  items: _skillItems,
                  maxSelections: 4,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  chipDecoration: ChipDecoration(
                    backgroundColor: Colors.green.shade50,
                    labelStyle: TextStyle(
                      color: Colors.green.shade800,
                      fontSize: 13,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    deleteIcon: Icon(
                      Icons.close_rounded,
                      size: 14,
                      color: Colors.green.shade400,
                    ),
                    wrap: true,
                    spacing: 8,
                    runSpacing: 8,
                  ),
                  fieldDecoration: FieldDecoration(
                    labelText: 'Skills (max 4)',
                    hintText: 'Select your skills',
                    prefixIcon: Icon(
                      Icons.psychology_outlined,
                      color: Colors.green.shade400,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(color: colorScheme.outline),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(
                        color: Colors.green.shade400,
                        width: 2,
                      ),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(
                        color: colorScheme.error,
                        width: 1.5,
                      ),
                    ),
                  ),
                  dropdownDecoration: DropdownDecoration(
                    backgroundColor: colorScheme.surfaceContainerLow,
                    maxHeight: 300,
                    header: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                      child: Text(
                        'Choose up to 4 skills',
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  validator: (items) {
                    if (items == null || items.isEmpty) {
                      return 'Please select at least one skill';
                    }
                    if (items.length > 4) {
                      return 'Maximum 4 skills allowed';
                    }
                    return null;
                  },
                  onSelectionChange: (values) {
                    _selectedSkills = values;
                  },
                ),
                const SizedBox(height: 28),

                // Submit button
                FilledButton.icon(
                  onPressed: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      setState(() => _submitted = true);
                    }
                  },
                  icon: const Icon(Icons.send_rounded, size: 18),
                  label: const Text('Submit'),
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.green.shade600,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Result card
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: _submitted
                ? Card(
                    key: const ValueKey('result'),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(color: Colors.green.shade200),
                    ),
                    color: Colors.green.shade50.withAlpha(80),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.check_circle,
                                color: Colors.green.shade600,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Form Submitted!',
                                style: theme.textTheme.titleMedium?.copyWith(
                                  color: Colors.green.shade700,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          _ResultRow(
                            label: 'Name',
                            value: _nameController.text,
                          ),
                          const SizedBox(height: 8),
                          _ResultRow(
                            label: 'Skills',
                            value: _selectedSkills.join(', '),
                          ),
                        ],
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}

class _ResultRow extends StatelessWidget {
  const _ResultRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 60,
          child: Text(
            label,
            style: TextStyle(
              color: Colors.green.shade600,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontSize: 13),
          ),
        ),
      ],
    );
  }
}

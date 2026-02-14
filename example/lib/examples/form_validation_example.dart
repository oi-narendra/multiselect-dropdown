import 'package:flutter/material.dart';
import 'package:multi_dropdown/multi_dropdown.dart';

/// Job application form with validation, max selections, and submit flow.
///
/// Demonstrates [MultiDropdown] within a [Form] with validation,
/// `maxSelections` limit, single-select for job title, and a submit flow.
class FormValidationExample extends StatefulWidget {
  const FormValidationExample({super.key});

  @override
  State<FormValidationExample> createState() => _FormValidationExampleState();
}

class _FormValidationExampleState extends State<FormValidationExample> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  bool _submitted = false;
  String? _selectedRole;
  List<String> _selectedSkills = [];

  final _roleItems = [
    DropdownItem(label: 'Software Engineer', value: 'swe'),
    DropdownItem(label: 'Product Manager', value: 'pm'),
    DropdownItem(label: 'UX Designer', value: 'ux'),
    DropdownItem(label: 'Data Scientist', value: 'ds'),
    DropdownItem(label: 'DevOps Engineer', value: 'devops'),
    DropdownItem(label: 'QA Engineer', value: 'qa'),
    DropdownItem(label: 'Tech Lead', value: 'lead'),
  ];

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
    DropdownItem(label: 'Cloud Services', value: 'cloud'),
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Job Application'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.blue.withAlpha(40),
                  Colors.indigo.withAlpha(30),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                const Icon(Icons.work_outline_rounded, color: Colors.indigo),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Fill in your application. Select a role and '
                    'up to 5 skills. All fields are validated on submit.',
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
                  textInputAction: TextInputAction.next,
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
                        color: Colors.indigo.shade400,
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

                // Email field
                TextFormField(
                  controller: _emailController,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    hintText: 'you@example.com',
                    prefixIcon: const Icon(Icons.email_outlined),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(
                        color: Colors.indigo.shade400,
                        width: 2,
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Email is required';
                    }
                    if (!value.contains('@')) {
                      return 'Enter a valid email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Role dropdown (single-select)
                MultiDropdown<String>(
                  items: _roleItems,
                  singleSelect: true,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  fieldDecoration: FieldDecoration(
                    labelText: 'Desired Role',
                    hintText: 'Select a role',
                    prefixIcon: Icon(
                      Icons.badge_outlined,
                      color: Colors.indigo.shade400,
                    ),
                    showClearIcon: false,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(color: colorScheme.outline),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(
                        color: Colors.indigo.shade400,
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
                    suffixIcon: const Icon(Icons.keyboard_arrow_down_rounded),
                  ),
                  dropdownDecoration: DropdownDecoration(
                    backgroundColor: colorScheme.surfaceContainerLow,
                    maxHeight: 300,
                  ),
                  validator: (items) {
                    if (items == null || items.isEmpty) {
                      return 'Please select a role';
                    }
                    return null;
                  },
                  onSelectionChange: (values) {
                    _selectedRole = values.firstOrNull;
                  },
                ),
                const SizedBox(height: 20),

                // Skills dropdown (multi-select with max)
                MultiDropdown<String>(
                  items: _skillItems,
                  maxSelections: 5,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  chipDecoration: ChipDecoration(
                    backgroundColor: Colors.indigo.shade50,
                    labelStyle: TextStyle(
                      color: Colors.indigo.shade800,
                      fontSize: 13,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    deleteIcon: Icon(
                      Icons.close_rounded,
                      size: 14,
                      color: Colors.indigo.shade400,
                    ),
                    wrap: true,
                    spacing: 8,
                    runSpacing: 8,
                  ),
                  fieldDecoration: FieldDecoration(
                    labelText: 'Skills (max 5)',
                    hintText: 'Select your skills',
                    prefixIcon: Icon(
                      Icons.psychology_outlined,
                      color: Colors.indigo.shade400,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(color: colorScheme.outline),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(
                        color: Colors.indigo.shade400,
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
                        'Choose up to 5 skills',
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
                    if (items.length > 5) {
                      return 'Maximum 5 skills allowed';
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
                  label: const Text('Submit Application'),
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.indigo.shade600,
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
                                'Application Submitted!',
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
                            label: 'Email',
                            value: _emailController.text,
                          ),
                          const SizedBox(height: 8),
                          _ResultRow(
                            label: 'Role',
                            value: _selectedRole != null
                                ? _roleItems
                                    .firstWhere(
                                      (i) => i.value == _selectedRole,
                                    )
                                    .label
                                : '—',
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

import 'package:example/main.dart';
import 'package:flutter/material.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';

class UsageWithForm extends StatefulWidget {
  const UsageWithForm({super.key});

  @override
  State<UsageWithForm> createState() => _UsageWithFormState();
}

class _UsageWithFormState extends State<UsageWithForm> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Multidropdown Usage with Form'),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            FormField<List<User>>(
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please select at least one option';
                }
                return null;
              },
              builder: (field) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MultiSelectDropDown<User>(
                      onOptionSelected: (options) {
                        field.didChange(options.map((e) => e.value!).toList());
                      },
                      options: <ValueItem<User>>[
                        ValueItem(
                            label: 'Option 1',
                            value: User(name: 'User 1', id: 1)),
                        ValueItem(
                            label: 'Option 2',
                            value: User(name: 'User 2', id: 2)),
                        ValueItem(
                            label: 'Option 3',
                            value: User(name: 'User 3', id: 3)),
                        ValueItem(
                            label: 'Option 4',
                            value: User(name: 'User 4', id: 4)),
                        ValueItem(
                            label: 'Option 5',
                            value: User(name: 'User 5', id: 5)),
                      ],
                    ),
                    if (field.errorText != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8, left: 8),
                        child: Text(
                          field.errorText!,
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 12,
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
            const SizedBox(
              height: 16,
            ),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Form is valid'),
                    ),
                  );
                }
              },
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}

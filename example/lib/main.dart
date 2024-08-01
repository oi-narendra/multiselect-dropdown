import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:multi_dropdown/multi_dropdown.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Multiselect dropdown demo',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      routerConfig: GoRouter(routes: [
        GoRoute(
          path: '/',
          builder: (context, state) {
            return const MyHomePage();
          },
        ),
      ]),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();

  static const _headerStyle = TextStyle(
    fontSize: 12,
    color: Colors.blue,
  );
}

class User {
  final String name;
  final int id;

  User({required this.name, required this.id});

  @override
  String toString() {
    return 'User(name: $name, id: $id)';
  }
}

class _MyHomePageState extends State<MyHomePage> {
  final _formKey = GlobalKey<FormState>();

  final controller = MultiSelectController<User>();

  @override
  Widget build(BuildContext context) {
    var items = [
      DropdownItem(
        label: 'Nepal',
        value: User(name: 'Nepal', id: 1),
      ),
      DropdownItem(
        label: 'Australia',
        value: User(name: 'Australia', id: 6),
      ),
      DropdownItem(
        label: 'India',
        value: User(name: 'India', id: 2),
      ),
      DropdownItem(
        label: 'China',
        value: User(name: 'China', id: 3),
      ),
      DropdownItem(
        label: 'USA',
        value: User(name: 'USA', id: 4),
      ),
      DropdownItem(
        label: 'UK',
        value: User(name: 'UK', id: 5),
      ),
    ];
    return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: SizedBox(
                width: double.infinity,
                height: MediaQuery.of(context).size.height,
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      const Text('WRAP', style: MyHomePage._headerStyle),
                      const SizedBox(
                        height: 4,
                      ),
                      MultiDropdown<User>(
                        items: items,
                        controller: controller,
                        enabled: true,
                        searchEnabled: false,
                        chipDecoration: ChipDecoration(
                            backgroundColor: Colors.grey.shade300, wrap: false),
                        fieldDecoration: FieldDecoration(
                          hintText: 'Select a country',
                          prefixIcon: const Icon(CupertinoIcons.flag),
                          suffixIcon: const Icon(Icons.read_more),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: Colors.grey.shade400,
                            ),
                          ),
                        ),
                        dropdownDecoration: const DropdownDecoration(
                          marginTop: 2,
                        ),
                        dropdownItemDecoration: const DropdownItemDecoration(
                          selectedIcon: Icon(Icons.check_box),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select a country';
                          }
                          return null;
                        },
                        onSelectionChange: (selectedItems) {
                          debugPrint("OnSelectionChange: $selectedItems");
                        },
                      ),
                      const SizedBox(height: 16),
                      ButtonBar(
                        buttonAlignedDropdown: true,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState?.validate() ?? false) {
                                final selectedItems = controller.selectedItems;
                
                                debugPrint(selectedItems.toString());
                              }
                            },
                            child: const Text('Submit'),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              controller.selectAll();
                            },
                            child: const Text('Select All'),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              controller.clearAll();
                            },
                            child: const Text('Deselect All'),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ));
  }
}

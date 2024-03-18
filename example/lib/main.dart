import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.green,
      ),
      home: const MyHomePage(),
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
  final MultiSelectController<User> _controller =
      MultiSelectController(options: [
    ValueItem(label: 'Option 1', value: User(name: 'User 1', id: 1)),
    ValueItem(label: 'Option 2', value: User(name: 'User 2', id: 2)),
    ValueItem(label: 'Option 3', value: User(name: 'User 3', id: 3)),
    ValueItem(label: 'Option 4', value: User(name: 'User 4', id: 4)),
    ValueItem(label: 'Option 5', value: User(name: 'User 5', id: 5)),
  ]);

  final List<ValueItem> _selectedOptions = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey.shade300,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('WRAP', style: MyHomePage._headerStyle),
                  const SizedBox(
                    height: 4,
                  ),
                  MultiSelectDropDown<User>(
                    controller: _controller,
                    clearIcon: const Icon(Icons.reddit),
                    maxItems: 4,
                    singleSelectItemStyle: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                    chipConfig: const ChipConfig(
                        wrapType: WrapType.wrap, backgroundColor: Colors.red),
                    optionTextStyle: const TextStyle(fontSize: 16),
                    selectedOptionIcon: const Icon(
                      Icons.check_circle,
                      color: Colors.pink,
                    ),
                    searchEnabled: true,
                    dropdownBorderRadius: 10,
                    dropdownBackgroundColor: Colors.white,
                    selectedOptionBackgroundColor: Colors.orange,
                    selectedOptionTextColor: Colors.blue,
                    dropdownMargin: 2,
                    onChanged: (options) {
                      debugPrint(options.toString());
                    },
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  Wrap(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          _controller.clearAllSelection();
                          setState(() {
                            _selectedOptions.clear();
                          });
                        },
                        child: const Text('CLEAR'),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _selectedOptions.clear();
                            _selectedOptions
                                .addAll(_controller.selectedOptions);
                          });
                        },
                        child: const Text('Get Selected Options'),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          if (_controller.isDropdownOpen) {
                            _controller.hideDropdown();
                          } else {
                            _controller.showDropdown();
                          }
                        },
                        child: const Text('SHOW/HIDE DROPDOWN'),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Text(
                    'Selected Options: $_selectedOptions',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  const Text('SCROLL', style: MyHomePage._headerStyle),
                  const SizedBox(
                    height: 4,
                  ),
                  MultiSelectDropDown(
                    onOptionSelected: (options) {
                      debugPrint(options.toString());
                    },
                    options: const <ValueItem>[
                      ValueItem(label: 'Option 1', value: '1'),
                      ValueItem(label: 'Option 2', value: '2'),
                      ValueItem(label: 'Option 3', value: '3'),
                      ValueItem(label: 'Option 4', value: '4'),
                      ValueItem(label: 'Option 5', value: '5'),
                      ValueItem(label: 'Option 6', value: '6'),
                    ],
                    selectionType: SelectionType.multi,
                    chipConfig: const ChipConfig(wrapType: WrapType.scroll),
                    dropdownHeight: 400,
                    optionTextStyle: const TextStyle(fontSize: 16),
                    selectedOptionIcon: const Icon(Icons.check_circle),
                    onOptionRemoved: (index, option) {
                      debugPrint(option.toString());
                    },
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  const Text('FROM NETWORK', style: MyHomePage._headerStyle),
                  const SizedBox(
                    height: 4,
                  ),
                  MultiSelectDropDown.async(
                    dropdownHeight: 300,
                    onOptionSelected: (options) {
                      debugPrint(options.toString());
                    },
                    searchEnabled: true,
                    asyncOptions: (search) async {
                      var response = await get(
                        Uri.parse('https://jsonplaceholder.typicode.com/users'),
                        headers: {
                          'Content-Type': 'application/json',
                        },
                      );
                      return (jsonDecode(response.body) as List<dynamic>)
                          .map((e) {
                            final item = e as Map<String, dynamic>;
                            return ValueItem(
                              label: item['name'],
                              value: item['id'].toString(),
                            );
                          })
                          .where((element) => element.label
                              .toLowerCase()
                              .contains(search.toLowerCase()))
                          .toList();
                    },
                    chipConfig: const ChipConfig(wrapType: WrapType.wrap),
                    responseErrorBuilder: ((context, body) {
                      return const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text('Error fetching the data'),
                      );
                    }),
                    onOptionRemoved: (index, option) {
                      debugPrint(option.toString());
                    },
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _controller.clearAllSelection();
                    },
                    child: const Text('CLEAR'),
                  ),
                  const SizedBox(height: 400)
                ],
              ),
            ),
          ),
        ));
  }
}

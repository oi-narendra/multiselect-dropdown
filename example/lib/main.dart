import 'package:flutter/material.dart';
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

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('WRAP', style: _headerStyle),
            const SizedBox(
              height: 4,
            ),
            MultiSelectDropDown(
              onOptionSelected: (List<ValueItem> selectedOptions) {},
              options: const <ValueItem>[
                ValueItem(label: 'Option 1', value: '1'),
                ValueItem(label: 'Option 2', value: '2'),
                ValueItem(label: 'Option 3', value: '3'),
                ValueItem(label: 'Option 4', value: '4'),
                ValueItem(label: 'Option 5', value: '5'),
                ValueItem(label: 'Option 6', value: '6'),
              ],
              selectionType: SelectionType.multi,
              chipConfig: const ChipConfig(wrapType: WrapType.wrap),
              dropdownHeight: 300,
              optionTextStyle: const TextStyle(fontSize: 16),
              selectedOptionIcon: const Icon(Icons.check_circle),
            ),
            const SizedBox(
              height: 50,
            ),
            const Text('SCROLL', style: _headerStyle),
            const SizedBox(
              height: 4,
            ),
            MultiSelectDropDown(
              onOptionSelected: (List<ValueItem> selectedOptions) {},
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
              dropdownHeight: 300,
              optionTextStyle: const TextStyle(fontSize: 16),
              selectedOptionIcon: const Icon(Icons.check_circle),
            ),
            const SizedBox(
              height: 50,
            ),
            const Text('FROM NETWORK', style: _headerStyle),
            const SizedBox(
              height: 4,
            ),
            MultiSelectDropDown.network(
              onOptionSelected: (options) {},
              networkConfig: NetworkConfig(
                url: 'https://jsonplaceholder.typicode.com/user',
                method: RequestMethod.get,
                headers: {
                  'Content-Type': 'application/json',
                },
              ),
              chipConfig: const ChipConfig(wrapType: WrapType.wrap),
              responseParser: (response) {
                debugPrint('Response: $response');

                final list = (response as List<dynamic>).map((e) {
                  final item = e as Map<String, dynamic>;
                  return ValueItem(
                    label: item['name'],
                    value: item['id'].toString(),
                  );
                }).toList();

                return Future.value(list);
              },
              responseErrorBuilder: ((context, body) {
                return const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text('Error fetching the data'),
                );
              }),
            ),
          ],
        ),
      ),
    ));
  }

  static const _headerStyle = TextStyle(
    fontSize: 12,
    color: Colors.blue,
  );
}

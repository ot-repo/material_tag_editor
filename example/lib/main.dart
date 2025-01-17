import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:material_tag_editor/tag_editor.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material Tag Editor Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Material Tag Editor Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<String> _values = [];
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _textEditingController = TextEditingController();

  _onDelete(index) {
    setState(() {
      _values.removeAt(index);
    });
  }

  /// This is just an example for using `TextEditingController` to manipulate
  /// the the `TextField` just like a normal `TextField`.
  _onPressedModifyTextField() {
    final text = 'Test';
    _textEditingController.text = text;
    _textEditingController.value = _textEditingController.value.copyWith(
      text: text,
      selection: TextSelection(
        baseOffset: text.length,
        extentOffset: text.length,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? ''),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: TagEditor(
          length: _values.length,
          controller: _textEditingController,
          focusNode: _focusNode,
          delimiters: [',', ' '],
          hasAddButton: true,
          inputDecoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(width: 1.0, color: Colors.grey),
              borderRadius: BorderRadius.circular(5.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(width: 1.0, color: Colors.grey),
              borderRadius: BorderRadius.circular(5.0),
            ),
            hintText: 'Ingredient',
            contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          ),
          resetTextOnSubmitted: true,
          // This is set to grey just to illustrate the `textStyle` prop
          textStyle: const TextStyle(color: Colors.grey),
          onSubmitted: (outstandingValue) {
            setState(() {
              _values.add(outstandingValue);
            });
          },
          onTagChanged: (newValue) {
            setState(() {
              _values.add(newValue);
            });
          },
          tagBuilder: (context, index) => _Chip(
            index: index,
            label: _values[index],
            onDeleted: _onDelete,
          ),
          // InputFormatters example, this disallow \ and /
          inputFormatters: [FilteringTextInputFormatter.deny(RegExp(r'[/\\]'))],
        ),
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({
    required this.label,
    required this.onDeleted,
    required this.index,
  });

  final String label;
  final ValueChanged<int> onDeleted;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Chip(
      labelPadding: const EdgeInsets.only(left: 8.0),
      label: Text(label),
      deleteIcon: const Icon(
        Icons.close,
        size: 18,
      ),
      onDeleted: () {
        onDeleted(index);
      },
    );
  }
}

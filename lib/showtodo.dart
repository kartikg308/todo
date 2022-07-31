import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;

class ShowTodo extends StatefulWidget {
  final Map todo;
  const ShowTodo({Key? key, required this.todo}) : super(key: key);

  @override
  State<ShowTodo> createState() => _ShowTodoState();
}

class _ShowTodoState extends State<ShowTodo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.todo['title']),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('Description'),
            ),
            SizedBox(
              height: 200,
              child: quill.QuillEditor(
                controller: quill.QuillController(
                  document: quill.Document.fromJson(widget.todo['description']),
                  selection: const TextSelection.collapsed(offset: 0),
                ),
                focusNode: FocusNode(),
                scrollController: ScrollController(),
                scrollable: true,
                padding: const EdgeInsets.all(8),
                autoFocus: true,
                readOnly: true,
                expands: true,
              ),
            ),
            widget.todo['image'] != ""
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.network(widget.todo['image']),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}

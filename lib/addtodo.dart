import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:image_picker/image_picker.dart';
import 'package:todo/custom/textfield.dart';
import 'package:todo/firebase/storage.dart';

import 'firebase/database.dart';

class AddTodo extends StatefulWidget {
  const AddTodo({Key? key}) : super(key: key);

  @override
  State<AddTodo> createState() => _AddTodoState();
}

class _AddTodoState extends State<AddTodo> {
  final TextEditingController _controller = TextEditingController();
  final _quillController = quill.QuillController.basic();
  File? _image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Todo"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            CustomField(
              controller: _controller,
              title: 'Title',
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Description',
                style: TextStyle(fontSize: 20),
              ),
            ),
            quill.QuillToolbar.basic(controller: _quillController),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 300,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: quill.QuillEditor(
                  controller: _quillController,
                  focusNode: FocusNode(),
                  scrollController: ScrollController(),
                  scrollable: true,
                  padding: const EdgeInsets.all(8),
                  autoFocus: true,
                  readOnly: false,
                  expands: true,
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Image',
                style: TextStyle(fontSize: 20),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 200,
                width: 300,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black,
                    width: 1,
                  ),
                  color: Colors.white,
                ),
                child: _image == null
                    ? Center(
                        child: IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () async {
                            await ImagePicker()
                                .pickImage(
                              source: ImageSource.gallery,
                            )
                                .then((value) {
                              setState(() {
                                _image = File(value!.path);
                                Storage.uploadImage(_image!);
                              });
                            });
                          },
                        ),
                      )
                    : Image.file(
                        _image!,
                        fit: BoxFit.cover,
                      ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Database().addTodo(
                  _controller.text,
                  _quillController.document.toDelta().toJson(),
                  imageUrl,
                );
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(300, 50),
              ),
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}

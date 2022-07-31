import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:swipeable_tile/swipeable_tile.dart';
import 'package:todo/addtodo.dart';
import 'package:todo/showtodo.dart';

import 'firebase/database.dart';

class Todos extends StatefulWidget {
  const Todos({Key? key}) : super(key: key);

  @override
  State<Todos> createState() => _TodosState();
}

class _TodosState extends State<Todos> {
  List mytodos = [];

  @override
  void initState() {
    super.initState();
    Timer.periodic(const Duration(seconds: 5), (timer) {
      Database().getTodos();
      sortbyTime();
      mytodos = todos;
      setState(() {});
    });
  }

  sortbyTime() {
    todos.sort((a, b) {
      return a['createdAt'] - b['createdAt'];
    });
    return todos;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Todo's"),
        centerTitle: true,
      ),
      body: todos.isNotEmpty
          ? ListView.builder(
              itemCount: mytodos.length,
              itemBuilder: (BuildContext context, int index) {
                return SwipeableTile(
                  key: UniqueKey(),
                  backgroundBuilder: (context, direction, progress) {
                    return AnimatedBuilder(
                      animation: progress,
                      builder: (context, child) {
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 400),
                          color: progress.value > 0.4
                              ? const Color(0xFFed7474)
                              : const Color(0xFFeded98),
                        );
                      },
                    );
                  },
                  color: Colors.white,
                  onSwiped: (dir) {
                    if (dir == SwipeDirection.endToStart) {
                      Database().deleteTodo(mytodos[index]['key']);
                      mytodos.removeAt(index);
                      setState(() {});
                    } else if (dir == SwipeDirection.startToEnd) {
                      Database().deleteTodo(mytodos[index]['key']);
                      mytodos.removeAt(index);
                      setState(() {});
                    }
                  },
                  direction: SwipeDirection.horizontal,
                  child: InkWell(
                    onLongPress: () {
                      Get.to(() => ShowTodo(
                            todo: mytodos[index],
                          ));
                    },
                    child: CheckboxListTile(
                      title: Text(
                        "${mytodos[index]["title"]}",
                        style: TextStyle(
                          fontSize: 20,
                          decoration: mytodos[index]["checked"]
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                        ),
                      ),
                      value: mytodos[index]["checked"] ?? false,
                      onChanged: (bool? value) {
                        mytodos[index]["checked"] = value;
                        Database().updateTodo(mytodos[index]["key"], value);
                        setState(() {});
                      },
                    ),
                  ),
                );
              },
            )
          : const Center(
              child: Text("No todos"),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(() => const AddTodo());
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

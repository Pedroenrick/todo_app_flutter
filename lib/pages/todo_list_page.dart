import 'package:flutter/material.dart';
import 'package:todo_app/models/todo.dart';
import 'package:todo_app/repositories/todo_repository.dart';
import 'package:todo_app/widgets/todo_list_item.dart';

class TodoList extends StatefulWidget {
  const TodoList({super.key});

  @override
  State<TodoList> createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  final TextEditingController todoController = TextEditingController();
  final TodoRepository todoRepository = TodoRepository();

  List<Todo> todos = [];
  int? deletedTodoIndex;

  String? errorMessage;

  @override
  void initState() {
    super.initState();

    todoRepository.getTodoList().then((value) {
      setState(() {
        todos = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: todoController,
                        decoration: InputDecoration(
                          labelText: 'Adicionar tarefa',
                          hintText: 'Ex. Estudar',
                          border: const OutlineInputBorder(),
                          errorText: errorMessage,
                          focusedBorder: const OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Color(0xff00d7f3), width: 2),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () {
                        String text = todoController.text;
                        if (text.isEmpty) {
                          setState(() {
                            errorMessage = "Digite uma tarefa";
                          });
                          return;
                        }
                        setState(() {
                          Todo newTodo = Todo(
                            title: text,
                            date: DateTime.now(),
                          );
                          todos.add(newTodo);
                          errorMessage = null;
                        });
                        todoController.clear();
                        todoRepository.saveTodoList(todos);
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xff00d7f3),
                          padding: const EdgeInsets.all(14.0)),
                      child: const Icon(
                        Icons.add,
                        size: 30,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Flexible(
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      for (Todo todo in todos)
                        TodoListItem(todo: todo, onDelete: onDelete),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child:
                          Text('Você possui ${todos.length} tarefas pendentes'),
                    ),
                    const SizedBox(width: 8),
                    if (todos.isNotEmpty)
                      ElevatedButton(
                        onPressed: showDeleteTodosConfirmationDialog,
                        style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xff00d7f3),
                            padding: const EdgeInsets.all(14.0)),
                        child: const Text("Limpar tudo"),
                      )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void onDelete(Todo todo) {
    deletedTodoIndex = todos.indexOf(todo);
    setState(() {
      todos.remove(todo);
    });
    todoRepository.saveTodoList(todos);

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "Tarefa ${todo.title} foi removida com sucesso!",
          style: const TextStyle(
            color: Color(0xff060708),
            fontSize: 16,
          ),
        ),
        backgroundColor: Colors.white,
        action: SnackBarAction(
            label: "Desfazer",
            textColor: const Color(0xff00d7f3),
            onPressed: () {
              setState(() {
                todos.insert(deletedTodoIndex!, todo);
              });
              todoRepository.saveTodoList(todos);
            }),
        duration: const Duration(seconds: 5),
      ),
    );
  }

  void showDeleteTodosConfirmationDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Limpar tudo"),
        content:
            const Text("Você tem certeza que deseja limpar todas as tarefas?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            style:
                TextButton.styleFrom(foregroundColor: const Color(0xff00d7f3)),
            child: const Text("Cancelar"),
          ),
          TextButton(
            onPressed: () {
              clearAllTodos;
              Navigator.pop(context);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text("Limpar tudo"),
          ),
        ],
      ),
    );
  }

  void clearAllTodos() {
    setState(() {
      todos.clear();
    });
    todoRepository.saveTodoList(todos);
  }
}

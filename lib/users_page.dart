import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:json_placeholderxdio/dio_service.dart';
import 'package:json_placeholderxdio/user.dart';

class UsersPage extends StatefulWidget {
  static String id = "users_page/";
  const UsersPage({Key? key}) : super(key: key);

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  bool isLoading = false;
  late List<Users> usersList;

  TextEditingController nameController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  Future<void> getAllData() async {
    isLoading = false;

    // String
    String result = await NetworkService.GET();

    // Map => Object
    usersList = userModelFromJson(result);

    isLoading = true;

    setState(() {});
  }

  // delete data
  Future<void> deleteData(String id) async {
    String result = await NetworkService.DELETE(id);
    if (result == "200" || result == "201") {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("$id Successfully deleted")));
    }
    await getAllData();
    setState(() {});
  }

  @override
  void initState() {
    getAllData().then((value) {
      isLoading = true;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Homework"),
      ),
      body: isLoading
          ? ListView.separated(
              padding: EdgeInsets.zero,
              itemBuilder: (_, index) {
                var item = usersList[index];
                return ListTile(
                  title: Text(item.name ?? ""),
                  subtitle: Text("Username: ${item.username}"),
                  leading: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "${index + 1}. ",
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 20,
                        ),
                      ),
                      Image.asset('assets/Sample_User_Icon.png'),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(CupertinoIcons.pencil),
                        onPressed: () {
                          nameController.text = item.name ?? "No name";
                          usernameController.text =
                              item.username ?? "No username";
                          emailController.text = item.email ?? "no email";

                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text("Update item"),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    // title
                                    TextField(
                                      controller: nameController,
                                      decoration: const InputDecoration(
                                        hintText: "Name",
                                      ),
                                    ),

                                    // desc
                                    TextField(
                                      controller: usernameController,
                                      decoration: const InputDecoration(
                                        hintText: "Username",
                                      ),
                                    ),

                                    // price
                                    TextField(
                                      controller: emailController,
                                      keyboardType: TextInputType.number,
                                      decoration: const InputDecoration(
                                        hintText: "Email",
                                      ),
                                    ),
                                  ],
                                ),
                                actions: [
                                  IconButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    icon: const Text("Close"),
                                  ),
                                  IconButton(
                                    onPressed: () async {
                                      if (nameController.text.isNotEmpty &&
                                          usernameController.text.isNotEmpty &&
                                          emailController.text.isNotEmpty) {
                                        Users user = Users(
                                            name: nameController.text.trim(),
                                            username:
                                                usernameController.text.trim(),
                                            email: emailController.text.trim(),
                                            address: Address(
                                              street: 'Default',
                                              suite: 'Default',
                                              city: 'Default',
                                              zipcode: 'Default',
                                              geo: Geo(
                                                  lat: 'Default',
                                                  lng: 'Default'),
                                            ),
                                            company: Company(
                                                bs: 'Default',
                                                catchPhrase: 'Default',
                                                name: 'Default'),
                                            phone: 'Default',
                                            website: 'Default');
                                        await NetworkService.PUT(
                                            user.toJson(), item.id ?? "0");
                                        await getAllData().then((value) {
                                          Navigator.pop(context);
                                        });
                                        setState(() {});
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(const SnackBar(
                                                content: Text(
                                                    "Please fill all the gaps")));
                                      }
                                    },
                                    icon: const Text("Save"),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(CupertinoIcons.delete),
                        onPressed: () async {
                          await deleteData(item.id ?? "0");
                        },
                      ),
                    ],
                  ),
                );
              },
              separatorBuilder: (_, index) {
                
                return const Divider();
              },
              itemCount: usersList.length,
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text("Adding new item"),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // title
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        hintText: "Name",
                      ),
                    ),

                    // desc
                    TextField(
                      controller: usernameController,
                      decoration: const InputDecoration(
                        hintText: "Username",
                      ),
                    ),

                    // price
                    TextField(
                      controller: emailController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        hintText: "Email",
                      ),
                    ),
                  ],
                ),
                actions: [
                  IconButton(
                    onPressed: () async {
                      if (nameController.text.isNotEmpty &&
                          usernameController.text.isNotEmpty &&
                          emailController.text.isNotEmpty) {
                        Users user = Users(
                            name: nameController.text.trim(),
                            username: usernameController.text.trim(),
                            email: emailController.text.trim(),
                            address: Address(
                              street: 'Default',
                              suite: 'Default',
                              city: 'Default',
                              zipcode: 'Default',
                              geo: Geo(lat: 'Default', lng: 'Default'),
                            ),
                            company: Company(
                                bs: 'Default',
                                catchPhrase: 'Default',
                                name: 'Default'),
                            phone: 'Default',
                            website: 'Default');
                        await NetworkService.POST(user.toJson());
                        await getAllData().then((value) {
                          Navigator.pop(context);
                        });
                        setState(() {});
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text("Please fill all the gaps")));
                      }
                    },
                    icon: const Text("Save"),
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Text("Close"),
                  ),
                ],
              );
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

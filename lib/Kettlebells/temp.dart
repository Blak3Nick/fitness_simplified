import 'package:flutter/material.dart';

import '../models.dart';
import '../services/firestore.dart';

class Temp extends StatefulWidget {
  const Temp({Key? key}) : super(key: key);

  @override
  _CreateKettleBellWorkoutState createState() =>
      _CreateKettleBellWorkoutState();
}

// Define a corresponding State class.
// This class holds the data related to the Form.
class _CreateKettleBellWorkoutState extends State<Temp> {
  // Create a text controller and use it to retrieve the current value
  // of the TextField.
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  static List<String> friendsList = [''];
  static List<Group> groupList = [];
  List<String> strings = ['Swing', 'Rest'];
  Group group =
      Group(repeat: 1, work_duration: [0], rest_duration: 10, work_rest: []);

  @override
  void initState() {
    super.initState();
    groupList.add(group);
    _nameController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text('Dynamic TextFormFields'),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // name textfield
                Padding(
                  padding: const EdgeInsets.only(right: 32.0),
                  child: TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(hintText: 'Enter your name'),
                    validator: (v) {
                      if (v!.trim().isEmpty) return 'Please enter something';
                      return null;
                    },
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  'Add Friends',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                ),
                ..._getFriends(),
                const Text(
                  'Add Groups',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                ),
                ..._getGroups(),
                const SizedBox(
                  height: 40,
                ),
                TextButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                    }
                  },
                  child: const Text('Create Workout'),
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.purple,
                    primary: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// get firends text-fields
  List<Widget> _getFriends() {
    List<Widget> friendsTextFields = [];
    for (int i = 0; i < friendsList.length; i++) {
      friendsTextFields.add(Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Row(
          children: [
            Expanded(child: FriendTextFields(i)),
            const SizedBox(
              width: 16,
            ),
            // we need add button at last friends row
            _addRemoveButton(i == friendsList.length - 1, i),
          ],
        ),
      ));
    }
    return friendsTextFields;
  }

  List<Widget> _getGroups() {
    List<Widget> groupsTextFields = [];
    for (int i = 0; i < groupList.length; i++) {
      groupsTextFields.add(
        FriendTextFields(0),
      );
    }

    return groupsTextFields;
  }

  /// add / remove button
  Widget _addRemoveButton(bool add, int index) {
    return InkWell(
      onTap: () {
        if (add) {
          // add new text-fields at the top of all friends textfields
          friendsList.insert(0, '');
        } else {
          friendsList.removeAt(index);
        }
        setState(() {});
      },
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          color: (add) ? Colors.green : Colors.red,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Icon(
          (add) ? Icons.add : Icons.remove,
          color: Colors.white,
        ),
      ),
    );
  }
}

class FriendTextFields extends StatefulWidget {
  final int index;
  FriendTextFields(this.index);
  @override
  _FriendTextFieldsState createState() => _FriendTextFieldsState();
}

class _FriendTextFieldsState extends State<FriendTextFields> {
  late TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      _nameController.text =
          _CreateKettleBellWorkoutState.friendsList[widget.index];
    });

    return TextFormField(
      controller: _nameController,
      onChanged: (v) =>
          _CreateKettleBellWorkoutState.friendsList[widget.index] = v,
      decoration: const InputDecoration(hintText: 'Enter your friend\'s name'),
      validator: (v) {
        if (v!.trim().isEmpty) return 'Please enter something';
        return null;
      },
    );
  }
}

class GroupTextFields extends StatefulWidget {
  final int index;
  const GroupTextFields(this.index);
  @override
  _GroupTextFieldsState createState() => _GroupTextFieldsState();
}

class _GroupTextFieldsState extends State<GroupTextFields> {
  late TextEditingController _nameController;
  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
    //   //_nameController.text = _CreateKettleBellWorkoutState.groupList[widget.index] ?? '';
    // });

    return Card(
      child: SizedBox(
        child: Column(
          children: [
            Center(
              child: Row(
                children: const [
                  Text('Circuit 1'),
                ],
              ),
            ),
            Row(
              children: [
                Flexible(
                  child: TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: "First Exercise",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const Spacer(),
                Flexible(
                  child: TextField(
                    controller: _nameController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: "Time",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Flexible(
                  child: TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: "Second Exercise",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const Spacer(),
                Flexible(
                  child: TextField(
                    controller: _nameController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: "Time",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
            Center(
              child: IconButton(
                  icon: const Icon(Icons.add_circle, color: Colors.deepPurple),
                  iconSize: 40,
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => const Temp()));
                  }),
            ),
          ],
        ),
      ),
    );
  }
}

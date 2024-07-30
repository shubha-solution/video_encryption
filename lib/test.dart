import 'package:flutter/material.dart';



class Shubha extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: UserManagementScreen(),
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
    );
  }
}

class UserManagementScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Management'),
        actions: [
          IconButton(icon: Icon(Icons.filter_list), onPressed: () {}),
          IconButton(icon: Icon(Icons.add), onPressed: () {}),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundImage: NetworkImage('https://via.placeholder.com/150'),
            ),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text('Menu'),
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
            ),
            ListTile(
              leading: Icon(Icons.dashboard),
              title: Text('Dashboard'),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.people),
              title: Text('User Management'),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.security),
              title: Text('Security & Access'),
              onTap: () {},
            ),
            // Add more items here
          ],
        ),
      ),
      body: UserList(),
    );
  }
}

class UserList extends StatelessWidget {
  final List<Map<String, String>> users = [
    {
      'name': 'Florence Shaw',
      'email': 'florence@untitledui.com',
      'image': 'https://via.placeholder.com/150',
      'role': 'Admin',
    },
    {
      'name': 'Amélie Laurent',
      'email': 'amelie@untitledui.com',
      'image': 'https://via.placeholder.com/150',
      'role': 'Admin',
    },
    // Add more users here
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: users.length,
      itemBuilder: (context, index) {
        final user = users[index];
        return Card(
          margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(user['image']!),
            ),
            title: Text(user['name']!),
            subtitle: Text(user['email']!),
            trailing: Wrap(
              spacing: 12, // space between two icons
              children: <Widget>[
                Chip(
                  label: Text(user['role']!),
                  backgroundColor: Colors.blue.shade100,
                ),
                Chip(
                  label: Text('Data Export'),
                  backgroundColor: Colors.green.shade100,
                ),
                Chip(
                  label: Text('Data Import'),
                  backgroundColor: Colors.orange.shade100,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

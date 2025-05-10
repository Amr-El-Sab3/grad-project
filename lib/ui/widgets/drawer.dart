import 'package:emotion_detection/ui/screens/records_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:emotion_detection/bloc/auth_bloc/auth_bloc.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({super.key});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle = TextStyle(
    fontSize: 30,
    fontWeight: FontWeight.bold,
  );
  static const List<Widget> _widgetOptions = <Widget>[RecordsScreen()];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // final Brightness systemBrightness = MediaQuery.of(context).platformBrightness;
    // final bool isDarkMode = systemBrightness == Brightness.dark;

    //  _ToggelTheme (){
    //    setState(() {
    //      Theme.of(context).brightness == Brightness.light
    //          ? ThemeMode.dark
    //          : ThemeMode.light;
    //    });
    // }

    return Drawer(
      child: SingleChildScrollView(
        padding: EdgeInsets.zero,
        child: Column(
          children: [
            DrawerHeader(
              decoration:
                  BoxDecoration(color: Theme.of(context).colorScheme.primary),
              child: const Center(
                child: Column(
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Icon(
                      Icons.person,
                      size: 55,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text('User Name'),
                  ],
                ),
              ),
            ),

            Container(
              child: ListTile(
                title: const Text('History'),
                leading: const Icon(Icons.history),
                selected: _selectedIndex == 0,
                onTap: () {
                  // Update the state of the app
                  _onItemTapped(0);
                  // Then close the drawer
                  Navigator.pop(context);
                },
              ),
            ),
            const SizedBox(
              height: 8,
            ),

            Container(
              color: Theme.of(context).colorScheme.secondary,
              child: const ListTile(
                title: Text("Settings"),
                leading: Icon(Icons.settings),
              ),
            ),
            ListTile(
              leading: const Icon(
                Icons.auto_graph_outlined,
              ),
              title: const Text("Graph Style"),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(
                Icons.logout,
                color: Colors.redAccent,
              ),
              title: const Text(
                "LOGOUT",
                style: TextStyle(color: Colors.redAccent),
              ),
              onTap: () async {
                final bloc = context.read<AuthBloc>();
                bloc.add(LogoutEvent());
                // Listen for logout completion and navigate
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) => const Center(child: CircularProgressIndicator()),
                );
                // Wait for AuthInitial state
                await for (final state in bloc.stream) {
                  if (state is AuthInitial) {
                    Navigator.of(context, rootNavigator: true).pop(); // Remove dialog
                    Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
                    break;
                  } else if (state is AuthFailure) {
                    Navigator.of(context, rootNavigator: true).pop(); // Remove dialog
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.error)),
                    );
                    break;
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:memorimage_160421082_160421046/screen/game.dart';
import 'package:memorimage_160421082_160421046/screen/highscore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:memorimage_160421082_160421046/screen/login.dart';

String active_user = "";
Future<String> checkUser() async {
  final prefs = await SharedPreferences.getInstance();
  String username = prefs.getString("username") ?? '';
  return username;
}
void doLogout() async {
  final prefs = await SharedPreferences.getInstance();
  prefs.remove("username");
  main();
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  checkUser().then((String result) {
    if (result == '')
      runApp(MyLogin());
    else {
      active_user = result;
      runApp(MyApp());
    }
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MemoryMage Game',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme:
            ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 255, 153, 221)),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'MemoryMage Home Page'),
      routes: {
        'game': (context) => Game(),
        'score': (context) => HighScore(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _username = "";

  @override
  void initState() {
    super.initState();
    checkUser().then((value) => setState(
          () {
            _username = value;
          },
        ));
  }

  Widget funDrawer() {
    return Drawer(
      elevation: 16.0,
      child: Column(
        children: <Widget>[
          UserAccountsDrawerHeader(
              accountName: Text(_username),
              accountEmail: Text(""),
              currentAccountPicture: CircleAvatar(
                  backgroundImage: NetworkImage("https://i.pravatar.cc/150"))),
          ListTile(
              title: new Text("Game"),
              leading: new Icon(Icons.games),
              onTap: () {
                Navigator.pushNamed(context, "game");
              }),
              ListTile(
              title: new Text("High Score"),
              leading: new Icon(Icons.score),
              onTap: () {
                Navigator.pushNamed(context, "score");
              }),
               ListTile(
              title: new Text("Logout"),
              leading: new Icon(Icons.logout),
              onTap: () {
                doLogout();
              }),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("Memorimage"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You will be given objects in the cards. Find the card you have seen before, among others.',
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Game()),
                );
              },
              child: Text("Play Game"),
            ),
          ],
        ),
      ),
      drawer:
          funDrawer(), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

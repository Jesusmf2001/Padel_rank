import 'package:flutter/material.dart';

void main() {
  runApp(PadelRankApp());
}

class PadelRankApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Padel Rank',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Map<String, dynamic>> players = [];
  final TextEditingController controller = TextEditingController();

  void addPlayer() {
    if (controller.text.isNotEmpty) {
      setState(() {
        players.add({'name': controller.text, 'score': 0});
        controller.clear();
      });
    }
  }

  void startRanking() {
    if (players.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => RankingScreen(players: players)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Padel Rank')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Añade jugadores:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    decoration: InputDecoration(hintText: 'Nombre del jugador', border: OutlineInputBorder()),
                  ),
                ),
                SizedBox(width: 10),
                ElevatedButton(onPressed: addPlayer, child: Text('Añadir')),
              ],
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: players.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 3,
                    margin: EdgeInsets.symmetric(vertical: 5),
                    child: ListTile(
                      title: Text(players[index]['name']),
                      leading: Icon(Icons.person),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: startRanking,
                child: Text('Iniciar Ranking'),
                style: ElevatedButton.styleFrom(padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RankingScreen extends StatefulWidget {
  final List<Map<String, dynamic>> players;
  RankingScreen({required this.players});

  @override
  _RankingScreenState createState() => _RankingScreenState();
}

class _RankingScreenState extends State<RankingScreen> {
  final TextEditingController controller = TextEditingController();

  void addPlayer() {
    if (controller.text.isNotEmpty) {
      setState(() {
        widget.players.add({'name': controller.text, 'score': 0});
        controller.clear();
      });
    }
  }

  void newMatch() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MatchScreen(players: widget.players)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Ranking')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: widget.players.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 3,
                    child: ListTile(
                      title: Text(widget.players[index]['name']),
                      trailing: Text('Puntos: ${widget.players[index]['score']}'),
                    ),
                  );
                },
              ),
            ),
            TextField(
              controller: controller,
              decoration: InputDecoration(hintText: 'Nuevo jugador', border: OutlineInputBorder()),
            ),
            ElevatedButton(onPressed: addPlayer, child: Text('Añadir Jugador')),
            SizedBox(height: 10),
            ElevatedButton(onPressed: newMatch, child: Text('Nuevo Partido')),
          ],
        ),
      ),
    );
  }
}

class MatchScreen extends StatelessWidget {
  final List<Map<String, dynamic>> players;
  MatchScreen({required this.players});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Nuevo Partido')),
      body: Center(
        child: Text('Aquí podrás registrar los sets de los partidos. (Por implementar)'),
      ),
    );
  }
}

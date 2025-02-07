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

class RankingScreen extends StatelessWidget {
  final List<Map<String, dynamic>> players;
  RankingScreen({required this.players});

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
                itemCount: players.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 3,
                    child: ListTile(
                      title: Text(players[index]['name']),
                      trailing: Text('Puntos: ${players[index]['score']}'),
                    ),
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: () {
                if (players.length >= 4) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MatchScreen(players: players)),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Se necesitan al menos 4 jugadores')),
                  );
                }
              },
              child: Text('Nuevo Partido'),
            ),
          ],
        ),
      ),
    );
  }
}

class MatchScreen extends StatefulWidget {
  final List<Map<String, dynamic>> players;
  MatchScreen({required this.players});

  @override
  _MatchScreenState createState() => _MatchScreenState();
}

class _MatchScreenState extends State<MatchScreen> {
  final TextEditingController scoreController1 = TextEditingController();
  final TextEditingController scoreController2 = TextEditingController();
  final TextEditingController scoreController3 = TextEditingController();

  late List<Map<String, dynamic>> selectedPair1;
  late List<Map<String, dynamic>> selectedPair2;

  @override
  void initState() {
    super.initState();
    selectedPair1 = [];
    selectedPair2 = [];
  }

  // Función para seleccionar las parejas
  void selectPairs() {
    if (widget.players.length >= 4) {
      setState(() {
        selectedPair1 = [widget.players[0], widget.players[1]];
        selectedPair2 = [widget.players[2], widget.players[3]];
      });
    }
  }

  // Registrar el resultado de los sets
  void registerMatch() {
    int set1Score1 = int.tryParse(scoreController1.text) ?? 0;
    int set2Score1 = int.tryParse(scoreController2.text) ?? 0;
    int set3Score1 = int.tryParse(scoreController3.text) ?? 0;
    
    int set1Score2 = int.tryParse(scoreController1.text) ?? 0;
    int set2Score2 = int.tryParse(scoreController2.text) ?? 0;
    int set3Score2 = int.tryParse(scoreController3.text) ?? 0;

    setState(() {
      // Actualizar los puntos de los jugadores después del partido
      if (selectedPair1.isNotEmpty && selectedPair2.isNotEmpty) {
        widget.players[0]['score'] += set1Score1 + set2Score1 + set3Score1;
        widget.players[1]['score'] += set1Score2 + set2Score2 + set3Score2;
      }
    });

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Nuevo Partido')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Selecciona las parejas para el partido:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ElevatedButton(
              onPressed: selectPairs,
              child: Text('Seleccionar parejas'),
            ),
            SizedBox(height: 20),
            selectedPair1.isNotEmpty && selectedPair2.isNotEmpty
                ? Column(
                    children: [
                      Text('Pareja 1:'),
                      Text('Jugador 1: ${selectedPair1[0]['name']}'),
                      Text('Jugador 2: ${selectedPair1[1]['name']}'),
                      Text('Pareja 2:'),
                      Text('Jugador 1: ${selectedPair2[0]['name']}'),
                      Text('Jugador 2: ${selectedPair2[1]['name']}'),
                    ],
                  )
                : Text('Esperando selección de parejas...'),
            SizedBox(height: 30),
            Text('Resultado de los sets:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            TextField(
              controller: scoreController1,
              decoration: InputDecoration(hintText: 'Resultado del primer set', border: OutlineInputBorder()),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: scoreController2,
              decoration: InputDecoration(hintText: 'Resultado del segundo set', border: OutlineInputBorder()),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: scoreController3,
              decoration: InputDecoration(hintText: 'Resultado del tercer set', border: OutlineInputBorder()),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: registerMatch,
              child: Text('Registrar partido'),
            ),
          ],
        ),
      ),
    );
  }
}

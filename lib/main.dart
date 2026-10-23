import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const CoffeeShopApp());
}

class CoffeeShopApp extends StatelessWidget {
  const CoffeeShopApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Coffee Shop',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.brown),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class CoffeeItem {
  final String image;
  final String title;
  final String description;

  const CoffeeItem(this.image, this.title, this.description);
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Les 6 images placées dans le dossier assets/ avec leur description
  final List<CoffeeItem> items = const [
    CoffeeItem(
      'assets/coffee1.jpg',
      'Grains et café noir',
      'Une tasse de café noir posée sur une table en bois, '
          'à côté d\'un sac en toile de jute rempli de grains torréfiés.',
    ),
    CoffeeItem(
      'assets/coffee2.jpg',
      'Café noir rétro',
      'Un café noir bien serré servi dans une tasse vintage '
          'à motifs étoilés, avec une fine mousse en surface.',
    ),
    CoffeeItem(
      'assets/coffee3.jpg',
      'Latte art en cœur',
      'Un cappuccino décoré d\'un cœur et de volutes de chocolat, '
          'tenu à deux mains, à côté d\'une viennoiserie.',
    ),
    CoffeeItem(
      'assets/coffee4.jpg',
      'Café et grains frais',
      'Vue du dessus d\'un café noir entouré de grains torréfiés '
          'et de feuilles de caféier.',
    ),
    CoffeeItem(
      'assets/coffee5.jpg',
      'Espresso fumant',
      'Un espresso crémeux et chaud dans une tasse blanche, '
          'posé sur des grains de café et un sac en toile de jute.',
    ),
    CoffeeItem(
      'assets/coffee6.jpg',
      'Latte art en feuille',
      'Un café au lait avec un joli motif de feuille (rosetta) '
          'dessiné dans la mousse, vu du dessus.',
    ),
  ];

  int index = 0;
  int clicks = 0;
  bool showCount = false;

  void changeImage() {
    setState(() {
      index = (index + 1) % items.length;
      clicks++;
    });
  }

  @override
  Widget build(BuildContext context) {
    final item = items[index];

    return Scaffold(
      backgroundColor: const Color(0xFFFFF3E0), // fond beige crème
      appBar: AppBar(
        // Icône du menu sans bulle « Open navigation menu »
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: const Text('Coffee Shop'),
        actions: [
          // Icône de message en haut à droite
          IconButton(
            icon: const Icon(Icons.message),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'Bonjour',
                    style: TextStyle(fontSize: 18),
                  ),
                  duration: Duration(seconds: 2),
                ),
              );
            },
          ),
        ],
        backgroundColor: Colors.brown,
        foregroundColor: Colors.white,
      ),
      onDrawerChanged: (isOpened) {
        // À la fermeture du menu, on remet le résultat à zéro
        if (!isOpened) {
          setState(() {
            showCount = false;
          });
        }
      },
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.brown),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  'Coffee Shop',
                  style: TextStyle(color: Colors.white, fontSize: 24),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: ElevatedButton.icon(
                onPressed: () {
                  setState(() {
                    showCount = !showCount; // 1er clic : affiche, 2e clic : cache
                  });
                },
                icon: const Icon(Icons.image),
                label: const Text('Nombre d\'images'),
              ),
            ),
            // Le résultat s'affiche dans le menu, après le clic sur le bouton
            if (showCount)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'Nombre d\'images : ${items.length}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.brown,
                  ),
                ),
              ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.exit_to_app, color: Colors.red),
              title: const Text('Quitter'),
              onTap: () {
                // Ferme l'application (Android / iOS)
                SystemNavigator.pop();
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  item.image,
                  width: 320,
                  height: 220,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                item.title,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(height: 12),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 320),
                child: Text(
                  item.description,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16, color: Colors.black87),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: changeImage,
                    child: const Text('Change'),
                  ),
                  const SizedBox(width: 20),
                  Text(
                    'Clics : $clicks',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.deepOrange,
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Bouton qui remet le compteur de clics à zéro
                  IconButton(
                    icon: const Icon(Icons.refresh, color: Colors.deepOrange),
                    onPressed: () {
                      setState(() {
                        clicks = 0;
                      });
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:movies_app/screens/screens.dart';
import 'services/pokemon_service.dart';
import 'models/pokemon.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final pokemons = await PokemonService().GetAllPokemon();
  runApp(MyApp(pokemons: pokemons));
}

class MyApp extends StatelessWidget {
  final List<Pokemon> pokemons;
  const MyApp({super.key, required this.pokemons});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pokémon',
      initialRoute: 'home',
      routes: {
        'home': (BuildContext context) => HomeScreen(pokemons: pokemons),
        'details': (BuildContext context) => DetailsScreen(),
      },
      theme: ThemeData.light()
          .copyWith(appBarTheme: const AppBarTheme(color: Colors.indigo)),
    );
  }
}

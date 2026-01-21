import 'package:flutter/material.dart';
import 'package:movies_app/services/pokemon_service.dart';
import 'package:movies_app/widgets/pokemon_search_delegate.dart';
import 'package:movies_app/widgets/widgets.dart';
import 'package:movies_app/models/pokemon.dart';

class HomeScreen extends StatefulWidget {
  final List<Pokemon> pokemons;
  const HomeScreen({super.key, required this.pokemons});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final List<Pokemon> pokemons;
  @override
  void initState() {
    super.initState();
    pokemons = widget.pokemons;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pokémon'),
        elevation: 0,
        actions: [
          IconButton(
              onPressed: () {
                showSearch(
                    context: context,
                    delegate: PokemonSearchDelegate(onSearch: (query) async {
                      return PokemonService().getPokemonsByQuery(query);
                    }, onSelected: (pokemon) async {
                      Navigator.pushNamed(
                        context,
                        'details',
                        arguments: await PokemonService()
                            .getPokemonByIdOrName(pokemon.name),
                      );
                    }));
              },
              icon: const Icon(Icons.search_outlined))
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              if (pokemons.isEmpty)
                const SizedBox(
                  height: 500,
                  child: Center(child: CircularProgressIndicator()),
                )
              else
                CardSwiper(pokes: pokemons), // Slider de pel·licules

              //MovieSlider(),
              // Poodeu fer la prova d'afegir-ne uns quants, veureu com cada llista és independent
              // MovieSlider(),
              // MovieSlider(),
            ],
          ),
        ),
      ),
    );
  }
}

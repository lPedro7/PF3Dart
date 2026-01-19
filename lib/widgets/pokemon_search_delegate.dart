import 'package:flutter/material.dart';
import 'package:movies_app/models/pokemon.dart';

class PokemonSearchDelegate extends SearchDelegate<Pokemon?> {
  final Future<List<Pokemon>> Function(String query) onSearch;
  final void Function(Pokemon pokemon) onSelected;

  PokemonSearchDelegate({
    required this.onSearch,
    required this.onSelected,
  });

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      if (query.isNotEmpty)
        IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () => query = '',
        ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => close(context, null),
    );
  }

  // Se ejecuta cuando le das al botón "buscar" del teclado
  @override
  Widget buildResults(BuildContext context) {
    return _ResultsList(
      query: query,
      onSearch: onSearch,
      onSelected: (p) {
        close(context, p); // cierra el search
        onSelected(p); // navega a detalle
      },
    );
  }

  // Sugerencias mientras escribe (puedes reutilizar el mismo widget)
  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.trim().isEmpty) {
      return const Center(child: Text('Escribe el nombre de un Pokémon...'));
    }

    return _ResultsList(
      query: query,
      onSearch: onSearch,
      onSelected: (p) {
        close(context, p);
        onSelected(p);
      },
    );
  }
}

class _ResultsList extends StatelessWidget {
  final String query;
  final Future<List<Pokemon>> Function(String query) onSearch;
  final void Function(Pokemon pokemon) onSelected;

  const _ResultsList({
    required this.query,
    required this.onSearch,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Pokemon>>(
      future: onSearch(query.trim()),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final results = snapshot.data ?? [];

        if (results.isEmpty) {
          return const Center(child: Text('No se encontraron resultados'));
        }

        return ListView.builder(
          itemCount: results.length,
          itemBuilder: (_, i) {
            final p = results[i];
            return ListTile(
              title: Text(p.name),
              subtitle: Text('#${p.id}'),
              onTap: () => onSelected(p),
            );
          },
        );
      },
    );
  }
}

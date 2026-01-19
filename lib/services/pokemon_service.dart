import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:movies_app/models/pokemon.dart';
import 'package:movies_app/models/stat.dart';

class PokemonService {
  static String HOST = 'https://pokeapi.co/api/v2/';

  static Future<List<Pokemon>> get10FirstPokemon() async {
    String url = HOST + "pokemon?limit=10".toString();
    Uri uri = Uri.parse(url);
    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw new Exception("Error buscando Pokémon");
    }

    Map<String, dynamic> dataJson = jsonDecode(response.body);

    final List<dynamic> results = dataJson["results"] as List<dynamic>;

    List<Pokemon> pokemons = List.empty(growable: true);

    for (final item in results) {
      final map = item as Map<String, dynamic>;
      final String name = map["name"].toString();

      pokemons.add(await getPokemonByIdOrName(name));
    }

    return pokemons;
  }

  static Future<Pokemon> getPokemonByIdOrName(String Id) async {
    String url = HOST + "pokemon/" + Id;
    Uri uri = Uri.parse(url);
    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw new Exception("Error buscando Pokémon");
    }

    Map<String, dynamic> data = jsonDecode(response.body);

    int id = data["id"];
    String name = data["name"].toString();
    String ability = ""; //data["ability"].toString();
    List<Stat> stats = List.empty(growable: true);
    List<dynamic> statData = data["stats"];
    for (final item in statData) {
      final map = item as Map<String, dynamic>;
      String name = map["stat"]["name"];
      int value = map["base_stat"];
      Stat stat = Stat(name, value);
      stats.add(stat);
    }

    String imageUrl = data["sprites"]["front_default"];

    return Pokemon.all(id, name, ability, [], [], stats, imageUrl, '');
  }

  static Future<Pokemon> getRandomPokemon() async {
    var nPokemon = 1025;

    Random random = new Random();
    int pokemonNum = random.nextInt(nPokemon) + 1;
    String url = HOST + "pokemon/" + pokemonNum.toString();
    Uri uri = Uri.parse(url);
    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw new Exception("Error buscando Pokémon");
    }

    Map<String, dynamic> data = jsonDecode(response.body);

    int id = data["id"];
    String name = data["name"].toString();
    String ability = ""; //data["ability"].toString();
    List<Stat> stats = List.empty(growable: true);
    List<dynamic> statData = data["stats"];
    for (final item in statData) {
      final map = item as Map<String, dynamic>;
      String name = map["stat"]["name"];
      int value = map["base_stat"];
      Stat stat = Stat(name, value);
      stats.add(stat);
    }

    String imageUrl = data["sprites"]["front_default"];

    return Pokemon.all(id, name, ability, [], [], stats, imageUrl, '');
  }
}

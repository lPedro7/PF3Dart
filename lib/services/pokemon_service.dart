import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:movies_app/models/pokemon.dart';
import 'package:movies_app/models/stat.dart';

class PokemonService {
  static String HOST = 'https://pokeapi.co/api/v2/';
  static String PHOTOHOST =
      'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/';

  static List<Pokemon> pokemonList = List.empty(growable: true);

  Future<List<Pokemon>> GetAllPokemon() async {
    print("Cargando Pokes !");

    String url = HOST + "pokemon?limit=1050&offset=0";
    Uri uri = Uri.parse(url);
    final response = await http.get(uri);
    if (response.statusCode != 200) {
      throw Exception("Error buscando Pokémon");
    }

    Map<String, dynamic> dataJson = jsonDecode(response.body);

    final List<dynamic> results = dataJson["results"] as List<dynamic>;

    List<Pokemon> pokemons = List.empty(growable: true);

    for (final item in results) {
      final map = item as Map<String, dynamic>;
      final String name = map["name"].toString();
      final String url = map["url"].toString();
      final List<String> urlSplitt = url.split("/");
      final String Id = urlSplitt[urlSplitt.length - 2];
      pokemons.add(
          Pokemon.basic(int.parse(Id), name, url, PHOTOHOST + Id + ".png"));
    }

    pokemonList = pokemons;
    print("Pokes cargados !");
    return pokemons;
  }

  List<Pokemon> getList() {
    return pokemonList;
  }

  Future<List<Pokemon>> get10FirstPokemon() async {
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

  List<Pokemon> getPokemonsByQuery(String query) {
    List<Pokemon> pkmns = List.empty(growable: true);
    for (Pokemon p in pokemonList) {
      print(p.id.toString() + " - " + p.name);

      if (p.name.toLowerCase().contains(query.toLowerCase())) pkmns.add(p);
    }
    return pkmns;
  }

  Future<Pokemon> getPokemonByIdOrName(String Id) async {
    try {
      print("Get " + Id);
      String url = HOST + "pokemon/" + Id;
      Uri uri = Uri.parse(url);
      final response = await http.get(uri);

      if (response.statusCode != 200) {
        throw new Exception("Error buscando Pokémon");
      }

      Map<String, dynamic> data = jsonDecode(response.body);

      int id = data["id"];
      String name = data["name"].toString();
      List<String> abilities = List.empty(growable: true);
      List<dynamic> abilitiesData = data["abilities"];
      for (final item in abilitiesData) {
        final map = item as Map<String, dynamic>;
        String name = map["ability"]["name"];
        abilities.add(name);
      }

      //Types
      List<String> types = List.empty(growable: true);
      List<dynamic> typesData = data["types"];
      for (final item in typesData) {
        final map = item as Map<String, dynamic>;
        String name = map["type"]["name"];
        types.add(name);
      }

      String imageUrl = "";

      if (data["sprites"]["front_default"] != null) {
        imageUrl = data["sprites"]["front_default"];
      }

      String description = await getPokemonDescriptionByIdOrName(Id);
      return Pokemon.all(
          id, name, description, abilities, types, imageUrl, url);
    } catch (Exception) {
      print("ERROR en ID " + Id + " - " + Exception.toString());
    }
    return Pokemon.empty();
  }

  Future<Pokemon> getRandomPokemon() async {
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

    // Abilities
    List<String> abilities = List.empty(growable: true);
    List<dynamic> abilitiesData = data["abilities"];
    for (final item in abilitiesData) {
      final map = item as Map<String, dynamic>;
      String name = map["ability"]["name"];
      abilities.add(name);
    }

    //Types
    List<String> types = List.empty(growable: true);
    List<dynamic> typesData = data["types"];
    for (final item in abilitiesData) {
      final map = item as Map<String, dynamic>;
      String name = map["type"]["name"];
      types.add(name);
    }

    // Image
    String imageUrl = data["sprites"]["front_default"].toString();

    String description = await getPokemonDescriptionByIdOrName(id.toString());

    return Pokemon.all(id, name, description, abilities, types, imageUrl, url);
  }

  static Future<String> getPokemonDescriptionByIdOrName(String Id) async {
    String url = HOST + "pokemon-species/" + Id;
    Uri uri = Uri.parse(url);
    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw new Exception("Error buscando Pokémon");
    }

    Map<String, dynamic> data = jsonDecode(response.body);
    List<dynamic> entries = data["flavor_text_entries"];
    String res = "";
    for (final entry in entries) {
      final item = entry as Map<String, dynamic>;
      String language = item["language"]["name"];
      if (language == "es") res = item["flavor_text"].toString();
      if (language != "en") continue;

      return item["flavor_text"].toString();
    }

    return res;
  }
}

import 'stat.dart';

class Pokemon {
  late int id;
  late String name;
  late String description;
  late List<String> abilities;
  late List<String> types;
  late String imageUrl;
  late String url;
  Pokemon.empty();
  Pokemon.basic(this.id, this.name, this.url, this.imageUrl);
  Pokemon.all(this.id, this.name, this.description, this.abilities, this.types,
      this.imageUrl, this.url);

  String abilitiesToString() {
    String res = "";
    for (String s in abilities) {
      res += "$s/";
    }

    res = res.substring(0, res.length - 1);

    return res;
  }

  String typesToString() {
    String res = "";
    for (String s in types) {
      res += "$s/";
    }

    res = res.substring(0, res.length - 1);

    return res;
  }
}

import 'stat.dart';

class Pokemon {
  late int id;
  late String name;
  late String ability;
  late List<String> types;
  late List<Stat> stats;
  late String imageUrl;
  late String url;
  Pokemon.empty();
  Pokemon.basic(this.name, this.url);
  Pokemon.all(this.id, this.name, this.ability, this.types, this.stats,
      this.imageUrl, this.url);
}

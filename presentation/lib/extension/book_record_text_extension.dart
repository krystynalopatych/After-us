import 'package:domain/book/model/book_record.dart';

extension BookRecordTextExtension on BookRecord {
  String get recipe => switch (this) {
    .sodisBottle => 'SODIS bottle: 1 plastic',
    .prefilter => 'Cloth prefilter: 1 cloth',
    .cookingPot => 'Cooking pot: 1 metal',
    .rocketStove => 'Rocket stove: 3 metal',
    .waterFilter => 'Water filter: plastic, cloth, sand and charcoal',
    .soakedAlgae => 'Soaked algae: algae and clean water',
    .clayFridge => 'Clay fridge: 2 clay pots and 2 sand',
    .gardenBed => 'Garden bed: 4 compost',
    .greenhouse => 'Greenhouse: 2 plastic',
    .wetCardboard => 'Wet cardboard: cardboard and any water',
    .mushroomFarm => 'Mushroom farm: 2 wet cardboard and a wild mushroom',
    .clayPot => 'Clay pot: 2 clay fired in the fire',
  };

  String get fact => switch (this) {
    .sodisBottle => 'Six hours of sun in a clear bottle kill most germs. The WHO recommends it: no fire, no smoke.',
    .prefilter => 'Water poured through folded cloth loses dirt and tiny bugs. In Bangladesh it cut cholera by half.',
    .cookingPot => 'Reusing old metal saves the energy of mining new ore. A pot with a lid boils water with less wood.',
    .rocketStove => 'It burns small sticks hot and clean: about half the wood of an open fire and far less smoke.',
    .waterFilter => 'Sand traps dirt and charcoal soaks up bad smells and chemicals. Many towns clean water this way.',
    .soakedAlgae =>
      'Seaweed grows without soil, fresh water or fertilizer and takes in carbon. In Japan it becomes nori.',
    .clayFridge =>
      'A zeer is a pot in a pot with wet sand between. Drying water cools it: in Nigeria food lasts weeks longer.',
    .gardenBed =>
      'Compost brings worms and food for plants back to dead soil. A raised bed of it can feed a family all year.',
    .greenhouse =>
      'Clear plastic traps the warmth of the sun. Even a cover of old bottles lets plants grow in cold months.',
    .wetCardboard => 'Wet cardboard is soft food for mushroom roots. Paper waste becomes the start of a new harvest.',
    .mushroomFarm =>
      'Oyster mushrooms grow on wet cardboard and coffee grounds. City farms turn waste into food this way.',
    .clayPot =>
      'Fired clay pots are among the oldest tools people made. Unglazed clay lets water seep and cool the pot.',
  };
}

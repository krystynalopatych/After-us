import 'package:domain/book/model/book_record.dart';

extension BookRecordTextExtension on BookRecord {
  String get recipe => switch (this) {
    .sodisBottle => 'SODIS bottle: 1 plastic',
    .prefilter => 'Cloth prefilter: 1 cloth',
    .cookingPot => 'Cooking pot: 1 metal',
    .rocketStove => 'Rocket stove: 3 metal',
    .waterFilter => 'Water filter: plastic, cloth, sand and charcoal',
    .soakedAlgae => 'Soaked algae: algae and clean water',
  };

  String get fact => switch (this) {
    .sodisBottle => 'Six hours of sun in a clear bottle kill most germs. The WHO recommends it: no fire, no smoke.',
    .prefilter => 'Water poured through folded cloth loses dirt and tiny bugs. In Bangladesh it cut cholera by half.',
    .cookingPot => 'Reusing old metal saves the energy of mining new ore. A pot with a lid boils water with less wood.',
    .rocketStove => 'It burns small sticks hot and clean: about half the wood of an open fire and far less smoke.',
    .waterFilter => 'Sand traps dirt and charcoal soaks up bad smells and chemicals. Many towns clean water this way.',
    .soakedAlgae =>
      'Seaweed grows without soil, fresh water or fertilizer and takes in carbon. In Japan it becomes nori.',
  };
}

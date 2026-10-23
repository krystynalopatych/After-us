import 'package:domain/inventory/model/inventory_item.dart';
import 'package:domain/material/model/game_material.dart';

enum PickupKind {
  plastic(
    material: .plastic,
    hint: 'A clear bottle... If I fill it with water and leave it in the sun, maybe the sun will kill the germs?',
  ),
  cloth(
    material: .cloth,
    hint: 'If I fold this cloth a few times, I can strain the water before the sun does the rest.',
  ),
  sand(
    material: .sand,
    hint: 'Clean sand... Water comes out clearer when it slowly runs through sand.',
  ),
  wood(
    material: .wood,
    hint: 'Dry branches. Boiling water on a fire is the surest way to make it safe... and charcoal could clean it too.',
  ),
  metal(
    material: .metal,
    hint: 'Scrap metal. Good enough for a cooking pot... With a bit more I could build a stove that eats less wood.',
  ),
  organics(
    material: .organics,
    hint: "Food scraps. If I bury them, they'll turn into compost for the soil.",
  ),
  cattail(
    food: .cattailRoot,
    hint: "Cattail root. Raw it's tough, but cooked it should be filling.",
  ),
  algae(
    food: .algae,
    hint: 'Algae... Edible, but salty and hard. Maybe soaking them in clean water would help.',
  ),
  berryBush(
    food: .berries,
    hint: "Berries! Food and a little water. But I shouldn't eat only these all day.",
  );

  final GameMaterial? material;
  final InventoryItem? food;
  final String hint;

  const PickupKind({
    this.material,
    this.food,
    required this.hint,
  });
}

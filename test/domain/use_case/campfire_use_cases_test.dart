import 'package:domain/feedback/model/feedback_message.dart';
import 'package:domain/station/model/campfire_fuel.dart';
import 'package:domain/station/model/campfire_recipe.dart';
import 'package:domain/station/use_case/campfire_fuel_use_case.dart';
import 'package:domain/station/use_case/campfire_recipe_use_case.dart';
import 'package:domain/station/use_case/cook_on_campfire_use_case.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/test_dependencies.dart';

void main() {
  late TestDependencies deps;
  late CampfireRecipeUseCase campfireRecipe;
  late CampfireFuelUseCase campfireFuel;
  late CookOnCampfireUseCase cookOnCampfire;
  late List<FeedbackMessage> messages;

  setUp(() {
    deps = TestDependencies();
    campfireRecipe = CampfireRecipeUseCase(
      feedbackRepository: deps.feedback,
      inventoryRepository: deps.inventory,
      selectionRepository: deps.selection,
    );
    campfireFuel = CampfireFuelUseCase(
      feedbackRepository: deps.feedback,
      materialRepository: deps.material,
      selectionRepository: deps.selection,
    );
    cookOnCampfire = CookOnCampfireUseCase(
      feedbackRepository: deps.feedback,
      inventoryRepository: deps.inventory,
      materialRepository: deps.material,
      pollutionRepository: deps.pollution,
      selectionRepository: deps.selection,
    );
    messages = [];
    final subscription = deps.feedback.messageStream.listen(messages.add);
    addTearDown(subscription.cancel);
  });

  void addWood(int count) {
    for (var i = 0; i < count; i++) {
      deps.material.add(.wood);
    }
  }

  group(
    'CampfireRecipeUseCase',
    () {
      test(
        'finds nothing and says nothing without a selection',
        () async {
          expect(
            campfireRecipe(),
            isNull,
          );
          await pumpEventQueue();
          expect(
            messages,
            isEmpty,
          );
        },
      );

      test(
        'refuses an item that cannot go into the fire',
        () async {
          deps.inventory
            ..add(.cookingPot)
            ..add(.berries);
          deps.selection.selectSlot(1);

          expect(
            campfireRecipe(),
            isNull,
          );
          await pumpEventQueue();
          expect(
            messages.single.text,
            "You can't use this at the campfire",
          );
        },
      );

      test(
        'refuses a material that cannot go into the fire',
        () async {
          deps.inventory.add(.cookingPot);
          deps.material.add(.sand);
          deps.selection.selectMaterial(.sand);

          expect(
            campfireRecipe(),
            isNull,
          );
          await pumpEventQueue();
          expect(
            messages.single.text,
            "You can't use this at the campfire",
          );
        },
      );

      test(
        'needs a cooking pot',
        () async {
          deps.inventory.add(.lakeWater);
          deps.selection.selectSlot(0);

          expect(
            campfireRecipe(),
            isNull,
          );
          await pumpEventQueue();
          expect(
            messages.single.text,
            'You need a cooking pot',
          );
        },
      );

      test(
        'needs room for the results',
        () async {
          for (var i = 0; i < 50; i++) {
            deps.inventory.add(.berries);
          }
          deps.inventory
            ..add(.cookingPot)
            ..add(.lakeWater)
            ..add(.lakeWater);
          deps.selection.selectSlot(11);

          expect(
            campfireRecipe(),
            isNull,
          );
          await pumpEventQueue();
          expect(
            messages.single.text,
            'Your inventory is full',
          );
        },
      );

      test(
        'finds the recipe, clears the selection and asks for fuel',
        () async {
          deps.inventory
            ..add(.cookingPot)
            ..add(.lakeWater);
          deps.selection.selectSlot(1);

          expect(
            campfireRecipe(),
            CampfireRecipe.boilWater,
          );
          expect(
            deps.selection.selection.slot,
            isNull,
          );
          await pumpEventQueue();
          expect(
            messages.single,
            const FeedbackMessage(text: 'Click on an item to use for starting a fire'),
          );
        },
      );

      test(
        'finds the recipe for cattail roots and wood',
        () {
          deps.inventory
            ..add(.cookingPot)
            ..add(.cattailRoot);
          addWood(1);

          deps.selection.selectSlot(1);
          expect(
            campfireRecipe(),
            CampfireRecipe.cookCattailRoot,
          );

          deps.selection.selectMaterial(.wood);
          expect(
            campfireRecipe(),
            CampfireRecipe.makeCharcoal,
          );
        },
      );
    },
  );

  group(
    'CampfireFuelUseCase',
    () {
      test(
        'accepts wood, plastic, cloth and cardboard',
        () {
          for (final fuel in CampfireFuel.values) {
            deps.material.add(fuel.material);

            expect(
              campfireFuel(
                .boilWater,
                fuel.material,
              ),
              fuel,
            );
          }
        },
      );

      test(
        'refuses a material that does not burn',
        () async {
          deps.material.add(.sand);
          deps.selection.selectMaterial(.sand);

          expect(
            campfireFuel(
              .boilWater,
              .sand,
            ),
            isNull,
          );
          expect(
            deps.selection.selection.material,
            isNull,
          );
          await pumpEventQueue();
          expect(
            messages.single.text,
            "You can't start a fire with this",
          );
        },
      );

      test(
        'needs a second wood when wood is also in the pot',
        () async {
          addWood(1);

          expect(
            campfireFuel(
              .makeCharcoal,
              .wood,
            ),
            isNull,
          );
          await pumpEventQueue();
          expect(
            messages.single.text,
            'You need 2 wood for this',
          );

          deps.material.add(.wood);
          expect(
            campfireFuel(
              .makeCharcoal,
              .wood,
            ),
            CampfireFuel.wood,
          );
        },
      );
    },
  );

  group(
    'CookOnCampfireUseCase',
    () {
      test(
        'boils one lake water into two clean water with one wood',
        () async {
          deps.inventory
            ..add(.cookingPot)
            ..add(.lakeWater);
          addWood(2);

          expect(
            cookOnCampfire(
              .boilWater,
              .wood,
            ),
            isTrue,
          );
          expect(
            deps.inventory.count(.lakeWater),
            0,
          );
          expect(
            deps.inventory.count(.cleanWater),
            2,
          );
          expect(
            deps.inventory.count(.cookingPot),
            1,
          );
          expect(
            deps.material.count(.wood),
            1,
          );
          expect(
            deps.pollution.pollution.airPoints,
            0,
          );
          await pumpEventQueue();
          expect(
            messages.single.heroLine,
            "Now it's safe to drink.",
          );
        },
      );

      test(
        'boiling lake water from a plastic bottle gives the plastic back',
        () {
          deps.inventory
            ..add(.cookingPot)
            ..add(.lakeWaterBottle);
          addWood(1);

          expect(
            cookOnCampfire(
              .boilBottledWater,
              .wood,
            ),
            isTrue,
          );
          expect(
            deps.inventory.count(.cleanWater),
            2,
          );
          expect(
            deps.material.count(.plastic),
            1,
          );
        },
      );

      test(
        'cooks one cattail root into one cooked root',
        () {
          deps.inventory
            ..add(.cookingPot)
            ..add(.cattailRoot)
            ..add(.cattailRoot);
          addWood(1);

          expect(
            cookOnCampfire(
              .cookCattailRoot,
              .wood,
            ),
            isTrue,
          );
          expect(
            deps.inventory.count(.cattailRoot),
            1,
          );
          expect(
            deps.inventory.count(.cattailRootCooked),
            1,
          );
          expect(
            deps.material.count(.wood),
            0,
          );
        },
      );

      test(
        'turns one wood in the pot plus one wood as fuel into one charcoal',
        () {
          deps.inventory.add(.cookingPot);
          addWood(3);

          expect(
            cookOnCampfire(
              .makeCharcoal,
              .wood,
            ),
            isTrue,
          );
          expect(
            deps.material.count(.wood),
            1,
          );
          expect(
            deps.material.count(.charcoal),
            1,
          );
        },
      );

      test(
        'burning plastic as fuel pollutes the air',
        () async {
          deps.inventory
            ..add(.cookingPot)
            ..add(.lakeWater);
          deps.material.add(.plastic);

          expect(
            cookOnCampfire(
              .boilWater,
              .plastic,
            ),
            isTrue,
          );
          expect(
            deps.material.count(.plastic),
            0,
          );
          expect(
            deps.pollution.pollution.airPoints,
            3,
          );
          await pumpEventQueue();
          expect(
            messages.single,
            const FeedbackMessage(
              text: 'You boiled lake water +2 clean water\nYou burned plastic Air quality −3',
              heroLine: 'Cough... Next time I should think harder.',
              mood: .sad,
            ),
          );
        },
      );

      test(
        'does nothing when the input is gone',
        () {
          deps.inventory.add(.cookingPot);
          addWood(1);

          expect(
            cookOnCampfire(
              .cookCattailRoot,
              .wood,
            ),
            isFalse,
          );
          expect(
            deps.material.count(.wood),
            1,
          );
        },
      );

      test(
        'does nothing without the fuel',
        () {
          deps.inventory
            ..add(.cookingPot)
            ..add(.lakeWater);

          expect(
            cookOnCampfire(
              .boilWater,
              .wood,
            ),
            isFalse,
          );
          expect(
            deps.inventory.count(.lakeWater),
            1,
          );
        },
      );
    },
  );
}

import 'package:data/compost/repository/compost_repository_impl.dart';
import 'package:data/day/repository/clock_repository_impl.dart';
import 'package:data/construction/repository/construction_repository_impl.dart';
import 'package:data/day/repository/day_repository_impl.dart';
import 'package:data/feedback/repository/feedback_repository_impl.dart';
import 'package:data/player/repository/player_repository_impl.dart';
import 'package:data/pollution/repository/pollution_repository_impl.dart';
import 'package:data/sun_spot/repository/sun_spot_repository_impl.dart';
import 'package:domain/compost/model/compost_pit.dart';
import 'package:domain/construction/model/construction.dart';
import 'package:domain/day/model/game_day.dart';
import 'package:domain/day/model/level_outcome.dart';
import 'package:domain/day/use_case/pass_second_use_case.dart';
import 'package:domain/feedback/model/feedback_message.dart';
import 'package:domain/player/model/player_stats.dart';
import 'package:domain/progress/model/game_level.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late ClockRepositoryImpl clock;
  late CompostRepositoryImpl compost;
  late ConstructionRepositoryImpl constructions;
  late DayRepositoryImpl day;
  late FeedbackRepositoryImpl feedback;
  late PlayerRepositoryImpl player;
  late PollutionRepositoryImpl pollution;
  late SunSpotRepositoryImpl sunSpot;
  late PassSecondUseCase passSecond;

  setUp(() {
    clock = ClockRepositoryImpl();
    compost = CompostRepositoryImpl();
    constructions = ConstructionRepositoryImpl();
    day = DayRepositoryImpl();
    feedback = FeedbackRepositoryImpl();
    player = PlayerRepositoryImpl();
    pollution = PollutionRepositoryImpl();
    sunSpot = SunSpotRepositoryImpl();
    passSecond = PassSecondUseCase(
      clockRepository: clock,
      compostRepository: compost,
      constructionRepository: constructions,
      dayRepository: day,
      feedbackRepository: feedback,
      playerRepository: player,
      pollutionRepository: pollution,
      sunSpotRepository: sunSpot,
    );
  });

  void pass([int seconds = 1]) {
    for (var i = 0; i < seconds; i++) {
      passSecond(.level1);
    }
  }

  test(
    'every second moves the day one second forward',
    () {
      pass(5);

      expect(
        day.day,
        const GameDay(
          number: 1,
          seconds: 5,
        ),
      );
    },
  );

  test(
    'a full day drops hunger by 40 and thirst by 60',
    () {
      pass(GameDay.secondsPerDay);

      expect(
        player.stats.hunger,
        closeTo(
          40,
          0.001,
        ),
      );
      expect(
        player.stats.thirst,
        closeTo(
          20,
          0.001,
        ),
      );
    },
  );

  test(
    'the day ends after ten minutes with a night, then the next day starts at 06:00',
    () {
      pass(GameDay.secondsPerDay);

      expect(
        day.day,
        const GameDay(
          number: 2,
          seconds: 0,
          nightSeconds: GameDay.nightLength,
        ),
      );
      expect(
        day.outcome,
        isNull,
      );

      final stats = player.stats;
      pass(GameDay.nightLength);

      expect(
        day.day,
        const GameDay(
          number: 2,
          seconds: 0,
        ),
      );
      expect(
        player.stats,
        stats,
      );

      pass();
      expect(
        day.day.seconds,
        1,
      );
    },
  );

  test(
    'health recovers 10 a day while hunger and thirst are above 50',
    () {
      player.setStats(
        const PlayerStats(
          health: 50,
          hunger: 100,
          thirst: 100,
        ),
      );
      pass(300);

      expect(
        player.stats.health,
        closeTo(
          55,
          0.001,
        ),
      );
    },
  );

  test(
    'health never goes above the ceiling',
    () {
      player.setStats(
        const PlayerStats(
          health: 89.99,
          hunger: 100,
          thirst: 100,
          healthCeiling: 90,
        ),
      );
      pass(30);

      expect(
        player.stats.health,
        90,
      );
    },
  );

  test(
    'zero hunger costs 25 health a day and zero thirst costs 35',
    () {
      player.setStats(
        const PlayerStats(
          health: 100,
          hunger: 0,
          thirst: 90,
        ),
      );
      pass(60);
      expect(
        player.stats.health,
        closeTo(
          97.5,
          0.001,
        ),
      );

      player.setStats(
        const PlayerStats(
          health: 100,
          hunger: 90,
          thirst: 0,
        ),
      );
      pass(60);
      expect(
        player.stats.health,
        closeTo(
          96.5,
          0.001,
        ),
      );
    },
  );

  test(
    'hunger and thirst drop 1.5 times faster while health is below 30',
    () {
      player.setStats(
        const PlayerStats(
          health: 20,
          hunger: 40,
          thirst: 40,
        ),
      );
      pass(60);

      expect(
        player.stats.hunger,
        closeTo(
          34,
          0.001,
        ),
      );
      expect(
        player.stats.thirst,
        closeTo(
          31,
          0.001,
        ),
      );
    },
  );

  test(
    'hunger and thirst never go below zero',
    () {
      player.setStats(
        const PlayerStats(
          health: 100,
          hunger: 0.01,
          thirst: 0.01,
        ),
      );
      pass(3);

      expect(
        player.stats.hunger,
        0,
      );
      expect(
        player.stats.thirst,
        0,
      );
    },
  );

  test(
    'air pollution lowers the health ceiling at the end of the day and says so',
    () async {
      final messages = <FeedbackMessage>[];
      final subscription = feedback.messageStream.listen(messages.add);
      addTearDown(subscription.cancel);
      pollution.addAirPoints(8);
      pass(GameDay.secondsPerDay);
      await pumpEventQueue();

      expect(
        messages.single.text,
        'The air is dirty max health −20',
      );

      expect(
        player.stats.healthCeiling,
        80,
      );
      expect(
        player.stats.health,
        80,
      );
    },
  );

  test(
    'clean air keeps the health ceiling without a message',
    () async {
      final messages = <FeedbackMessage>[];
      final subscription = feedback.messageStream.listen(messages.add);
      addTearDown(subscription.cancel);
      pass(GameDay.secondsPerDay);
      await pumpEventQueue();

      expect(
        messages,
        isEmpty,
      );

      expect(
        player.stats.healthCeiling,
        100,
      );
    },
  );

  test(
    'health reaching zero ends the level as died and stops the clock',
    () {
      player.setStats(
        const PlayerStats(
          health: 0.01,
          hunger: 0,
          thirst: 0,
        ),
      );
      pass();

      expect(
        day.outcome,
        LevelOutcome.died,
      );

      final seconds = day.day.seconds;
      pass(5);

      expect(
        day.day.seconds,
        seconds,
      );
    },
  );

  test(
    'health already at zero ends the level even when the hero is fed and would recover',
    () {
      player.setStats(
        const PlayerStats(
          health: 0,
          hunger: 80,
          thirst: 80,
        ),
      );
      pass();

      expect(
        day.outcome,
        LevelOutcome.died,
      );
      expect(
        player.stats.health,
        0,
      );
    },
  );

  void startLastSecond() => day.setDay(
    const GameDay(
      number: 3,
      seconds: GameDay.secondsPerDay - 1,
    ),
  );

  void buildAll() {
    for (final construction in GameLevel.level1.goals) {
      constructions.build(construction);
    }
  }

  test(
    'the end of the last day without constructions ends the level with no time left',
    () {
      startLastSecond();
      pass();

      expect(
        day.outcome,
        LevelOutcome.noTimeLeft,
      );
      expect(
        day.day.number,
        3,
      );
    },
  );

  test(
    'the end of the last day with only some constructions built is still a loss',
    () {
      constructions
        ..build(.waterFilter)
        ..build(.rocketStove);
      startLastSecond();
      pass();

      expect(
        day.outcome,
        LevelOutcome.noTimeLeft,
      );
    },
  );

  test(
    'the end of the last day with every construction built wins the level',
    () {
      buildAll();
      startLastSecond();
      pass();

      expect(
        day.outcome,
        LevelOutcome.won,
      );
    },
  );

  test(
    'building everything early does not end the level',
    () {
      buildAll();
      pass(GameDay.secondsPerDay);

      expect(
        day.outcome,
        isNull,
      );
      expect(
        day.day.number,
        2,
      );
    },
  );

  test(
    'dying on the last second is a loss even with every construction built',
    () {
      buildAll();
      player.setStats(
        const PlayerStats(
          health: 0.01,
          hunger: 0,
          thirst: 0,
        ),
      );
      startLastSecond();
      pass();

      expect(
        day.outcome,
        LevelOutcome.died,
      );
    },
  );

  test(
    'longer levels keep going after day three',
    () {
      day.setDay(
        const GameDay(
          number: 3,
          seconds: GameDay.secondsPerDay - 1,
        ),
      );
      passSecond(.level2);

      expect(
        day.outcome,
        isNull,
      );
      expect(
        day.day,
        const GameDay(
          number: 4,
          seconds: 0,
          nightSeconds: GameDay.nightLength,
        ),
      );
    },
  );

  test(
    'compost in a full pit is ready after one day and completes the goal',
    () async {
      final messages = <FeedbackMessage>[];
      final subscription = feedback.messageStream.listen(messages.add);
      addTearDown(subscription.cancel);
      for (var i = 0; i < CompostPit.capacity; i++) {
        compost.addOrganics();
      }

      pass(CompostPit.readySeconds - 1);
      expect(
        constructions.built,
        isEmpty,
      );

      pass();
      await pumpEventQueue();

      expect(
        compost.pit.isReady,
        isTrue,
      );
      expect(
        constructions.built,
        {Construction.compostPit},
      );
      expect(
        messages.map((message) => message.text),
        contains('Your compost is ready'),
      );
    },
  );

  test(
    'nothing happens while time is paused',
    () {
      clock.setPaused(true);
      pass(10);

      expect(
        day.day.seconds,
        0,
      );
      expect(
        player.stats,
        const PlayerStats.initial(),
      );

      clock.setPaused(false);
      pass();

      expect(
        day.day.seconds,
        1,
      );
    },
  );
}

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $PlayersTable extends Players with TableInfo<$PlayersTable, Player> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PlayersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _wristSnapMeta = const VerificationMeta(
    'wristSnap',
  );
  @override
  late final GeneratedColumn<int> wristSnap = GeneratedColumn<int>(
    'wrist_snap',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(10),
  );
  static const VerificationMeta _powerMeta = const VerificationMeta('power');
  @override
  late final GeneratedColumn<int> power = GeneratedColumn<int>(
    'power',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(10),
  );
  static const VerificationMeta _accuracyMeta = const VerificationMeta(
    'accuracy',
  );
  @override
  late final GeneratedColumn<int> accuracy = GeneratedColumn<int>(
    'accuracy',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(10),
  );
  static const VerificationMeta _aggressionMeta = const VerificationMeta(
    'aggression',
  );
  @override
  late final GeneratedColumn<int> aggression = GeneratedColumn<int>(
    'aggression',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(10),
  );
  static const VerificationMeta _strengthMeta = const VerificationMeta(
    'strength',
  );
  @override
  late final GeneratedColumn<int> strength = GeneratedColumn<int>(
    'strength',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(10),
  );
  static const VerificationMeta _positioningMeta = const VerificationMeta(
    'positioning',
  );
  @override
  late final GeneratedColumn<int> positioning = GeneratedColumn<int>(
    'positioning',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(10),
  );
  static const VerificationMeta _predictabilityMeta = const VerificationMeta(
    'predictability',
  );
  @override
  late final GeneratedColumn<int> predictability = GeneratedColumn<int>(
    'predictability',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(10),
  );
  static const VerificationMeta _creativityMeta = const VerificationMeta(
    'creativity',
  );
  @override
  late final GeneratedColumn<int> creativity = GeneratedColumn<int>(
    'creativity',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(10),
  );
  static const VerificationMeta _penetrationMeta = const VerificationMeta(
    'penetration',
  );
  @override
  late final GeneratedColumn<int> penetration = GeneratedColumn<int>(
    'penetration',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(10),
  );
  static const VerificationMeta _heightMeta = const VerificationMeta('height');
  @override
  late final GeneratedColumn<int> height = GeneratedColumn<int>(
    'height',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(10),
  );
  static const VerificationMeta _formMeta = const VerificationMeta('form');
  @override
  late final GeneratedColumn<int> form = GeneratedColumn<int>(
    'form',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(10),
  );
  static const VerificationMeta _anticipationMeta = const VerificationMeta(
    'anticipation',
  );
  @override
  late final GeneratedColumn<int> anticipation = GeneratedColumn<int>(
    'anticipation',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(10),
  );
  static const VerificationMeta _footworkMeta = const VerificationMeta(
    'footwork',
  );
  @override
  late final GeneratedColumn<int> footwork = GeneratedColumn<int>(
    'footwork',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(10),
  );
  static const VerificationMeta _platformMeta = const VerificationMeta(
    'platform',
  );
  @override
  late final GeneratedColumn<int> platform = GeneratedColumn<int>(
    'platform',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(10),
  );
  static const VerificationMeta _stabilityMeta = const VerificationMeta(
    'stability',
  );
  @override
  late final GeneratedColumn<int> stability = GeneratedColumn<int>(
    'stability',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(10),
  );
  static const VerificationMeta _touchMeta = const VerificationMeta('touch');
  @override
  late final GeneratedColumn<int> touch = GeneratedColumn<int>(
    'touch',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(10),
  );
  static const VerificationMeta _visionMeta = const VerificationMeta('vision');
  @override
  late final GeneratedColumn<int> vision = GeneratedColumn<int>(
    'vision',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(10),
  );
  static const VerificationMeta _timingMeta = const VerificationMeta('timing');
  @override
  late final GeneratedColumn<int> timing = GeneratedColumn<int>(
    'timing',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(10),
  );
  static const VerificationMeta _versatilityMeta = const VerificationMeta(
    'versatility',
  );
  @override
  late final GeneratedColumn<int> versatility = GeneratedColumn<int>(
    'versatility',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(10),
  );
  static const VerificationMeta _reactionMeta = const VerificationMeta(
    'reaction',
  );
  @override
  late final GeneratedColumn<int> reaction = GeneratedColumn<int>(
    'reaction',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(10),
  );
  static const VerificationMeta _readingMeta = const VerificationMeta(
    'reading',
  );
  @override
  late final GeneratedColumn<int> reading = GeneratedColumn<int>(
    'reading',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(10),
  );
  static const VerificationMeta _intentionMeta = const VerificationMeta(
    'intention',
  );
  @override
  late final GeneratedColumn<int> intention = GeneratedColumn<int>(
    'intention',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(10),
  );
  static const VerificationMeta _controlMeta = const VerificationMeta(
    'control',
  );
  @override
  late final GeneratedColumn<int> control = GeneratedColumn<int>(
    'control',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(10),
  );
  static const VerificationMeta _ratingOhMeta = const VerificationMeta(
    'ratingOh',
  );
  @override
  late final GeneratedColumn<double> ratingOh = GeneratedColumn<double>(
    'rating_oh',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(10.0),
  );
  static const VerificationMeta _ratingOppMeta = const VerificationMeta(
    'ratingOpp',
  );
  @override
  late final GeneratedColumn<double> ratingOpp = GeneratedColumn<double>(
    'rating_opp',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(10.0),
  );
  static const VerificationMeta _ratingMbMeta = const VerificationMeta(
    'ratingMb',
  );
  @override
  late final GeneratedColumn<double> ratingMb = GeneratedColumn<double>(
    'rating_mb',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(10.0),
  );
  static const VerificationMeta _ratingSMeta = const VerificationMeta(
    'ratingS',
  );
  @override
  late final GeneratedColumn<double> ratingS = GeneratedColumn<double>(
    'rating_s',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(10.0),
  );
  static const VerificationMeta _ratingLMeta = const VerificationMeta(
    'ratingL',
  );
  @override
  late final GeneratedColumn<double> ratingL = GeneratedColumn<double>(
    'rating_l',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(10.0),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    wristSnap,
    power,
    accuracy,
    aggression,
    strength,
    positioning,
    predictability,
    creativity,
    penetration,
    height,
    form,
    anticipation,
    footwork,
    platform,
    stability,
    touch,
    vision,
    timing,
    versatility,
    reaction,
    reading,
    intention,
    control,
    ratingOh,
    ratingOpp,
    ratingMb,
    ratingS,
    ratingL,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'players';
  @override
  VerificationContext validateIntegrity(
    Insertable<Player> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('wrist_snap')) {
      context.handle(
        _wristSnapMeta,
        wristSnap.isAcceptableOrUnknown(data['wrist_snap']!, _wristSnapMeta),
      );
    }
    if (data.containsKey('power')) {
      context.handle(
        _powerMeta,
        power.isAcceptableOrUnknown(data['power']!, _powerMeta),
      );
    }
    if (data.containsKey('accuracy')) {
      context.handle(
        _accuracyMeta,
        accuracy.isAcceptableOrUnknown(data['accuracy']!, _accuracyMeta),
      );
    }
    if (data.containsKey('aggression')) {
      context.handle(
        _aggressionMeta,
        aggression.isAcceptableOrUnknown(data['aggression']!, _aggressionMeta),
      );
    }
    if (data.containsKey('strength')) {
      context.handle(
        _strengthMeta,
        strength.isAcceptableOrUnknown(data['strength']!, _strengthMeta),
      );
    }
    if (data.containsKey('positioning')) {
      context.handle(
        _positioningMeta,
        positioning.isAcceptableOrUnknown(
          data['positioning']!,
          _positioningMeta,
        ),
      );
    }
    if (data.containsKey('predictability')) {
      context.handle(
        _predictabilityMeta,
        predictability.isAcceptableOrUnknown(
          data['predictability']!,
          _predictabilityMeta,
        ),
      );
    }
    if (data.containsKey('creativity')) {
      context.handle(
        _creativityMeta,
        creativity.isAcceptableOrUnknown(data['creativity']!, _creativityMeta),
      );
    }
    if (data.containsKey('penetration')) {
      context.handle(
        _penetrationMeta,
        penetration.isAcceptableOrUnknown(
          data['penetration']!,
          _penetrationMeta,
        ),
      );
    }
    if (data.containsKey('height')) {
      context.handle(
        _heightMeta,
        height.isAcceptableOrUnknown(data['height']!, _heightMeta),
      );
    }
    if (data.containsKey('form')) {
      context.handle(
        _formMeta,
        form.isAcceptableOrUnknown(data['form']!, _formMeta),
      );
    }
    if (data.containsKey('anticipation')) {
      context.handle(
        _anticipationMeta,
        anticipation.isAcceptableOrUnknown(
          data['anticipation']!,
          _anticipationMeta,
        ),
      );
    }
    if (data.containsKey('footwork')) {
      context.handle(
        _footworkMeta,
        footwork.isAcceptableOrUnknown(data['footwork']!, _footworkMeta),
      );
    }
    if (data.containsKey('platform')) {
      context.handle(
        _platformMeta,
        platform.isAcceptableOrUnknown(data['platform']!, _platformMeta),
      );
    }
    if (data.containsKey('stability')) {
      context.handle(
        _stabilityMeta,
        stability.isAcceptableOrUnknown(data['stability']!, _stabilityMeta),
      );
    }
    if (data.containsKey('touch')) {
      context.handle(
        _touchMeta,
        touch.isAcceptableOrUnknown(data['touch']!, _touchMeta),
      );
    }
    if (data.containsKey('vision')) {
      context.handle(
        _visionMeta,
        vision.isAcceptableOrUnknown(data['vision']!, _visionMeta),
      );
    }
    if (data.containsKey('timing')) {
      context.handle(
        _timingMeta,
        timing.isAcceptableOrUnknown(data['timing']!, _timingMeta),
      );
    }
    if (data.containsKey('versatility')) {
      context.handle(
        _versatilityMeta,
        versatility.isAcceptableOrUnknown(
          data['versatility']!,
          _versatilityMeta,
        ),
      );
    }
    if (data.containsKey('reaction')) {
      context.handle(
        _reactionMeta,
        reaction.isAcceptableOrUnknown(data['reaction']!, _reactionMeta),
      );
    }
    if (data.containsKey('reading')) {
      context.handle(
        _readingMeta,
        reading.isAcceptableOrUnknown(data['reading']!, _readingMeta),
      );
    }
    if (data.containsKey('intention')) {
      context.handle(
        _intentionMeta,
        intention.isAcceptableOrUnknown(data['intention']!, _intentionMeta),
      );
    }
    if (data.containsKey('control')) {
      context.handle(
        _controlMeta,
        control.isAcceptableOrUnknown(data['control']!, _controlMeta),
      );
    }
    if (data.containsKey('rating_oh')) {
      context.handle(
        _ratingOhMeta,
        ratingOh.isAcceptableOrUnknown(data['rating_oh']!, _ratingOhMeta),
      );
    }
    if (data.containsKey('rating_opp')) {
      context.handle(
        _ratingOppMeta,
        ratingOpp.isAcceptableOrUnknown(data['rating_opp']!, _ratingOppMeta),
      );
    }
    if (data.containsKey('rating_mb')) {
      context.handle(
        _ratingMbMeta,
        ratingMb.isAcceptableOrUnknown(data['rating_mb']!, _ratingMbMeta),
      );
    }
    if (data.containsKey('rating_s')) {
      context.handle(
        _ratingSMeta,
        ratingS.isAcceptableOrUnknown(data['rating_s']!, _ratingSMeta),
      );
    }
    if (data.containsKey('rating_l')) {
      context.handle(
        _ratingLMeta,
        ratingL.isAcceptableOrUnknown(data['rating_l']!, _ratingLMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Player map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Player(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      wristSnap: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}wrist_snap'],
      )!,
      power: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}power'],
      )!,
      accuracy: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}accuracy'],
      )!,
      aggression: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}aggression'],
      )!,
      strength: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}strength'],
      )!,
      positioning: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}positioning'],
      )!,
      predictability: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}predictability'],
      )!,
      creativity: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}creativity'],
      )!,
      penetration: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}penetration'],
      )!,
      height: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}height'],
      )!,
      form: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}form'],
      )!,
      anticipation: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}anticipation'],
      )!,
      footwork: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}footwork'],
      )!,
      platform: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}platform'],
      )!,
      stability: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}stability'],
      )!,
      touch: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}touch'],
      )!,
      vision: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}vision'],
      )!,
      timing: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}timing'],
      )!,
      versatility: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}versatility'],
      )!,
      reaction: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}reaction'],
      )!,
      reading: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}reading'],
      )!,
      intention: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}intention'],
      )!,
      control: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}control'],
      )!,
      ratingOh: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}rating_oh'],
      )!,
      ratingOpp: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}rating_opp'],
      )!,
      ratingMb: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}rating_mb'],
      )!,
      ratingS: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}rating_s'],
      )!,
      ratingL: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}rating_l'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $PlayersTable createAlias(String alias) {
    return $PlayersTable(attachedDatabase, alias);
  }
}

class Player extends DataClass implements Insertable<Player> {
  final int id;
  final String name;
  final int wristSnap;
  final int power;
  final int accuracy;
  final int aggression;
  final int strength;
  final int positioning;
  final int predictability;
  final int creativity;
  final int penetration;
  final int height;
  final int form;
  final int anticipation;
  final int footwork;
  final int platform;
  final int stability;
  final int touch;
  final int vision;
  final int timing;
  final int versatility;
  final int reaction;
  final int reading;
  final int intention;
  final int control;
  final double ratingOh;
  final double ratingOpp;
  final double ratingMb;
  final double ratingS;
  final double ratingL;
  final DateTime createdAt;
  final DateTime updatedAt;
  const Player({
    required this.id,
    required this.name,
    required this.wristSnap,
    required this.power,
    required this.accuracy,
    required this.aggression,
    required this.strength,
    required this.positioning,
    required this.predictability,
    required this.creativity,
    required this.penetration,
    required this.height,
    required this.form,
    required this.anticipation,
    required this.footwork,
    required this.platform,
    required this.stability,
    required this.touch,
    required this.vision,
    required this.timing,
    required this.versatility,
    required this.reaction,
    required this.reading,
    required this.intention,
    required this.control,
    required this.ratingOh,
    required this.ratingOpp,
    required this.ratingMb,
    required this.ratingS,
    required this.ratingL,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['wrist_snap'] = Variable<int>(wristSnap);
    map['power'] = Variable<int>(power);
    map['accuracy'] = Variable<int>(accuracy);
    map['aggression'] = Variable<int>(aggression);
    map['strength'] = Variable<int>(strength);
    map['positioning'] = Variable<int>(positioning);
    map['predictability'] = Variable<int>(predictability);
    map['creativity'] = Variable<int>(creativity);
    map['penetration'] = Variable<int>(penetration);
    map['height'] = Variable<int>(height);
    map['form'] = Variable<int>(form);
    map['anticipation'] = Variable<int>(anticipation);
    map['footwork'] = Variable<int>(footwork);
    map['platform'] = Variable<int>(platform);
    map['stability'] = Variable<int>(stability);
    map['touch'] = Variable<int>(touch);
    map['vision'] = Variable<int>(vision);
    map['timing'] = Variable<int>(timing);
    map['versatility'] = Variable<int>(versatility);
    map['reaction'] = Variable<int>(reaction);
    map['reading'] = Variable<int>(reading);
    map['intention'] = Variable<int>(intention);
    map['control'] = Variable<int>(control);
    map['rating_oh'] = Variable<double>(ratingOh);
    map['rating_opp'] = Variable<double>(ratingOpp);
    map['rating_mb'] = Variable<double>(ratingMb);
    map['rating_s'] = Variable<double>(ratingS);
    map['rating_l'] = Variable<double>(ratingL);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  PlayersCompanion toCompanion(bool nullToAbsent) {
    return PlayersCompanion(
      id: Value(id),
      name: Value(name),
      wristSnap: Value(wristSnap),
      power: Value(power),
      accuracy: Value(accuracy),
      aggression: Value(aggression),
      strength: Value(strength),
      positioning: Value(positioning),
      predictability: Value(predictability),
      creativity: Value(creativity),
      penetration: Value(penetration),
      height: Value(height),
      form: Value(form),
      anticipation: Value(anticipation),
      footwork: Value(footwork),
      platform: Value(platform),
      stability: Value(stability),
      touch: Value(touch),
      vision: Value(vision),
      timing: Value(timing),
      versatility: Value(versatility),
      reaction: Value(reaction),
      reading: Value(reading),
      intention: Value(intention),
      control: Value(control),
      ratingOh: Value(ratingOh),
      ratingOpp: Value(ratingOpp),
      ratingMb: Value(ratingMb),
      ratingS: Value(ratingS),
      ratingL: Value(ratingL),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Player.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Player(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      wristSnap: serializer.fromJson<int>(json['wristSnap']),
      power: serializer.fromJson<int>(json['power']),
      accuracy: serializer.fromJson<int>(json['accuracy']),
      aggression: serializer.fromJson<int>(json['aggression']),
      strength: serializer.fromJson<int>(json['strength']),
      positioning: serializer.fromJson<int>(json['positioning']),
      predictability: serializer.fromJson<int>(json['predictability']),
      creativity: serializer.fromJson<int>(json['creativity']),
      penetration: serializer.fromJson<int>(json['penetration']),
      height: serializer.fromJson<int>(json['height']),
      form: serializer.fromJson<int>(json['form']),
      anticipation: serializer.fromJson<int>(json['anticipation']),
      footwork: serializer.fromJson<int>(json['footwork']),
      platform: serializer.fromJson<int>(json['platform']),
      stability: serializer.fromJson<int>(json['stability']),
      touch: serializer.fromJson<int>(json['touch']),
      vision: serializer.fromJson<int>(json['vision']),
      timing: serializer.fromJson<int>(json['timing']),
      versatility: serializer.fromJson<int>(json['versatility']),
      reaction: serializer.fromJson<int>(json['reaction']),
      reading: serializer.fromJson<int>(json['reading']),
      intention: serializer.fromJson<int>(json['intention']),
      control: serializer.fromJson<int>(json['control']),
      ratingOh: serializer.fromJson<double>(json['ratingOh']),
      ratingOpp: serializer.fromJson<double>(json['ratingOpp']),
      ratingMb: serializer.fromJson<double>(json['ratingMb']),
      ratingS: serializer.fromJson<double>(json['ratingS']),
      ratingL: serializer.fromJson<double>(json['ratingL']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'wristSnap': serializer.toJson<int>(wristSnap),
      'power': serializer.toJson<int>(power),
      'accuracy': serializer.toJson<int>(accuracy),
      'aggression': serializer.toJson<int>(aggression),
      'strength': serializer.toJson<int>(strength),
      'positioning': serializer.toJson<int>(positioning),
      'predictability': serializer.toJson<int>(predictability),
      'creativity': serializer.toJson<int>(creativity),
      'penetration': serializer.toJson<int>(penetration),
      'height': serializer.toJson<int>(height),
      'form': serializer.toJson<int>(form),
      'anticipation': serializer.toJson<int>(anticipation),
      'footwork': serializer.toJson<int>(footwork),
      'platform': serializer.toJson<int>(platform),
      'stability': serializer.toJson<int>(stability),
      'touch': serializer.toJson<int>(touch),
      'vision': serializer.toJson<int>(vision),
      'timing': serializer.toJson<int>(timing),
      'versatility': serializer.toJson<int>(versatility),
      'reaction': serializer.toJson<int>(reaction),
      'reading': serializer.toJson<int>(reading),
      'intention': serializer.toJson<int>(intention),
      'control': serializer.toJson<int>(control),
      'ratingOh': serializer.toJson<double>(ratingOh),
      'ratingOpp': serializer.toJson<double>(ratingOpp),
      'ratingMb': serializer.toJson<double>(ratingMb),
      'ratingS': serializer.toJson<double>(ratingS),
      'ratingL': serializer.toJson<double>(ratingL),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Player copyWith({
    int? id,
    String? name,
    int? wristSnap,
    int? power,
    int? accuracy,
    int? aggression,
    int? strength,
    int? positioning,
    int? predictability,
    int? creativity,
    int? penetration,
    int? height,
    int? form,
    int? anticipation,
    int? footwork,
    int? platform,
    int? stability,
    int? touch,
    int? vision,
    int? timing,
    int? versatility,
    int? reaction,
    int? reading,
    int? intention,
    int? control,
    double? ratingOh,
    double? ratingOpp,
    double? ratingMb,
    double? ratingS,
    double? ratingL,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => Player(
    id: id ?? this.id,
    name: name ?? this.name,
    wristSnap: wristSnap ?? this.wristSnap,
    power: power ?? this.power,
    accuracy: accuracy ?? this.accuracy,
    aggression: aggression ?? this.aggression,
    strength: strength ?? this.strength,
    positioning: positioning ?? this.positioning,
    predictability: predictability ?? this.predictability,
    creativity: creativity ?? this.creativity,
    penetration: penetration ?? this.penetration,
    height: height ?? this.height,
    form: form ?? this.form,
    anticipation: anticipation ?? this.anticipation,
    footwork: footwork ?? this.footwork,
    platform: platform ?? this.platform,
    stability: stability ?? this.stability,
    touch: touch ?? this.touch,
    vision: vision ?? this.vision,
    timing: timing ?? this.timing,
    versatility: versatility ?? this.versatility,
    reaction: reaction ?? this.reaction,
    reading: reading ?? this.reading,
    intention: intention ?? this.intention,
    control: control ?? this.control,
    ratingOh: ratingOh ?? this.ratingOh,
    ratingOpp: ratingOpp ?? this.ratingOpp,
    ratingMb: ratingMb ?? this.ratingMb,
    ratingS: ratingS ?? this.ratingS,
    ratingL: ratingL ?? this.ratingL,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  Player copyWithCompanion(PlayersCompanion data) {
    return Player(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      wristSnap: data.wristSnap.present ? data.wristSnap.value : this.wristSnap,
      power: data.power.present ? data.power.value : this.power,
      accuracy: data.accuracy.present ? data.accuracy.value : this.accuracy,
      aggression: data.aggression.present
          ? data.aggression.value
          : this.aggression,
      strength: data.strength.present ? data.strength.value : this.strength,
      positioning: data.positioning.present
          ? data.positioning.value
          : this.positioning,
      predictability: data.predictability.present
          ? data.predictability.value
          : this.predictability,
      creativity: data.creativity.present
          ? data.creativity.value
          : this.creativity,
      penetration: data.penetration.present
          ? data.penetration.value
          : this.penetration,
      height: data.height.present ? data.height.value : this.height,
      form: data.form.present ? data.form.value : this.form,
      anticipation: data.anticipation.present
          ? data.anticipation.value
          : this.anticipation,
      footwork: data.footwork.present ? data.footwork.value : this.footwork,
      platform: data.platform.present ? data.platform.value : this.platform,
      stability: data.stability.present ? data.stability.value : this.stability,
      touch: data.touch.present ? data.touch.value : this.touch,
      vision: data.vision.present ? data.vision.value : this.vision,
      timing: data.timing.present ? data.timing.value : this.timing,
      versatility: data.versatility.present
          ? data.versatility.value
          : this.versatility,
      reaction: data.reaction.present ? data.reaction.value : this.reaction,
      reading: data.reading.present ? data.reading.value : this.reading,
      intention: data.intention.present ? data.intention.value : this.intention,
      control: data.control.present ? data.control.value : this.control,
      ratingOh: data.ratingOh.present ? data.ratingOh.value : this.ratingOh,
      ratingOpp: data.ratingOpp.present ? data.ratingOpp.value : this.ratingOpp,
      ratingMb: data.ratingMb.present ? data.ratingMb.value : this.ratingMb,
      ratingS: data.ratingS.present ? data.ratingS.value : this.ratingS,
      ratingL: data.ratingL.present ? data.ratingL.value : this.ratingL,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Player(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('wristSnap: $wristSnap, ')
          ..write('power: $power, ')
          ..write('accuracy: $accuracy, ')
          ..write('aggression: $aggression, ')
          ..write('strength: $strength, ')
          ..write('positioning: $positioning, ')
          ..write('predictability: $predictability, ')
          ..write('creativity: $creativity, ')
          ..write('penetration: $penetration, ')
          ..write('height: $height, ')
          ..write('form: $form, ')
          ..write('anticipation: $anticipation, ')
          ..write('footwork: $footwork, ')
          ..write('platform: $platform, ')
          ..write('stability: $stability, ')
          ..write('touch: $touch, ')
          ..write('vision: $vision, ')
          ..write('timing: $timing, ')
          ..write('versatility: $versatility, ')
          ..write('reaction: $reaction, ')
          ..write('reading: $reading, ')
          ..write('intention: $intention, ')
          ..write('control: $control, ')
          ..write('ratingOh: $ratingOh, ')
          ..write('ratingOpp: $ratingOpp, ')
          ..write('ratingMb: $ratingMb, ')
          ..write('ratingS: $ratingS, ')
          ..write('ratingL: $ratingL, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    id,
    name,
    wristSnap,
    power,
    accuracy,
    aggression,
    strength,
    positioning,
    predictability,
    creativity,
    penetration,
    height,
    form,
    anticipation,
    footwork,
    platform,
    stability,
    touch,
    vision,
    timing,
    versatility,
    reaction,
    reading,
    intention,
    control,
    ratingOh,
    ratingOpp,
    ratingMb,
    ratingS,
    ratingL,
    createdAt,
    updatedAt,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Player &&
          other.id == this.id &&
          other.name == this.name &&
          other.wristSnap == this.wristSnap &&
          other.power == this.power &&
          other.accuracy == this.accuracy &&
          other.aggression == this.aggression &&
          other.strength == this.strength &&
          other.positioning == this.positioning &&
          other.predictability == this.predictability &&
          other.creativity == this.creativity &&
          other.penetration == this.penetration &&
          other.height == this.height &&
          other.form == this.form &&
          other.anticipation == this.anticipation &&
          other.footwork == this.footwork &&
          other.platform == this.platform &&
          other.stability == this.stability &&
          other.touch == this.touch &&
          other.vision == this.vision &&
          other.timing == this.timing &&
          other.versatility == this.versatility &&
          other.reaction == this.reaction &&
          other.reading == this.reading &&
          other.intention == this.intention &&
          other.control == this.control &&
          other.ratingOh == this.ratingOh &&
          other.ratingOpp == this.ratingOpp &&
          other.ratingMb == this.ratingMb &&
          other.ratingS == this.ratingS &&
          other.ratingL == this.ratingL &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class PlayersCompanion extends UpdateCompanion<Player> {
  final Value<int> id;
  final Value<String> name;
  final Value<int> wristSnap;
  final Value<int> power;
  final Value<int> accuracy;
  final Value<int> aggression;
  final Value<int> strength;
  final Value<int> positioning;
  final Value<int> predictability;
  final Value<int> creativity;
  final Value<int> penetration;
  final Value<int> height;
  final Value<int> form;
  final Value<int> anticipation;
  final Value<int> footwork;
  final Value<int> platform;
  final Value<int> stability;
  final Value<int> touch;
  final Value<int> vision;
  final Value<int> timing;
  final Value<int> versatility;
  final Value<int> reaction;
  final Value<int> reading;
  final Value<int> intention;
  final Value<int> control;
  final Value<double> ratingOh;
  final Value<double> ratingOpp;
  final Value<double> ratingMb;
  final Value<double> ratingS;
  final Value<double> ratingL;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const PlayersCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.wristSnap = const Value.absent(),
    this.power = const Value.absent(),
    this.accuracy = const Value.absent(),
    this.aggression = const Value.absent(),
    this.strength = const Value.absent(),
    this.positioning = const Value.absent(),
    this.predictability = const Value.absent(),
    this.creativity = const Value.absent(),
    this.penetration = const Value.absent(),
    this.height = const Value.absent(),
    this.form = const Value.absent(),
    this.anticipation = const Value.absent(),
    this.footwork = const Value.absent(),
    this.platform = const Value.absent(),
    this.stability = const Value.absent(),
    this.touch = const Value.absent(),
    this.vision = const Value.absent(),
    this.timing = const Value.absent(),
    this.versatility = const Value.absent(),
    this.reaction = const Value.absent(),
    this.reading = const Value.absent(),
    this.intention = const Value.absent(),
    this.control = const Value.absent(),
    this.ratingOh = const Value.absent(),
    this.ratingOpp = const Value.absent(),
    this.ratingMb = const Value.absent(),
    this.ratingS = const Value.absent(),
    this.ratingL = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  PlayersCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.wristSnap = const Value.absent(),
    this.power = const Value.absent(),
    this.accuracy = const Value.absent(),
    this.aggression = const Value.absent(),
    this.strength = const Value.absent(),
    this.positioning = const Value.absent(),
    this.predictability = const Value.absent(),
    this.creativity = const Value.absent(),
    this.penetration = const Value.absent(),
    this.height = const Value.absent(),
    this.form = const Value.absent(),
    this.anticipation = const Value.absent(),
    this.footwork = const Value.absent(),
    this.platform = const Value.absent(),
    this.stability = const Value.absent(),
    this.touch = const Value.absent(),
    this.vision = const Value.absent(),
    this.timing = const Value.absent(),
    this.versatility = const Value.absent(),
    this.reaction = const Value.absent(),
    this.reading = const Value.absent(),
    this.intention = const Value.absent(),
    this.control = const Value.absent(),
    this.ratingOh = const Value.absent(),
    this.ratingOpp = const Value.absent(),
    this.ratingMb = const Value.absent(),
    this.ratingS = const Value.absent(),
    this.ratingL = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : name = Value(name);
  static Insertable<Player> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<int>? wristSnap,
    Expression<int>? power,
    Expression<int>? accuracy,
    Expression<int>? aggression,
    Expression<int>? strength,
    Expression<int>? positioning,
    Expression<int>? predictability,
    Expression<int>? creativity,
    Expression<int>? penetration,
    Expression<int>? height,
    Expression<int>? form,
    Expression<int>? anticipation,
    Expression<int>? footwork,
    Expression<int>? platform,
    Expression<int>? stability,
    Expression<int>? touch,
    Expression<int>? vision,
    Expression<int>? timing,
    Expression<int>? versatility,
    Expression<int>? reaction,
    Expression<int>? reading,
    Expression<int>? intention,
    Expression<int>? control,
    Expression<double>? ratingOh,
    Expression<double>? ratingOpp,
    Expression<double>? ratingMb,
    Expression<double>? ratingS,
    Expression<double>? ratingL,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (wristSnap != null) 'wrist_snap': wristSnap,
      if (power != null) 'power': power,
      if (accuracy != null) 'accuracy': accuracy,
      if (aggression != null) 'aggression': aggression,
      if (strength != null) 'strength': strength,
      if (positioning != null) 'positioning': positioning,
      if (predictability != null) 'predictability': predictability,
      if (creativity != null) 'creativity': creativity,
      if (penetration != null) 'penetration': penetration,
      if (height != null) 'height': height,
      if (form != null) 'form': form,
      if (anticipation != null) 'anticipation': anticipation,
      if (footwork != null) 'footwork': footwork,
      if (platform != null) 'platform': platform,
      if (stability != null) 'stability': stability,
      if (touch != null) 'touch': touch,
      if (vision != null) 'vision': vision,
      if (timing != null) 'timing': timing,
      if (versatility != null) 'versatility': versatility,
      if (reaction != null) 'reaction': reaction,
      if (reading != null) 'reading': reading,
      if (intention != null) 'intention': intention,
      if (control != null) 'control': control,
      if (ratingOh != null) 'rating_oh': ratingOh,
      if (ratingOpp != null) 'rating_opp': ratingOpp,
      if (ratingMb != null) 'rating_mb': ratingMb,
      if (ratingS != null) 'rating_s': ratingS,
      if (ratingL != null) 'rating_l': ratingL,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  PlayersCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<int>? wristSnap,
    Value<int>? power,
    Value<int>? accuracy,
    Value<int>? aggression,
    Value<int>? strength,
    Value<int>? positioning,
    Value<int>? predictability,
    Value<int>? creativity,
    Value<int>? penetration,
    Value<int>? height,
    Value<int>? form,
    Value<int>? anticipation,
    Value<int>? footwork,
    Value<int>? platform,
    Value<int>? stability,
    Value<int>? touch,
    Value<int>? vision,
    Value<int>? timing,
    Value<int>? versatility,
    Value<int>? reaction,
    Value<int>? reading,
    Value<int>? intention,
    Value<int>? control,
    Value<double>? ratingOh,
    Value<double>? ratingOpp,
    Value<double>? ratingMb,
    Value<double>? ratingS,
    Value<double>? ratingL,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return PlayersCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      wristSnap: wristSnap ?? this.wristSnap,
      power: power ?? this.power,
      accuracy: accuracy ?? this.accuracy,
      aggression: aggression ?? this.aggression,
      strength: strength ?? this.strength,
      positioning: positioning ?? this.positioning,
      predictability: predictability ?? this.predictability,
      creativity: creativity ?? this.creativity,
      penetration: penetration ?? this.penetration,
      height: height ?? this.height,
      form: form ?? this.form,
      anticipation: anticipation ?? this.anticipation,
      footwork: footwork ?? this.footwork,
      platform: platform ?? this.platform,
      stability: stability ?? this.stability,
      touch: touch ?? this.touch,
      vision: vision ?? this.vision,
      timing: timing ?? this.timing,
      versatility: versatility ?? this.versatility,
      reaction: reaction ?? this.reaction,
      reading: reading ?? this.reading,
      intention: intention ?? this.intention,
      control: control ?? this.control,
      ratingOh: ratingOh ?? this.ratingOh,
      ratingOpp: ratingOpp ?? this.ratingOpp,
      ratingMb: ratingMb ?? this.ratingMb,
      ratingS: ratingS ?? this.ratingS,
      ratingL: ratingL ?? this.ratingL,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (wristSnap.present) {
      map['wrist_snap'] = Variable<int>(wristSnap.value);
    }
    if (power.present) {
      map['power'] = Variable<int>(power.value);
    }
    if (accuracy.present) {
      map['accuracy'] = Variable<int>(accuracy.value);
    }
    if (aggression.present) {
      map['aggression'] = Variable<int>(aggression.value);
    }
    if (strength.present) {
      map['strength'] = Variable<int>(strength.value);
    }
    if (positioning.present) {
      map['positioning'] = Variable<int>(positioning.value);
    }
    if (predictability.present) {
      map['predictability'] = Variable<int>(predictability.value);
    }
    if (creativity.present) {
      map['creativity'] = Variable<int>(creativity.value);
    }
    if (penetration.present) {
      map['penetration'] = Variable<int>(penetration.value);
    }
    if (height.present) {
      map['height'] = Variable<int>(height.value);
    }
    if (form.present) {
      map['form'] = Variable<int>(form.value);
    }
    if (anticipation.present) {
      map['anticipation'] = Variable<int>(anticipation.value);
    }
    if (footwork.present) {
      map['footwork'] = Variable<int>(footwork.value);
    }
    if (platform.present) {
      map['platform'] = Variable<int>(platform.value);
    }
    if (stability.present) {
      map['stability'] = Variable<int>(stability.value);
    }
    if (touch.present) {
      map['touch'] = Variable<int>(touch.value);
    }
    if (vision.present) {
      map['vision'] = Variable<int>(vision.value);
    }
    if (timing.present) {
      map['timing'] = Variable<int>(timing.value);
    }
    if (versatility.present) {
      map['versatility'] = Variable<int>(versatility.value);
    }
    if (reaction.present) {
      map['reaction'] = Variable<int>(reaction.value);
    }
    if (reading.present) {
      map['reading'] = Variable<int>(reading.value);
    }
    if (intention.present) {
      map['intention'] = Variable<int>(intention.value);
    }
    if (control.present) {
      map['control'] = Variable<int>(control.value);
    }
    if (ratingOh.present) {
      map['rating_oh'] = Variable<double>(ratingOh.value);
    }
    if (ratingOpp.present) {
      map['rating_opp'] = Variable<double>(ratingOpp.value);
    }
    if (ratingMb.present) {
      map['rating_mb'] = Variable<double>(ratingMb.value);
    }
    if (ratingS.present) {
      map['rating_s'] = Variable<double>(ratingS.value);
    }
    if (ratingL.present) {
      map['rating_l'] = Variable<double>(ratingL.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PlayersCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('wristSnap: $wristSnap, ')
          ..write('power: $power, ')
          ..write('accuracy: $accuracy, ')
          ..write('aggression: $aggression, ')
          ..write('strength: $strength, ')
          ..write('positioning: $positioning, ')
          ..write('predictability: $predictability, ')
          ..write('creativity: $creativity, ')
          ..write('penetration: $penetration, ')
          ..write('height: $height, ')
          ..write('form: $form, ')
          ..write('anticipation: $anticipation, ')
          ..write('footwork: $footwork, ')
          ..write('platform: $platform, ')
          ..write('stability: $stability, ')
          ..write('touch: $touch, ')
          ..write('vision: $vision, ')
          ..write('timing: $timing, ')
          ..write('versatility: $versatility, ')
          ..write('reaction: $reaction, ')
          ..write('reading: $reading, ')
          ..write('intention: $intention, ')
          ..write('control: $control, ')
          ..write('ratingOh: $ratingOh, ')
          ..write('ratingOpp: $ratingOpp, ')
          ..write('ratingMb: $ratingMb, ')
          ..write('ratingS: $ratingS, ')
          ..write('ratingL: $ratingL, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $TeamsTable extends Teams with TableInfo<$TeamsTable, Team> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TeamsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, name];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'teams';
  @override
  VerificationContext validateIntegrity(
    Insertable<Team> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Team map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Team(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
    );
  }

  @override
  $TeamsTable createAlias(String alias) {
    return $TeamsTable(attachedDatabase, alias);
  }
}

class Team extends DataClass implements Insertable<Team> {
  final int id;
  final String name;
  const Team({required this.id, required this.name});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    return map;
  }

  TeamsCompanion toCompanion(bool nullToAbsent) {
    return TeamsCompanion(id: Value(id), name: Value(name));
  }

  factory Team.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Team(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
    };
  }

  Team copyWith({int? id, String? name}) =>
      Team(id: id ?? this.id, name: name ?? this.name);
  Team copyWithCompanion(TeamsCompanion data) {
    return Team(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Team(')
          ..write('id: $id, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Team && other.id == this.id && other.name == this.name);
}

class TeamsCompanion extends UpdateCompanion<Team> {
  final Value<int> id;
  final Value<String> name;
  const TeamsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
  });
  TeamsCompanion.insert({this.id = const Value.absent(), required String name})
    : name = Value(name);
  static Insertable<Team> custom({
    Expression<int>? id,
    Expression<String>? name,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
    });
  }

  TeamsCompanion copyWith({Value<int>? id, Value<String>? name}) {
    return TeamsCompanion(id: id ?? this.id, name: name ?? this.name);
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TeamsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }
}

class $TeamPlayersTable extends TeamPlayers
    with TableInfo<$TeamPlayersTable, TeamPlayer> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TeamPlayersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _teamIdMeta = const VerificationMeta('teamId');
  @override
  late final GeneratedColumn<int> teamId = GeneratedColumn<int>(
    'team_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES teams (id)',
    ),
  );
  static const VerificationMeta _playerIdMeta = const VerificationMeta(
    'playerId',
  );
  @override
  late final GeneratedColumn<int> playerId = GeneratedColumn<int>(
    'player_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES players (id)',
    ),
  );
  static const VerificationMeta _roleTagMeta = const VerificationMeta(
    'roleTag',
  );
  @override
  late final GeneratedColumn<String> roleTag = GeneratedColumn<String>(
    'role_tag',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _rotationOrderMeta = const VerificationMeta(
    'rotationOrder',
  );
  @override
  late final GeneratedColumn<int> rotationOrder = GeneratedColumn<int>(
    'rotation_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isStarterMeta = const VerificationMeta(
    'isStarter',
  );
  @override
  late final GeneratedColumn<bool> isStarter = GeneratedColumn<bool>(
    'is_starter',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_starter" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    teamId,
    playerId,
    roleTag,
    rotationOrder,
    isStarter,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'team_players';
  @override
  VerificationContext validateIntegrity(
    Insertable<TeamPlayer> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('team_id')) {
      context.handle(
        _teamIdMeta,
        teamId.isAcceptableOrUnknown(data['team_id']!, _teamIdMeta),
      );
    } else if (isInserting) {
      context.missing(_teamIdMeta);
    }
    if (data.containsKey('player_id')) {
      context.handle(
        _playerIdMeta,
        playerId.isAcceptableOrUnknown(data['player_id']!, _playerIdMeta),
      );
    } else if (isInserting) {
      context.missing(_playerIdMeta);
    }
    if (data.containsKey('role_tag')) {
      context.handle(
        _roleTagMeta,
        roleTag.isAcceptableOrUnknown(data['role_tag']!, _roleTagMeta),
      );
    } else if (isInserting) {
      context.missing(_roleTagMeta);
    }
    if (data.containsKey('rotation_order')) {
      context.handle(
        _rotationOrderMeta,
        rotationOrder.isAcceptableOrUnknown(
          data['rotation_order']!,
          _rotationOrderMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_rotationOrderMeta);
    }
    if (data.containsKey('is_starter')) {
      context.handle(
        _isStarterMeta,
        isStarter.isAcceptableOrUnknown(data['is_starter']!, _isStarterMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {teamId, playerId},
    {teamId, rotationOrder},
  ];
  @override
  TeamPlayer map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TeamPlayer(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      teamId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}team_id'],
      )!,
      playerId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}player_id'],
      )!,
      roleTag: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}role_tag'],
      )!,
      rotationOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}rotation_order'],
      )!,
      isStarter: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_starter'],
      )!,
    );
  }

  @override
  $TeamPlayersTable createAlias(String alias) {
    return $TeamPlayersTable(attachedDatabase, alias);
  }
}

class TeamPlayer extends DataClass implements Insertable<TeamPlayer> {
  final int id;
  final int teamId;
  final int playerId;

  /// Role tag: S | OH1 | OH2 | MB1 | MB2 | OPP | L
  final String roleTag;

  /// Position in starting rotation (1 = serves first, 7 = libero)
  final int rotationOrder;
  final bool isStarter;
  const TeamPlayer({
    required this.id,
    required this.teamId,
    required this.playerId,
    required this.roleTag,
    required this.rotationOrder,
    required this.isStarter,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['team_id'] = Variable<int>(teamId);
    map['player_id'] = Variable<int>(playerId);
    map['role_tag'] = Variable<String>(roleTag);
    map['rotation_order'] = Variable<int>(rotationOrder);
    map['is_starter'] = Variable<bool>(isStarter);
    return map;
  }

  TeamPlayersCompanion toCompanion(bool nullToAbsent) {
    return TeamPlayersCompanion(
      id: Value(id),
      teamId: Value(teamId),
      playerId: Value(playerId),
      roleTag: Value(roleTag),
      rotationOrder: Value(rotationOrder),
      isStarter: Value(isStarter),
    );
  }

  factory TeamPlayer.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TeamPlayer(
      id: serializer.fromJson<int>(json['id']),
      teamId: serializer.fromJson<int>(json['teamId']),
      playerId: serializer.fromJson<int>(json['playerId']),
      roleTag: serializer.fromJson<String>(json['roleTag']),
      rotationOrder: serializer.fromJson<int>(json['rotationOrder']),
      isStarter: serializer.fromJson<bool>(json['isStarter']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'teamId': serializer.toJson<int>(teamId),
      'playerId': serializer.toJson<int>(playerId),
      'roleTag': serializer.toJson<String>(roleTag),
      'rotationOrder': serializer.toJson<int>(rotationOrder),
      'isStarter': serializer.toJson<bool>(isStarter),
    };
  }

  TeamPlayer copyWith({
    int? id,
    int? teamId,
    int? playerId,
    String? roleTag,
    int? rotationOrder,
    bool? isStarter,
  }) => TeamPlayer(
    id: id ?? this.id,
    teamId: teamId ?? this.teamId,
    playerId: playerId ?? this.playerId,
    roleTag: roleTag ?? this.roleTag,
    rotationOrder: rotationOrder ?? this.rotationOrder,
    isStarter: isStarter ?? this.isStarter,
  );
  TeamPlayer copyWithCompanion(TeamPlayersCompanion data) {
    return TeamPlayer(
      id: data.id.present ? data.id.value : this.id,
      teamId: data.teamId.present ? data.teamId.value : this.teamId,
      playerId: data.playerId.present ? data.playerId.value : this.playerId,
      roleTag: data.roleTag.present ? data.roleTag.value : this.roleTag,
      rotationOrder: data.rotationOrder.present
          ? data.rotationOrder.value
          : this.rotationOrder,
      isStarter: data.isStarter.present ? data.isStarter.value : this.isStarter,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TeamPlayer(')
          ..write('id: $id, ')
          ..write('teamId: $teamId, ')
          ..write('playerId: $playerId, ')
          ..write('roleTag: $roleTag, ')
          ..write('rotationOrder: $rotationOrder, ')
          ..write('isStarter: $isStarter')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, teamId, playerId, roleTag, rotationOrder, isStarter);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TeamPlayer &&
          other.id == this.id &&
          other.teamId == this.teamId &&
          other.playerId == this.playerId &&
          other.roleTag == this.roleTag &&
          other.rotationOrder == this.rotationOrder &&
          other.isStarter == this.isStarter);
}

class TeamPlayersCompanion extends UpdateCompanion<TeamPlayer> {
  final Value<int> id;
  final Value<int> teamId;
  final Value<int> playerId;
  final Value<String> roleTag;
  final Value<int> rotationOrder;
  final Value<bool> isStarter;
  const TeamPlayersCompanion({
    this.id = const Value.absent(),
    this.teamId = const Value.absent(),
    this.playerId = const Value.absent(),
    this.roleTag = const Value.absent(),
    this.rotationOrder = const Value.absent(),
    this.isStarter = const Value.absent(),
  });
  TeamPlayersCompanion.insert({
    this.id = const Value.absent(),
    required int teamId,
    required int playerId,
    required String roleTag,
    required int rotationOrder,
    this.isStarter = const Value.absent(),
  }) : teamId = Value(teamId),
       playerId = Value(playerId),
       roleTag = Value(roleTag),
       rotationOrder = Value(rotationOrder);
  static Insertable<TeamPlayer> custom({
    Expression<int>? id,
    Expression<int>? teamId,
    Expression<int>? playerId,
    Expression<String>? roleTag,
    Expression<int>? rotationOrder,
    Expression<bool>? isStarter,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (teamId != null) 'team_id': teamId,
      if (playerId != null) 'player_id': playerId,
      if (roleTag != null) 'role_tag': roleTag,
      if (rotationOrder != null) 'rotation_order': rotationOrder,
      if (isStarter != null) 'is_starter': isStarter,
    });
  }

  TeamPlayersCompanion copyWith({
    Value<int>? id,
    Value<int>? teamId,
    Value<int>? playerId,
    Value<String>? roleTag,
    Value<int>? rotationOrder,
    Value<bool>? isStarter,
  }) {
    return TeamPlayersCompanion(
      id: id ?? this.id,
      teamId: teamId ?? this.teamId,
      playerId: playerId ?? this.playerId,
      roleTag: roleTag ?? this.roleTag,
      rotationOrder: rotationOrder ?? this.rotationOrder,
      isStarter: isStarter ?? this.isStarter,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (teamId.present) {
      map['team_id'] = Variable<int>(teamId.value);
    }
    if (playerId.present) {
      map['player_id'] = Variable<int>(playerId.value);
    }
    if (roleTag.present) {
      map['role_tag'] = Variable<String>(roleTag.value);
    }
    if (rotationOrder.present) {
      map['rotation_order'] = Variable<int>(rotationOrder.value);
    }
    if (isStarter.present) {
      map['is_starter'] = Variable<bool>(isStarter.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TeamPlayersCompanion(')
          ..write('id: $id, ')
          ..write('teamId: $teamId, ')
          ..write('playerId: $playerId, ')
          ..write('roleTag: $roleTag, ')
          ..write('rotationOrder: $rotationOrder, ')
          ..write('isStarter: $isStarter')
          ..write(')'))
        .toString();
  }
}

class $SkillFormulasTable extends SkillFormulas
    with TableInfo<$SkillFormulasTable, SkillFormula> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SkillFormulasTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _skillKeyMeta = const VerificationMeta(
    'skillKey',
  );
  @override
  late final GeneratedColumn<String> skillKey = GeneratedColumn<String>(
    'skill_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _skillNameMeta = const VerificationMeta(
    'skillName',
  );
  @override
  late final GeneratedColumn<String> skillName = GeneratedColumn<String>(
    'skill_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _formulaMeta = const VerificationMeta(
    'formula',
  );
  @override
  late final GeneratedColumn<String> formula = GeneratedColumn<String>(
    'formula',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    skillKey,
    skillName,
    category,
    formula,
    isActive,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'skill_formulas';
  @override
  VerificationContext validateIntegrity(
    Insertable<SkillFormula> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('skill_key')) {
      context.handle(
        _skillKeyMeta,
        skillKey.isAcceptableOrUnknown(data['skill_key']!, _skillKeyMeta),
      );
    } else if (isInserting) {
      context.missing(_skillKeyMeta);
    }
    if (data.containsKey('skill_name')) {
      context.handle(
        _skillNameMeta,
        skillName.isAcceptableOrUnknown(data['skill_name']!, _skillNameMeta),
      );
    } else if (isInserting) {
      context.missing(_skillNameMeta);
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('formula')) {
      context.handle(
        _formulaMeta,
        formula.isAcceptableOrUnknown(data['formula']!, _formulaMeta),
      );
    } else if (isInserting) {
      context.missing(_formulaMeta);
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SkillFormula map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SkillFormula(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      skillKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}skill_key'],
      )!,
      skillName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}skill_name'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
      formula: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}formula'],
      )!,
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $SkillFormulasTable createAlias(String alias) {
    return $SkillFormulasTable(attachedDatabase, alias);
  }
}

class SkillFormula extends DataClass implements Insertable<SkillFormula> {
  final int id;

  /// Unique identifier for the skill (e.g., "serveJumpServe")
  final String skillKey;

  /// Human-readable name (e.g., "Serve a Jump Serve")
  final String skillName;

  /// Category (e.g., "serving", "blocking", "reception")
  final String category;

  /// JSON formula: {"wristSnap": 0.40, "power": 0.40, "accuracy": 0.10, "aggression": 0.10}
  final String formula;

  /// Whether this formula is active
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;
  const SkillFormula({
    required this.id,
    required this.skillKey,
    required this.skillName,
    required this.category,
    required this.formula,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['skill_key'] = Variable<String>(skillKey);
    map['skill_name'] = Variable<String>(skillName);
    map['category'] = Variable<String>(category);
    map['formula'] = Variable<String>(formula);
    map['is_active'] = Variable<bool>(isActive);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  SkillFormulasCompanion toCompanion(bool nullToAbsent) {
    return SkillFormulasCompanion(
      id: Value(id),
      skillKey: Value(skillKey),
      skillName: Value(skillName),
      category: Value(category),
      formula: Value(formula),
      isActive: Value(isActive),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory SkillFormula.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SkillFormula(
      id: serializer.fromJson<int>(json['id']),
      skillKey: serializer.fromJson<String>(json['skillKey']),
      skillName: serializer.fromJson<String>(json['skillName']),
      category: serializer.fromJson<String>(json['category']),
      formula: serializer.fromJson<String>(json['formula']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'skillKey': serializer.toJson<String>(skillKey),
      'skillName': serializer.toJson<String>(skillName),
      'category': serializer.toJson<String>(category),
      'formula': serializer.toJson<String>(formula),
      'isActive': serializer.toJson<bool>(isActive),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  SkillFormula copyWith({
    int? id,
    String? skillKey,
    String? skillName,
    String? category,
    String? formula,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => SkillFormula(
    id: id ?? this.id,
    skillKey: skillKey ?? this.skillKey,
    skillName: skillName ?? this.skillName,
    category: category ?? this.category,
    formula: formula ?? this.formula,
    isActive: isActive ?? this.isActive,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  SkillFormula copyWithCompanion(SkillFormulasCompanion data) {
    return SkillFormula(
      id: data.id.present ? data.id.value : this.id,
      skillKey: data.skillKey.present ? data.skillKey.value : this.skillKey,
      skillName: data.skillName.present ? data.skillName.value : this.skillName,
      category: data.category.present ? data.category.value : this.category,
      formula: data.formula.present ? data.formula.value : this.formula,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SkillFormula(')
          ..write('id: $id, ')
          ..write('skillKey: $skillKey, ')
          ..write('skillName: $skillName, ')
          ..write('category: $category, ')
          ..write('formula: $formula, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    skillKey,
    skillName,
    category,
    formula,
    isActive,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SkillFormula &&
          other.id == this.id &&
          other.skillKey == this.skillKey &&
          other.skillName == this.skillName &&
          other.category == this.category &&
          other.formula == this.formula &&
          other.isActive == this.isActive &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class SkillFormulasCompanion extends UpdateCompanion<SkillFormula> {
  final Value<int> id;
  final Value<String> skillKey;
  final Value<String> skillName;
  final Value<String> category;
  final Value<String> formula;
  final Value<bool> isActive;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const SkillFormulasCompanion({
    this.id = const Value.absent(),
    this.skillKey = const Value.absent(),
    this.skillName = const Value.absent(),
    this.category = const Value.absent(),
    this.formula = const Value.absent(),
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  SkillFormulasCompanion.insert({
    this.id = const Value.absent(),
    required String skillKey,
    required String skillName,
    required String category,
    required String formula,
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : skillKey = Value(skillKey),
       skillName = Value(skillName),
       category = Value(category),
       formula = Value(formula);
  static Insertable<SkillFormula> custom({
    Expression<int>? id,
    Expression<String>? skillKey,
    Expression<String>? skillName,
    Expression<String>? category,
    Expression<String>? formula,
    Expression<bool>? isActive,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (skillKey != null) 'skill_key': skillKey,
      if (skillName != null) 'skill_name': skillName,
      if (category != null) 'category': category,
      if (formula != null) 'formula': formula,
      if (isActive != null) 'is_active': isActive,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  SkillFormulasCompanion copyWith({
    Value<int>? id,
    Value<String>? skillKey,
    Value<String>? skillName,
    Value<String>? category,
    Value<String>? formula,
    Value<bool>? isActive,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return SkillFormulasCompanion(
      id: id ?? this.id,
      skillKey: skillKey ?? this.skillKey,
      skillName: skillName ?? this.skillName,
      category: category ?? this.category,
      formula: formula ?? this.formula,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (skillKey.present) {
      map['skill_key'] = Variable<String>(skillKey.value);
    }
    if (skillName.present) {
      map['skill_name'] = Variable<String>(skillName.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (formula.present) {
      map['formula'] = Variable<String>(formula.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SkillFormulasCompanion(')
          ..write('id: $id, ')
          ..write('skillKey: $skillKey, ')
          ..write('skillName: $skillName, ')
          ..write('category: $category, ')
          ..write('formula: $formula, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $OutcomeCurvesTable extends OutcomeCurves
    with TableInfo<$OutcomeCurvesTable, OutcomeCurve> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $OutcomeCurvesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _matchupKeyMeta = const VerificationMeta(
    'matchupKey',
  );
  @override
  late final GeneratedColumn<String> matchupKey = GeneratedColumn<String>(
    'matchup_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _differentialMeta = const VerificationMeta(
    'differential',
  );
  @override
  late final GeneratedColumn<double> differential = GeneratedColumn<double>(
    'differential',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _probabilitiesMeta = const VerificationMeta(
    'probabilities',
  );
  @override
  late final GeneratedColumn<String> probabilities = GeneratedColumn<String>(
    'probabilities',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    matchupKey,
    differential,
    probabilities,
    isActive,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'outcome_curves';
  @override
  VerificationContext validateIntegrity(
    Insertable<OutcomeCurve> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('matchup_key')) {
      context.handle(
        _matchupKeyMeta,
        matchupKey.isAcceptableOrUnknown(data['matchup_key']!, _matchupKeyMeta),
      );
    } else if (isInserting) {
      context.missing(_matchupKeyMeta);
    }
    if (data.containsKey('differential')) {
      context.handle(
        _differentialMeta,
        differential.isAcceptableOrUnknown(
          data['differential']!,
          _differentialMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_differentialMeta);
    }
    if (data.containsKey('probabilities')) {
      context.handle(
        _probabilitiesMeta,
        probabilities.isAcceptableOrUnknown(
          data['probabilities']!,
          _probabilitiesMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_probabilitiesMeta);
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  OutcomeCurve map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return OutcomeCurve(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      matchupKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}matchup_key'],
      )!,
      differential: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}differential'],
      )!,
      probabilities: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}probabilities'],
      )!,
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $OutcomeCurvesTable createAlias(String alias) {
    return $OutcomeCurvesTable(attachedDatabase, alias);
  }
}

class OutcomeCurve extends DataClass implements Insertable<OutcomeCurve> {
  final int id;

  /// Skill matchup identifier (e.g., "serve_vs_reception", "attack_vs_block")
  final String matchupKey;

  /// Skill differential threshold (e.g., -6.0, -3.0, 0.0, 3.0, 6.0)
  /// Positive = attacker advantage, Negative = defender advantage
  final double differential;

  /// JSON probabilities: {"ace": 0.30, "error": 0.05, "good": 0.50, "perfect": 0.15}
  final String probabilities;

  /// Whether this curve is active
  final bool isActive;
  final DateTime createdAt;
  const OutcomeCurve({
    required this.id,
    required this.matchupKey,
    required this.differential,
    required this.probabilities,
    required this.isActive,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['matchup_key'] = Variable<String>(matchupKey);
    map['differential'] = Variable<double>(differential);
    map['probabilities'] = Variable<String>(probabilities);
    map['is_active'] = Variable<bool>(isActive);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  OutcomeCurvesCompanion toCompanion(bool nullToAbsent) {
    return OutcomeCurvesCompanion(
      id: Value(id),
      matchupKey: Value(matchupKey),
      differential: Value(differential),
      probabilities: Value(probabilities),
      isActive: Value(isActive),
      createdAt: Value(createdAt),
    );
  }

  factory OutcomeCurve.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return OutcomeCurve(
      id: serializer.fromJson<int>(json['id']),
      matchupKey: serializer.fromJson<String>(json['matchupKey']),
      differential: serializer.fromJson<double>(json['differential']),
      probabilities: serializer.fromJson<String>(json['probabilities']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'matchupKey': serializer.toJson<String>(matchupKey),
      'differential': serializer.toJson<double>(differential),
      'probabilities': serializer.toJson<String>(probabilities),
      'isActive': serializer.toJson<bool>(isActive),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  OutcomeCurve copyWith({
    int? id,
    String? matchupKey,
    double? differential,
    String? probabilities,
    bool? isActive,
    DateTime? createdAt,
  }) => OutcomeCurve(
    id: id ?? this.id,
    matchupKey: matchupKey ?? this.matchupKey,
    differential: differential ?? this.differential,
    probabilities: probabilities ?? this.probabilities,
    isActive: isActive ?? this.isActive,
    createdAt: createdAt ?? this.createdAt,
  );
  OutcomeCurve copyWithCompanion(OutcomeCurvesCompanion data) {
    return OutcomeCurve(
      id: data.id.present ? data.id.value : this.id,
      matchupKey: data.matchupKey.present
          ? data.matchupKey.value
          : this.matchupKey,
      differential: data.differential.present
          ? data.differential.value
          : this.differential,
      probabilities: data.probabilities.present
          ? data.probabilities.value
          : this.probabilities,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('OutcomeCurve(')
          ..write('id: $id, ')
          ..write('matchupKey: $matchupKey, ')
          ..write('differential: $differential, ')
          ..write('probabilities: $probabilities, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    matchupKey,
    differential,
    probabilities,
    isActive,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is OutcomeCurve &&
          other.id == this.id &&
          other.matchupKey == this.matchupKey &&
          other.differential == this.differential &&
          other.probabilities == this.probabilities &&
          other.isActive == this.isActive &&
          other.createdAt == this.createdAt);
}

class OutcomeCurvesCompanion extends UpdateCompanion<OutcomeCurve> {
  final Value<int> id;
  final Value<String> matchupKey;
  final Value<double> differential;
  final Value<String> probabilities;
  final Value<bool> isActive;
  final Value<DateTime> createdAt;
  const OutcomeCurvesCompanion({
    this.id = const Value.absent(),
    this.matchupKey = const Value.absent(),
    this.differential = const Value.absent(),
    this.probabilities = const Value.absent(),
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  OutcomeCurvesCompanion.insert({
    this.id = const Value.absent(),
    required String matchupKey,
    required double differential,
    required String probabilities,
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : matchupKey = Value(matchupKey),
       differential = Value(differential),
       probabilities = Value(probabilities);
  static Insertable<OutcomeCurve> custom({
    Expression<int>? id,
    Expression<String>? matchupKey,
    Expression<double>? differential,
    Expression<String>? probabilities,
    Expression<bool>? isActive,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (matchupKey != null) 'matchup_key': matchupKey,
      if (differential != null) 'differential': differential,
      if (probabilities != null) 'probabilities': probabilities,
      if (isActive != null) 'is_active': isActive,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  OutcomeCurvesCompanion copyWith({
    Value<int>? id,
    Value<String>? matchupKey,
    Value<double>? differential,
    Value<String>? probabilities,
    Value<bool>? isActive,
    Value<DateTime>? createdAt,
  }) {
    return OutcomeCurvesCompanion(
      id: id ?? this.id,
      matchupKey: matchupKey ?? this.matchupKey,
      differential: differential ?? this.differential,
      probabilities: probabilities ?? this.probabilities,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (matchupKey.present) {
      map['matchup_key'] = Variable<String>(matchupKey.value);
    }
    if (differential.present) {
      map['differential'] = Variable<double>(differential.value);
    }
    if (probabilities.present) {
      map['probabilities'] = Variable<String>(probabilities.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OutcomeCurvesCompanion(')
          ..write('id: $id, ')
          ..write('matchupKey: $matchupKey, ')
          ..write('differential: $differential, ')
          ..write('probabilities: $probabilities, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $MatchesTable extends Matches with TableInfo<$MatchesTable, Match> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MatchesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _homeTeamIdMeta = const VerificationMeta(
    'homeTeamId',
  );
  @override
  late final GeneratedColumn<int> homeTeamId = GeneratedColumn<int>(
    'home_team_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES teams (id)',
    ),
  );
  static const VerificationMeta _awayTeamIdMeta = const VerificationMeta(
    'awayTeamId',
  );
  @override
  late final GeneratedColumn<int> awayTeamId = GeneratedColumn<int>(
    'away_team_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES teams (id)',
    ),
  );
  static const VerificationMeta _startedAtMeta = const VerificationMeta(
    'startedAt',
  );
  @override
  late final GeneratedColumn<DateTime> startedAt = GeneratedColumn<DateTime>(
    'started_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _completedAtMeta = const VerificationMeta(
    'completedAt',
  );
  @override
  late final GeneratedColumn<DateTime> completedAt = GeneratedColumn<DateTime>(
    'completed_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _homeScoreMeta = const VerificationMeta(
    'homeScore',
  );
  @override
  late final GeneratedColumn<int> homeScore = GeneratedColumn<int>(
    'home_score',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _awayScoreMeta = const VerificationMeta(
    'awayScore',
  );
  @override
  late final GeneratedColumn<int> awayScore = GeneratedColumn<int>(
    'away_score',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _isCompleteMeta = const VerificationMeta(
    'isComplete',
  );
  @override
  late final GeneratedColumn<bool> isComplete = GeneratedColumn<bool>(
    'is_complete',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_complete" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    homeTeamId,
    awayTeamId,
    startedAt,
    completedAt,
    homeScore,
    awayScore,
    isComplete,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'matches';
  @override
  VerificationContext validateIntegrity(
    Insertable<Match> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('home_team_id')) {
      context.handle(
        _homeTeamIdMeta,
        homeTeamId.isAcceptableOrUnknown(
          data['home_team_id']!,
          _homeTeamIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_homeTeamIdMeta);
    }
    if (data.containsKey('away_team_id')) {
      context.handle(
        _awayTeamIdMeta,
        awayTeamId.isAcceptableOrUnknown(
          data['away_team_id']!,
          _awayTeamIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_awayTeamIdMeta);
    }
    if (data.containsKey('started_at')) {
      context.handle(
        _startedAtMeta,
        startedAt.isAcceptableOrUnknown(data['started_at']!, _startedAtMeta),
      );
    }
    if (data.containsKey('completed_at')) {
      context.handle(
        _completedAtMeta,
        completedAt.isAcceptableOrUnknown(
          data['completed_at']!,
          _completedAtMeta,
        ),
      );
    }
    if (data.containsKey('home_score')) {
      context.handle(
        _homeScoreMeta,
        homeScore.isAcceptableOrUnknown(data['home_score']!, _homeScoreMeta),
      );
    }
    if (data.containsKey('away_score')) {
      context.handle(
        _awayScoreMeta,
        awayScore.isAcceptableOrUnknown(data['away_score']!, _awayScoreMeta),
      );
    }
    if (data.containsKey('is_complete')) {
      context.handle(
        _isCompleteMeta,
        isComplete.isAcceptableOrUnknown(data['is_complete']!, _isCompleteMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Match map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Match(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      homeTeamId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}home_team_id'],
      )!,
      awayTeamId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}away_team_id'],
      )!,
      startedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}started_at'],
      )!,
      completedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}completed_at'],
      ),
      homeScore: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}home_score'],
      )!,
      awayScore: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}away_score'],
      )!,
      isComplete: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_complete'],
      )!,
    );
  }

  @override
  $MatchesTable createAlias(String alias) {
    return $MatchesTable(attachedDatabase, alias);
  }
}

class Match extends DataClass implements Insertable<Match> {
  final int id;
  final int homeTeamId;
  final int awayTeamId;
  final DateTime startedAt;
  final DateTime? completedAt;
  final int homeScore;
  final int awayScore;
  final bool isComplete;
  const Match({
    required this.id,
    required this.homeTeamId,
    required this.awayTeamId,
    required this.startedAt,
    this.completedAt,
    required this.homeScore,
    required this.awayScore,
    required this.isComplete,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['home_team_id'] = Variable<int>(homeTeamId);
    map['away_team_id'] = Variable<int>(awayTeamId);
    map['started_at'] = Variable<DateTime>(startedAt);
    if (!nullToAbsent || completedAt != null) {
      map['completed_at'] = Variable<DateTime>(completedAt);
    }
    map['home_score'] = Variable<int>(homeScore);
    map['away_score'] = Variable<int>(awayScore);
    map['is_complete'] = Variable<bool>(isComplete);
    return map;
  }

  MatchesCompanion toCompanion(bool nullToAbsent) {
    return MatchesCompanion(
      id: Value(id),
      homeTeamId: Value(homeTeamId),
      awayTeamId: Value(awayTeamId),
      startedAt: Value(startedAt),
      completedAt: completedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(completedAt),
      homeScore: Value(homeScore),
      awayScore: Value(awayScore),
      isComplete: Value(isComplete),
    );
  }

  factory Match.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Match(
      id: serializer.fromJson<int>(json['id']),
      homeTeamId: serializer.fromJson<int>(json['homeTeamId']),
      awayTeamId: serializer.fromJson<int>(json['awayTeamId']),
      startedAt: serializer.fromJson<DateTime>(json['startedAt']),
      completedAt: serializer.fromJson<DateTime?>(json['completedAt']),
      homeScore: serializer.fromJson<int>(json['homeScore']),
      awayScore: serializer.fromJson<int>(json['awayScore']),
      isComplete: serializer.fromJson<bool>(json['isComplete']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'homeTeamId': serializer.toJson<int>(homeTeamId),
      'awayTeamId': serializer.toJson<int>(awayTeamId),
      'startedAt': serializer.toJson<DateTime>(startedAt),
      'completedAt': serializer.toJson<DateTime?>(completedAt),
      'homeScore': serializer.toJson<int>(homeScore),
      'awayScore': serializer.toJson<int>(awayScore),
      'isComplete': serializer.toJson<bool>(isComplete),
    };
  }

  Match copyWith({
    int? id,
    int? homeTeamId,
    int? awayTeamId,
    DateTime? startedAt,
    Value<DateTime?> completedAt = const Value.absent(),
    int? homeScore,
    int? awayScore,
    bool? isComplete,
  }) => Match(
    id: id ?? this.id,
    homeTeamId: homeTeamId ?? this.homeTeamId,
    awayTeamId: awayTeamId ?? this.awayTeamId,
    startedAt: startedAt ?? this.startedAt,
    completedAt: completedAt.present ? completedAt.value : this.completedAt,
    homeScore: homeScore ?? this.homeScore,
    awayScore: awayScore ?? this.awayScore,
    isComplete: isComplete ?? this.isComplete,
  );
  Match copyWithCompanion(MatchesCompanion data) {
    return Match(
      id: data.id.present ? data.id.value : this.id,
      homeTeamId: data.homeTeamId.present
          ? data.homeTeamId.value
          : this.homeTeamId,
      awayTeamId: data.awayTeamId.present
          ? data.awayTeamId.value
          : this.awayTeamId,
      startedAt: data.startedAt.present ? data.startedAt.value : this.startedAt,
      completedAt: data.completedAt.present
          ? data.completedAt.value
          : this.completedAt,
      homeScore: data.homeScore.present ? data.homeScore.value : this.homeScore,
      awayScore: data.awayScore.present ? data.awayScore.value : this.awayScore,
      isComplete: data.isComplete.present
          ? data.isComplete.value
          : this.isComplete,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Match(')
          ..write('id: $id, ')
          ..write('homeTeamId: $homeTeamId, ')
          ..write('awayTeamId: $awayTeamId, ')
          ..write('startedAt: $startedAt, ')
          ..write('completedAt: $completedAt, ')
          ..write('homeScore: $homeScore, ')
          ..write('awayScore: $awayScore, ')
          ..write('isComplete: $isComplete')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    homeTeamId,
    awayTeamId,
    startedAt,
    completedAt,
    homeScore,
    awayScore,
    isComplete,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Match &&
          other.id == this.id &&
          other.homeTeamId == this.homeTeamId &&
          other.awayTeamId == this.awayTeamId &&
          other.startedAt == this.startedAt &&
          other.completedAt == this.completedAt &&
          other.homeScore == this.homeScore &&
          other.awayScore == this.awayScore &&
          other.isComplete == this.isComplete);
}

class MatchesCompanion extends UpdateCompanion<Match> {
  final Value<int> id;
  final Value<int> homeTeamId;
  final Value<int> awayTeamId;
  final Value<DateTime> startedAt;
  final Value<DateTime?> completedAt;
  final Value<int> homeScore;
  final Value<int> awayScore;
  final Value<bool> isComplete;
  const MatchesCompanion({
    this.id = const Value.absent(),
    this.homeTeamId = const Value.absent(),
    this.awayTeamId = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.homeScore = const Value.absent(),
    this.awayScore = const Value.absent(),
    this.isComplete = const Value.absent(),
  });
  MatchesCompanion.insert({
    this.id = const Value.absent(),
    required int homeTeamId,
    required int awayTeamId,
    this.startedAt = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.homeScore = const Value.absent(),
    this.awayScore = const Value.absent(),
    this.isComplete = const Value.absent(),
  }) : homeTeamId = Value(homeTeamId),
       awayTeamId = Value(awayTeamId);
  static Insertable<Match> custom({
    Expression<int>? id,
    Expression<int>? homeTeamId,
    Expression<int>? awayTeamId,
    Expression<DateTime>? startedAt,
    Expression<DateTime>? completedAt,
    Expression<int>? homeScore,
    Expression<int>? awayScore,
    Expression<bool>? isComplete,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (homeTeamId != null) 'home_team_id': homeTeamId,
      if (awayTeamId != null) 'away_team_id': awayTeamId,
      if (startedAt != null) 'started_at': startedAt,
      if (completedAt != null) 'completed_at': completedAt,
      if (homeScore != null) 'home_score': homeScore,
      if (awayScore != null) 'away_score': awayScore,
      if (isComplete != null) 'is_complete': isComplete,
    });
  }

  MatchesCompanion copyWith({
    Value<int>? id,
    Value<int>? homeTeamId,
    Value<int>? awayTeamId,
    Value<DateTime>? startedAt,
    Value<DateTime?>? completedAt,
    Value<int>? homeScore,
    Value<int>? awayScore,
    Value<bool>? isComplete,
  }) {
    return MatchesCompanion(
      id: id ?? this.id,
      homeTeamId: homeTeamId ?? this.homeTeamId,
      awayTeamId: awayTeamId ?? this.awayTeamId,
      startedAt: startedAt ?? this.startedAt,
      completedAt: completedAt ?? this.completedAt,
      homeScore: homeScore ?? this.homeScore,
      awayScore: awayScore ?? this.awayScore,
      isComplete: isComplete ?? this.isComplete,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (homeTeamId.present) {
      map['home_team_id'] = Variable<int>(homeTeamId.value);
    }
    if (awayTeamId.present) {
      map['away_team_id'] = Variable<int>(awayTeamId.value);
    }
    if (startedAt.present) {
      map['started_at'] = Variable<DateTime>(startedAt.value);
    }
    if (completedAt.present) {
      map['completed_at'] = Variable<DateTime>(completedAt.value);
    }
    if (homeScore.present) {
      map['home_score'] = Variable<int>(homeScore.value);
    }
    if (awayScore.present) {
      map['away_score'] = Variable<int>(awayScore.value);
    }
    if (isComplete.present) {
      map['is_complete'] = Variable<bool>(isComplete.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MatchesCompanion(')
          ..write('id: $id, ')
          ..write('homeTeamId: $homeTeamId, ')
          ..write('awayTeamId: $awayTeamId, ')
          ..write('startedAt: $startedAt, ')
          ..write('completedAt: $completedAt, ')
          ..write('homeScore: $homeScore, ')
          ..write('awayScore: $awayScore, ')
          ..write('isComplete: $isComplete')
          ..write(')'))
        .toString();
  }
}

class $MatchAuditLogTable extends MatchAuditLog
    with TableInfo<$MatchAuditLogTable, MatchAuditEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MatchAuditLogTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _matchIdMeta = const VerificationMeta(
    'matchId',
  );
  @override
  late final GeneratedColumn<int> matchId = GeneratedColumn<int>(
    'match_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _rallyIdMeta = const VerificationMeta(
    'rallyId',
  );
  @override
  late final GeneratedColumn<int> rallyId = GeneratedColumn<int>(
    'rally_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _phaseMeta = const VerificationMeta('phase');
  @override
  late final GeneratedColumn<String> phase = GeneratedColumn<String>(
    'phase',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _eventTypeMeta = const VerificationMeta(
    'eventType',
  );
  @override
  late final GeneratedColumn<String> eventType = GeneratedColumn<String>(
    'event_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _payloadMeta = const VerificationMeta(
    'payload',
  );
  @override
  late final GeneratedColumn<String> payload = GeneratedColumn<String>(
    'payload',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _occurredAtMeta = const VerificationMeta(
    'occurredAt',
  );
  @override
  late final GeneratedColumn<DateTime> occurredAt = GeneratedColumn<DateTime>(
    'occurred_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    matchId,
    rallyId,
    phase,
    eventType,
    payload,
    occurredAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'match_audit_log';
  @override
  VerificationContext validateIntegrity(
    Insertable<MatchAuditEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('match_id')) {
      context.handle(
        _matchIdMeta,
        matchId.isAcceptableOrUnknown(data['match_id']!, _matchIdMeta),
      );
    } else if (isInserting) {
      context.missing(_matchIdMeta);
    }
    if (data.containsKey('rally_id')) {
      context.handle(
        _rallyIdMeta,
        rallyId.isAcceptableOrUnknown(data['rally_id']!, _rallyIdMeta),
      );
    } else if (isInserting) {
      context.missing(_rallyIdMeta);
    }
    if (data.containsKey('phase')) {
      context.handle(
        _phaseMeta,
        phase.isAcceptableOrUnknown(data['phase']!, _phaseMeta),
      );
    } else if (isInserting) {
      context.missing(_phaseMeta);
    }
    if (data.containsKey('event_type')) {
      context.handle(
        _eventTypeMeta,
        eventType.isAcceptableOrUnknown(data['event_type']!, _eventTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_eventTypeMeta);
    }
    if (data.containsKey('payload')) {
      context.handle(
        _payloadMeta,
        payload.isAcceptableOrUnknown(data['payload']!, _payloadMeta),
      );
    } else if (isInserting) {
      context.missing(_payloadMeta);
    }
    if (data.containsKey('occurred_at')) {
      context.handle(
        _occurredAtMeta,
        occurredAt.isAcceptableOrUnknown(data['occurred_at']!, _occurredAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MatchAuditEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MatchAuditEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      matchId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}match_id'],
      )!,
      rallyId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}rally_id'],
      )!,
      phase: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}phase'],
      )!,
      eventType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}event_type'],
      )!,
      payload: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payload'],
      )!,
      occurredAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}occurred_at'],
      )!,
    );
  }

  @override
  $MatchAuditLogTable createAlias(String alias) {
    return $MatchAuditLogTable(attachedDatabase, alias);
  }
}

class MatchAuditEntry extends DataClass implements Insertable<MatchAuditEntry> {
  final int id;
  final int matchId;
  final int rallyId;

  /// Match phase: preServe | serve | reception | setting | attack | rallyEnd
  final String phase;

  /// Event type: phaseChanged | serveBallFlight | scoreChanged |
  ///             rotationAdvanced | rallyEnded | attackOutcome |
  ///             passOutcome | setOutcome | serveOutcome
  final String eventType;

  /// JSON payload — varies by eventType.
  ///
  /// For outcome events includes:
  /// { score, rotationHome, rotationAway, serverSide, result,
  ///   playerComparison: { serverSkill, receiverSkill, differential, probs } }
  final String payload;
  final DateTime occurredAt;
  const MatchAuditEntry({
    required this.id,
    required this.matchId,
    required this.rallyId,
    required this.phase,
    required this.eventType,
    required this.payload,
    required this.occurredAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['match_id'] = Variable<int>(matchId);
    map['rally_id'] = Variable<int>(rallyId);
    map['phase'] = Variable<String>(phase);
    map['event_type'] = Variable<String>(eventType);
    map['payload'] = Variable<String>(payload);
    map['occurred_at'] = Variable<DateTime>(occurredAt);
    return map;
  }

  MatchAuditLogCompanion toCompanion(bool nullToAbsent) {
    return MatchAuditLogCompanion(
      id: Value(id),
      matchId: Value(matchId),
      rallyId: Value(rallyId),
      phase: Value(phase),
      eventType: Value(eventType),
      payload: Value(payload),
      occurredAt: Value(occurredAt),
    );
  }

  factory MatchAuditEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MatchAuditEntry(
      id: serializer.fromJson<int>(json['id']),
      matchId: serializer.fromJson<int>(json['matchId']),
      rallyId: serializer.fromJson<int>(json['rallyId']),
      phase: serializer.fromJson<String>(json['phase']),
      eventType: serializer.fromJson<String>(json['eventType']),
      payload: serializer.fromJson<String>(json['payload']),
      occurredAt: serializer.fromJson<DateTime>(json['occurredAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'matchId': serializer.toJson<int>(matchId),
      'rallyId': serializer.toJson<int>(rallyId),
      'phase': serializer.toJson<String>(phase),
      'eventType': serializer.toJson<String>(eventType),
      'payload': serializer.toJson<String>(payload),
      'occurredAt': serializer.toJson<DateTime>(occurredAt),
    };
  }

  MatchAuditEntry copyWith({
    int? id,
    int? matchId,
    int? rallyId,
    String? phase,
    String? eventType,
    String? payload,
    DateTime? occurredAt,
  }) => MatchAuditEntry(
    id: id ?? this.id,
    matchId: matchId ?? this.matchId,
    rallyId: rallyId ?? this.rallyId,
    phase: phase ?? this.phase,
    eventType: eventType ?? this.eventType,
    payload: payload ?? this.payload,
    occurredAt: occurredAt ?? this.occurredAt,
  );
  MatchAuditEntry copyWithCompanion(MatchAuditLogCompanion data) {
    return MatchAuditEntry(
      id: data.id.present ? data.id.value : this.id,
      matchId: data.matchId.present ? data.matchId.value : this.matchId,
      rallyId: data.rallyId.present ? data.rallyId.value : this.rallyId,
      phase: data.phase.present ? data.phase.value : this.phase,
      eventType: data.eventType.present ? data.eventType.value : this.eventType,
      payload: data.payload.present ? data.payload.value : this.payload,
      occurredAt: data.occurredAt.present
          ? data.occurredAt.value
          : this.occurredAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MatchAuditEntry(')
          ..write('id: $id, ')
          ..write('matchId: $matchId, ')
          ..write('rallyId: $rallyId, ')
          ..write('phase: $phase, ')
          ..write('eventType: $eventType, ')
          ..write('payload: $payload, ')
          ..write('occurredAt: $occurredAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, matchId, rallyId, phase, eventType, payload, occurredAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MatchAuditEntry &&
          other.id == this.id &&
          other.matchId == this.matchId &&
          other.rallyId == this.rallyId &&
          other.phase == this.phase &&
          other.eventType == this.eventType &&
          other.payload == this.payload &&
          other.occurredAt == this.occurredAt);
}

class MatchAuditLogCompanion extends UpdateCompanion<MatchAuditEntry> {
  final Value<int> id;
  final Value<int> matchId;
  final Value<int> rallyId;
  final Value<String> phase;
  final Value<String> eventType;
  final Value<String> payload;
  final Value<DateTime> occurredAt;
  const MatchAuditLogCompanion({
    this.id = const Value.absent(),
    this.matchId = const Value.absent(),
    this.rallyId = const Value.absent(),
    this.phase = const Value.absent(),
    this.eventType = const Value.absent(),
    this.payload = const Value.absent(),
    this.occurredAt = const Value.absent(),
  });
  MatchAuditLogCompanion.insert({
    this.id = const Value.absent(),
    required int matchId,
    required int rallyId,
    required String phase,
    required String eventType,
    required String payload,
    this.occurredAt = const Value.absent(),
  }) : matchId = Value(matchId),
       rallyId = Value(rallyId),
       phase = Value(phase),
       eventType = Value(eventType),
       payload = Value(payload);
  static Insertable<MatchAuditEntry> custom({
    Expression<int>? id,
    Expression<int>? matchId,
    Expression<int>? rallyId,
    Expression<String>? phase,
    Expression<String>? eventType,
    Expression<String>? payload,
    Expression<DateTime>? occurredAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (matchId != null) 'match_id': matchId,
      if (rallyId != null) 'rally_id': rallyId,
      if (phase != null) 'phase': phase,
      if (eventType != null) 'event_type': eventType,
      if (payload != null) 'payload': payload,
      if (occurredAt != null) 'occurred_at': occurredAt,
    });
  }

  MatchAuditLogCompanion copyWith({
    Value<int>? id,
    Value<int>? matchId,
    Value<int>? rallyId,
    Value<String>? phase,
    Value<String>? eventType,
    Value<String>? payload,
    Value<DateTime>? occurredAt,
  }) {
    return MatchAuditLogCompanion(
      id: id ?? this.id,
      matchId: matchId ?? this.matchId,
      rallyId: rallyId ?? this.rallyId,
      phase: phase ?? this.phase,
      eventType: eventType ?? this.eventType,
      payload: payload ?? this.payload,
      occurredAt: occurredAt ?? this.occurredAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (matchId.present) {
      map['match_id'] = Variable<int>(matchId.value);
    }
    if (rallyId.present) {
      map['rally_id'] = Variable<int>(rallyId.value);
    }
    if (phase.present) {
      map['phase'] = Variable<String>(phase.value);
    }
    if (eventType.present) {
      map['event_type'] = Variable<String>(eventType.value);
    }
    if (payload.present) {
      map['payload'] = Variable<String>(payload.value);
    }
    if (occurredAt.present) {
      map['occurred_at'] = Variable<DateTime>(occurredAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MatchAuditLogCompanion(')
          ..write('id: $id, ')
          ..write('matchId: $matchId, ')
          ..write('rallyId: $rallyId, ')
          ..write('phase: $phase, ')
          ..write('eventType: $eventType, ')
          ..write('payload: $payload, ')
          ..write('occurredAt: $occurredAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $PlayersTable players = $PlayersTable(this);
  late final $TeamsTable teams = $TeamsTable(this);
  late final $TeamPlayersTable teamPlayers = $TeamPlayersTable(this);
  late final $SkillFormulasTable skillFormulas = $SkillFormulasTable(this);
  late final $OutcomeCurvesTable outcomeCurves = $OutcomeCurvesTable(this);
  late final $MatchesTable matches = $MatchesTable(this);
  late final $MatchAuditLogTable matchAuditLog = $MatchAuditLogTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    players,
    teams,
    teamPlayers,
    skillFormulas,
    outcomeCurves,
    matches,
    matchAuditLog,
  ];
}

typedef $$PlayersTableCreateCompanionBuilder =
    PlayersCompanion Function({
      Value<int> id,
      required String name,
      Value<int> wristSnap,
      Value<int> power,
      Value<int> accuracy,
      Value<int> aggression,
      Value<int> strength,
      Value<int> positioning,
      Value<int> predictability,
      Value<int> creativity,
      Value<int> penetration,
      Value<int> height,
      Value<int> form,
      Value<int> anticipation,
      Value<int> footwork,
      Value<int> platform,
      Value<int> stability,
      Value<int> touch,
      Value<int> vision,
      Value<int> timing,
      Value<int> versatility,
      Value<int> reaction,
      Value<int> reading,
      Value<int> intention,
      Value<int> control,
      Value<double> ratingOh,
      Value<double> ratingOpp,
      Value<double> ratingMb,
      Value<double> ratingS,
      Value<double> ratingL,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });
typedef $$PlayersTableUpdateCompanionBuilder =
    PlayersCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<int> wristSnap,
      Value<int> power,
      Value<int> accuracy,
      Value<int> aggression,
      Value<int> strength,
      Value<int> positioning,
      Value<int> predictability,
      Value<int> creativity,
      Value<int> penetration,
      Value<int> height,
      Value<int> form,
      Value<int> anticipation,
      Value<int> footwork,
      Value<int> platform,
      Value<int> stability,
      Value<int> touch,
      Value<int> vision,
      Value<int> timing,
      Value<int> versatility,
      Value<int> reaction,
      Value<int> reading,
      Value<int> intention,
      Value<int> control,
      Value<double> ratingOh,
      Value<double> ratingOpp,
      Value<double> ratingMb,
      Value<double> ratingS,
      Value<double> ratingL,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });

final class $$PlayersTableReferences
    extends BaseReferences<_$AppDatabase, $PlayersTable, Player> {
  $$PlayersTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$TeamPlayersTable, List<TeamPlayer>>
  _teamPlayersRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.teamPlayers,
    aliasName: $_aliasNameGenerator(db.players.id, db.teamPlayers.playerId),
  );

  $$TeamPlayersTableProcessedTableManager get teamPlayersRefs {
    final manager = $$TeamPlayersTableTableManager(
      $_db,
      $_db.teamPlayers,
    ).filter((f) => f.playerId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_teamPlayersRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$PlayersTableFilterComposer
    extends Composer<_$AppDatabase, $PlayersTable> {
  $$PlayersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get wristSnap => $composableBuilder(
    column: $table.wristSnap,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get power => $composableBuilder(
    column: $table.power,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get accuracy => $composableBuilder(
    column: $table.accuracy,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get aggression => $composableBuilder(
    column: $table.aggression,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get strength => $composableBuilder(
    column: $table.strength,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get positioning => $composableBuilder(
    column: $table.positioning,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get predictability => $composableBuilder(
    column: $table.predictability,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get creativity => $composableBuilder(
    column: $table.creativity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get penetration => $composableBuilder(
    column: $table.penetration,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get height => $composableBuilder(
    column: $table.height,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get form => $composableBuilder(
    column: $table.form,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get anticipation => $composableBuilder(
    column: $table.anticipation,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get footwork => $composableBuilder(
    column: $table.footwork,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get platform => $composableBuilder(
    column: $table.platform,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get stability => $composableBuilder(
    column: $table.stability,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get touch => $composableBuilder(
    column: $table.touch,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get vision => $composableBuilder(
    column: $table.vision,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get timing => $composableBuilder(
    column: $table.timing,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get versatility => $composableBuilder(
    column: $table.versatility,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get reaction => $composableBuilder(
    column: $table.reaction,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get reading => $composableBuilder(
    column: $table.reading,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get intention => $composableBuilder(
    column: $table.intention,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get control => $composableBuilder(
    column: $table.control,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get ratingOh => $composableBuilder(
    column: $table.ratingOh,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get ratingOpp => $composableBuilder(
    column: $table.ratingOpp,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get ratingMb => $composableBuilder(
    column: $table.ratingMb,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get ratingS => $composableBuilder(
    column: $table.ratingS,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get ratingL => $composableBuilder(
    column: $table.ratingL,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> teamPlayersRefs(
    Expression<bool> Function($$TeamPlayersTableFilterComposer f) f,
  ) {
    final $$TeamPlayersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.teamPlayers,
      getReferencedColumn: (t) => t.playerId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TeamPlayersTableFilterComposer(
            $db: $db,
            $table: $db.teamPlayers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PlayersTableOrderingComposer
    extends Composer<_$AppDatabase, $PlayersTable> {
  $$PlayersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get wristSnap => $composableBuilder(
    column: $table.wristSnap,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get power => $composableBuilder(
    column: $table.power,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get accuracy => $composableBuilder(
    column: $table.accuracy,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get aggression => $composableBuilder(
    column: $table.aggression,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get strength => $composableBuilder(
    column: $table.strength,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get positioning => $composableBuilder(
    column: $table.positioning,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get predictability => $composableBuilder(
    column: $table.predictability,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get creativity => $composableBuilder(
    column: $table.creativity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get penetration => $composableBuilder(
    column: $table.penetration,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get height => $composableBuilder(
    column: $table.height,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get form => $composableBuilder(
    column: $table.form,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get anticipation => $composableBuilder(
    column: $table.anticipation,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get footwork => $composableBuilder(
    column: $table.footwork,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get platform => $composableBuilder(
    column: $table.platform,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get stability => $composableBuilder(
    column: $table.stability,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get touch => $composableBuilder(
    column: $table.touch,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get vision => $composableBuilder(
    column: $table.vision,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get timing => $composableBuilder(
    column: $table.timing,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get versatility => $composableBuilder(
    column: $table.versatility,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get reaction => $composableBuilder(
    column: $table.reaction,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get reading => $composableBuilder(
    column: $table.reading,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get intention => $composableBuilder(
    column: $table.intention,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get control => $composableBuilder(
    column: $table.control,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get ratingOh => $composableBuilder(
    column: $table.ratingOh,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get ratingOpp => $composableBuilder(
    column: $table.ratingOpp,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get ratingMb => $composableBuilder(
    column: $table.ratingMb,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get ratingS => $composableBuilder(
    column: $table.ratingS,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get ratingL => $composableBuilder(
    column: $table.ratingL,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PlayersTableAnnotationComposer
    extends Composer<_$AppDatabase, $PlayersTable> {
  $$PlayersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get wristSnap =>
      $composableBuilder(column: $table.wristSnap, builder: (column) => column);

  GeneratedColumn<int> get power =>
      $composableBuilder(column: $table.power, builder: (column) => column);

  GeneratedColumn<int> get accuracy =>
      $composableBuilder(column: $table.accuracy, builder: (column) => column);

  GeneratedColumn<int> get aggression => $composableBuilder(
    column: $table.aggression,
    builder: (column) => column,
  );

  GeneratedColumn<int> get strength =>
      $composableBuilder(column: $table.strength, builder: (column) => column);

  GeneratedColumn<int> get positioning => $composableBuilder(
    column: $table.positioning,
    builder: (column) => column,
  );

  GeneratedColumn<int> get predictability => $composableBuilder(
    column: $table.predictability,
    builder: (column) => column,
  );

  GeneratedColumn<int> get creativity => $composableBuilder(
    column: $table.creativity,
    builder: (column) => column,
  );

  GeneratedColumn<int> get penetration => $composableBuilder(
    column: $table.penetration,
    builder: (column) => column,
  );

  GeneratedColumn<int> get height =>
      $composableBuilder(column: $table.height, builder: (column) => column);

  GeneratedColumn<int> get form =>
      $composableBuilder(column: $table.form, builder: (column) => column);

  GeneratedColumn<int> get anticipation => $composableBuilder(
    column: $table.anticipation,
    builder: (column) => column,
  );

  GeneratedColumn<int> get footwork =>
      $composableBuilder(column: $table.footwork, builder: (column) => column);

  GeneratedColumn<int> get platform =>
      $composableBuilder(column: $table.platform, builder: (column) => column);

  GeneratedColumn<int> get stability =>
      $composableBuilder(column: $table.stability, builder: (column) => column);

  GeneratedColumn<int> get touch =>
      $composableBuilder(column: $table.touch, builder: (column) => column);

  GeneratedColumn<int> get vision =>
      $composableBuilder(column: $table.vision, builder: (column) => column);

  GeneratedColumn<int> get timing =>
      $composableBuilder(column: $table.timing, builder: (column) => column);

  GeneratedColumn<int> get versatility => $composableBuilder(
    column: $table.versatility,
    builder: (column) => column,
  );

  GeneratedColumn<int> get reaction =>
      $composableBuilder(column: $table.reaction, builder: (column) => column);

  GeneratedColumn<int> get reading =>
      $composableBuilder(column: $table.reading, builder: (column) => column);

  GeneratedColumn<int> get intention =>
      $composableBuilder(column: $table.intention, builder: (column) => column);

  GeneratedColumn<int> get control =>
      $composableBuilder(column: $table.control, builder: (column) => column);

  GeneratedColumn<double> get ratingOh =>
      $composableBuilder(column: $table.ratingOh, builder: (column) => column);

  GeneratedColumn<double> get ratingOpp =>
      $composableBuilder(column: $table.ratingOpp, builder: (column) => column);

  GeneratedColumn<double> get ratingMb =>
      $composableBuilder(column: $table.ratingMb, builder: (column) => column);

  GeneratedColumn<double> get ratingS =>
      $composableBuilder(column: $table.ratingS, builder: (column) => column);

  GeneratedColumn<double> get ratingL =>
      $composableBuilder(column: $table.ratingL, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> teamPlayersRefs<T extends Object>(
    Expression<T> Function($$TeamPlayersTableAnnotationComposer a) f,
  ) {
    final $$TeamPlayersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.teamPlayers,
      getReferencedColumn: (t) => t.playerId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TeamPlayersTableAnnotationComposer(
            $db: $db,
            $table: $db.teamPlayers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PlayersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PlayersTable,
          Player,
          $$PlayersTableFilterComposer,
          $$PlayersTableOrderingComposer,
          $$PlayersTableAnnotationComposer,
          $$PlayersTableCreateCompanionBuilder,
          $$PlayersTableUpdateCompanionBuilder,
          (Player, $$PlayersTableReferences),
          Player,
          PrefetchHooks Function({bool teamPlayersRefs})
        > {
  $$PlayersTableTableManager(_$AppDatabase db, $PlayersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PlayersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PlayersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PlayersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> wristSnap = const Value.absent(),
                Value<int> power = const Value.absent(),
                Value<int> accuracy = const Value.absent(),
                Value<int> aggression = const Value.absent(),
                Value<int> strength = const Value.absent(),
                Value<int> positioning = const Value.absent(),
                Value<int> predictability = const Value.absent(),
                Value<int> creativity = const Value.absent(),
                Value<int> penetration = const Value.absent(),
                Value<int> height = const Value.absent(),
                Value<int> form = const Value.absent(),
                Value<int> anticipation = const Value.absent(),
                Value<int> footwork = const Value.absent(),
                Value<int> platform = const Value.absent(),
                Value<int> stability = const Value.absent(),
                Value<int> touch = const Value.absent(),
                Value<int> vision = const Value.absent(),
                Value<int> timing = const Value.absent(),
                Value<int> versatility = const Value.absent(),
                Value<int> reaction = const Value.absent(),
                Value<int> reading = const Value.absent(),
                Value<int> intention = const Value.absent(),
                Value<int> control = const Value.absent(),
                Value<double> ratingOh = const Value.absent(),
                Value<double> ratingOpp = const Value.absent(),
                Value<double> ratingMb = const Value.absent(),
                Value<double> ratingS = const Value.absent(),
                Value<double> ratingL = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => PlayersCompanion(
                id: id,
                name: name,
                wristSnap: wristSnap,
                power: power,
                accuracy: accuracy,
                aggression: aggression,
                strength: strength,
                positioning: positioning,
                predictability: predictability,
                creativity: creativity,
                penetration: penetration,
                height: height,
                form: form,
                anticipation: anticipation,
                footwork: footwork,
                platform: platform,
                stability: stability,
                touch: touch,
                vision: vision,
                timing: timing,
                versatility: versatility,
                reaction: reaction,
                reading: reading,
                intention: intention,
                control: control,
                ratingOh: ratingOh,
                ratingOpp: ratingOpp,
                ratingMb: ratingMb,
                ratingS: ratingS,
                ratingL: ratingL,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                Value<int> wristSnap = const Value.absent(),
                Value<int> power = const Value.absent(),
                Value<int> accuracy = const Value.absent(),
                Value<int> aggression = const Value.absent(),
                Value<int> strength = const Value.absent(),
                Value<int> positioning = const Value.absent(),
                Value<int> predictability = const Value.absent(),
                Value<int> creativity = const Value.absent(),
                Value<int> penetration = const Value.absent(),
                Value<int> height = const Value.absent(),
                Value<int> form = const Value.absent(),
                Value<int> anticipation = const Value.absent(),
                Value<int> footwork = const Value.absent(),
                Value<int> platform = const Value.absent(),
                Value<int> stability = const Value.absent(),
                Value<int> touch = const Value.absent(),
                Value<int> vision = const Value.absent(),
                Value<int> timing = const Value.absent(),
                Value<int> versatility = const Value.absent(),
                Value<int> reaction = const Value.absent(),
                Value<int> reading = const Value.absent(),
                Value<int> intention = const Value.absent(),
                Value<int> control = const Value.absent(),
                Value<double> ratingOh = const Value.absent(),
                Value<double> ratingOpp = const Value.absent(),
                Value<double> ratingMb = const Value.absent(),
                Value<double> ratingS = const Value.absent(),
                Value<double> ratingL = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => PlayersCompanion.insert(
                id: id,
                name: name,
                wristSnap: wristSnap,
                power: power,
                accuracy: accuracy,
                aggression: aggression,
                strength: strength,
                positioning: positioning,
                predictability: predictability,
                creativity: creativity,
                penetration: penetration,
                height: height,
                form: form,
                anticipation: anticipation,
                footwork: footwork,
                platform: platform,
                stability: stability,
                touch: touch,
                vision: vision,
                timing: timing,
                versatility: versatility,
                reaction: reaction,
                reading: reading,
                intention: intention,
                control: control,
                ratingOh: ratingOh,
                ratingOpp: ratingOpp,
                ratingMb: ratingMb,
                ratingS: ratingS,
                ratingL: ratingL,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$PlayersTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({teamPlayersRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (teamPlayersRefs) db.teamPlayers],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (teamPlayersRefs)
                    await $_getPrefetchedData<
                      Player,
                      $PlayersTable,
                      TeamPlayer
                    >(
                      currentTable: table,
                      referencedTable: $$PlayersTableReferences
                          ._teamPlayersRefsTable(db),
                      managerFromTypedResult: (p0) => $$PlayersTableReferences(
                        db,
                        table,
                        p0,
                      ).teamPlayersRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.playerId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$PlayersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PlayersTable,
      Player,
      $$PlayersTableFilterComposer,
      $$PlayersTableOrderingComposer,
      $$PlayersTableAnnotationComposer,
      $$PlayersTableCreateCompanionBuilder,
      $$PlayersTableUpdateCompanionBuilder,
      (Player, $$PlayersTableReferences),
      Player,
      PrefetchHooks Function({bool teamPlayersRefs})
    >;
typedef $$TeamsTableCreateCompanionBuilder =
    TeamsCompanion Function({Value<int> id, required String name});
typedef $$TeamsTableUpdateCompanionBuilder =
    TeamsCompanion Function({Value<int> id, Value<String> name});

final class $$TeamsTableReferences
    extends BaseReferences<_$AppDatabase, $TeamsTable, Team> {
  $$TeamsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$TeamPlayersTable, List<TeamPlayer>>
  _teamPlayersRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.teamPlayers,
    aliasName: $_aliasNameGenerator(db.teams.id, db.teamPlayers.teamId),
  );

  $$TeamPlayersTableProcessedTableManager get teamPlayersRefs {
    final manager = $$TeamPlayersTableTableManager(
      $_db,
      $_db.teamPlayers,
    ).filter((f) => f.teamId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_teamPlayersRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$TeamsTableFilterComposer extends Composer<_$AppDatabase, $TeamsTable> {
  $$TeamsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> teamPlayersRefs(
    Expression<bool> Function($$TeamPlayersTableFilterComposer f) f,
  ) {
    final $$TeamPlayersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.teamPlayers,
      getReferencedColumn: (t) => t.teamId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TeamPlayersTableFilterComposer(
            $db: $db,
            $table: $db.teamPlayers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TeamsTableOrderingComposer
    extends Composer<_$AppDatabase, $TeamsTable> {
  $$TeamsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TeamsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TeamsTable> {
  $$TeamsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  Expression<T> teamPlayersRefs<T extends Object>(
    Expression<T> Function($$TeamPlayersTableAnnotationComposer a) f,
  ) {
    final $$TeamPlayersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.teamPlayers,
      getReferencedColumn: (t) => t.teamId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TeamPlayersTableAnnotationComposer(
            $db: $db,
            $table: $db.teamPlayers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TeamsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TeamsTable,
          Team,
          $$TeamsTableFilterComposer,
          $$TeamsTableOrderingComposer,
          $$TeamsTableAnnotationComposer,
          $$TeamsTableCreateCompanionBuilder,
          $$TeamsTableUpdateCompanionBuilder,
          (Team, $$TeamsTableReferences),
          Team,
          PrefetchHooks Function({bool teamPlayersRefs})
        > {
  $$TeamsTableTableManager(_$AppDatabase db, $TeamsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TeamsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TeamsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TeamsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
              }) => TeamsCompanion(id: id, name: name),
          createCompanionCallback:
              ({Value<int> id = const Value.absent(), required String name}) =>
                  TeamsCompanion.insert(id: id, name: name),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$TeamsTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback: ({teamPlayersRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (teamPlayersRefs) db.teamPlayers],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (teamPlayersRefs)
                    await $_getPrefetchedData<Team, $TeamsTable, TeamPlayer>(
                      currentTable: table,
                      referencedTable: $$TeamsTableReferences
                          ._teamPlayersRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$TeamsTableReferences(db, table, p0).teamPlayersRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.teamId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$TeamsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TeamsTable,
      Team,
      $$TeamsTableFilterComposer,
      $$TeamsTableOrderingComposer,
      $$TeamsTableAnnotationComposer,
      $$TeamsTableCreateCompanionBuilder,
      $$TeamsTableUpdateCompanionBuilder,
      (Team, $$TeamsTableReferences),
      Team,
      PrefetchHooks Function({bool teamPlayersRefs})
    >;
typedef $$TeamPlayersTableCreateCompanionBuilder =
    TeamPlayersCompanion Function({
      Value<int> id,
      required int teamId,
      required int playerId,
      required String roleTag,
      required int rotationOrder,
      Value<bool> isStarter,
    });
typedef $$TeamPlayersTableUpdateCompanionBuilder =
    TeamPlayersCompanion Function({
      Value<int> id,
      Value<int> teamId,
      Value<int> playerId,
      Value<String> roleTag,
      Value<int> rotationOrder,
      Value<bool> isStarter,
    });

final class $$TeamPlayersTableReferences
    extends BaseReferences<_$AppDatabase, $TeamPlayersTable, TeamPlayer> {
  $$TeamPlayersTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $TeamsTable _teamIdTable(_$AppDatabase db) => db.teams.createAlias(
    $_aliasNameGenerator(db.teamPlayers.teamId, db.teams.id),
  );

  $$TeamsTableProcessedTableManager get teamId {
    final $_column = $_itemColumn<int>('team_id')!;

    final manager = $$TeamsTableTableManager(
      $_db,
      $_db.teams,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_teamIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $PlayersTable _playerIdTable(_$AppDatabase db) =>
      db.players.createAlias(
        $_aliasNameGenerator(db.teamPlayers.playerId, db.players.id),
      );

  $$PlayersTableProcessedTableManager get playerId {
    final $_column = $_itemColumn<int>('player_id')!;

    final manager = $$PlayersTableTableManager(
      $_db,
      $_db.players,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_playerIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$TeamPlayersTableFilterComposer
    extends Composer<_$AppDatabase, $TeamPlayersTable> {
  $$TeamPlayersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get roleTag => $composableBuilder(
    column: $table.roleTag,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get rotationOrder => $composableBuilder(
    column: $table.rotationOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isStarter => $composableBuilder(
    column: $table.isStarter,
    builder: (column) => ColumnFilters(column),
  );

  $$TeamsTableFilterComposer get teamId {
    final $$TeamsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.teamId,
      referencedTable: $db.teams,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TeamsTableFilterComposer(
            $db: $db,
            $table: $db.teams,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PlayersTableFilterComposer get playerId {
    final $$PlayersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.playerId,
      referencedTable: $db.players,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlayersTableFilterComposer(
            $db: $db,
            $table: $db.players,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TeamPlayersTableOrderingComposer
    extends Composer<_$AppDatabase, $TeamPlayersTable> {
  $$TeamPlayersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get roleTag => $composableBuilder(
    column: $table.roleTag,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get rotationOrder => $composableBuilder(
    column: $table.rotationOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isStarter => $composableBuilder(
    column: $table.isStarter,
    builder: (column) => ColumnOrderings(column),
  );

  $$TeamsTableOrderingComposer get teamId {
    final $$TeamsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.teamId,
      referencedTable: $db.teams,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TeamsTableOrderingComposer(
            $db: $db,
            $table: $db.teams,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PlayersTableOrderingComposer get playerId {
    final $$PlayersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.playerId,
      referencedTable: $db.players,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlayersTableOrderingComposer(
            $db: $db,
            $table: $db.players,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TeamPlayersTableAnnotationComposer
    extends Composer<_$AppDatabase, $TeamPlayersTable> {
  $$TeamPlayersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get roleTag =>
      $composableBuilder(column: $table.roleTag, builder: (column) => column);

  GeneratedColumn<int> get rotationOrder => $composableBuilder(
    column: $table.rotationOrder,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isStarter =>
      $composableBuilder(column: $table.isStarter, builder: (column) => column);

  $$TeamsTableAnnotationComposer get teamId {
    final $$TeamsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.teamId,
      referencedTable: $db.teams,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TeamsTableAnnotationComposer(
            $db: $db,
            $table: $db.teams,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PlayersTableAnnotationComposer get playerId {
    final $$PlayersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.playerId,
      referencedTable: $db.players,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlayersTableAnnotationComposer(
            $db: $db,
            $table: $db.players,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TeamPlayersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TeamPlayersTable,
          TeamPlayer,
          $$TeamPlayersTableFilterComposer,
          $$TeamPlayersTableOrderingComposer,
          $$TeamPlayersTableAnnotationComposer,
          $$TeamPlayersTableCreateCompanionBuilder,
          $$TeamPlayersTableUpdateCompanionBuilder,
          (TeamPlayer, $$TeamPlayersTableReferences),
          TeamPlayer,
          PrefetchHooks Function({bool teamId, bool playerId})
        > {
  $$TeamPlayersTableTableManager(_$AppDatabase db, $TeamPlayersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TeamPlayersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TeamPlayersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TeamPlayersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> teamId = const Value.absent(),
                Value<int> playerId = const Value.absent(),
                Value<String> roleTag = const Value.absent(),
                Value<int> rotationOrder = const Value.absent(),
                Value<bool> isStarter = const Value.absent(),
              }) => TeamPlayersCompanion(
                id: id,
                teamId: teamId,
                playerId: playerId,
                roleTag: roleTag,
                rotationOrder: rotationOrder,
                isStarter: isStarter,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int teamId,
                required int playerId,
                required String roleTag,
                required int rotationOrder,
                Value<bool> isStarter = const Value.absent(),
              }) => TeamPlayersCompanion.insert(
                id: id,
                teamId: teamId,
                playerId: playerId,
                roleTag: roleTag,
                rotationOrder: rotationOrder,
                isStarter: isStarter,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$TeamPlayersTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({teamId = false, playerId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (teamId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.teamId,
                                referencedTable: $$TeamPlayersTableReferences
                                    ._teamIdTable(db),
                                referencedColumn: $$TeamPlayersTableReferences
                                    ._teamIdTable(db)
                                    .id,
                              )
                              as T;
                    }
                    if (playerId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.playerId,
                                referencedTable: $$TeamPlayersTableReferences
                                    ._playerIdTable(db),
                                referencedColumn: $$TeamPlayersTableReferences
                                    ._playerIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$TeamPlayersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TeamPlayersTable,
      TeamPlayer,
      $$TeamPlayersTableFilterComposer,
      $$TeamPlayersTableOrderingComposer,
      $$TeamPlayersTableAnnotationComposer,
      $$TeamPlayersTableCreateCompanionBuilder,
      $$TeamPlayersTableUpdateCompanionBuilder,
      (TeamPlayer, $$TeamPlayersTableReferences),
      TeamPlayer,
      PrefetchHooks Function({bool teamId, bool playerId})
    >;
typedef $$SkillFormulasTableCreateCompanionBuilder =
    SkillFormulasCompanion Function({
      Value<int> id,
      required String skillKey,
      required String skillName,
      required String category,
      required String formula,
      Value<bool> isActive,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });
typedef $$SkillFormulasTableUpdateCompanionBuilder =
    SkillFormulasCompanion Function({
      Value<int> id,
      Value<String> skillKey,
      Value<String> skillName,
      Value<String> category,
      Value<String> formula,
      Value<bool> isActive,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });

class $$SkillFormulasTableFilterComposer
    extends Composer<_$AppDatabase, $SkillFormulasTable> {
  $$SkillFormulasTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get skillKey => $composableBuilder(
    column: $table.skillKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get skillName => $composableBuilder(
    column: $table.skillName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get formula => $composableBuilder(
    column: $table.formula,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SkillFormulasTableOrderingComposer
    extends Composer<_$AppDatabase, $SkillFormulasTable> {
  $$SkillFormulasTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get skillKey => $composableBuilder(
    column: $table.skillKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get skillName => $composableBuilder(
    column: $table.skillName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get formula => $composableBuilder(
    column: $table.formula,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SkillFormulasTableAnnotationComposer
    extends Composer<_$AppDatabase, $SkillFormulasTable> {
  $$SkillFormulasTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get skillKey =>
      $composableBuilder(column: $table.skillKey, builder: (column) => column);

  GeneratedColumn<String> get skillName =>
      $composableBuilder(column: $table.skillName, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get formula =>
      $composableBuilder(column: $table.formula, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$SkillFormulasTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SkillFormulasTable,
          SkillFormula,
          $$SkillFormulasTableFilterComposer,
          $$SkillFormulasTableOrderingComposer,
          $$SkillFormulasTableAnnotationComposer,
          $$SkillFormulasTableCreateCompanionBuilder,
          $$SkillFormulasTableUpdateCompanionBuilder,
          (
            SkillFormula,
            BaseReferences<_$AppDatabase, $SkillFormulasTable, SkillFormula>,
          ),
          SkillFormula,
          PrefetchHooks Function()
        > {
  $$SkillFormulasTableTableManager(_$AppDatabase db, $SkillFormulasTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SkillFormulasTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SkillFormulasTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SkillFormulasTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> skillKey = const Value.absent(),
                Value<String> skillName = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<String> formula = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => SkillFormulasCompanion(
                id: id,
                skillKey: skillKey,
                skillName: skillName,
                category: category,
                formula: formula,
                isActive: isActive,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String skillKey,
                required String skillName,
                required String category,
                required String formula,
                Value<bool> isActive = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => SkillFormulasCompanion.insert(
                id: id,
                skillKey: skillKey,
                skillName: skillName,
                category: category,
                formula: formula,
                isActive: isActive,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SkillFormulasTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SkillFormulasTable,
      SkillFormula,
      $$SkillFormulasTableFilterComposer,
      $$SkillFormulasTableOrderingComposer,
      $$SkillFormulasTableAnnotationComposer,
      $$SkillFormulasTableCreateCompanionBuilder,
      $$SkillFormulasTableUpdateCompanionBuilder,
      (
        SkillFormula,
        BaseReferences<_$AppDatabase, $SkillFormulasTable, SkillFormula>,
      ),
      SkillFormula,
      PrefetchHooks Function()
    >;
typedef $$OutcomeCurvesTableCreateCompanionBuilder =
    OutcomeCurvesCompanion Function({
      Value<int> id,
      required String matchupKey,
      required double differential,
      required String probabilities,
      Value<bool> isActive,
      Value<DateTime> createdAt,
    });
typedef $$OutcomeCurvesTableUpdateCompanionBuilder =
    OutcomeCurvesCompanion Function({
      Value<int> id,
      Value<String> matchupKey,
      Value<double> differential,
      Value<String> probabilities,
      Value<bool> isActive,
      Value<DateTime> createdAt,
    });

class $$OutcomeCurvesTableFilterComposer
    extends Composer<_$AppDatabase, $OutcomeCurvesTable> {
  $$OutcomeCurvesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get matchupKey => $composableBuilder(
    column: $table.matchupKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get differential => $composableBuilder(
    column: $table.differential,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get probabilities => $composableBuilder(
    column: $table.probabilities,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$OutcomeCurvesTableOrderingComposer
    extends Composer<_$AppDatabase, $OutcomeCurvesTable> {
  $$OutcomeCurvesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get matchupKey => $composableBuilder(
    column: $table.matchupKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get differential => $composableBuilder(
    column: $table.differential,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get probabilities => $composableBuilder(
    column: $table.probabilities,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$OutcomeCurvesTableAnnotationComposer
    extends Composer<_$AppDatabase, $OutcomeCurvesTable> {
  $$OutcomeCurvesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get matchupKey => $composableBuilder(
    column: $table.matchupKey,
    builder: (column) => column,
  );

  GeneratedColumn<double> get differential => $composableBuilder(
    column: $table.differential,
    builder: (column) => column,
  );

  GeneratedColumn<String> get probabilities => $composableBuilder(
    column: $table.probabilities,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$OutcomeCurvesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $OutcomeCurvesTable,
          OutcomeCurve,
          $$OutcomeCurvesTableFilterComposer,
          $$OutcomeCurvesTableOrderingComposer,
          $$OutcomeCurvesTableAnnotationComposer,
          $$OutcomeCurvesTableCreateCompanionBuilder,
          $$OutcomeCurvesTableUpdateCompanionBuilder,
          (
            OutcomeCurve,
            BaseReferences<_$AppDatabase, $OutcomeCurvesTable, OutcomeCurve>,
          ),
          OutcomeCurve,
          PrefetchHooks Function()
        > {
  $$OutcomeCurvesTableTableManager(_$AppDatabase db, $OutcomeCurvesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$OutcomeCurvesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$OutcomeCurvesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$OutcomeCurvesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> matchupKey = const Value.absent(),
                Value<double> differential = const Value.absent(),
                Value<String> probabilities = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => OutcomeCurvesCompanion(
                id: id,
                matchupKey: matchupKey,
                differential: differential,
                probabilities: probabilities,
                isActive: isActive,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String matchupKey,
                required double differential,
                required String probabilities,
                Value<bool> isActive = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => OutcomeCurvesCompanion.insert(
                id: id,
                matchupKey: matchupKey,
                differential: differential,
                probabilities: probabilities,
                isActive: isActive,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$OutcomeCurvesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $OutcomeCurvesTable,
      OutcomeCurve,
      $$OutcomeCurvesTableFilterComposer,
      $$OutcomeCurvesTableOrderingComposer,
      $$OutcomeCurvesTableAnnotationComposer,
      $$OutcomeCurvesTableCreateCompanionBuilder,
      $$OutcomeCurvesTableUpdateCompanionBuilder,
      (
        OutcomeCurve,
        BaseReferences<_$AppDatabase, $OutcomeCurvesTable, OutcomeCurve>,
      ),
      OutcomeCurve,
      PrefetchHooks Function()
    >;
typedef $$MatchesTableCreateCompanionBuilder =
    MatchesCompanion Function({
      Value<int> id,
      required int homeTeamId,
      required int awayTeamId,
      Value<DateTime> startedAt,
      Value<DateTime?> completedAt,
      Value<int> homeScore,
      Value<int> awayScore,
      Value<bool> isComplete,
    });
typedef $$MatchesTableUpdateCompanionBuilder =
    MatchesCompanion Function({
      Value<int> id,
      Value<int> homeTeamId,
      Value<int> awayTeamId,
      Value<DateTime> startedAt,
      Value<DateTime?> completedAt,
      Value<int> homeScore,
      Value<int> awayScore,
      Value<bool> isComplete,
    });

final class $$MatchesTableReferences
    extends BaseReferences<_$AppDatabase, $MatchesTable, Match> {
  $$MatchesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $TeamsTable _homeTeamIdTable(_$AppDatabase db) => db.teams.createAlias(
    $_aliasNameGenerator(db.matches.homeTeamId, db.teams.id),
  );

  $$TeamsTableProcessedTableManager get homeTeamId {
    final $_column = $_itemColumn<int>('home_team_id')!;

    final manager = $$TeamsTableTableManager(
      $_db,
      $_db.teams,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_homeTeamIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $TeamsTable _awayTeamIdTable(_$AppDatabase db) => db.teams.createAlias(
    $_aliasNameGenerator(db.matches.awayTeamId, db.teams.id),
  );

  $$TeamsTableProcessedTableManager get awayTeamId {
    final $_column = $_itemColumn<int>('away_team_id')!;

    final manager = $$TeamsTableTableManager(
      $_db,
      $_db.teams,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_awayTeamIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$MatchesTableFilterComposer
    extends Composer<_$AppDatabase, $MatchesTable> {
  $$MatchesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get homeScore => $composableBuilder(
    column: $table.homeScore,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get awayScore => $composableBuilder(
    column: $table.awayScore,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isComplete => $composableBuilder(
    column: $table.isComplete,
    builder: (column) => ColumnFilters(column),
  );

  $$TeamsTableFilterComposer get homeTeamId {
    final $$TeamsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.homeTeamId,
      referencedTable: $db.teams,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TeamsTableFilterComposer(
            $db: $db,
            $table: $db.teams,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TeamsTableFilterComposer get awayTeamId {
    final $$TeamsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.awayTeamId,
      referencedTable: $db.teams,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TeamsTableFilterComposer(
            $db: $db,
            $table: $db.teams,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MatchesTableOrderingComposer
    extends Composer<_$AppDatabase, $MatchesTable> {
  $$MatchesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get homeScore => $composableBuilder(
    column: $table.homeScore,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get awayScore => $composableBuilder(
    column: $table.awayScore,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isComplete => $composableBuilder(
    column: $table.isComplete,
    builder: (column) => ColumnOrderings(column),
  );

  $$TeamsTableOrderingComposer get homeTeamId {
    final $$TeamsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.homeTeamId,
      referencedTable: $db.teams,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TeamsTableOrderingComposer(
            $db: $db,
            $table: $db.teams,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TeamsTableOrderingComposer get awayTeamId {
    final $$TeamsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.awayTeamId,
      referencedTable: $db.teams,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TeamsTableOrderingComposer(
            $db: $db,
            $table: $db.teams,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MatchesTableAnnotationComposer
    extends Composer<_$AppDatabase, $MatchesTable> {
  $$MatchesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get startedAt =>
      $composableBuilder(column: $table.startedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => column,
  );

  GeneratedColumn<int> get homeScore =>
      $composableBuilder(column: $table.homeScore, builder: (column) => column);

  GeneratedColumn<int> get awayScore =>
      $composableBuilder(column: $table.awayScore, builder: (column) => column);

  GeneratedColumn<bool> get isComplete => $composableBuilder(
    column: $table.isComplete,
    builder: (column) => column,
  );

  $$TeamsTableAnnotationComposer get homeTeamId {
    final $$TeamsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.homeTeamId,
      referencedTable: $db.teams,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TeamsTableAnnotationComposer(
            $db: $db,
            $table: $db.teams,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TeamsTableAnnotationComposer get awayTeamId {
    final $$TeamsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.awayTeamId,
      referencedTable: $db.teams,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TeamsTableAnnotationComposer(
            $db: $db,
            $table: $db.teams,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MatchesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MatchesTable,
          Match,
          $$MatchesTableFilterComposer,
          $$MatchesTableOrderingComposer,
          $$MatchesTableAnnotationComposer,
          $$MatchesTableCreateCompanionBuilder,
          $$MatchesTableUpdateCompanionBuilder,
          (Match, $$MatchesTableReferences),
          Match,
          PrefetchHooks Function({bool homeTeamId, bool awayTeamId})
        > {
  $$MatchesTableTableManager(_$AppDatabase db, $MatchesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MatchesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MatchesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MatchesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> homeTeamId = const Value.absent(),
                Value<int> awayTeamId = const Value.absent(),
                Value<DateTime> startedAt = const Value.absent(),
                Value<DateTime?> completedAt = const Value.absent(),
                Value<int> homeScore = const Value.absent(),
                Value<int> awayScore = const Value.absent(),
                Value<bool> isComplete = const Value.absent(),
              }) => MatchesCompanion(
                id: id,
                homeTeamId: homeTeamId,
                awayTeamId: awayTeamId,
                startedAt: startedAt,
                completedAt: completedAt,
                homeScore: homeScore,
                awayScore: awayScore,
                isComplete: isComplete,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int homeTeamId,
                required int awayTeamId,
                Value<DateTime> startedAt = const Value.absent(),
                Value<DateTime?> completedAt = const Value.absent(),
                Value<int> homeScore = const Value.absent(),
                Value<int> awayScore = const Value.absent(),
                Value<bool> isComplete = const Value.absent(),
              }) => MatchesCompanion.insert(
                id: id,
                homeTeamId: homeTeamId,
                awayTeamId: awayTeamId,
                startedAt: startedAt,
                completedAt: completedAt,
                homeScore: homeScore,
                awayScore: awayScore,
                isComplete: isComplete,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$MatchesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({homeTeamId = false, awayTeamId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (homeTeamId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.homeTeamId,
                                referencedTable: $$MatchesTableReferences
                                    ._homeTeamIdTable(db),
                                referencedColumn: $$MatchesTableReferences
                                    ._homeTeamIdTable(db)
                                    .id,
                              )
                              as T;
                    }
                    if (awayTeamId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.awayTeamId,
                                referencedTable: $$MatchesTableReferences
                                    ._awayTeamIdTable(db),
                                referencedColumn: $$MatchesTableReferences
                                    ._awayTeamIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$MatchesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MatchesTable,
      Match,
      $$MatchesTableFilterComposer,
      $$MatchesTableOrderingComposer,
      $$MatchesTableAnnotationComposer,
      $$MatchesTableCreateCompanionBuilder,
      $$MatchesTableUpdateCompanionBuilder,
      (Match, $$MatchesTableReferences),
      Match,
      PrefetchHooks Function({bool homeTeamId, bool awayTeamId})
    >;
typedef $$MatchAuditLogTableCreateCompanionBuilder =
    MatchAuditLogCompanion Function({
      Value<int> id,
      required int matchId,
      required int rallyId,
      required String phase,
      required String eventType,
      required String payload,
      Value<DateTime> occurredAt,
    });
typedef $$MatchAuditLogTableUpdateCompanionBuilder =
    MatchAuditLogCompanion Function({
      Value<int> id,
      Value<int> matchId,
      Value<int> rallyId,
      Value<String> phase,
      Value<String> eventType,
      Value<String> payload,
      Value<DateTime> occurredAt,
    });

class $$MatchAuditLogTableFilterComposer
    extends Composer<_$AppDatabase, $MatchAuditLogTable> {
  $$MatchAuditLogTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get matchId => $composableBuilder(
    column: $table.matchId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get rallyId => $composableBuilder(
    column: $table.rallyId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get phase => $composableBuilder(
    column: $table.phase,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get eventType => $composableBuilder(
    column: $table.eventType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get occurredAt => $composableBuilder(
    column: $table.occurredAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$MatchAuditLogTableOrderingComposer
    extends Composer<_$AppDatabase, $MatchAuditLogTable> {
  $$MatchAuditLogTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get matchId => $composableBuilder(
    column: $table.matchId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get rallyId => $composableBuilder(
    column: $table.rallyId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get phase => $composableBuilder(
    column: $table.phase,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get eventType => $composableBuilder(
    column: $table.eventType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get occurredAt => $composableBuilder(
    column: $table.occurredAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$MatchAuditLogTableAnnotationComposer
    extends Composer<_$AppDatabase, $MatchAuditLogTable> {
  $$MatchAuditLogTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get matchId =>
      $composableBuilder(column: $table.matchId, builder: (column) => column);

  GeneratedColumn<int> get rallyId =>
      $composableBuilder(column: $table.rallyId, builder: (column) => column);

  GeneratedColumn<String> get phase =>
      $composableBuilder(column: $table.phase, builder: (column) => column);

  GeneratedColumn<String> get eventType =>
      $composableBuilder(column: $table.eventType, builder: (column) => column);

  GeneratedColumn<String> get payload =>
      $composableBuilder(column: $table.payload, builder: (column) => column);

  GeneratedColumn<DateTime> get occurredAt => $composableBuilder(
    column: $table.occurredAt,
    builder: (column) => column,
  );
}

class $$MatchAuditLogTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MatchAuditLogTable,
          MatchAuditEntry,
          $$MatchAuditLogTableFilterComposer,
          $$MatchAuditLogTableOrderingComposer,
          $$MatchAuditLogTableAnnotationComposer,
          $$MatchAuditLogTableCreateCompanionBuilder,
          $$MatchAuditLogTableUpdateCompanionBuilder,
          (
            MatchAuditEntry,
            BaseReferences<_$AppDatabase, $MatchAuditLogTable, MatchAuditEntry>,
          ),
          MatchAuditEntry,
          PrefetchHooks Function()
        > {
  $$MatchAuditLogTableTableManager(_$AppDatabase db, $MatchAuditLogTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MatchAuditLogTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MatchAuditLogTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MatchAuditLogTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> matchId = const Value.absent(),
                Value<int> rallyId = const Value.absent(),
                Value<String> phase = const Value.absent(),
                Value<String> eventType = const Value.absent(),
                Value<String> payload = const Value.absent(),
                Value<DateTime> occurredAt = const Value.absent(),
              }) => MatchAuditLogCompanion(
                id: id,
                matchId: matchId,
                rallyId: rallyId,
                phase: phase,
                eventType: eventType,
                payload: payload,
                occurredAt: occurredAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int matchId,
                required int rallyId,
                required String phase,
                required String eventType,
                required String payload,
                Value<DateTime> occurredAt = const Value.absent(),
              }) => MatchAuditLogCompanion.insert(
                id: id,
                matchId: matchId,
                rallyId: rallyId,
                phase: phase,
                eventType: eventType,
                payload: payload,
                occurredAt: occurredAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$MatchAuditLogTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MatchAuditLogTable,
      MatchAuditEntry,
      $$MatchAuditLogTableFilterComposer,
      $$MatchAuditLogTableOrderingComposer,
      $$MatchAuditLogTableAnnotationComposer,
      $$MatchAuditLogTableCreateCompanionBuilder,
      $$MatchAuditLogTableUpdateCompanionBuilder,
      (
        MatchAuditEntry,
        BaseReferences<_$AppDatabase, $MatchAuditLogTable, MatchAuditEntry>,
      ),
      MatchAuditEntry,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$PlayersTableTableManager get players =>
      $$PlayersTableTableManager(_db, _db.players);
  $$TeamsTableTableManager get teams =>
      $$TeamsTableTableManager(_db, _db.teams);
  $$TeamPlayersTableTableManager get teamPlayers =>
      $$TeamPlayersTableTableManager(_db, _db.teamPlayers);
  $$SkillFormulasTableTableManager get skillFormulas =>
      $$SkillFormulasTableTableManager(_db, _db.skillFormulas);
  $$OutcomeCurvesTableTableManager get outcomeCurves =>
      $$OutcomeCurvesTableTableManager(_db, _db.outcomeCurves);
  $$MatchesTableTableManager get matches =>
      $$MatchesTableTableManager(_db, _db.matches);
  $$MatchAuditLogTableTableManager get matchAuditLog =>
      $$MatchAuditLogTableTableManager(_db, _db.matchAuditLog);
}

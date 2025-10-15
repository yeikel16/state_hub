// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_theme_cubit.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppThemeState _$AppThemeStateFromJson(Map<String, dynamic> json) =>
    AppThemeState(
      themeMode: AppThemeState._themeModeFromJson(
        (json['themeMode'] as num).toInt(),
      ),
      aviableSchemes: (json['aviableSchemes'] as List<dynamic>)
          .map((e) => $enumDecode(_$FlexSchemeEnumMap, e))
          .toList(),
      schemeSelected: $enumDecode(_$FlexSchemeEnumMap, json['schemeSelected']),
    );

Map<String, dynamic> _$AppThemeStateToJson(AppThemeState instance) =>
    <String, dynamic>{
      'themeMode': AppThemeState._themeModeToJson(instance.themeMode),
      'aviableSchemes': instance.aviableSchemes
          .map((e) => _$FlexSchemeEnumMap[e]!)
          .toList(),
      'schemeSelected': _$FlexSchemeEnumMap[instance.schemeSelected]!,
    };

const _$FlexSchemeEnumMap = {
  FlexScheme.material: 'material',
  FlexScheme.materialHc: 'materialHc',
  FlexScheme.blue: 'blue',
  FlexScheme.indigo: 'indigo',
  FlexScheme.hippieBlue: 'hippieBlue',
  FlexScheme.aquaBlue: 'aquaBlue',
  FlexScheme.brandBlue: 'brandBlue',
  FlexScheme.deepBlue: 'deepBlue',
  FlexScheme.sakura: 'sakura',
  FlexScheme.mandyRed: 'mandyRed',
  FlexScheme.red: 'red',
  FlexScheme.redWine: 'redWine',
  FlexScheme.purpleBrown: 'purpleBrown',
  FlexScheme.green: 'green',
  FlexScheme.money: 'money',
  FlexScheme.jungle: 'jungle',
  FlexScheme.greyLaw: 'greyLaw',
  FlexScheme.wasabi: 'wasabi',
  FlexScheme.gold: 'gold',
  FlexScheme.mango: 'mango',
  FlexScheme.amber: 'amber',
  FlexScheme.vesuviusBurn: 'vesuviusBurn',
  FlexScheme.deepPurple: 'deepPurple',
  FlexScheme.ebonyClay: 'ebonyClay',
  FlexScheme.barossa: 'barossa',
  FlexScheme.shark: 'shark',
  FlexScheme.bigStone: 'bigStone',
  FlexScheme.damask: 'damask',
  FlexScheme.bahamaBlue: 'bahamaBlue',
  FlexScheme.mallardGreen: 'mallardGreen',
  FlexScheme.espresso: 'espresso',
  FlexScheme.outerSpace: 'outerSpace',
  FlexScheme.blueWhale: 'blueWhale',
  FlexScheme.sanJuanBlue: 'sanJuanBlue',
  FlexScheme.rosewood: 'rosewood',
  FlexScheme.blumineBlue: 'blumineBlue',
  FlexScheme.flutterDash: 'flutterDash',
  FlexScheme.materialBaseline: 'materialBaseline',
  FlexScheme.verdunHemlock: 'verdunHemlock',
  FlexScheme.dellGenoa: 'dellGenoa',
  FlexScheme.redM3: 'redM3',
  FlexScheme.pinkM3: 'pinkM3',
  FlexScheme.purpleM3: 'purpleM3',
  FlexScheme.indigoM3: 'indigoM3',
  FlexScheme.blueM3: 'blueM3',
  FlexScheme.cyanM3: 'cyanM3',
  FlexScheme.tealM3: 'tealM3',
  FlexScheme.greenM3: 'greenM3',
  FlexScheme.limeM3: 'limeM3',
  FlexScheme.yellowM3: 'yellowM3',
  FlexScheme.orangeM3: 'orangeM3',
  FlexScheme.deepOrangeM3: 'deepOrangeM3',
  FlexScheme.blackWhite: 'blackWhite',
  FlexScheme.greys: 'greys',
  FlexScheme.sepia: 'sepia',
  FlexScheme.shadBlue: 'shadBlue',
  FlexScheme.shadGray: 'shadGray',
  FlexScheme.shadGreen: 'shadGreen',
  FlexScheme.shadNeutral: 'shadNeutral',
  FlexScheme.shadOrange: 'shadOrange',
  FlexScheme.shadRed: 'shadRed',
  FlexScheme.shadRose: 'shadRose',
  FlexScheme.shadSlate: 'shadSlate',
  FlexScheme.shadStone: 'shadStone',
  FlexScheme.shadViolet: 'shadViolet',
  FlexScheme.shadYellow: 'shadYellow',
  FlexScheme.shadZinc: 'shadZinc',
  FlexScheme.custom: 'custom',
};

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:state_hub/src/data/data_source/api.dart';
import 'package:state_hub/src/data/repository/properties_repository.dart';
import 'package:state_hub/src/features/home/view/home_view.dart';
import 'package:state_hub/src/features/properties/blocs/blocs.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final propertiesRepository = PropertiesRepository(
      api: LocalPropertiesApi(),
    );

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => PropertiesFilterBloc(
            propertiesRepository: propertiesRepository,
          )..add(const PropertiesFilterCitiesRequested()),
        ),
        BlocProvider(
          create: (context) => PropertiesBloc(
            propertiesRepository: propertiesRepository,
          )..add(const LoadProperties(query: null, city: null)),
        ),
      ],
      child: const HomeView(),
    );
  }
}

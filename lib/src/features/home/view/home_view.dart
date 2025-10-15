import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:state_hub/app/routes/routes.dart';
import 'package:state_hub/src/features/properties/blocs/blocs.dart';
import 'package:state_hub/src/features/properties/widgets/widgets.dart';
import 'package:very_good_infinite_list/very_good_infinite_list.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              floating: true,
              snap: true,
              pinned: true,
              title: const Text('StateHub'),
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(150),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SearchAndFilters(),
                    BlocBuilder<PropertiesBloc, PropertiesState>(
                      builder: (context, state) {
                        final filterState = context.select(
                          (PropertiesFilterBloc bloc) => bloc.state,
                        );

                        final filtersChanged =
                            state.query != filterState.searchQuery ||
                            state.city != filterState.selectedCity;
                        if (state.isLoading && filtersChanged) {
                          return const LinearProgressIndicator();
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ],
                ),
              ),
            ),
          ];
        },
        body: BlocListener<PropertiesFilterBloc, PropertiesFilterState>(
          listenWhen: (previous, current) =>
              previous.searchQuery != current.searchQuery ||
              previous.selectedCity != current.selectedCity,
          listener: (context, filterState) {
            context.read<PropertiesBloc>().add(
              LoadProperties(
                query: filterState.searchQuery,
                city: filterState.selectedCity,
              ),
            );
          },
          child: const PropertiesList(),
        ),
      ),
    );
  }
}

class SearchAndFilters extends StatelessWidget {
  const SearchAndFilters({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          TextField(
            decoration: InputDecoration(
              hintText: 'Search properties...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: theme.colorScheme.surfaceContainerHighest,
            ),
            onChanged: (value) {
              context.read<PropertiesFilterBloc>().add(
                PropertiesFilterSearchChanged(
                  value.isEmpty ? '' : value,
                ),
              );
            },
          ),
          const SizedBox(height: 12),
          BlocBuilder<PropertiesFilterBloc, PropertiesFilterState>(
            buildWhen: (previous, current) =>
                previous.availableCities != current.availableCities ||
                previous.selectedCity != current.selectedCity ||
                previous.isLoadingCities != current.isLoadingCities,
            builder: (context, state) {
              if (state.isLoadingCities) {
                return const SizedBox(
                  height: 40,
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              if (state.availableCities.isEmpty) {
                return const SizedBox.shrink();
              }

              return SizedBox(
                height: 40,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    CityChip(
                      label: 'All',
                      isSelected: state.selectedCity == null,
                      onTap: () {
                        context.read<PropertiesFilterBloc>().add(
                          const PropertiesFilterCityChanged(null),
                        );
                      },
                    ),
                    const SizedBox(width: 8),
                    ...state.availableCities.map(
                      (city) => Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: CityChip(
                          label: city,
                          isSelected: state.selectedCity == city,
                          onTap: () {
                            context.read<PropertiesFilterBloc>().add(
                              PropertiesFilterCityChanged(city),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class CityChip extends StatelessWidget {
  const CityChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
    super.key,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => onTap(),
      backgroundColor: theme.colorScheme.surfaceContainerHighest,
      selectedColor: theme.colorScheme.primaryContainer,
      checkmarkColor: theme.colorScheme.onPrimaryContainer,
      labelStyle: TextStyle(
        color: isSelected
            ? theme.colorScheme.onPrimaryContainer
            : theme.colorScheme.onSurface,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
    );
  }
}

class PropertiesList extends StatelessWidget {
  const PropertiesList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PropertiesBloc, PropertiesState>(
      builder: (context, state) {
        if (state.properties.isEmpty) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Theme.of(context).colorScheme.error,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Error',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    state.error!,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 16),
                  FilledButton.icon(
                    onPressed: () {
                      final filterState = context
                          .read<PropertiesFilterBloc>()
                          .state;
                      context.read<PropertiesBloc>().add(
                        LoadProperties(
                          query: filterState.searchQuery,
                          city: filterState.selectedCity,
                        ),
                      );
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.search_off,
                  size: 64,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 16),
                Text(
                  'No properties found',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  'Try adjusting your search or filters',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () async {
            final filterState = context.read<PropertiesFilterBloc>().state;
            context.read<PropertiesBloc>().add(
              LoadProperties(
                query: filterState.searchQuery,
                city: filterState.selectedCity,
              ),
            );
          },
          child: InfiniteList(
            padding: const EdgeInsets.only(bottom: 24),
            itemCount: state.properties.length,
            isLoading: state.isLoading,
            hasReachedMax: state.hasReachedMax,
            onFetchData: () {
              final filterState = context.read<PropertiesFilterBloc>().state;
              context.read<PropertiesBloc>().add(
                LoadProperties(
                  query: filterState.searchQuery,
                  city: filterState.selectedCity,
                ),
              );
            },
            itemBuilder: (context, index) {
              final property = state.properties[index];
              return PropertyCard(
                property: property,
                onTap: () async {
                  PropertyDetailsRoute($extra: property).go(context);
                },
              );
            },
            loadingBuilder: (context) => const Padding(
              padding: EdgeInsets.all(16),
              child: Center(child: CircularProgressIndicator()),
            ),
            errorBuilder: (context) => Padding(
              padding: const EdgeInsets.all(16),
              child: Center(
                child: Column(
                  children: [
                    Text(
                      state.error ?? 'Error loading more properties',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextButton.icon(
                      onPressed: () {
                        final filterState = context
                            .read<PropertiesFilterBloc>()
                            .state;
                        context.read<PropertiesBloc>().add(
                          LoadProperties(
                            query: filterState.searchQuery,
                            city: filterState.selectedCity,
                          ),
                        );
                      },
                      icon: const Icon(Icons.refresh),
                      label: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            ),
            emptyBuilder: (context) => const SizedBox.shrink(),
          ),
        );
      },
    );
  }
}

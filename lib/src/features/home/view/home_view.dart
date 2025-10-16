import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:state_hub/app/routes/routes.dart';
import 'package:state_hub/l10n/l10n.dart';
import 'package:state_hub/src/data/models/models.dart';
import 'package:state_hub/src/features/properties/blocs/blocs.dart';
import 'package:state_hub/src/features/properties/widgets/widgets.dart';
import 'package:state_hub/src/widgets/widgets.dart';

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
    final l10n = context.l10n;
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
              hintText: l10n.searchProperties,
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
                      label: l10n.all,
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

  void _fetchNextPage(BuildContext context) {
    final filterState = context.read<PropertiesFilterBloc>().state;
    context.read<PropertiesBloc>().add(
      LoadProperties(
        query: filterState.searchQuery,
        city: filterState.selectedCity,
      ),
    );
  }

  PagingState<int, PropertyModel> _toPagingState(PropertiesState state) {
    return PagingState(
      pages: state.properties.isEmpty ? null : [state.properties],
      keys: state.properties.isEmpty ? null : [state.currentPage],
      hasNextPage: !state.hasReachedMax,
      isLoading: state.isLoading,
      error: state.error,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocBuilder<PropertiesBloc, PropertiesState>(
      builder: (context, blocState) {
        if (blocState.properties.isEmpty && !blocState.isLoading) {
          return EmptyState(
            icon: Icons.search_off,
            title: l10n.noPropertiesFound,
            message: l10n.tryAdjustingFilters,
          );
        }

        final pagingState = _toPagingState(blocState);

        return ResponsiveBuilder(
          builder: (context, sizingInformation) {
            final isMobile =
                sizingInformation.deviceScreenType == DeviceScreenType.mobile;

            if (isMobile) {
              return RefreshIndicator(
                onRefresh: () async {
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
                child: PagedListView<int, PropertyModel>(
                  state: pagingState,
                  fetchNextPage: () => _fetchNextPage(context),
                  builderDelegate: PagedChildBuilderDelegate(
                    itemBuilder: (context, property, index) => PropertyCard(
                      property: property,
                      onTap: () {
                        PropertyDetailsRoute($extra: property).go(context);
                      },
                    ),
                    firstPageErrorIndicatorBuilder: (context) => ErrorState(
                      message:
                          pagingState.error?.toString() ?? l10n.unknownError,
                      onRetry: () => _fetchNextPage(context),
                    ),
                    noItemsFoundIndicatorBuilder: (context) => EmptyState(
                      icon: Icons.search_off,
                      title: l10n.noPropertiesFound,
                      message: l10n.tryAdjustingFilters,
                    ),
                  ),
                ),
              );
            }

            // Grid layout for desktop/tablet
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
              child: PagedGridView<int, PropertyModel>(
                state: pagingState,
                fetchNextPage: () => _fetchNextPage(context),
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 450,
                  mainAxisExtent: 360,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                builderDelegate: PagedChildBuilderDelegate(
                  itemBuilder: (context, property, index) => PropertyCard(
                    property: property,
                    onTap: () {
                      PropertyDetailsRoute($extra: property).go(context);
                    },
                  ),
                  firstPageErrorIndicatorBuilder: (context) => ErrorState(
                    message: pagingState.error?.toString() ?? l10n.unknownError,
                    onRetry: () => _fetchNextPage(context),
                  ),
                  noItemsFoundIndicatorBuilder: (context) => EmptyState(
                    icon: Icons.search_off,
                    title: l10n.noPropertiesFound,
                    message: l10n.tryAdjustingFilters,
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

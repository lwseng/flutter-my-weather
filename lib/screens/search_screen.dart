import 'package:flutter/material.dart';

import '../constants/string_constants.dart';
import '../../widgets/base/base_content_view.dart';
import '../widgets/search/search_result_section.dart';
import '../services/geocoding_api_service.dart';

import '../models/location_data.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final FocusNode _searchFocusNode = FocusNode();
  final TextEditingController _searchController = TextEditingController();
  final searchService = GeocodingApiService();
  List<Location> _locationData = [];
  bool _isLoading = false;
  String? _errorMessage;
  String _lastQuery = '';

  @override
  void initState() {
    super.initState();
    _searchFocusNode.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _searchFocusNode.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void searchCity(String searchText) async {
    _lastQuery = searchText;
    List<Location> result = [];

    setState(() {
      _errorMessage = null;
      _isLoading = true;
    });

    try {
      result = await searchService.searchCity(searchText);
    } catch (error) {
      _errorMessage = StringConstants.genericErrorMessage;
    } finally {
      setState(() {
        _locationData = result;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text('Search a Place')),
        body: BaseContentView(
          isLoading: _isLoading,
          errorMessage: _errorMessage,
          onRetry: () => searchCity(_lastQuery),
          content: RefreshIndicator(
            onRefresh: () => searchService.searchCity(_lastQuery),
            child: Padding(
              padding: const EdgeInsetsGeometry.all(20.0),
              child: Column(
                spacing: 20,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: SearchBar(
                          controller: _searchController,
                          hintText: 'Search city',
                          focusNode: _searchFocusNode,
                          onSubmitted: searchCity,
                          elevation: WidgetStatePropertyAll(1),
                        ),
                      ),
                      if (_searchFocusNode.hasFocus)
                        IconButton(
                          onPressed: () {
                            _searchController.clear();
                            _searchFocusNode.unfocus();
                            setState(() {});
                          },
                          icon: const Icon(Icons.cancel, color: Colors.grey),
                          iconSize: 30,
                        ),
                    ],
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: .start,
                      children: [
                        if (_lastQuery.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(left: 5, bottom: 5),
                            child: Text(
                              '${_locationData.length} results found',
                              style: TextTheme.of(context).titleSmall,
                              textAlign: .left,
                            ),
                          ),
                        Expanded(
                          child: ListView.builder(
                            itemBuilder: ((context, index) {
                              return SearchResultSection(
                                result: _locationData[index],
                              );
                            }),
                            itemCount: _locationData.length,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

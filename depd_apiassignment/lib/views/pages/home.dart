// ignore_for_file: sized_box_for_whitespace, deprecated_member_use

part of 'pages.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Province> provinceData = [];

  bool isLoading = false;
  bool isLoadingCityOrigin = false;
  bool isLoadingCityDestination = false;

  Future<dynamic> getProvinces() async {
    await MasterDataService.getProvince().then((value) {
      setState(() {
        provinceData = value;
      });
    });
  }

  dynamic originProvinceId;
  dynamic selectedOriginProvince;
  dynamic destinationProvinceId;
  dynamic selectedDestinationProvince;

  dynamic cityDataOrigin;
  dynamic cityIdOrigin;
  dynamic selectedCityOrigin;

  dynamic destinationCityData;
  dynamic destinationCityId;
  dynamic selectedDestinationCity;

  Future<List<City>> getCities(var provId, var originORdestination) async {
    dynamic city;
    await MasterDataService.getCity(provId).then((value) {
      setState(() {
        city = value;
        if (originORdestination == 'origin') {
          isLoadingCityOrigin = false;
        } else {
          isLoadingCityDestination = false;
        }
      });
    });

    return city;
  }

  var selectedCourier = 'jne';
  List<Costs> costData = [];

  Future<dynamic> getCost(
      var courier, var origin, var destination, var weight) async {
    dynamic costs;
    await MasterDataService.getCosts(origin, destination, weight, courier)
        .then((value) {
      setState(() {
        costs = value;
      });
      isLoading = false;
    });

    return costs;
  }

  var weight = 0;

  @override
  void initState() {
    super.initState();
    getProvinces();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text(
          "Hitung Ongkir",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: AbsorbPointer(
        absorbing: isLoading,
        child: Stack(
          children: [
            Column(
              children: [
                Flexible(
                  flex: 1,
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Flexible(
                                flex: 1,
                                child: DropdownButtonFormField(
                                  items: const [
                                    DropdownMenuItem(
                                      value: 'jne',
                                      child: Text('JNE'),
                                    ),
                                    DropdownMenuItem(
                                      value: 'pos',
                                      child: Text('POS'),
                                    ),
                                    DropdownMenuItem(
                                      value: 'tiki',
                                      child: Text('TIKI'),
                                    ),
                                  ],
                                  onChanged: (value) {
                                    setState(() {
                                      selectedCourier = value as String;
                                    });
                                  },
                                  value: selectedCourier,
                                  isDense: true,
                                  isExpanded: false,
                                ),
                              ),
                              const SizedBox(width: 30),
                              Flexible(
                                flex: 2,
                                child: TextFormField(
                                  decoration: const InputDecoration(
                                    labelText: 'Berat (gr)',
                                  ),
                                  keyboardType: TextInputType.number,
                                  onChanged: (value) {
                                    setState(() {
                                      weight = int.tryParse(value) ?? 0;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                          const Padding(
                            padding: EdgeInsets.only(top: 20),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Origin",
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: DropdownButton(
                                  items: provinceData.map((Province province) {
                                    return DropdownMenuItem(
                                      value: province.provinceId,
                                      child: Text(province.province ?? ""),
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      originProvinceId = value;
                                      isLoadingCityOrigin = true;
                                      selectedCityOrigin = null;
                                      cityDataOrigin =
                                          getCities(originProvinceId, 'origin');
                                    });
                                    cityIdOrigin = null;
                                  },
                                  value: originProvinceId,
                                  isExpanded: true,
                                  hint: selectedOriginProvince == null
                                      ? Text('Pilih Provinsi')
                                      : Text(selectedOriginProvince),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                flex: 1,
                                child: FutureBuilder<List<City>>(
                                  future: cityDataOrigin,
                                  builder: (context, snapshot) {
                                    if (isLoadingCityOrigin) {
                                      return UiLoading.loadingSmall();
                                    } else if (snapshot.hasData) {
                                      return DropdownButton(
                                        isExpanded: true,
                                        value: selectedCityOrigin,
                                        icon: const Icon(Icons.arrow_drop_down),
                                        iconSize: 30,
                                        elevation: 4,
                                        style: const TextStyle(
                                            color: Colors.black),
                                        hint: selectedCityOrigin == null
                                            ? const Text('Pilih kota')
                                            : Text(selectedCityOrigin.cityName),
                                        items: snapshot.data!
                                            .map<DropdownMenuItem<City>>(
                                                (City value) {
                                          return DropdownMenuItem(
                                            value: value,
                                            child:
                                                Text(value.cityName.toString()),
                                          );
                                        }).toList(),
                                        onChanged: (newValue) {
                                          setState(() {
                                            selectedCityOrigin = newValue;
                                            cityIdOrigin =
                                                selectedCityOrigin.cityId;
                                          });
                                        },
                                      );
                                    } else if (snapshot.hasError) {
                                      return const Text("Tidak ada data");
                                    }
                                    return AbsorbPointer(
                                      absorbing: true,
                                      child: DropdownButton(
                                        isExpanded: true,
                                        value: selectedDestinationCity,
                                        icon: const Icon(Icons.arrow_drop_down),
                                        iconSize: 30,
                                        elevation: 4,
                                        style: const TextStyle(
                                            color: Colors.black),
                                        hint: const Text('Pilih kota'),
                                        items: [],
                                        onChanged: null,
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                          const Padding(
                            padding: EdgeInsets.only(top: 20),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Destination",
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: provinceData.isEmpty
                                    ? UiLoading.loadingSmall()
                                    : DropdownButton(
                                        items: provinceData
                                            .map((Province province) {
                                          return DropdownMenuItem(
                                            value: province.provinceId,
                                            child:
                                                Text(province.province ?? ""),
                                          );
                                        }).toList(),
                                        onChanged: (value) {
                                          setState(() {
                                            destinationProvinceId = value;
                                            isLoadingCityDestination = true;
                                            selectedDestinationCity = null;
                                            destinationCityData = getCities(
                                                destinationProvinceId,
                                                'destination');
                                            destinationCityId = null;
                                          });
                                        },
                                        value: destinationProvinceId,
                                        isExpanded: true,
                                        hint: selectedDestinationProvince ==
                                                null
                                            ? Text('Pilih Provinsi')
                                            : Text(selectedDestinationProvince),
                                      ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                flex: 1,
                                child: FutureBuilder<List<City>>(
                                  future: destinationCityData,
                                  builder: (context, snapshot) {
                                    if (isLoadingCityDestination) {
                                      return UiLoading.loadingSmall();
                                    } else if (snapshot.hasData) {
                                      return DropdownButton(
                                        isExpanded: true,
                                        value: selectedDestinationCity,
                                        icon: const Icon(Icons.arrow_drop_down),
                                        iconSize: 30,
                                        elevation: 4,
                                        style: const TextStyle(
                                            color: Colors.black),
                                        hint: selectedDestinationCity == null
                                            ? const Text('Pilih kota')
                                            : Text(selectedDestinationCity
                                                .cityName),
                                        items: snapshot.data!
                                            .map<DropdownMenuItem<City>>(
                                                (City value) {
                                          return DropdownMenuItem(
                                            value: value,
                                            child:
                                                Text(value.cityName.toString()),
                                          );
                                        }).toList(),
                                        onChanged: (newValue) {
                                          setState(() {
                                            selectedDestinationCity = newValue;
                                            destinationCityId =
                                                selectedDestinationCity.cityId;
                                          });
                                        },
                                      );
                                    } else if (snapshot.hasError) {
                                      return const Text("Tidak ada data");
                                    }
                                    return AbsorbPointer(
                                      absorbing: true,
                                      child: DropdownButton(
                                        isExpanded: true,
                                        value: selectedDestinationCity,
                                        icon: const Icon(Icons.arrow_drop_down),
                                        iconSize: 30,
                                        elevation: 4,
                                        style: const TextStyle(
                                            color: Colors.black),
                                        hint: const Text('Pilih kota'),
                                        items: const [],
                                        onChanged: null,
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                          Flexible(
                            flex: 1,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 30),
                              child: ElevatedButton(
                                onPressed: () {
                                  if (destinationCityId == null ||
                                      cityIdOrigin == null ||
                                      weight < 1) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Tolong Isi Semua Data Yang Diperlukan!',
                                        ),
                                      ),
                                    );
                                  } else {
                                    setState(() {
                                      isLoading = true;
                                    });
                                    setState(() async {
                                      costData = await getCost(
                                        selectedCourier,
                                        cityIdOrigin,
                                        destinationCityId,
                                        weight,
                                      );
                                    });
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.blue,
                                ),
                                child: const Text(
                                  'Hitung Estimasi harga',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: Container(
                      width: double.infinity,
                      height: double.infinity,
                      child: costData.isEmpty || costData[0].cost.isEmpty
                          ? const Align(
                              alignment: Alignment.center,
                              child: Text("Tidak Ada Data"),
                            )
                          : ListView.builder(
                              itemCount: costData.length,
                              itemBuilder: (context, index) {
                                return CardProvince(costData[index]);
                              })),
                ),
              ],
            ),
            isLoading == true ? UiLoading.loadingBlock() : Container()
          ],
        ),
      ),
    );
  }
}

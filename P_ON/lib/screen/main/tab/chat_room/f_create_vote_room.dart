import 'dart:isolate';

import 'package:day_night_time_picker/day_night_time_picker.dart';
import 'package:day_night_time_picker/lib/daynight_timepicker.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:location/location.dart';
import 'package:p_on/common/common.dart';
import '../promise_room/vo_naver_headers.dart';
import 'w_header_text_vote.dart';

class CreateVoteRoom extends StatefulWidget {
  final String id;
  final VoteType voteType;

  const CreateVoteRoom({super.key, required this.id, required this.voteType});

  @override
  State<CreateVoteRoom> createState() => _CreateVoteRoomState();
}

class _CreateVoteRoomState extends State<CreateVoteRoom> {
  VoteType? selectedVoteType;
  bool isEndTimeSet = true;
  bool isMultipleChoice = false;
  bool isAnoymous = false;
  TextEditingController _endDateController = TextEditingController();
  TextEditingController _endTimeController = TextEditingController();
  double? _lat;
  double? _lng;
  List<NMarker> _markers = [];
  List<NMarker> get markers => _markers;
  late Future<LocationData> locationData;
  late NaverMapController _mapController;

  void addMarker(double lat, double lng, String id) {
    final marker = NMarker(id: id, position: NLatLng(lat, lng));

    _markers.add(marker);
    for (var marker in _markers) {
      _mapController.addOverlay(marker);
    }
    _mapController.updateCamera(NCameraUpdate.withParams(target: marker.position, zoom: 12));
  }

  Future<LocationData> _getCurrentLocation() async {
    final location = Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return Future.error('Location service not enabled');
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return Future.error('Location permission not granted');
      }
    }
    _locationData = await location.getLocation();

    _lat = _locationData.latitude;
    _lng = _locationData.longitude;

    return _locationData;
  }

  Map<VoteType, List<String>> voteItems = {
    VoteType.Date: ['', ''],
    VoteType.Time: ['', ''],
    VoteType.Location: ['', '']
  };
  Map<VoteType, List<TextEditingController>> textEditingControllers = {
    VoteType.Date: [TextEditingController(), TextEditingController()],
    VoteType.Time: [TextEditingController(), TextEditingController()],
    VoteType.Location: [TextEditingController(), TextEditingController()]
  };

  @override
  void initState() {
    super.initState();
    selectedVoteType = widget.voteType;
    _endDateController.text = _formatDate(DateTime.now());
    locationData = _getCurrentLocation();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      setState(() {});
    });
  }

  String _formatDate(DateTime date) {
    final formatter = DateFormat('yyyy-MM-dd (E)', 'ko_KR');
    return formatter.format(date);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: FutureBuilder<LocationData>(
            future: locationData,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('404 Error!'));
              } else {
                _lat = snapshot.data!.latitude;
                _lng = snapshot.data!.longitude;
                return Scaffold(
                  appBar: PreferredSize(
                    preferredSize: const Size.fromHeight(kToolbarHeight),
                    child: Container(
                      decoration: const BoxDecoration(
                          border:
                              Border(bottom: BorderSide(color: Colors.grey))),
                      child: AppBar(
                        backgroundColor: Colors.white,
                        leading: IconButton(
                            icon: const Icon(
                              Icons.arrow_back_ios,
                              color: Colors.black,
                            ),
                            onPressed: () {}),
                        title: const Text('투표 만들기',
                            style: TextStyle(
                                fontFamily: 'Pretendard', color: Colors.black)),
                        centerTitle: true,
                        actions: [
                          TextButton(
                              onPressed: () {},
                              child: const Text(
                                '저장',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'Pretendard',
                                    fontSize: 18),
                              ))
                        ],
                        elevation: 0,
                      ),
                    ),
                  ),
                  body: ListView(
                    children: [
                      Row(
                        children: VoteType.values.map((voteType) {
                              return Expanded(
                                child: ListTile(
                                  title: Text(voteTypeToString(voteType)),
                                  leading: Radio<VoteType>(
                                    activeColor: AppColors.mainBlue,
                                    value: voteType,
                                    groupValue: selectedVoteType,
                                    onChanged: (VoteType? value) {
                                      setState(() {
                                        selectedVoteType = value;
                                      });
                                    },
                                  ),
                                ),
                              );
                            }).toList() ??
                            [],
                      ),
                      ...selectedVoteType == null
                          ? []
                          : voteItems[selectedVoteType]!
                              .asMap()
                              .entries
                              .map((entry) {
                              int index = entry.key;
                              String item = entry.value;
                              return Container(
                                margin: const EdgeInsets.symmetric(
                                    vertical: 6, horizontal: 24),
                                padding: const EdgeInsets.fromLTRB(12, 4, 4, 4),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    border:
                                        Border.all(color: AppColors.mainBlue3)),
                                child: Stack(
                                  children: [
                                    TextField(
                                      controller: textEditingControllers[
                                          selectedVoteType!]![index],
                                      readOnly:
                                          selectedVoteType == VoteType.Location
                                              ? false
                                              : true,
                                      onTap: () async {
                                        switch (selectedVoteType) {
                                          case VoteType.Date:
                                            _selectedDate(context,
                                                selectedVoteType!, index);
                                            break;
                                          case VoteType.Time:
                                            _selectTime(context,
                                                selectedVoteType!, index);
                                            break;
                                          case VoteType.Location:
                                            break;
                                          default:
                                            break;
                                        }
                                      },
                                      onChanged: (value) {
                                        setState(() {
                                          voteItems[selectedVoteType!]![index] =
                                              value;
                                        });
                                      },
                                      decoration: const InputDecoration(
                                          border: InputBorder.none),
                                    ),
                                    Positioned(
                                      top: 0,
                                      right: 0,
                                      child: IconButton(
                                        icon: const Icon(Icons.close, size: 24),
                                        color: AppColors.mainBlue2,
                                        padding: EdgeInsets.zero,
                                        onPressed: () {
                                          setState(() {
                                            int index =
                                                voteItems[selectedVoteType!]!
                                                    .indexOf(item);
                                            voteItems[selectedVoteType!]
                                                ?.removeAt(index);
                                            textEditingControllers[
                                                    selectedVoteType!]
                                                ?.removeAt(index);
                                          });
                                        },
                                      ),
                                    ),
                                    if (selectedVoteType == VoteType.Location)
                                      Positioned(
                                          right: 30,
                                          child: TextButton(
                                            onPressed: () {
                                              String searchText =
                                                  textEditingControllers[
                                                              selectedVoteType!]![
                                                          index]
                                                      .text;
                                              SearchPlace(searchText);
                                            },
                                            child: Container(
                                                padding: const EdgeInsets.all(6),
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                    color: AppColors.mainBlue2),
                                                child: const Text('검색',
                                                    style: TextStyle(
                                                        fontFamily:
                                                            'Pretendard',
                                                        color: Colors.white))),
                                          ))
                                  ],
                                ),
                              );
                            }).toList(),
                      Align(
                        alignment: Alignment.center,
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                              vertical: 6, horizontal: 24),
                          width: double.infinity,
                          height: 60,
                          child: OutlinedButton(
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all(Colors.white),
                                foregroundColor: MaterialStateProperty.all(
                                    AppColors.mainBlue3),
                                side: MaterialStateProperty.all(
                                    BorderSide(color: AppColors.mainBlue3))),
                            onPressed: () {
                              setState(() {
                                voteItems[selectedVoteType!]?.add('');
                                textEditingControllers[selectedVoteType!]
                                    ?.add(TextEditingController());
                              });
                            },
                            child: const Text('+ 항목 추가',
                                style: TextStyle(
                                    fontFamily: 'Pretenadrd',
                                    fontWeight: FontWeight.w900,
                                    fontSize: 16)),
                          ),
                        ),
                      ),
                      if (selectedVoteType == VoteType.Location)
                        Align(
                          alignment: Alignment.center,
                          child: Container(
                            width: 300,
                            height: 300,
                            decoration: BoxDecoration(
                                border: Border.all(color: AppColors.mainBlue3)),
                            child: NaverMap(
                              options: NaverMapViewOptions(
                                  mapType: NMapType.basic,
                                  rotationGesturesEnable: true,
                                  scrollGesturesEnable: true,
                                  tiltGesturesEnable: true,
                                  zoomGesturesEnable: true,
                                  stopGesturesEnable: true,
                                  // locationButtonEnable: true,
                                  initialCameraPosition: NCameraPosition(
                                      target: NLatLng(_lat ?? 37.5666102,
                                          _lng ?? 126.9783881),
                                      zoom: 10)),
                              onMapReady: (controller) {
                                _mapController = controller;

                                final currentMarker = NMarker(
                                    id: '내위치', position: NLatLng(_lat!, _lng!));
                                controller.addOverlay(currentMarker);
                                print('========================');
                                print('========================');
                                print('========================');
                                print('========================');
                                print('========================');
                                print(currentMarker);
                              },

                              onCameraIdle: () {
                                // 카메라 위치에 대한 좌표 얻어와서 마커 표시하고
                                //   그 부분 검색해서 모달창으로 검색결과 띄워주고
                              },
                            ),
                          ),
                        ),
                      Container(
                        height: 100,
                        margin: const EdgeInsets.symmetric(horizontal: 12),
                        child: Row(
                          children: [
                            Checkbox(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15)),
                                activeColor: AppColors.mainBlue,
                                side: isEndTimeSet
                                    ? const BorderSide(
                                        color: AppColors.mainBlue3)
                                    : const BorderSide(
                                        color: AppColors.grey300),
                                value: isEndTimeSet,
                                onChanged: (bool? value) {
                                  setState(() {
                                    isEndTimeSet = value!;
                                  });
                                }),
                            Text(
                              '종료시간',
                              style: TextStyle(
                                  fontFamily: 'Pretendard',
                                  color: isEndTimeSet
                                      ? Colors.black
                                      : AppColors.grey300),
                            ),
                            Expanded(child: Container()),
                            Container(
                              width: 145,
                              height: 50,
                              padding: const EdgeInsets.only(left: 12),
                              margin: const EdgeInsets.only(right: 6),
                              decoration: BoxDecoration(
                                  border: isEndTimeSet
                                      ? Border.all(color: AppColors.mainBlue3)
                                      : Border.all(color: AppColors.grey300),
                                  borderRadius: BorderRadius.circular(6)),
                              child: TextField(
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                  ),
                                  readOnly: true,
                                  controller: _endDateController,
                                  enabled: isEndTimeSet,
                                  onTap: () async {
                                    DateTime? date = await showDatePicker(
                                      builder: (context, child) {
                                        return Theme(
                                          data: Theme.of(context).copyWith(
                                              colorScheme:
                                                  const ColorScheme.light(
                                                primary: AppColors.mainBlue2,
                                                onPrimary: Colors.white,
                                                onSurface: Colors.black,
                                              ),
                                              textButtonTheme:
                                                  TextButtonThemeData(
                                                style: TextButton.styleFrom(
                                                    foregroundColor:
                                                        AppColors.mainBlue),
                                              )),
                                          child: child!,
                                        );
                                      },
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime(2000),
                                      lastDate: DateTime(2100),
                                    );
                                    if (date != null) {
                                      _endDateController.text =
                                          _formatDate(date);
                                    }
                                  }),
                            ),
                            Container(
                              width: 120,
                              height: 50,
                              padding: const EdgeInsets.only(left: 6),
                              decoration: BoxDecoration(
                                  border: isEndTimeSet
                                      ? Border.all(color: AppColors.mainBlue3)
                                      : Border.all(color: AppColors.grey300),
                                  borderRadius: BorderRadius.circular(6)),
                              child: TextField(
                                readOnly: true,
                                decoration: const InputDecoration(
                                    border: InputBorder.none),
                                controller: _endTimeController,
                                enabled: isEndTimeSet,
                                onTap: () {
                                  TimeOfDay initialTime = TimeOfDay.now();
                                  Navigator.of(context).push(showPicker(
                                      context: context,
                                      value: Time(
                                          hour: initialTime.hour,
                                          minute: initialTime.minute),
                                      onChange: (TimeOfDay time) {
                                        final period =
                                            time.period == DayPeriod.am
                                                ? '오전'
                                                : '오후';
                                        _endTimeController.text =
                                            '$period ${time.hourOfPeriod}시 ${time.minute.toString().padLeft(2, '0')}분';
                                      },
                                      minuteInterval: TimePickerInterval.FIVE,
                                      iosStylePicker: true,
                                      okText: '확인',
                                      okStyle: const TextStyle(
                                          color: AppColors.mainBlue2),
                                      cancelText: '취소',
                                      cancelStyle: const TextStyle(
                                          color: AppColors.mainBlue2),
                                      hourLabel: '시',
                                      minuteLabel: '분',
                                      accentColor: AppColors.mainBlue2));
                                },
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 12),
                        child: Row(
                          children: [
                            Checkbox(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15)),
                                activeColor: AppColors.mainBlue,
                                side: isMultipleChoice
                                    ? const BorderSide(
                                        color: AppColors.mainBlue3)
                                    : const BorderSide(
                                        color: AppColors.grey300),
                                value: isMultipleChoice,
                                onChanged: (bool? value) {
                                  setState(() {
                                    isMultipleChoice = value!;
                                  });
                                }),
                            Text('복수선택',
                                style: TextStyle(
                                    fontFamily: 'Pretendard',
                                    color: isMultipleChoice
                                        ? Colors.black
                                        : AppColors.grey300))
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 12),
                        child: Row(
                          children: [
                            Checkbox(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15)),
                                activeColor: AppColors.mainBlue,
                                side: isAnoymous
                                    ? const BorderSide(
                                        color: AppColors.mainBlue3)
                                    : const BorderSide(
                                        color: AppColors.grey300),
                                value: isAnoymous,
                                onChanged: (bool? value) {
                                  setState(() {
                                    isAnoymous = value!;
                                  });
                                }),
                            Text('익명투표',
                                style: TextStyle(
                                    fontFamily: 'Pretendard',
                                    color: isAnoymous
                                        ? Colors.black
                                        : AppColors.grey300))
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }
            }));
  }

  String voteTypeToString(VoteType voteType) {
    switch (voteType) {
      case VoteType.Date:
        return '일시';
      case VoteType.Time:
        return '시간';
      case VoteType.Location:
        return '장소';
      default:
        return '';
    }
  }

  Future<void> _selectedDate(
      BuildContext context, VoteType voteType, int index) async {
    DateTime? picked = await showDatePicker(
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
              colorScheme: const ColorScheme.light(
                primary: AppColors.mainBlue2,
                onPrimary: Colors.white,
                onSurface: Colors.black,
              ),
              textButtonTheme: TextButtonThemeData(
                style:
                    TextButton.styleFrom(foregroundColor: AppColors.mainBlue),
              )),
          child: child!,
        );
      },
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      textEditingControllers[voteType]![index].text =
          DateFormat('yyyy-MM-dd (EEEE)', 'ko_kr').format(picked);
    }
  }

  Future<void> _selectTime(
      BuildContext context, VoteType voteType, int index) async {
    TimeOfDay initialTime = TimeOfDay.now();
    Navigator.of(context).push(showPicker(
        context: context,
        value: Time(hour: initialTime.hour, minute: initialTime.minute),
        onChange: (TimeOfDay time) {
          final period = time.period == DayPeriod.am ? '오전' : '오후';
          textEditingControllers[voteType]![index].text =
              '$period ${time.hourOfPeriod}시 ${time.minute.toString().padLeft(2, '0')}분';
        },
        minuteInterval: TimePickerInterval.FIVE,
        iosStylePicker: true,
        okText: '확인',
        okStyle: const TextStyle(color: AppColors.mainBlue2),
        cancelText: '취소',
        cancelStyle: const TextStyle(color: AppColors.mainBlue2),
        hourLabel: '시',
        minuteLabel: '분',
        accentColor: AppColors.mainBlue2));
  }

  void SearchPlace(String text) async {
    final dio = Dio();
    final response = await dio.get(
      'https://openapi.naver.com/v1/search/local.json?',
      queryParameters: {
        'query': text,
        'display': 5,
        'sort': 'random',
      },
      options: Options(
        headers: {
          'X-Naver-Client-Id': Client_ID,
          'X-Naver-Client-Secret': Client_Secret,
        },
      ),
    );

    final List<dynamic> items = response.data['items'];
    StringBuffer buffer = StringBuffer();

    // ignore: use_build_context_synchronously
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return SingleChildScrollView(
            child: Column(
              children: items.map((item) {
                return Card(
                  child: Column(
                    children: [
                      ListTile(
                        title: Text((item['title']).replaceAll(RegExp(r'<[^>]*>'), '')),
                        subtitle: Text(item['description']),
                        onTap: () async {
                          Navigator.of(context).pop();
                          final xString = (item['mapx']);
                          buffer..write(xString.substring(0,3))
                            ..write('.')
                            ..write(xString.substring(3));
                          final x = double.parse(buffer.toString());

                          buffer.clear();

                          final yString = (item['mapy']);
                          buffer..write(yString.substring(0,2))
                            ..write('.')
                            ..write(yString.substring(2));
                          final y = double.parse(buffer.toString());

                          addMarker(y, x, _markers.length.toString());

                        },
                      )
                    ],
                  ),
                );
              }).toList(),
            ),
          );
        }
    );
  print(_markers);
  }
}


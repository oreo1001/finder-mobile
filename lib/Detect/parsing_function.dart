import 'dart:convert';

List<List<double>> parseBoxes(String boxString){
  // RegExp regExp = RegExp(r'\d+\.\d+');
  RegExp regExp = RegExp(r'[-+]?\d*\.?\d+(?:[eE][-+]?\d+)?');
  Iterable<Match> matches = regExp.allMatches(boxString);

  // 추출한 숫자를 리스트로 변환
  List<double> numbers = matches.map((match) => double.parse(match.group(0)!)).toList();

  // 이중 리스트로 변환 (2행 4열 구조)
  List<List<double>> result = [];
  for (int i = 0; i < numbers.length; i += 4) {
    result.add(numbers.sublist(i, i + 4));
  }
  return result;
}

Map<String,dynamic> getMapFromParsedData(Map<String,dynamic> parsedData){
  Map<String, dynamic> dataMap = {
    'boxes': [],
    'scores': [],
    'class_ids': [],
    'labels': [],
  };
  if (parsedData['boxes']=='[]') {
    return dataMap;
  }else{
    List<List<double>> boxes = parseBoxes(parsedData['boxes']);

    String scores = parsedData['scores'].replaceAll(' ',',');
    List<double> scoreList = scores.substring(1, scores.length - 1).split(',').map((e) => double.parse(e.trim())).toList();

    String classIds = parsedData['class_ids'].replaceAll(' ',',');
    List<int> classIdList = classIds.substring(1, classIds.length - 1).split(',').map((e) => int.parse(e.trim())).toList();

    String labels =  parsedData['labels'].replaceAll("'", '"');
    List<dynamic> labelDynamicList = jsonDecode(labels);
    List<String> labelList = labelDynamicList.map((e) => e.toString()).toList();

    dataMap = {
      'boxes': boxes,
      'scores': scoreList,
      'class_ids': classIdList,
      'labels': labelList,
    };
    return dataMap;
  }
}
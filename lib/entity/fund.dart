import 'dart:convert' show json;

class Fund {

  double? fundRate;
  double? buyMin;
  double? buySourceRate;
  int? id;
  int? sort;
  double? expectWorth;
  double? netWorth;
  double? totalWorth;
  String? createTime;
  String? dayGrowth;
  String? expectGrowth;
  String? favorite;
  String? fundCode;
  String? fundFullPinyin;
  String? fundName;
  String? fundType;
  String? lastMonthGrowth;
  String? lastSixMonthsGrowth;
  String? lastWeekGrowth;
  String? lastYearGrowth;
  String? manager;
  String? shortName;
  String? updateTime;

  Fund.fromParams({this.fundRate, this.buyMin, this.buySourceRate, this.id, this.sort, this.expectWorth, this.netWorth, this.totalWorth, this.createTime, this.dayGrowth, this.expectGrowth, this.favorite, this.fundCode, this.fundFullPinyin, this.fundName, this.fundType, this.lastMonthGrowth, this.lastSixMonthsGrowth, this.lastWeekGrowth, this.lastYearGrowth, this.manager, this.shortName, this.updateTime});

  factory Fund(Object jsonStr) => jsonStr is String ? Fund.fromJson(json.decode(jsonStr)) : Fund.fromJson(jsonStr);

  static Fund? parse(jsonStr) => ['null', '', null].contains(jsonStr) ? null : Fund(jsonStr);

  Fund.fromJson(jsonRes) {
    fundRate = jsonRes['fundRate'];
    buyMin = jsonRes['buyMin'];
    buySourceRate = jsonRes['buySourceRate'];
    id = jsonRes['id'];
    sort = jsonRes['sort'];
    expectWorth = jsonRes['expectWorth'];
    netWorth = jsonRes['netWorth'];
    totalWorth = jsonRes['totalWorth'];
    createTime = jsonRes['createTime'];
    dayGrowth = jsonRes['dayGrowth'];
    expectGrowth = jsonRes['expectGrowth'];
    favorite = jsonRes['favorite'];
    fundCode = jsonRes['fundCode'];
    fundFullPinyin = jsonRes['fundFullPinyin'];
    fundName = jsonRes['fundName'];
    fundType = jsonRes['fundType'];
    lastMonthGrowth = jsonRes['lastMonthGrowth'];
    lastSixMonthsGrowth = jsonRes['lastSixMonthsGrowth'];
    lastWeekGrowth = jsonRes['lastWeekGrowth'];
    lastYearGrowth = jsonRes['lastYearGrowth'];
    manager = jsonRes['manager'];
    shortName = jsonRes['shortName'];
    updateTime = jsonRes['updateTime'];
  }

  @override
  String toString() {
    return '{"fundRate": ${fundRate != null?'${json.encode(fundRate)}':'null'}, "buyMin": $buyMin, "buySourceRate": $buySourceRate, "id": $id, "sort": $sort, "expectWorth": $expectWorth, "netWorth": $netWorth, "totalWorth": $totalWorth, "createTime": ${createTime != null?'${json.encode(createTime)}':'null'}, "dayGrowth": ${dayGrowth != null?'${json.encode(dayGrowth)}':'null'}, "expectGrowth": ${expectGrowth != null?'${json.encode(expectGrowth)}':'null'}, "favorite": ${favorite != null?'${json.encode(favorite)}':'null'}, "fundCode": ${fundCode != null?'${json.encode(fundCode)}':'null'}, "fundFullPinyin": ${fundFullPinyin != null?'${json.encode(fundFullPinyin)}':'null'}, "fundName": ${fundName != null?'${json.encode(fundName)}':'null'}, "fundType": ${fundType != null?'${json.encode(fundType)}':'null'}, "lastMonthGrowth": ${lastMonthGrowth != null?'${json.encode(lastMonthGrowth)}':'null'}, "lastSixMonthsGrowth": ${lastSixMonthsGrowth != null?'${json.encode(lastSixMonthsGrowth)}':'null'}, "lastWeekGrowth": ${lastWeekGrowth != null?'${json.encode(lastWeekGrowth)}':'null'}, "lastYearGrowth": ${lastYearGrowth != null?'${json.encode(lastYearGrowth)}':'null'}, "manager": ${manager != null?'${json.encode(manager)}':'null'}, "shortName": ${shortName != null?'${json.encode(shortName)}':'null'}, "updateTime": ${updateTime != null?'${json.encode(updateTime)}':'null'}}';
  }

  String toJson() => this.toString();
}
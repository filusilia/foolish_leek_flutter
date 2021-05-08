import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class Profile {
    Profile();
    num? theme;
    String? lastLogin;
    String? locale;
}

import 'package:dio/dio.dart';

import '../rest_client/rest_client.dart';

final dio = Dio(BaseOptions(
));

final restClient = RestClient(Dio());
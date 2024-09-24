// ignore_for_file: depend_on_referenced_packages

import 'dart:io';
import 'package:cookie_jar/cookie_jar.dart';

import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:third_eye/config.dart';
import 'package:third_eye/models/Submit.dart';
import 'package:third_eye/models/get_banners.dart';
import 'package:third_eye/models/get_recipes.dart';

class Api {
  final Dio _dio = Dio();

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<Directory> get _localCoookieDirectory async {
    final path = await _localPath;
    final Directory dir = Directory('$path/cookies');
    await dir.create();
    return dir;
  }

  Future<void> setCookie() async {
    try {
      final Directory dir = await _localCoookieDirectory;
      final cookiePath = dir.path;
      var persistentCookies = PersistCookieJar(
          ignoreExpires: true, storage: FileStorage(cookiePath));

      _dio.interceptors.add(CookieManager(
              persistentCookies) //this sets up _dio to persist cookies throughout subsequent requests
          );
      _dio.options = BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(microseconds: 500000),
        receiveTimeout: const Duration(microseconds: 500000),
        headers: {
          HttpHeaders.userAgentHeader: "PlayPointz-dio-all-head",
          "Connection": "keep-alive",
        },
      );
    } catch (error) {
      debugPrint("set cookie failed $error");
    }
  }

  Future<GetRecipes> getRecipes({int offset, int limit}) async {
    try {
      Response response = await _dio.get(
        '$baseUrl/public/recipe-controller-player?offset=$offset&limit=$limit',
      );
      return GetRecipes.fromJson(response.data);
    } catch (e) {
      if (e.response.statusCode == 400) {
        GetRecipes result = GetRecipes();
        result.message = 'Bad Request.';
        return result;
      } else if (e.response.statusCode == 401) {
        GetRecipes result = GetRecipes();
        result.message = 'Unauthorized.';
        return result;
      } else if (e.response.statusCode == 503) {
        GetRecipes result = GetRecipes();
        result.message = 'Service Unavailable.';
        return result;
      } else {
        GetRecipes result = GetRecipes();
        result.message = 'Something went wrong';
        return result;
      }
    }
  }

  Future<GetBanners> getBanners() async {
    try {
      Response response = await _dio.get(
        '$baseUrl/public/banner-controller-user',
      );
      return GetBanners.fromJson(response.data);
    } catch (e) {
      if (e.response.statusCode == 400) {
        GetBanners result = GetBanners();
        result.message = 'Bad Request.';
        return result;
      } else if (e.response.statusCode == 401) {
        GetBanners result = GetBanners();
        result.message = 'Unauthorized.';
        return result;
      } else if (e.response.statusCode == 503) {
        GetBanners result = GetBanners();
        result.message = 'Service Unavailable.';
        return result;
      } else {
        GetBanners result = GetBanners();
        result.message = 'Something went wrong';
        return result;
      }
    }
  }

  Future<Submit> submitEyeDonation({
    String name,
    String address,
    String nic,
    String gender,
    String nominee,
    String email,
    String phoneNum,
    String dob,
    String district,
    String type,
    String nomineePhoneNum,
  }) async {
    try {
      Response response =
          await _dio.post('$baseUrl/public/eye-donation-controller', data: {
        'name': name,
        'address': address,
        "nic": nic,
        "gender": gender,
        "nominee": nominee,
        "email": email,
        "phone_no": phoneNum,
        "date_of_birth": dob,
        "district": district,
        "type": type,
        "nominee_phone_no": nomineePhoneNum
      });
      return Submit.fromJson(response.data);
    } catch (e) {
      if (e.response.statusCode == 400) {
        Submit result = Submit();
        result.message = 'Bad Request.';
        return result;
      } else if (e.response.statusCode == 401) {
        Submit result = Submit();
        result.message = 'Unauthorized.';
        return result;
      } else if (e.response.statusCode == 503) {
        Submit result = Submit();
        result.message = 'Service Unavailable.';
        return result;
      } else {
        Submit result = Submit();
        result.message = 'Something went wrong';
        return result;
      }
    }
  }
}

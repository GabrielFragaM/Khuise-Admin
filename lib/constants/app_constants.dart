import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:intl/intl.dart';

Logger logger = Logger();

final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

var pageController = PageController();

bool load_api = true;
bool login_status = true;
bool tryLoginLocal = true;

final DateFormat dateFormat = DateFormat('dd/MM/yyyy');

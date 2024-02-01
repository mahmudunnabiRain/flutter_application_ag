import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_application_ag/api_service.dart';
import 'package:flutter_application_ag/auth_controller.dart';
import 'package:flutter_application_ag/helpers.dart';
import 'package:flutter_application_ag/widgets/my_progress_indicator.dart';
import 'package:get/get.dart';

class TradesScreen extends StatefulWidget {
  const TradesScreen({super.key});

  @override
  State<TradesScreen> createState() => _TradesScreenState();
}

class _TradesScreenState extends State<TradesScreen> {
  final AuthController authController = Get.find<AuthController>();
  final ApiService apiService = Get.find<ApiService>();
  bool openTradesLoading = false;
  List<Map<String, dynamic>>? openTrades;
  double? totalProfit;

  @override
  void initState() {
    super.initState();

    fetchOpenTrades();

    // listener to know if the user is logged out. if so, trades screen should pop.
    ever(authController.isAuthenticatedObs, (bool isAuthenticated) {
      if (!isAuthenticated) {
        if (mounted) {
          Navigator.pop(context);
        }
      }
    });
  }

  Future<void> fetchOpenTrades() async {
    setState(() {
      openTradesLoading = true;
    });
    try {
      openTrades = await apiService.getOpenTrades();
      double tp = 0;
      for (var trade in openTrades!) {
        tp += trade['profit'];
      }
      totalProfit = tp;
      log(openTrades.toString());
    } catch (e) {
      if (mounted) {
        mySnack(e.toString(), context, danger: true);
      }
    } finally {
      if (mounted) {
        setState(() {
          openTradesLoading = false;
        });
      }
    }
  }

  Future<void> refreshOpenTrades() async {
    try {
      openTrades = await apiService.getOpenTrades();
      double tp = 0;
      for (var trade in openTrades!) {
        tp += trade['profit'];
      }
      totalProfit = tp;
      log(openTrades.toString());
    } catch (e) {
      if (mounted) {
        mySnack(e.toString(), context, danger: true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Open Trades'),
        actions: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: Colors.blue.shade400,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text('Profit: ${totalProfit?.toStringAsFixed(2) ?? '~'}', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Colors.white)),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              authController.removeAuth();
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: refreshOpenTrades,
        child: !openTradesLoading
            ? ListView.separated(
                itemCount: openTrades == null ? 0 : openTrades!.length,
                separatorBuilder: (BuildContext context, int index) => const Divider(),
                itemBuilder: (BuildContext context, int index) {
                  Map<String, dynamic> trade = openTrades![index];
                  return ListTile(
                    title: Text(
                      '${trade['symbol']}',
                      style: TextStyle(fontWeight: FontWeight.w600, color: Theme.of(context).primaryColor),
                    ),
                    subtitle: Text('Current Price: ${trade['currentPrice']}\n'
                        'Open Price: ${trade['openPrice']}\n'
                        'Profit: ${trade['profit']}\n'
                        'Digits: ${trade['digits']}\n'
                        'Open Time: ${trade['openTime']}\n'
                        'SL: ${trade['sl']}\n'
                        'Swaps: ${trade['swaps']}\n'
                        'TP: ${trade['tp']}\n'
                        'Ticket: ${trade['ticket']}\n'
                        'Type: ${trade['type']}\n'
                        'Volume: ${trade['volume']}'),
                  );
                },
              )
            : const Center(
                child: MyProgressIndicator(),
              ),
      ),
    );
  }
}

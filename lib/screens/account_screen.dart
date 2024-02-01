import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_application_ag/api_service.dart';
import 'package:flutter_application_ag/auth_controller.dart';
import 'package:flutter_application_ag/helpers.dart';
import 'package:flutter_application_ag/screens/trades_screen.dart';
import 'package:flutter_application_ag/widgets/my_button.dart';
import 'package:flutter_application_ag/widgets/my_progress_indicator.dart';
import 'package:get/get.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  final AuthController authController = Get.find<AuthController>();
  final ApiService apiService = Get.find<ApiService>();
  bool accountInformationLoading = false;
  Map<String, dynamic>? accountInformation;

  @override
  initState() {
    super.initState();
    fetchAccountInformation();
  }

  fetchAccountInformation() async {
    setState(() {
      accountInformationLoading = true;
    });
    try {
      accountInformation = await apiService.getAccountInformation();
      log(accountInformation.toString());
    } catch (e) {
      if (mounted) {
        mySnack(e.toString(), context, danger: true);
      }
    } finally {
      if (mounted) {
        setState(() {
          accountInformationLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              authController.removeAuth();
            },
          ),
        ],
      ),
      body: !accountInformationLoading
          ? SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Text('Login: ${authController.login}'),
                    // Text('Token: ${authController.token}'),
                    // MyButton(
                    //   text: 'Fetch Account Information',
                    //   onPress: fetchAccountInformation,
                    //   loading: accountInformationLoading,
                    // ),
                    MyButton(
                      text: 'View Open Trades',
                      onPress: () {
                        if (mounted) {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const TradesScreen(),
                            ),
                          );
                        }
                      },
                    ),
                    if (accountInformation != null)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 16),
                          Container(
                            decoration: const BoxDecoration(border: Border(bottom: BorderSide())),
                            child: const Text('Account Information', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                          ),
                          const SizedBox(height: 8),
                          InfoItem(title: 'Name', value: '${accountInformation!['name']}'),
                          InfoItem(title: 'Address', value: '${accountInformation!['address']}'),
                          InfoItem(title: 'City', value: '${accountInformation!['city']}'),
                          InfoItem(title: 'Country', value: '${accountInformation!['country']}'),
                          InfoItem(title: 'Balance', value: '${accountInformation!['balance']}'),
                          InfoItem(title: 'Currency', value: '${accountInformation!['currency']}'),
                          InfoItem(title: 'Current Trades Count', value: '${accountInformation!['currentTradesCount']}'),
                          InfoItem(title: 'Current Trades Volume', value: '${accountInformation!['currentTradesVolume']}'),
                          InfoItem(title: 'Equity', value: '${accountInformation!['equity']}'),
                          InfoItem(title: 'Free Margin', value: '${accountInformation!['freeMargin']}'),
                          InfoItem(title: 'Is Any Open Trades', value: '${accountInformation!['isAnyOpenTrades']}'),
                          InfoItem(title: 'Is Swap Free', value: '${accountInformation!['isSwapFree']}'),
                          InfoItem(title: 'Leverage', value: '${accountInformation!['leverage']}'),
                          InfoItem(title: 'Phone', value: '${accountInformation!['phone']}'),
                          InfoItem(title: 'Total Trades Count', value: '${accountInformation!['totalTradesCount']}'),
                          InfoItem(title: 'Total Trades Volume', value: '${accountInformation!['totalTradesVolume']}'),
                          InfoItem(title: 'Type', value: '${accountInformation!['type']}'),
                          InfoItem(title: 'Verification Level', value: '${accountInformation!['verificationLevel']}'),
                          InfoItem(title: 'Zip Code', value: '${accountInformation!['zipCode']}'),
                        ],
                      ),
                  ],
                ),
              ),
            )
          : const Center(
              child: MyProgressIndicator(),
            ),
    );
  }
}

class InfoItem extends StatelessWidget {
  final String title;
  final String value;

  const InfoItem({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: Text(
        '$title: $value',
        style: const TextStyle(
            // Add your desired style here
            ),
      ),
    );
  }
}

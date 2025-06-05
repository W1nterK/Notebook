import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:matule/core/colors/brand_colors.dart';
import 'package:matule/layers/presentation/screens/language_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: BrandColors.black,
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: BrandColors.darkbackground,
                ),
                alignment: Alignment.center,
                child: IconButton(
                  onPressed: () => context.go('/first'),
                  icon: Icon(CupertinoIcons.back, color: BrandColors.block,),
                ),
              ),
              Text(
                context.tr('settings'),
                style: GoogleFonts.roboto(
                  fontSize: 25,
                  color: BrandColors.block,
                  fontWeight: FontWeight.w700,
                  decoration: TextDecoration.none
                ),
              ),
              SizedBox(width: 50),
            ],
          ),
          SizedBox(height: 20),
          Expanded(
            child: Column(
              children: [
                GestureDetector(
                  onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LanguageScreen()),
                      ),
                  child: Container(
                    height: 60,
                    width: 400,
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: BrandColors.darkbackground,
                    ),
                    alignment: Alignment.centerLeft,
                    child: Row(
                      children: [
                        Icon(Icons.g_translate, color: BrandColors.purple,),
                        SizedBox(width: 20),
                        Text(
                          context.tr('language'),
                          style: GoogleFonts.roboto(
                            fontSize: 15,
                            color: BrandColors.block,
                            decoration: TextDecoration.none
                            // fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

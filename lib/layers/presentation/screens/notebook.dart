import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:matule/core/colors/brand_colors.dart';

class Notebook extends StatefulWidget {
  const Notebook({super.key});

  @override
  State<Notebook> createState() => _NotebookState();
}

class _NotebookState extends State<Notebook> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BrandColors.black,
      appBar: AppBar(
        backgroundColor: BrandColors.black,
        title: Text(
          context.tr('notebook'),
          style: GoogleFonts.roboto(
            fontSize: 25,
            color: BrandColors.block,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [
          PopupMenuButton<String>(
            icon: Icon(Icons.more_vert, color: BrandColors.block),
            color: BrandColors.darkbackground,
            surfaceTintColor: Colors.transparent,
            itemBuilder:
                (context) => [
                  PopupMenuItem<String>(
                    value: 'settings',
                    height: 40,
                    child: Row(
                      children: [
                        Icon(Icons.settings, color: BrandColors.purple),
                        const SizedBox(width: 12),
                        Text(
                          context.tr('settings'),
                          style: TextStyle(color: BrandColors.block),
                        ),
                      ],
                    ),
                  ),
                ],
            onSelected: (value) {
              context.go('/settings');
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.note_add_outlined,
              size: 64,
              color: BrandColors.subTextDark,
            ),
            const SizedBox(height: 16),
            Text(
              context.tr('notes'),
              style: TextStyle(color: BrandColors.subTextDark, fontSize: 18),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        shape: CircleBorder(),
        backgroundColor: BrandColors.purple,
        child: Icon(Icons.add, color: BrandColors.block),
        onPressed: () {},
      ),
    );
  }
}

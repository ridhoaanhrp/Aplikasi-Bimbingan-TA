import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/bx.dart';

Widget daftarPustakaListTile(
    BuildContext context,
    double bodyWidth,
    double bodyHeight,
    TextEditingController daftarPustakaController,
    TextEditingController catatanDaftarPustakaController,
    String daftarPustakaNote,
    int daftarPustakaValue) {
  return Card(
    elevation: 0,
    child: Container(
      width: bodyWidth * 0.9,
      padding: EdgeInsets.symmetric(horizontal: bodyWidth * 0.03),
      decoration: BoxDecoration(
          color: const Color(0xFFD9E2EE),
          borderRadius: BorderRadius.circular(10)),
      child: Center(
        child: ExpansionTile(
          controlAffinity: ListTileControlAffinity.leading,
          expandedAlignment: Alignment.topLeft,
          expandedCrossAxisAlignment: CrossAxisAlignment.start,
          childrenPadding: EdgeInsets.symmetric(vertical: bodyHeight * 0.01),
          title: Text(
            "Daftar Pustaka: $daftarPustakaValue%",
            style: GoogleFonts.poppins(
                textStyle: const TextStyle(
                    fontSize: 12,
                    color: Colors.black,
                    fontWeight: FontWeight.bold)),
          ),
          trailing: IconButton(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                        title: Text(
                          "Data Progress",
                          style: GoogleFonts.poppins(
                              textStyle: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold)),
                        ),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextFormField(
                              textAlign: TextAlign.center,
                              controller: daftarPustakaController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                  hintText:
                                      daftarPustakaValue.toString().isEmpty
                                          ? 'Progress'
                                          : daftarPustakaValue.toString(),
                                  hintStyle: GoogleFonts.poppins(
                                      textStyle: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.black,
                                          fontWeight: FontWeight.normal)),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: const BorderSide(
                                          color: Color(0xFFE31C21), width: 2))),
                            ),
                            const Divider(color: Colors.white),
                            TextFormField(
                              maxLines: 3,
                              textAlign: TextAlign.center,
                              controller: catatanDaftarPustakaController,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                  hintText: daftarPustakaNote.isEmpty
                                      ? 'Catatan'
                                      : daftarPustakaNote,
                                  hintStyle: GoogleFonts.poppins(
                                      textStyle: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.black,
                                          fontWeight: FontWeight.normal)),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: const BorderSide(
                                          color: Color(0xFFE31C21), width: 2))),
                            ),
                          ],
                        ),
                      ));
            },
            icon: const Iconify(
              Bx.pencil,
              size: 26,
            ),
          ),
          children: [
            Text(
              "Catatan",
              style: GoogleFonts.poppins(
                  textStyle: const TextStyle(
                      fontSize: 12,
                      color: Colors.black,
                      fontWeight: FontWeight.bold)),
            ),
            Text(
              daftarPustakaNote,
              maxLines: 10,
              style: GoogleFonts.poppins(
                  textStyle: const TextStyle(
                      fontSize: 12,
                      color: Colors.black,
                      fontWeight: FontWeight.normal)),
            ),
            SizedBox(
              height: bodyHeight * 0.01,
            ),
            Text(
              "Progress: $daftarPustakaValue%",
              style: GoogleFonts.poppins(
                  textStyle: const TextStyle(
                      fontSize: 12,
                      color: Colors.black,
                      fontWeight: FontWeight.bold)),
            )
          ],
        ),
      ),
    ),
  );
}

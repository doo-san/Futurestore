import 'dart:typed_data';

import 'package:flutter/services.dart' show rootBundle;
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../models/track_order_model.dart';
import 'app_tags.dart';

/// Génère la facture en PDF directement dans l'application (sans backend),
/// avec le logo Futurestore et une mise en page professionnelle.
class InvoicePdfGenerator {
  static const PdfColor _brandRed = PdfColor.fromInt(0xFFFF0008);
  static const PdfColor _dark = PdfColor.fromInt(0xFF333333);
  static const PdfColor _grey = PdfColor.fromInt(0xFF777777);
  static const PdfColor _line = PdfColor.fromInt(0xFFE0E0E0);

  static Future<Uint8List> generate({
    required Order order,
    required String invoiceNo,
    required String Function(String?) convert,
  }) async {
    final doc = pw.Document();

    final logo = pw.MemoryImage(
      (await rootBundle.load('assets/logos/logo.png')).buffer.asUint8List(),
    );
    final regular =
        pw.Font.ttf(await rootBundle.load('assets/fonts/Poppins-Regular.ttf'));
    final medium =
        pw.Font.ttf(await rootBundle.load('assets/fonts/Poppins-Medium.ttf'));
    final theme = pw.ThemeData.withFont(base: regular, bold: medium);

    final details = order.orderDetails ?? [];

    doc.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        theme: theme,
        margin: const pw.EdgeInsets.all(28),
        build: (context) => [
          _header(logo, invoiceNo, order),
          pw.SizedBox(height: 18),
          _customer(order),
          pw.SizedBox(height: 16),
          _itemsTable(details, convert),
          pw.SizedBox(height: 14),
          _totals(order, convert),
        ],
        footer: (context) => _footer(),
      ),
    );

    return doc.save();
  }

  static pw.Widget _header(pw.MemoryImage logo, String invoiceNo, Order order) {
    return pw.Column(
      children: [
        pw.Center(child: pw.Image(logo, height: 46)),
        pw.SizedBox(height: 12),
        pw.Container(height: 2, color: _brandRed),
        pw.SizedBox(height: 12),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(AppTags.invoice.tr.toUpperCase(),
                    style: pw.TextStyle(color: _grey, fontSize: 9)),
                pw.SizedBox(height: 2),
                pw.Text('#$invoiceNo',
                    style: pw.TextStyle(
                        color: _dark,
                        fontSize: 14,
                        fontWeight: pw.FontWeight.bold)),
              ],
            ),
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.end,
              children: [
                pw.Text(AppTags.orderDate.tr,
                    style: pw.TextStyle(color: _grey, fontSize: 9)),
                pw.SizedBox(height: 2),
                pw.Text(_formatDate(order.date),
                    style: pw.TextStyle(color: _dark, fontSize: 11)),
              ],
            ),
          ],
        ),
      ],
    );
  }

  static pw.Widget _customer(Order order) {
    final b = order.billingAddress;
    return pw.Container(
      width: double.infinity,
      padding: const pw.EdgeInsets.all(12),
      decoration: pw.BoxDecoration(
        color: const PdfColor.fromInt(0xFFF7F7F8),
        borderRadius: pw.BorderRadius.circular(6),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(AppTags.accountDetails.tr,
              style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold, color: _dark, fontSize: 11)),
          pw.SizedBox(height: 6),
          if ((b?.name ?? '').isNotEmpty) _kv(AppTags.name.tr, b!.name!),
          if ((b?.email ?? '').isNotEmpty) _kv(AppTags.email.tr, b!.email!),
          if ((b?.address ?? '').isNotEmpty)
            _kv(AppTags.shippingAddress.tr, b!.address!),
          _kv(AppTags.paymentStatus.tr, order.paymentStatus ?? ''),
          _kv(AppTags.deliveryStatus.tr, order.orderStatus ?? ''),
        ],
      ),
    );
  }

  static pw.Widget _kv(String k, String v) => pw.Padding(
        padding: const pw.EdgeInsets.only(bottom: 3),
        child: pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.SizedBox(
                width: 110,
                child: pw.Text('$k:',
                    style: pw.TextStyle(color: _grey, fontSize: 9))),
            pw.Expanded(
                child: pw.Text(v,
                    style: pw.TextStyle(color: _dark, fontSize: 9))),
          ],
        ),
      );

  static pw.Widget _itemsTable(
      List<OrderDetails> details, String Function(String?) convert) {
    return pw.TableHelper.fromTextArray(
      border: pw.TableBorder.all(color: _line, width: .5),
      headerDecoration: const pw.BoxDecoration(color: _brandRed),
      headerStyle: pw.TextStyle(
          color: PdfColors.white, fontWeight: pw.FontWeight.bold, fontSize: 9),
      cellStyle: pw.TextStyle(fontSize: 9, color: _dark),
      cellPadding: const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 6),
      headerAlignment: pw.Alignment.centerLeft,
      cellAlignments: {
        0: pw.Alignment.centerLeft,
        1: pw.Alignment.center,
        2: pw.Alignment.centerRight,
      },
      columnWidths: {
        0: const pw.FlexColumnWidth(5),
        1: const pw.FlexColumnWidth(2),
        2: const pw.FlexColumnWidth(3),
      },
      headers: [AppTags.products.tr, AppTags.qty.tr, AppTags.totalCost.tr],
      data: details
          .map((d) => [
                d.productName ?? '',
                (d.quantity ?? '').toString(),
                convert(d.formattedTotalPayable),
              ])
          .toList(),
    );
  }

  static pw.Widget _totals(Order order, String Function(String?) convert) {
    pw.Widget row(String label, String value, {bool total = false}) {
      final style = pw.TextStyle(
        fontSize: total ? 11 : 9,
        color: total ? _brandRed : _dark,
        fontWeight: total ? pw.FontWeight.bold : pw.FontWeight.normal,
      );
      return pw.Padding(
        padding: const pw.EdgeInsets.symmetric(vertical: 3),
        child: pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [pw.Text(label, style: style), pw.Text(value, style: style)],
        ),
      );
    }

    return pw.Align(
      alignment: pw.Alignment.centerRight,
      child: pw.SizedBox(
        width: 240,
        child: pw.Column(
          children: [
            row(AppTags.subtotal.tr, convert(order.formattedSubTotal)),
            row(AppTags.discountOffer.tr, convert(order.formattedDiscount)),
            row(AppTags.deliveryCharge.tr, convert(order.formattedShippingCost)),
            row(AppTags.tax.tr, convert(order.formattedTax)),
            pw.Divider(color: _line),
            row(AppTags.totalCost.tr, convert(order.formattedTotalPayable),
                total: true),
          ],
        ),
      ),
    );
  }

  static pw.Widget _footer() => pw.Center(
        child: pw.Text(
          "Futurestore — Le futur s'installe chez vous",
          style: pw.TextStyle(color: _grey, fontSize: 8),
        ),
      );

  static String _formatDate(DateTime? date) {
    if (date == null) return '';
    return DateFormat('dd/MM/yyyy').format(date);
  }
}

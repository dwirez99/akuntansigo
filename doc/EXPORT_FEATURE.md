# 📊 Fitur Export Data - AkuntansiGo

## Overview
Fitur export memungkinkan pengguna untuk mengekspor data transaksi dan kategori ke format Excel (.xlsx) untuk analisis lebih lanjut, backup, atau berbagi dengan pihak lain.

---

## Fitur Utama

### 1. Export Transaksi
- **Format**: Excel (.xlsx) dengan multiple sheets
- **Sheets yang dibuat**:
  - `Ringkasan`: Berisi total pemasukan, pengeluaran, saldo, dan analisis per kategori
  - `Pemasukan`: Daftar semua transaksi pemasukan
  - `Pengeluaran`: Daftar semua transaksi pengeluaran
  - `Semua Data`: Gabungan semua transaksi

### 2. Export Kategori
- **Format**: Excel (.xlsx)
- **Isi**: Daftar semua kategori dengan nama dan deskripsi

---

## Cara Menggunakan

### Export Transaksi

1. **Buka Halaman Kelola Transaksi**
2. **Klik icon Download** (⬇️) di pojok kanan atas
3. **Pilih pengaturan export**:
   - **Format File**: Excel (saat ini hanya Excel yang tersedia)
   - **Rentang Waktu**:
     - Semua Data
     - Bulan Ini
     - Pilih Rentang (custom date range)
   - **Jenis Transaksi**: 
     - ☑ Pemasukan
     - ☑ Pengeluaran
   - **Filter Kategori**: Pilih kategori tertentu atau "Semua Kategori"
4. **Klik "Export Sekarang"**
5. **Pilih opsi**:
   - **Tutup**: Menutup dialog
   - **Bagikan** (Android/iOS): Membagikan file melalui aplikasi lain (WhatsApp, Email, dll)
   - **Buka Folder** (Desktop): Membuka file manager di lokasi file tersimpan

### Export Kategori

1. **Buka Halaman Kelola Kategori**
2. **Klik icon Download** (⬇️) di pojok kanan atas
3. **File akan langsung di-export**
4. **Pilih opsi**:
   - **Tutup**: Menutup dialog
   - **Bagikan** (Android/iOS): Membagikan file
   - **Buka Folder** (Desktop): Membuka lokasi file

---

## Lokasi File Export

File yang di-export disimpan di:
```
Android: /data/data/com.example.akuntansigo/app_flutter/documents/
iOS: Application Documents Directory
Linux: ~/.local/share/akuntansigo/app_flutter/documents/
Windows: C:\Users\[Username]\AppData\Roaming\akuntansigo\documents\
macOS: ~/Library/Application Support/akuntansigo/documents/
```

**Nama File Format**:
```
AkuntansiGo_Export_YYYYMMDD_HHMMSS.xlsx
AkuntansiGo_Kategori_YYYYMMDD_HHMMSS.xlsx
```

Contoh: `AkuntansiGo_Export_20241215_143022.xlsx`

---

## Struktur File Excel

### Sheet: Ringkasan
```
┌─────────────────────────────────┐
│ RINGKASAN KEUANGAN              │
├─────────────────────────────────┤
│ Tanggal Export: 15 Des 2024     │
│                                 │
│ TOTAL PEMASUKAN    : Rp 5,000,000│
│ TOTAL PENGELUARAN  : Rp 3,500,000│
│ SALDO              : Rp 1,500,000│
│                                 │
│ Jumlah Transaksi Pemasukan: 15  │
│ Jumlah Transaksi Pengeluaran: 23│
│                                 │
│ ANALISIS PEMASUKAN PER KATEGORI │
│ Kategori | Jumlah | Total | %   │
│ ...                             │
└─────────────────────────────────┘
```

### Sheet: Pemasukan/Pengeluaran/Semua Data
```
┌─────────────────────────────────────────────────────────┐
│ No | Tanggal   | Nama       | Kategori | Jenis | Nominal│
├─────────────────────────────────────────────────────────┤
│ 1  | 01/12/24  | Gaji       | Gaji     | ...   | 5,000  │
│ 2  | 05/12/24  | Bonus      | Bonus    | ...   | 1,000  │
│ ...                                                     │
│                              TOTAL:         6,000       │
└─────────────────────────────────────────────────────────┘
```

---

## Styling Excel

### Color Coding:
- 🟢 **Hijau** (`#D4EDDA`): Pemasukan
- 🔴 **Merah** (`#F8D7DA`): Pengeluaran
- 🔵 **Biru** (`#4472C4`): Header kolom
- 🟡 **Kuning** (`#FFD966`): Total/Summary

### Format:
- **Header**: Bold, white text, colored background
- **Nominal**: Format currency dengan separator (e.g., 1,000,000)
- **Persentase**: Format percentage (e.g., 25.50%)
- **Auto-fit columns**: Semua kolom otomatis menyesuaikan lebar

---

## Dependencies

Package yang digunakan untuk fitur export:

```yaml
dependencies:
  syncfusion_flutter_xlsio: ^24.2.9  # Excel file creation
  share_plus: ^7.2.2                 # File sharing
  permission_handler: ^11.3.0        # Storage permissions
  path_provider: ^2.1.1              # File path
  intl: ^0.18.1                      # Date formatting
```

---

## Permissions

### Android
Tambahkan di `android/app/src/main/AndroidManifest.xml`:

```xml
<!-- For Android 10 and below -->
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" 
    android:maxSdkVersion="29"/>
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" 
    android:maxSdkVersion="32"/>

<!-- For Android 11+ (optional, for broader access) -->
<uses-permission android:name="android.permission.MANAGE_EXTERNAL_STORAGE"/>
```

### iOS
Tambahkan di `ios/Runner/Info.plist`:

```xml
<key>NSPhotoLibraryAddUsageDescription</key>
<string>Aplikasi memerlukan akses untuk menyimpan file export</string>
```

---

## Troubleshooting

### 1. "Permission denied"
**Solusi**: 
- Pastikan permission sudah di-grant
- Coba restart aplikasi
- Periksa settings → Apps → AkuntansiGo → Permissions

### 2. "Tidak ada data untuk di-export"
**Solusi**:
- Pastikan ada transaksi yang sesuai dengan filter
- Coba ganti rentang waktu ke "Semua Data"
- Pastikan checkbox Pemasukan/Pengeluaran di-centang

### 3. File tidak bisa dibuka di Excel
**Solusi**:
- Pastikan menggunakan Microsoft Excel 2007 atau lebih baru
- Atau gunakan Google Sheets / LibreOffice Calc
- File format: `.xlsx` (Excel modern)

### 4. "Export gagal"
**Solusi**:
- Periksa storage space (pastikan ada ruang tersisa)
- Coba export data yang lebih sedikit (gunakan filter)
- Restart aplikasi

### 5. "Share tidak tersedia" di Desktop
**Penjelasan**:
- Share functionality hanya tersedia di Android dan iOS
- Desktop platforms (Linux/Windows/Mac) tidak mendukung native sharing

**Solusi**:
- Gunakan tombol **"Buka Folder"** untuk membuka file manager
- Copy/move file secara manual ke lokasi yang diinginkan
- Atau kirim via email client desktop Anda

---

## Platform Support

### Share Functionality
| Platform | Share Support | Alternative |
|----------|---------------|-------------|
| Android  | ✅ Yes        | Native share dialog |
| iOS      | ✅ Yes        | Native share dialog |
| Linux    | ❌ No         | "Buka Folder" button |
| Windows  | ❌ No         | "Buka Folder" button |
| macOS    | ❌ No         | "Buka Folder" button |

### Notes:
- Desktop platforms tidak mendukung native sharing seperti mobile
- Fitur "Buka Folder" membuka file manager di lokasi file tersimpan
- File dapat di-copy/move secara manual atau di-attach ke email

---

## Roadmap / Coming Soon

- [ ] **CSV Export**: Format sederhana untuk import ke sistem lain
- [ ] **PDF Export**: Laporan dalam format PDF
- [ ] **Email Export**: Kirim langsung via email
- [ ] **Auto Export**: Schedule export otomatis (harian/mingguan/bulanan)
- [ ] **Cloud Backup**: Upload otomatis ke Google Drive / Dropbox
- [ ] **Custom Template**: Pilih template Excel sesuai kebutuhan
- [ ] **Chart Export**: Include grafik dalam Excel
- [ ] **Desktop Share**: Implement desktop-specific sharing mechanisms

---

## Technical Details

### File Structure
```
lib/
├── core/
│   └── export/
│       ├── excel_exporter.dart     # Main export logic
│       └── export_helper.dart      # Helper utilities
└── widgets/
    └── export_dialog.dart          # Export UI dialog
```

### Main Classes

#### ExcelExporter
```dart
static Future<File> exportTransaksi({
  required List<Transaksi> transaksiList,
  required List<Kategori> kategoriList,
  String? fileName,
  DateTime? startDate,
  DateTime? endDate,
})
```

#### ExportHelper
```dart
static Future<void> shareFile(File file)
static String generateFileName({required String prefix, required String extension})
static Future<bool> requestStoragePermission()
```

---

## Support

Jika mengalami masalah atau ada pertanyaan:
1. Periksa bagian Troubleshooting di atas
2. Pastikan semua dependencies ter-install dengan benar: `flutter pub get`
3. Cek console untuk error messages
4. Buat issue di repository (jika menggunakan Git)

---

## Version History

### v1.0.1 (2024-12-15)
- ✅ Export transaksi ke Excel
- ✅ Multiple sheets (Ringkasan, Pemasukan, Pengeluaran, Semua)
- ✅ Filter berdasarkan date range
- ✅ Filter berdasarkan jenis transaksi
- ✅ Filter berdasarkan kategori
- ✅ Export kategori ke Excel
- ✅ Share functionality (Android/iOS)
- ✅ "Buka Folder" functionality (Desktop)
- ✅ Platform-specific button handling
- ✅ Auto styling & formatting
- ✅ Permission handling

---

**Happy Exporting! 📊✨**
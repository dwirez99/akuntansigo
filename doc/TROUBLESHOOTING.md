# 🔧 Troubleshooting Guide - AkuntansiGo

## Common Warnings & Errors

### 1. Keyboard Event Warning (Linux/Desktop)

**Warning Message:**
```
WARNING: Unable to retrieve framework response: Message is not valid JSON
A KeyDownEvent is dispatched, but the state shows that the physical key is already pressed
```

**Severity:** ⚠️ Low (Tidak mempengaruhi functionality)

**Explanation:**
- Ini adalah bug known di Flutter untuk desktop platforms (Linux/Windows/Mac)
- Terjadi saat keyboard event handling
- **TIDAK mempengaruhi** fitur aplikasi, termasuk fitur export

**Solution:**
1. **Ignore:** Warning ini aman diabaikan, aplikasi tetap berfungsi normal
2. **Update Flutter:** Jalankan `flutter upgrade` untuk mendapat fix terbaru
3. **Workaround:** Tidak ada action diperlukan

**Status:** Known Flutter Issue - Not App-Specific

---

### 2. Database Factory Warning

**Warning Message:**
```
Bad state: databaseFactory not initialized
databaseFactory is only initialized when using sqflite
```

**Severity:** 🔴 High (Aplikasi crash)

**Explanation:**
- Terjadi saat menggunakan sqflite di desktop platform
- Desktop memerlukan `sqflite_common_ffi` untuk database

**Solution:**
✅ **Sudah diperbaiki** di `main.dart` dengan kode:
```dart
if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;
}
```

**Cara Test:**
1. Restart aplikasi completely (bukan hot restart)
2. Jika masih error, jalankan: `flutter clean && flutter pub get && flutter run`

---

### 3. Permission Denied (Export Feature)

**Error Message:**
```
Exception: Permission denied
```

**Severity:** 🟡 Medium

**Explanation:**
- Android memerlukan permission untuk akses storage
- Terjadi saat pertama kali export file

**Solution:**

#### Android:
1. Pastikan `AndroidManifest.xml` sudah ada permission:
```xml
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" 
    android:maxSdkVersion="29"/>
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" 
    android:maxSdkVersion="32"/>
```

2. Jika masih error:
   - Buka Settings → Apps → AkuntansiGo → Permissions
   - Enable "Storage" atau "Files and media"

3. Atau uninstall dan install ulang aplikasi

#### Desktop (Linux/Windows/Mac):
- Tidak perlu permission khusus
- File disimpan di Application Documents Directory

---

### 4. Unused Import Warning

**Warning Message:**
```
warning • Unused import: '../models/kategori.dart'
```

**Severity:** 🟢 Very Low

**Explanation:**
- Import yang tidak terpakai dalam file
- Tidak mempengaruhi performance atau functionality

**Solution:**
```dart
// Hapus import yang tidak digunakan
// Sebelum:
import '../models/kategori.dart';

// Sesudah: (dihapus)
```

**Auto-fix:**
```bash
flutter analyze
# Kemudian hapus import yang disebutkan
```

---

### 5. Dependency Conflict

**Error Message:**
```
Because excel ^4.0.3 depends on archive ^3.6.1 and 
flutter_native_splash >=2.4.6 requires archive ^4.0.2
version solving failed
```

**Severity:** 🔴 High

**Explanation:**
- Konflik versi antara packages
- Package memerlukan versi archive yang berbeda

**Solution:**
✅ **Sudah diperbaiki** dengan downgrade `flutter_native_splash` ke versi 2.4.4

**Jika masih terjadi:**
```bash
flutter pub get
# Atau
flutter pub upgrade
# Atau
flutter clean && flutter pub get
```

---

### 6. Export File Tidak Bisa Dibuka

**Error:** File Excel corrupt atau tidak bisa dibuka

**Severity:** 🟡 Medium

**Possible Causes:**
1. Export proses terganggu (app closed sebelum selesai)
2. Storage penuh
3. Aplikasi Excel/Sheets outdated

**Solution:**
1. **Pastikan export selesai completely** (tunggu success dialog)
2. **Check storage space:** Pastikan ada minimal 50MB free space
3. **Update aplikasi Excel:**
   - Microsoft Excel 2007 or newer
   - Google Sheets (online)
   - LibreOffice Calc (free alternative)
4. **Try different app:** Jika Excel error, coba buka dengan Google Sheets
5. **Re-export:** Coba export ulang data

---

### 7. Hot Reload/Restart Issues

**Problem:** Perubahan code tidak terlihat setelah hot reload

**Severity:** 🟢 Low

**Solution:**
```bash
# Hot Restart (lebih baik dari hot reload)
r

# Full Restart (paling reliable)
# Stop app, then:
flutter run

# Clear everything (jika masih bermasalah)
flutter clean
flutter pub get
flutter run
```

**When to use:**
- Hot Reload: UI changes
- Hot Restart: Logic changes, state changes
- Full Restart: Database changes, main.dart changes
- Flutter Clean: Dependency changes

---

### 8. Build Errors After Adding Dependencies

**Error:** Various build errors setelah `flutter pub add`

**Solution:**
```bash
# Step 1: Clean
flutter clean

# Step 2: Get dependencies
flutter pub get

# Step 3: Build
flutter build linux  # or android/windows/ios
```

---

### 9. Syncfusion License Warning

**Warning:**
```
Invalid syncfusion license key
```

**Severity:** 🟢 Low (Community license free)

**Explanation:**
- Syncfusion menampilkan watermark jika tidak ada license
- Community license GRATIS untuk personal/small business use

**Solution:**
1. **Untuk personal use:** Ignore warning (app tetap jalan)
2. **Untuk production:**
   - Daftar di: https://www.syncfusion.com/account/claim-license-key
   - Get free community license
   - Add to app:
```dart
void main() {
  SyncfusionLicense.registerLicense('YOUR-LICENSE-KEY');
  runApp(MyApp());
}
```

---

## Performance Issues

### Slow Export for Large Data

**Problem:** Export lambat untuk >1000 transaksi

**Solution:**
1. **Use date filter:** Export data per bulan
2. **Use category filter:** Export per kategori
3. **Export in background:** (feature coming soon)

---

## Development Tips

### 1. Check Diagnostics
```bash
flutter analyze
```

### 2. Check Device Logs
```bash
flutter logs
```

### 3. Verbose Output
```bash
flutter run -v
```

### 4. Clear App Data (Testing)
```bash
# Android
adb shell pm clear com.example.akuntansigo

# Desktop
# Hapus database file di documents directory
```

---

### 10. Share Not Supported (Desktop Platforms)

**Error Message:**
```
UnimplementedError: shareXFiles() has not been implemented on Linux
```

**Severity:** 🟢 Low (Expected behavior)

**Explanation:**
- Share functionality tidak tersedia di desktop platforms (Linux/Windows/Mac)
- Ini adalah limitasi dari package `share_plus`
- Hanya Android dan iOS yang mendukung native sharing

**Solution:**
✅ **Sudah diperbaiki** dengan fallback:
- **Desktop**: Tombol "Buka Folder" untuk membuka file manager
- **Mobile**: Tombol "Bagikan" untuk share via WhatsApp/Email/dll

**Cara Menggunakan:**
1. **Di Android/iOS:** 
   - Klik "Bagikan" → Pilih app (WhatsApp, Email, dll)
2. **Di Desktop (Linux/Windows/Mac):**
   - Klik "Buka Folder" → File manager akan terbuka
   - Copy/Move file secara manual ke lokasi yang diinginkan

**File Location:**
- Linux: `~/.local/share/akuntansigo/app_flutter/documents/`
- Windows: `C:\Users\[Username]\AppData\Roaming\akuntansigo\documents\`
- Mac: `~/Library/Application Support/akuntansigo/documents/`

---

## When to Report Bug

Report bug jika:
- ✅ App crash consistently
- ✅ Data loss terjadi
- ✅ Export completely fails (tidak bisa membuat file)
- ✅ Database error yang persistent
- ✅ File Excel corrupt/tidak bisa dibuka

**Jangan report** untuk:
- ❌ Keyboard warning (Flutter issue)
- ❌ Unused import warning
- ❌ UI minor glitches yang hilang setelah restart
- ❌ Share not supported di desktop (expected behavior)

---

## Getting Help

1. **Check Documentation:**
   - `README.md` - Overview
   - `EXPORT_FEATURE.md` - Export guide
   - This file - Troubleshooting

2. **Debug Steps:**
   - Run `flutter doctor`
   - Run `flutter analyze`
   - Check console logs
   - Try flutter clean

3. **Common Fixes:**
   ```bash
   # The magic command that fixes 80% of issues:
   flutter clean && flutter pub get && flutter run
   ```

---

## System Requirements

### Minimum:
- Flutter SDK 3.0+
- Dart 3.0+
- Android 5.0+ (API 21+) or Desktop Linux/Windows/Mac
- 100MB free storage
- 2GB RAM

### Recommended:
- Flutter SDK 3.10+
- 500MB free storage
- 4GB RAM
- SSD storage

---

**Last Updated:** 2024-12-15
**Version:** 1.0.0
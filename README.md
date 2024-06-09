# MoneyFest

Aplikasi mobile yang akan dikembangkan ini diberi nama MoneyFest dan dikembangkan menggunakan teknologi Postgre sebagai database dan hosting, flutter sebagai platform aplikasi mobile, serta Laravel sebagai server untuk menghubungkan aplikasi mobile dengan database dan menyediakan API untuk berkomunikasi dengan aplikasi. MoneyFest ditargetkan dapat membantu User membuat dan memanage keuangan mereka. 

Dengan Penggunaan teknologi terbaru dan inovatif, aplikasi MoneyFest ditargetkan dapat membantu individu membuat dan memanage catatan keuangan yang dimiliki. Sehingga dapat membuat catatan keuangan yang akurat dan juga detail. Oleh karena itu, pembuatan aplikasi MoneyFest diharapkan dapat memberikan manfaat yang positif dalam meningkatkan kualitas catatan keuang individu serta memberikan kontribusi positif kepada individu yang menggunakannya.

## Proses Instalasi :

### 1. Mengunduh proyek dengan cara clone.
```bash
git clone https://github.com/RenoSebastian/MoneyFest.git
```

### 2. Instal Front End

2.1 Menuju direktori MoneyFest.
```bash
cd MoneyFest/money_fest_frontend 
```

2.2 Buka Folder di Visual Studio Code.
```bash
code .
```

2.3 Buka Terminal dan New Terminal

2.4 Menginstal Dependencies.
```bash
flutter pub get
```

2.5 Membuka dan Mengatur Android Studio (SDK)

2.6 Menjalankan di main.dart 
Klik Run pada :
```dart
import 'package:flutter/material.dart';

import 'app.dart';

void main() => runApp(const MoneyFestApp());
```

### 3. Instal Back-End 

3.1 Menuju direktori MoneyFest.
```bash
cd MoneyFest/money_fest_frontend 
```

3.2 Buka Folder di Visual Studio Code.
```bash
code .
```

3.3 Buka Terminal dan New Terminal

3.4 Menginstal composer
```bash
composer install
```

3.5 Menduplikasi .env.example lalu mengubah copy-an nya menjadi .env saja.

3.6 Atur .env 
Jika anda memakai PgAdmin :

```bash
DB_CONNECTION=pgsql
DB_HOST=localhost
DB_PORT=5432
DB_DATABASE=nama_database
DB_USERNAME= username_anda
DB_PASSWORD= password_anda
```

Jika anda memakai phpmyadmin :

```bash
DB_CONNECTION=mysql
DB_HOST=localhost
DB_PORT=3306
DB_DATABASE=nama_database
DB_USERNAME=username_anda
DB_PASSWORD=password_anda
```

3.7 Melakukan Migrasi
```bash
php artisan migrate
```

3.8 Menggunakan Seeder yang telah kami buat
```bash
php artisan db:seed UserSeeder
```

## Penggunaan Aplikasi

### 1. Login

1.1 Jika memakai seeder yang telah kita sediakan :
* Username: timsar
* Password: 123456

1.2 Jika ingin membuat akun baru:
* Melakukan registrasi
* Mengisi data yang sesuai
* Masuk ke Aplikasi

### 2. Profile

* Anda akan diarahkan ke tampilan profile
* Anda bisa menambahkan foto sesuai dengan yang anda inginkan

### 3. Budget

#### 3.1 Add Balance

* Dimana anda bisa menginputkan jumlah saldo yang anda miliki saat itu

#### 3.2 Savings

* Di dalam fitur ini anda dapat menambahkan target tabungan anda dimana nantinya di sesuaikan dengan saldo yang anda miliki
* 3.2.1 Add Category:
	+ Masukan Nama Category
* 3.2.2 Add Sub Category:
	+ Masukan Nama Sub Category
	+ Masukan Jumlah yang anda Butuhkan untuk menabung
* 3.2.3 Anda Dapat menghapus per category
* 3.2.4 Anda dapat melakukan perubahan pada category dan sub category

#### 3.3 Instalment

* Di dalam fitur ini anda dapat menambahkan target cicilan anda dimana nantinya di sesuaikan dengan saldo yang anda miliki
* 3.3.1 Add Category:
	+ Masukan Nama Category
	+ Masukan Jumlah target yang anda akan cicil
* 3.3.2 Anda Dapat menghapus per category
* 3.3.3 Anda dapat melakukan perubahan pada category
* 3.3.4 Atur Pengingat:
	+ Klik icon lonceng atau notifikasi
	+ Anda akan diarahkan ke pop up dan mengisi sesuai dengan target deadline anda
	+ Save

### 4. Report

* Anda Dapat Melihat:
	+ Pengeluaran anda setiap bulan dengan diagram untuk mengetahui persentasenya
	+ Agar anda dapat lebih teratur

### 5. Logout

* 5.1 Kembali ke halaman profile
* 5.2 Klik Titik 3 di pojok kanan atas
* 5.3 Klik Logout

### Informasi Tambahan

* Anda dapat masuk ke akun yang sudah anda buat sebelumnya dan data-data nya akan tetap ada di akun tersebut.
* Anda akan mendapatkan notifikasi pengingat harian.


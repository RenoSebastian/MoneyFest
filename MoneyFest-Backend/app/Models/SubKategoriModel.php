<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class SubKategoriModel extends Model
{
    protected $table = 'SubKategori';

    protected $fillable = [
        'NamaSub',
        'uang',
        'kategori_id',
    ];

    protected static function boot()
    {
        parent::boot();

        static::saved(function ($subKategori) {
            // Ambil kategori terkait
            $kategori = $subKategori->kategori;

            // Hitung total uang dari subkategori terkait dan update jumlah di kategori
            $kategori->jumlah = $kategori->subKategoris()->sum('uang');
            $kategori->save();
        });
    }

    public function kategori()
    {
        return $this->belongsTo(KategoriModel::class, 'kategori_id');
    }
}

// <?php

// namespace App\Models;

// use Illuminate\Database\Eloquent\Model;

// class SubKategoriModel extends Model
// {
//     protected $table = 'SubKategori';

//     protected $fillable = [
//         'NamaSub',
//         'uang',
//     ];

//     public static function boot()
//     {
//         parent::boot();

//         static::creating(function ($subKategori) {
//             // Ambil kategori_id dari request saat ini jika ada
//             if (!$subKategori->kategori_id && request()->has('kategori_id')) {
//                 $subKategori->kategori_id = request()->input('kategori_id');
//             }
//         });
//     }

//     public function kategori()
//     {
//         return $this->belongsTo(Kategori::class, 'kategori_id');
//     }
// }
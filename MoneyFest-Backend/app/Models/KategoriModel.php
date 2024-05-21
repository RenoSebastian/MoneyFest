<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class KategoriModel extends Model
{
    protected $table = 'kategori';

    protected $fillable = [
        'user_id',
        'NamaKategori',
    ];

    protected static function booted()
{
    parent::boot();

    static::saved(function ($kategori) {
        // Hitung total uang dari subkategori terkait
        $totalUang = $kategori->subKategoris()->sum('uang');

        // Format total uang sesuai kebutuhan
        $formattedTotalUang = number_format($totalUang, 2, '.', ',');

        // Update jumlah di kategori dengan total uang yang diformat
        $kategori->jumlah = $formattedTotalUang;
        $kategori->save();
    });
}


    public function subKategoris()
    {
        return $this->hasMany(SubKategoriModel::class, 'kategori_id');
    }

    public function user()
    {
        return $this->belongsTo(User::class);
    }
}
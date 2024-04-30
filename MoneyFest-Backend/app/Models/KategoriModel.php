<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class KategoriModel extends Model
{
    protected $table = 'kategori';

    protected $fillable = [
        'NamaKategori',
    ];

    protected static function booted()
    {
        static::saved(function ($kategori) {
            $kategori->jumlah = $kategori->subKategoris()->sum('uang');
        });
    }

    public function subKategoris()
    {
        return $this->hasMany(SubKategoriModel::class, 'kategori_id');
    }
}
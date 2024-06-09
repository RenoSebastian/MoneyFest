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

    public $timestamps = true;

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

    public function user()
    {
        return $this->belongsTo(User::class);
    }
}
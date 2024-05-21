<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class SubKategoriModel extends Model
{
    protected $table = 'SubKategori';

    protected $fillable = [
        'user_id',
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

            // Update balance
            $balance = BalanceModel::where('user_id', $subKategori->user_id)->first();
            if ($balance) {
                $balance->balance -= $subKategori->uang;
                $balance->save();
            }
        });
    }

    public function kategori()
    {
        return $this->belongsTo(KategoriModel::class, 'kategori_id');
    }

    public function user()
    {
        return $this->belongsTo(User::class);
    }
}
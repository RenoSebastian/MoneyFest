<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Foundation\Auth\User as Authenticatable;
use Illuminate\Notifications\Notifiable;
use Laravel\Sanctum\HasApiTokens;

class User extends Authenticatable
{
    use HasApiTokens, HasFactory, Notifiable;

    protected $fillable = [
        'email',
        'username',
        'NickName',
        'password',
        'profile_image', // Tambahkan kolom baru ke fillable
    ];

    protected $hidden = [
        'password',
        'remember_token',
    ];

    protected $casts = [
        'email_verified_at' => 'datetime',
        'password' => 'hashed',
    ];

    public function instalments()
    {
        return $this->hasMany(InstalmentModel::class);
    }

    public function balances()
    {
        return $this->hasMany(BalanceModel::class);
    }

    public function kategori()
    {
        return $this->hasMany(KategoriModel::class);
    }

    public function subkategori()
    {
        return $this->hasMany(SubKategoriModel::class);
    }

    public function reminders()
    {
        return $this->hasMany(ReminderModel::class);
    }
}
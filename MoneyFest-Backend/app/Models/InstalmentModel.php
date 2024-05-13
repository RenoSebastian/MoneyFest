<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class InstalmentModel extends Model
{
    use HasFactory;

    protected $table = 'instalment';
    protected $fillable = ['user_id', 'kategori', 'assigned', 'available'];

    public function user()
    {
        return $this->belongsTo(User::class);
    }
}
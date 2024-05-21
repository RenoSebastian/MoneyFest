<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class InstalmentModel extends Model
{
    use HasFactory;

    protected $table = 'instalment';
    protected $fillable = ['user_id', 'kategori', 'assigned', 'available'];

    protected static function boot()
    {
        parent::boot();

        static::saved(function ($instalment) {
            // Update balance
            $balance = BalanceModel::where('user_id', $instalment->user_id)->first();
            if ($balance) {
                $balance->balance -= $instalment->assigned;
                $balance->save();
            }
        });
    }

    public function user()
    {
        return $this->belongsTo(User::class);
    }
}
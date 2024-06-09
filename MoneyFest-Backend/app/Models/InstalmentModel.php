<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class InstalmentModel extends Model
{
    use HasFactory;

    protected $table = 'instalment';
    protected $fillable = ['user_id', 'kategori', 'assigned', 'available'];

    protected $originalAssigned;

    protected static function boot()
    {
        parent::boot();

        // Listen for the updating event to capture the original assigned value
        static::updating(function ($instalment) {
            $instalment->originalAssigned = $instalment->getOriginal('assigned');
        });

        // Listen for the saved event to update the balance
        static::saved(function ($instalment) {
            $balance = BalanceModel::where('user_id', $instalment->user_id)->first();
            if ($balance) {
                $difference = $instalment->assigned - $instalment->originalAssigned;
                $balance->balance -= $difference;
                $balance->save();
            }
        });
    }

    public function user()
    {
        return $this->belongsTo(User::class);
    }

    public function reminders()
    {
        return $this->hasMany(ReminderModel::class);
    }
}
<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class ReminderModel extends Model
{
    use HasFactory;

    protected $table = 'reminders';
    protected $fillable = [
        'user_id',
        'instalment_id',
        'deadline',
        'frequency',
        'notes',
    ];

    public function user()
    {
        return $this->belongsTo(User::class);
    }

    public function instalment()
    {
        return $this->belongsTo(InstalmentModel::class);
    }
}
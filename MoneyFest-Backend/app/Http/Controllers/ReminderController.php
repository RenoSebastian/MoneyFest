<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\ReminderModel;
use App\Models\User;
use Illuminate\Support\Facades\Mail;
use App\Mail\ReminderNotification;

class ReminderController extends Controller
{
    public function store(Request $request, $instalmentId)
    {
        $request->validate([
            'user_id' => 'required|exists:users,id',
            'deadline' => 'required|date',
            'frequency' => 'required|string',
            'notes' => 'nullable|string',
        ]);

        $user_id = $request->user_id;


        $reminder = ReminderModel::create([
            'user_id' => $user_id,
            'instalment_id' => $instalmentId,
            'deadline' => $request->deadline,
            'frequency' => $request->frequency,
            'notes' => $request->notes,
        ]);

        // Send email notification
        // $user = User::find($user_id); // Menggunakan User model untuk mendapatkan pengguna berdasarkan ID
        // $email = $user->email; // Mendapatkan alamat email pengguna
        // Mail::to($email)->send(new ReminderNotification($reminder));


        return response()->json([
            'reminder' => $reminder,
            'message' => 'Reminder successfully set',
        ], 201);
    }
}
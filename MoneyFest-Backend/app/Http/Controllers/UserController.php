<?php

namespace App\Http\Controllers;
use Illuminate\Http\Request;
use App\Models\User;

class UserController extends Controller
{
    //Metode index
    public function index($id)
    {
        $user = User::findOrFail($id);
        return response()->json(
            [
            'User'     => $user->loadMissing('order'),
            'response'  => 200
            ]
        );
    }

    public function show($id)
    {
        $user = User::findOrFail($id);
        return response()->json([
            'User' => $user,
            'response' => 200
        ]);
    }
}
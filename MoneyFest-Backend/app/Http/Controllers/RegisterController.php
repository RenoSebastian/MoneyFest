<?php

namespace App\Http\Controllers;

use Laravel\Sanctum\Sanctum;
use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\User;
use Illuminate\Support\Facades\Hash;

class RegisterController extends Controller
{
    public function register(Request $request)
    {
        // Validate the incoming request data
        $request->validate([
            'email' => 'required|email|unique:users',
            'username' => 'required|unique:users',
            'NickName' => 'required',
            'password' => 'required|min:6',
        ]);

        // Create the new user
        $user = new User();
        $user->email = $request->email;
        $user->username = $request->username;
        $user->NickName = $request->NickName;
        $user->password = Hash::make($request->password);
        $user->save();

        // Return a response
        return response()->json([
            'data' => $user,
            'message' => 'User registered successfully',
            'status' => 200
        ]); 
    }
}
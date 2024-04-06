<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\User;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Facades\Auth;
 
class LoginController extends Controller
{
    public function login(Request $request)
    {
        $credentials = $request->only('username', 'password');

        if (Auth::attempt($credentials)) {
            $user = Auth::user();
            return response()->json([
                'dataUser'  => $user,
                'message'   => 'Login berhasil', 
                'response'  => 200
            ]);
        }

        return response()->json([
            'message'   => 'Username/Password salah', 
            'response'  => 404
        ]);
    }
}
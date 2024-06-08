<?php

namespace App\Http\Controllers;

use Laravel\Sanctum\Sanctum;
use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\User;
use Illuminate\Support\Facades\Hash;
use Illuminate\Database\Eloquent\ModelNotFoundException;
use Illuminate\Validation\ValidationException;
use Exception;

class RegisterController extends Controller
{
    public function register(Request $request)
    {
        try {
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

            // Return a success response
            return response()->json([
                'data' => $user,
                'message' => 'User registered successfully',
                'status' => 200
            ]); 
        } catch (ValidationException $e) {
            // Return a response for validation errors
            return response()->json([
                'errors' => $e->errors(),
                'message' => 'Validation failed',
                'status' => 422
            ], 422);
        } catch (Exception $e) {
            // Return a general error response
            return response()->json([
                'message' => 'An error occurred during registration',
                'status' => 500
            ], 500);
        }
    }
}
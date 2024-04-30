<?php

use Illuminate\Http\Request;
use Laravel\Sanctum\Sanctum;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\RegisterController;
use App\Http\Controllers\LoginController;
use App\Http\Controllers\UserController;
use App\Http\Controllers\KategoriController;
use App\Http\Controllers\SubKategoriController;

/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
|
| Here is where you can register API routes for your application. These
| routes are loaded by the RouteServiceProvider within a group which
| is assigned the "api" middleware group. Enjoy building your API!
|
*/
Route::post('/register', [RegisterController::class,'register']);
Route::post('/login', [LoginController::class, 'login']);
Route::get('/user/{id}', [UserController::class, 'show']);
Route::get('/user/{id}/details', [UserController::class, 'index']);
Route::post('/kategori', [KategoriController::class, 'store']);
Route::post('/subkategori', [SubKategoriController::class, 'store']);
Route::get('/kategori/{id}', [KategoriController::class, 'show']);

Route::middleware('auth:sanctum')->get('/user', function (Request $request) {
    return $request->user();
});
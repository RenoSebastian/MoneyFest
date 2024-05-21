<?php

use Illuminate\Http\Request;
use Laravel\Sanctum\Sanctum;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\RegisterController;
use App\Http\Controllers\LoginController;
use App\Http\Controllers\UserController;
use App\Http\Controllers\KategoriController;
use App\Http\Controllers\SubKategoriController;
use App\Http\Controllers\InstalmentController;
use App\Http\Controllers\BalanceController;

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
Route::post('/register', [RegisterController::class, 'register']);
Route::post('/login', [LoginController::class, 'login']);
Route::get('/user/{id}', [UserController::class, 'show']);
Route::get('/user/{id}/details', [UserController::class, 'index']);
Route::post('/kategori', [KategoriController::class, 'store']);
Route::post('/subkategori', [SubKategoriController::class, 'store']);
Route::get('/kategori/{id}', [KategoriController::class, 'show']);
Route::post('/update-profile-image', [UserController::class, 'updateProfileImage']);
Route::get('/profile-image/{id}', [UserController::class, 'getProfileImage']);
Route::get('/instalments', [InstalmentController::class, 'index']);
Route::post('/create/instalments', [InstalmentController::class, 'store']);
Route::put('/instalments/{id}', [InstalmentController::class, 'update']);
Route::post('reset/instalments', [InstalmentController::class, 'reset']);
Route::post('/balance/store', [BalanceController::class, 'store']);
Route::get('/balance/user/{userId}', [BalanceController::class, 'showByUserId']);
Route::get('/kategori/user/{userId}', [KategoriController::class, 'getCategoriesByUser']);





//Route::middleware('auth:sanctum')->post('/update-profile-image', [UserController::class, 'updateProfileImage']);
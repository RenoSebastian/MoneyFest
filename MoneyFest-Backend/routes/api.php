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
use App\Http\Controllers\ReminderController;

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

//auth
Route::post('/register', [RegisterController::class, 'register']);
Route::post('/login', [LoginController::class, 'login']);

//user controller
Route::get('/user/{id}', [UserController::class, 'show']);
Route::post('/update-profile-image', [UserController::class, 'updateProfileImage']);

//kategori controller
Route::post('/kategori', [KategoriController::class, 'store']);
Route::get('/kategori/{id}', [KategoriController::class, 'show']);
Route::get('/kategori/user/{userId}', [KategoriController::class, 'getCategoriesByUser']);
Route::get('/categories/{userId}', [KategoriController::class, 'getCategoriesByMonth']);
Route::get('/categories/{userId}/by-month/{month}', [KategoriController::class, 'getCategoriesByMonth']);
Route::get('/subcategories/{userId}', [SubKategoriController::class, 'getSubCategoriesByMonth']);
Route::get('/instalments/{id}', [InstalmentController::class, 'show']);
Route::get('/instalments/user/{userId}', [InstalmentController::class, 'getInstalmentsByUser']);
Route::get('/instalments', [InstalmentController::class, 'index']);

//subkategori controller
Route::post('/subkategori', [SubKategoriController::class, 'store']);
Route::get('/subkategori/user/{userId}/{kategoriId}', [SubKategoriController::class, 'getSubCategoriesByUserAndCategory']);
Route::put('/subkategori/edit/{id}', [SubKategoriController::class, 'edit']);
Route::delete('/subkategori/del/{id}', [SubKategoriController::class, 'destroy']);

//instalments controller
Route::get('/instalments', [InstalmentController::class, 'index']);
Route::post('/create/instalments', [InstalmentController::class, 'store']);
Route::put('/instalments/{id}', [InstalmentController::class, 'update']);
Route::post('reset/instalments', [InstalmentController::class, 'reset']);
Route::get('/instalments/{id}', [InstalmentController::class, 'show']);
Route::get('/instalments/user/{userId}', [InstalmentController::class, 'getInstalmentsByUser']);
Route::put('/instalments/edit/{id}', [InstalmentController::class, 'edit']);
Route::delete('/instalments/del/{id}', [InstalmentController::class, 'destroy']);

//balance controller
Route::post('/balance/store', [BalanceController::class, 'store']);
Route::post('/balance/update/{userId}', [BalanceController::class, 'update']);
Route::get('/balance/user/{userId}', [BalanceController::class, 'showByUserId']);

Route::post('instalments/{id}/reminders', [ReminderController::class, 'store']);


//Route::middleware('auth:sanctum')->post('/update-profile-image', [UserController::class, 'updateProfileImage']);
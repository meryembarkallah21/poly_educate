<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;


//added
use App\Http\Controllers\UsersController;
use App\Http\Controllers\AppointmentsController;
use App\Http\Controllers\ProfsController;



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


Route::post('/login', [UsersController::class, 'login']);
Route::post('/register', [UsersController::class, 'register']);


// to return user data
Route::middleware('auth:sanctum')->group(function() {
    Route::get('/user', [UsersController::class, 'index']);
    Route::post('/fav', [UsersController::class, 'storeFavProf']);
    Route::post('/logout', [UsersController::class, 'logout']);
    Route::post('/book', [AppointmentsController::class, 'store']);
    Route::post('/reviews', [ProfsController::class, 'store']);
    Route::get('/appointments', [AppointmentsController::class, 'index']);
});

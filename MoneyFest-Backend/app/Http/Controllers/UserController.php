<?php

namespace App\Http\Controllers;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Facades\Storage;
use App\Models\User;
use Illuminate\Http\UploadedFile;

class UserController extends Controller
{
    //Metode index
    public function index($id)
    {
        $user = User::findOrFail($id);
        return response()->json([
            'User'     => $user->loadMissing('order'),
            'response'  => 200
        ]);
    }

    public function show($id)
    {
        $user = User::findOrFail($id);
        return response()->json([
            'User' => $user,
            'response' => 200
        ]);
    }

    public function updateProfileImage(Request $request)
{
    $userId = $request->input('user_id'); // Mengambil ID pengguna dari permintaan

    $user = User::find($userId); // Mencari pengguna berdasarkan ID

    if (!$user) {
        return response()->json(['message' => 'Pengguna tidak ditemukan'], 404);
    }

    $validator = Validator::make($request->all(), [
        'profile_image' => 'required|image|mimes:jpeg,png,jpg,gif|max:2048',
    ]);

    if ($validator->fails()) {
        return response()->json(['message' => $validator->errors()->first()], 400);
    }

    if ($request->hasFile('profile_image')) {
        $image = $request->file('profile_image'); // Mendapatkan file gambar dari permintaan
        $photoPath = $image->store('profile-photos', 'public'); // Menyimpan gambar ke direktori

        // Pastikan foto sebelumnya dihapus sebelum menyimpan foto yang baru
        if ($user->profile_image) {
            Storage::disk('public')->delete($user->profile_image);
        }

        $user->profile_image = $photoPath; // Menyimpan path gambar ke dalam database
        $user->save();

        return response()->json([
            'message' => 'Foto profil berhasil diperbarui',
            'photo_path' => $photoPath
        ], 200);
    }

    return response()->json(['message' => 'Gagal memperbarui foto profil'], 500);
}

}
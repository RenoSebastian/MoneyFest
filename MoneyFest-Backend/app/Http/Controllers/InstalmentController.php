<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\InstalmentModel;
use Illuminate\Support\Facades\Auth;

class InstalmentController extends Controller
{
    public function index(Request $request)
    {
        // Ambil ID pengguna dari permintaan
        $userId = $request->user()->id;

        // Ambil semua data instalment dari database yang terkait dengan user yang sedang login
        $instalments = InstalmentModel::where('user_id', $userId)->get();

        // Kembalikan data sebagai response JSON
        return response()->json(['instalments' => $instalments]);
    }




    public function store(Request $request)
    {
        // Validasi input
        $request->validate([
            'user_id' => 'required|exists:users,id',
            'kategori' => 'required',
            'available' => 'required|numeric|min:0',
        ]);

        // Buat instalment baru dengan assigned 0
        $instalment = InstalmentModel::create([
            'user_id' => $request->user_id,
            'kategori' => $request->kategori,
            'available' => $request->available,
            'assigned' => 0,
        ]);

        // Kembalikan response sukses dengan data instalment yang baru dibuat
        return response()->json([
            'instalment'    => $instalment,
            'message'       => 'kategori instalment berhasil dibuat',
        ], 201);
    }

    public function update(Request $request, $id)
    {
        // Validasi input
        $request->validate([
            'assigned' => 'required|numeric|min:0',
        ]);

        // Temukan instalment berdasarkan ID
        $instalment = InstalmentModel::findOrFail($id);

        // Perbarui nilai assigned dan available
        $assigned = $request->assigned;
        $available = $instalment->available - $assigned;

        if ($available < 0) {
            return response()->json([
                'message' => 'Input jumlah uang dengan sesuai'
            ], 400); // Kode status 400 menunjukkan kesalahan klien
        }

        // Update kolom assigned dan available
        $instalment->update([
            'assigned' => $instalment->assigned + $assigned,
            'available' => $available,
        ]);

        // Kembalikan response sukses dengan data instalment yang telah diperbarui
        return response()->json([
            'instalment'    => $instalment,
            'message'       => 'Instalment berhasil diperbarui',
        ]);
    }

    public function reset()
{
    // Hapus semua data instalment dari database
    InstalmentModel::truncate();

    // Kembalikan response sukses dengan pesan
    return response()->json([
        'message' => 'Semua data instalment berhasil dihapus'
    ]);
}


}
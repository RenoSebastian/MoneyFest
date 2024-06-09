<?php

namespace App\Http\Controllers;

use App\Models\BalanceModel;
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
        // Validate input
        $request->validate([
            'assigned' => 'required|numeric|min:0',
        ]);

        // Find the instalment by ID
        $instalment = InstalmentModel::findOrFail($id);

        // Update the instalment
        $assigned = $request->input('assigned');
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

    public function edit(Request $request, $id)
    {
        // Validate input
        $request->validate([
            'kategori' => 'required|string|max:255',
        ]);

        // Find the instalment by ID
        $instalment = InstalmentModel::findOrFail($id);

        // Update the category name
        $instalment->update([
            'kategori' => $request->input('kategori'),
        ]);

        // Return a success response with the updated instalment data
        return response()->json([
            'instalment' => $instalment,
            'message'    => 'Category name updated successfully',
        ], 200);
    }

    public function getInstalmentsByUser($userId)
    {
        $instalments = InstalmentModel::where('user_id', $userId)->get();

        return response()->json([
            'data' => $instalments,
            'message' => 'Instalments berhasil diambil',
            'status' => '200'
        ], 200);
    }

    public function destroy($id)
{
    // Find the instalment by ID
    $instalment = InstalmentModel::findOrFail($id);

    // Retrieve the assigned amount
    $assignedAmount = $instalment->assigned;

    // Find the user's balance
    $balance = BalanceModel::where('user_id', $instalment->user_id)->first();

    if ($balance) {
        // Increment the user's balance by the assigned amount
        $balance->balance += $assignedAmount;
        $balance->save();
    }

    // Delete the instalment
    $instalment->delete();

    // Return a success response
    return response()->json([
        'message' => 'Instalment berhasil dihapus dan uang dikembalikan ke balance'
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
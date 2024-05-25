<?php

namespace App\Http\Controllers;

use App\Models\BalanceModel;
use Illuminate\Http\Request;

class BalanceController extends Controller
{

    public function index()
    {
        // Ambil semua data saldo
        $balances = BalanceModel::all();
        
        // Tampilkan data saldo dalam bentuk response JSON
        return response()->json(['balances' => $balances], 200);
    }


    public function store(Request $request)
    {
        $request->validate([
            'balance' => 'required|string',
            'user_id' => 'required|exists:users,id'
        ]);

        // Cari saldo berdasarkan user_id
        $balance = BalanceModel::where('user_id', $request->user_id)->first();

        if ($balance) {
            // Jika saldo sudah ada, tambahkan saldo baru ke saldo yang sudah ada
            $newBalance = $balance->balance + $request->balance;
            $balance->balance = $newBalance;
            $balance->save();

            // Tampilkan data saldo yang telah diperbarui dalam bentuk response JSON
            return response()->json(['message' => 'Balance updated successfully', 'balance' => $balance], 200);
        } else {
            // Jika saldo belum ada, buat saldo baru
            $newBalance = new BalanceModel([
                'balance' => $request->balance,
                'user_id' => $request->user_id
            ]);
            $newBalance->save();

            // Tampilkan data saldo baru dalam bentuk response JSON
            return response()->json(['message' => 'New balance created successfully', 'balance' => $newBalance], 201);
        }
    }


    // BalanceController.php

    public function showByUserId($userId)
    {
        $balance = BalanceModel::where('user_id', $userId)->first();

        if ($balance) {
            return response()->json(['balance' => $balance], 200);
        } else {
            return response()->json(['message' => 'Balance not found'], 404);
        }
    }



    public function update(Request $request, BalanceModel $userId)
    {
        // Validasi data yang diterima dari request
        $request->validate([
            'balance' => 'required|string',
        ]);

        // Perbarui data saldo
        $userId->balance = $request->balance;

        // Simpan perubahan saldo ke dalam database
        $userId->save();

        // Tampilkan data saldo yang diperbarui dalam bentuk response JSON
        return response()->json([
            'Message' => 'Balance berhasil diperbarui',
            'balance' => $userId], 200);
    }

    public function destroy(BalanceModel $balance)
    {
        // Hapus saldo dari database
        $balance->delete();

        // Tampilkan pesan bahwa saldo telah dihapus dalam bentuk response JSON
        return response()->json(['message' => 'Balance deleted'], 200);
    }
}
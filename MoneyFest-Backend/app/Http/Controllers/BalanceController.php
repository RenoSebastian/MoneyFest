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
        // Validasi data yang diterima dari request
        $request->validate([
            'balance' => 'required|string',
            'user_id' => 'required|exists:users,id'
        ]);

        // Buat objek baru untuk saldo
        $balance = new BalanceModel([
            'balance' => $request->balance,
            'user_id' => $request->user_id
        ]);

        // Simpan saldo ke dalam database
        $balance->save();

        // Tampilkan data saldo yang baru dibuat dalam bentuk response JSON
        return response()->json(['balance' => $balance], 201);
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



    public function update(Request $request, BalanceModel $balance)
    {
        // Validasi data yang diterima dari request
        $request->validate([
            'balance' => 'required|string',
        ]);

        // Perbarui data saldo
        $balance->balance = $request->balance;

        // Simpan perubahan saldo ke dalam database
        $balance->save();

        // Tampilkan data saldo yang diperbarui dalam bentuk response JSON
        return response()->json([
            'Message' => 'Balance berhasil diperbarui',
            'balance' => $balance], 200);
    }

    public function destroy(BalanceModel $balance)
    {
        // Hapus saldo dari database
        $balance->delete();

        // Tampilkan pesan bahwa saldo telah dihapus dalam bentuk response JSON
        return response()->json(['message' => 'Balance deleted'], 200);
    }
}
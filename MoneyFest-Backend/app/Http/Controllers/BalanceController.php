<?php

namespace App\Http\Controllers;

use App\Models\BalanceModel;
use Illuminate\Http\Request;

class BalanceController extends Controller
{
    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function index()
    {
        // Ambil semua data saldo
        $balances = BalanceModel::all();
        
        // Tampilkan data saldo dalam bentuk response JSON
        return response()->json(['balances' => $balances], 200);
    }

    /**
     * Store a newly created resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\Response
     */
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

    /**
     * Display the specified resource.
     *
     * @param  \App\Models\BalanceModel  $balance
     * @return \Illuminate\Http\Response
     */
    public function show(BalanceModel $balance)
    {
        // Tampilkan data saldo dalam bentuk response JSON
        return response()->json(['balance' => $balance], 200);
    }

    /**
     * Update the specified resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  \App\Models\BalanceModel  $balance
     * @return \Illuminate\Http\Response
     */
    public function update(Request $request, BalanceModel $balance)
    {
        // Validasi data yang diterima dari request
        $request->validate([
            'balance' => 'required|string',
            'user_id' => 'required|exists:users,id'
        ]);

        // Perbarui data saldo
        $balance->balance = $request->balance;
        $balance->user_id = $request->user_id;

        // Simpan perubahan saldo ke dalam database
        $balance->save();

        // Tampilkan data saldo yang diperbarui dalam bentuk response JSON
        return response()->json(['balance' => $balance], 200);
    }

    /**
     * Remove the specified resource from storage.
     *
     * @param  \App\Models\BalanceModel  $balance
     * @return \Illuminate\Http\Response
     */
    public function destroy(BalanceModel $balance)
    {
        // Hapus saldo dari database
        $balance->delete();

        // Tampilkan pesan bahwa saldo telah dihapus dalam bentuk response JSON
        return response()->json(['message' => 'Balance deleted'], 200);
    }
}

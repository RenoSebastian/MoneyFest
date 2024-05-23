<?php

namespace App\Http\Controllers;

use App\Models\SubKategoriModel;
use App\Models\KategoriModel;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;

class SubKategoriController extends Controller
{
    public function store(Request $request)
{
    // Validasi input
    $validator = Validator::make($request->all(), [
        'user_id' => 'required|exists:users,id',
        'NamaSub' => 'required|string',
        'uang' => 'required|numeric',
        'kategori_id' => 'required|exists:kategori,id',
    ]);

    // Jika validasi gagal
    if ($validator->fails()) {
        return response()->json([
            'message' => 'Gagal membuat sub kategori',
            'errors' => $validator->errors(),
            'status' => '400'
        ], 400);
    }

    // Jika validasi berhasil
    $subKategori = new SubKategoriModel();
    $subKategori->user_id = $request->user_id;
    $subKategori->NamaSub = $request->input('NamaSub');
    $subKategori->uang = $request->input('uang');
    $subKategori->kategori_id = $request->kategori_id;
    $subKategori->save();

    // Ambil kategori terkait
    $kategori = KategoriModel::findOrFail($request->input('kategori_id'));

    // Hitung total uang dari subkategori terkait dan update jumlah di kategori
    $kategori->jumlah = $kategori->subKategoris()->sum('uang');
    $kategori->save();

    return response()->json([
        'data' => $subKategori,
        'message' => 'Sub Kategori berhasil dibuat',
        'status' => '200'
    ]);
}

}
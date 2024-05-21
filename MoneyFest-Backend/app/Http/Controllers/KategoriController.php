<?php

namespace App\Http\Controllers;

use App\Models\KategoriModel;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;

class KategoriController extends Controller
{
    public function show($id)
    {
        // Temukan kategori berdasarkan ID
        $kategori = KategoriModel::find($id);

        // Jika kategori tidak ditemukan
        if (!$kategori) {
            return response()->json([
                'message' => 'Kategori tidak ditemukan',
                'status' => '404'
            ], 404);
        }

        // Jika kategori ditemukan
        return response()->json([
            'data' => $kategori,
            'message' => 'Kategori berhasil ditemukan',
            'status' => '200'
        ], 200);
    }

    public function store(Request $request)
    {
        // Validasi input
        $validator = Validator::make($request->all(), [
            'user_id' => 'required|exists:users,id',
            'NamaKategori' => 'required|string|max:255', // Menjadi required dan batas panjang maksimal 255 karakter
        ]);

        // Jika validasi gagal
        if ($validator->fails()) {
            return response()->json([
                'error' => $validator->errors(),
                'message' => 'Gagal membuat kategori',
                'status' => '400'
            ], 400);
        }

        // Jika validasi berhasil
        $kategori = new KategoriModel();
        $kategori->user_id = $request->user_id;
        $kategori->NamaKategori = $request->input('NamaKategori');
        $kategori->save();

        return response()->json([
            'data' => $kategori,
            'message' => 'Kategori berhasil dibuat',
            'status' => '200'
        ]);
    }
}
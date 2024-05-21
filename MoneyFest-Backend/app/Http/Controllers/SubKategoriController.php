<?php

namespace App\Http\Controllers;

use App\Models\KategoriModel;
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
            'NamaSub' => 'required|string',
            'uang' => 'required|numeric',
            'kategori_id' => 'required|exists:kategori,id', // Ensure the category exists
        ]);

        // Jika validasi gagal
        if ($validator->fails()) {
            return response()->json([
                'message' => 'Gagal membuat subkategori',
                'errors' => $validator->errors(),
                'status' => 400
            ], 400);
        }

        // Jika validasi berhasil
        $subKategori = new SubKategoriModel();
        $subKategori->NamaSub = $request->input('NamaSub');
        $subKategori->uang = $request->input('uang');
        $subKategori->kategori_id = $request->input('kategori_id'); // Assign the category ID
        $subKategori->save();

        // Ambil objek KategoriModel terkait
        $kategori = KategoriModel::find($request->input('kategori_id'));

        // Hitung total uang dari subkategori terkait dan update jumlah di kategori
        $totalUang = $kategori->subKategoris()->sum('uang');
        $kategori->jumlah = $totalUang;
        $kategori->save();

        // Respon dengan data
        return response()->json([
            'data' => $subKategori,
            'message' => 'Subkategori berhasil dibuat',
            'status' => 200
        ]);
    }

        // Jika validasi berhasil
        $subKategori = new SubKategoriModel();
        $subKategori->NamaSub = $request->input('NamaSub');
        $subKategori->uang = $request->input('uang');
        $subKategori->kategori_id = $request->input('kategori_id'); // Assign the category ID // Mengambil ID kategori dari input
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
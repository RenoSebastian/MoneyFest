<?php

namespace App\Http\Controllers;

use App\Models\SubKategoriModel;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;

class SubKategoriController extends Controller
{
    public function store(Request $request)
    {
        // Validasi input
        $validator = Validator::make($request->all(), [
            'NamaSub' => 'required|string',
            'uang' => 'required|integer',
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
        $subKategori->NamaSub = $request->input('NamaSub');
        $subKategori->uang = $request->input('uang');
        $subKategori->kategori_id = $request->input('kategori_id');
        $subKategori->save();

        return response()->json([
            'data' => $subKategori,
            'message' => 'Sub Kategori berhasil dibuat',
            'status' => '200'
        ]);
    }
}
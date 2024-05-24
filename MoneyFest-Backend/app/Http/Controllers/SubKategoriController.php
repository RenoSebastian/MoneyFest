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
        $validator = Validator::make($request->all(), [
            'user_id' => 'required|exists:users,id',
            'NamaSub' => 'required|string',
            'uang' => 'required|numeric',
            'kategori_id' => 'required|exists:kategori,id',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'message' => 'Gagal membuat sub kategori',
                'errors' => $validator->errors(),
                'status' => '400'
            ], 400);
        }

        $subKategori = new SubKategoriModel();
        $subKategori->user_id = $request->user_id;
        $subKategori->NamaSub = $request->input('NamaSub');
        $subKategori->uang = $request->input('uang');
        $subKategori->kategori_id = $request->kategori_id;
        $subKategori->save();

        $kategori = KategoriModel::find($request->input('kategori_id'));

        if (!$kategori) {
            return response()->json([
                'message' => 'Kategori tidak ditemukan',
                'status' => '400'
            ], 400);
        }

        $totalUang = $kategori->subKategoris()->sum('uang');
        $kategori->jumlah = $totalUang;
        $kategori->save();

        return response()->json([
            'data' => $subKategori,
            'message' => 'Subkategori berhasil dibuat',
            'status' => 200
        ]);
    }
}
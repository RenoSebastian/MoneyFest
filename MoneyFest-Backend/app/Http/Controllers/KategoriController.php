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

    public function chart($userId)
{
    // Fetch all categories with their related expenditures for the given user
    $categories = KategoriModel::with(['subKategoris' => function ($query) use ($userId) {
        $query->where('user_id', $userId);
    }])->get();

    // Prepare data to include the sum of expenditures for each category
    $categoriesData = $categories->map(function ($category) {
        return [
            'id' => $category->id,
            'NamaKategori' => $category->NamaKategori,
            'totalExpenditure' => $category->subKategoris->sum('uang'),
        ];
    });

    return response()->json([
        'data' => $categoriesData,
        'message' => 'Categories fetched successfully',
        'status' => '200'
    ], 200);
}


    public function getCategoriesByUser($userId)
    {
        $categories = KategoriModel::with('subKategoris')
            ->where('user_id', $userId)
            ->get();

        return response()->json([
            'data' => $categories,
            'message' => 'Kategori dan subkategori berhasil diambil',
            'status' => '200'
        ], 200);
    }

    public function getCategoriesByMonth(Request $request, $userId)
{
    $month = $request->input('month');

    $categories = KategoriModel::where('user_id', $userId)
                    ->whereYear('created_at', date('Y', strtotime($month)))
                    ->whereMonth('created_at', date('m', strtotime($month)))
                    ->get();

    return response()->json([
        'data' => $categories,
        'message' => 'Kategori berhasil diambil berdasarkan bulan',
        'status' => '200'
    ], 200);
}

}
<?php

namespace App\Http\Controllers;

use App\Models\KategoriModel;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;
use App\Models\SubKategoriModel;
use Carbon\carbon;

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

    // KategoriController.php

    public function edit(Request $request, $id)
    {
        // Validasi input
        $validator = Validator::make($request->all(), [
            'NamaKategori' => 'required|string|max:255', // Menjadi required dan batas panjang maksimal 255 karakter
        ]);

        // Jika validasi gagal
        if ($validator->fails()) {
            return response()->json([
                'error' => $validator->errors(),
                'message' => 'Gagal mengedit kategori',
                'status' => '400'
            ], 400);
        }

        // Temukan kategori berdasarkan ID
        $kategori = KategoriModel::find($id);

        // Jika kategori tidak ditemukan
        if (!$kategori) {
            return response()->json([
                'message' => 'Kategori tidak ditemukan',
                'status' => '404'
            ], 404);
        }

        // Jika kategori ditemukan, perbarui NamaKategori
        $oldNamaKategori = $kategori->NamaKategori; // Simpan nama kategori lama
        $kategori->NamaKategori = $request->input('NamaKategori');
        $kategori->save();

        // Perbarui juga NamaKategori pada subkategori yang terkait
        SubKategoriModel::where('kategori_id', $kategori->id)
            ->update(['NamaKategori' => $request->input('NamaKategori')]);

        return response()->json([
            'data' => $kategori,
            'message' => 'Kategori berhasil diupdate',
            'status' => '200'
        ], 200);
    }


    public function destroy($id)
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

        // Hapus semua subkategori yang terkait dengan kategori ini
        $kategori->subKategoris()->delete();

        // Jika kategori ditemukan, hapus kategori
        $kategori->delete();

        return response()->json([
            'message' => 'Kategori dan subkategori terkait berhasil dihapus',
            'status' => '200'
        ], 200);
    }



    public function chart($userId)
    {
        // Fetch all categories with their related expenditures for the given user
        $categories = KategoriModel::with([
            'subKategoris' => function ($query) use ($userId) {
                $query->where('user_id', $userId);
            }
        ])->get();

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
            ->orderBy('created_at', 'asc') // Order by creation date
            ->get();

        return response()->json([
            'data' => $categories,
            'message' => 'Kategori dan subkategori berhasil diambil',
            'status' => '200'
        ], 200);
    }

    public function getCategoriesByMonth($userId, $month)
    {
        // Parse month name to get the numeric month value
        $date = Carbon::parse($month);
        $monthNumber = $date->month;

        // Fetch categories created in the specified month for the given user
        $categories = KategoriModel::where('user_id', $userId)
            ->whereMonth('created_at', $monthNumber)
            ->orderBy('created_at', 'asc')
            ->get();

        return response()->json([
            'data' => $categories,
            'message' => 'Kategori berhasil diambil berdasarkan bulan ' . $month,
            'status' => '200'
        ], 200);
    }


}
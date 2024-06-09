<?php

namespace App\Http\Controllers;

use App\Models\SubKategoriModel;
use App\Models\KategoriModel;
use App\Models\BalanceModel;
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

        $userBalance = BalanceModel::where('user_id', $request->user_id)->first();
        $subCategoryAmount = $request->input('uang');

        if ($userBalance && $subCategoryAmount > $userBalance->balance) {
            return response()->json([
                'message' => 'Gagal membuat sub kategori: Jumlah uang melebihi saldo',
                'status' => '400'
            ], 400);
        }

        $subKategori = new SubKategoriModel();
        $subKategori->user_id = $request->user_id;
        $subKategori->NamaSub = $request->input('NamaSub');
        $subKategori->uang = $subCategoryAmount;
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

        // Kurangi saldo user setelah menyimpan subkategori
        if ($userBalance) {
            $userBalance->balance -= $subCategoryAmount;
            $userBalance->save();
        }

        return response()->json([
            'data' => $subKategori,
            'message' => 'Subkategori berhasil dibuat',
            'status' => 200
        ]);
    }

    // SubKategoriController.php

    public function edit(Request $request, $id)
    {
        $validator = Validator::make($request->all(), [
            'NamaSub' => 'required|string',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'message' => 'Gagal mengedit sub kategori',
                'errors' => $validator->errors(),
                'status' => '400'
            ], 400);
        }

        $subKategori = SubKategoriModel::find($id);

        if (!$subKategori) {
            return response()->json([
                'message' => 'Sub kategori tidak ditemukan',
                'status' => '404'
            ], 404);
        }

        $oldNamaSub = $subKategori->NamaSub; // Simpan nama sub kategori lama
        $subKategori->NamaSub = $request->input('NamaSub');
        $subKategori->save();

        return response()->json([
            'data' => $subKategori,
            'message' => 'Subkategori berhasil diupdate',
            'status' => '200'
        ]);
    }


    public function destroy($id)
    {
        $subKategori = SubKategoriModel::find($id);

        if (!$subKategori) {
            return response()->json([
                'message' => 'Sub kategori tidak ditemukan',
                'status' => '404'
            ], 404);
        }

        $subCategoryAmount = $subKategori->uang;
        $kategori = KategoriModel::find($subKategori->kategori_id);

        // Restore the balance to the user's account
        $userBalance = BalanceModel::where('user_id', $subKategori->user_id)->first();
        if ($userBalance) {
            $userBalance->balance += $subCategoryAmount;
            $userBalance->save();
        }

        // Delete the subcategory
        $subKategori->delete();

        // Recalculate the total amount for the category
        if ($kategori) {
            $totalUang = $kategori->subKategoris()->sum('uang');
            $kategori->jumlah = $totalUang;
            $kategori->save();
        }

        return response()->json([
            'message' => 'Subkategori berhasil dihapus',
            'status' => 200
        ]);
    }

    public function getSubCategoriesByUserAndCategory($userId, $kategoriId)
    {
        // Mengambil subkategori berdasarkan ID pengguna dan ID kategori
        $subCategories = SubKategoriModel::where('user_id', $userId)
            ->where('kategori_id', $kategoriId)
            ->orderBy('created_at', 'asc') // Order by creation date
            ->get();

        // Jika subkategori ditemukan
        if ($subCategories->isNotEmpty()) {
            return response()->json([
                'data' => $subCategories,
                'message' => 'Subkategori berhasil diambil',
                'status' => 200
            ], 200);
        } else {
            return response()->json([
                'data' => [],
                'message' => 'Tidak ada subkategori yang ditemukan',
                'status' => 404
            ], 404);
        }
    }


    public function getSubCategoriesByMonth(Request $request, $userId)
    {
        $month = $request->input('month');

        $subCategories = SubKategoriModel::where('user_id', $userId)
            ->whereYear('created_at', date('Y', strtotime($month)))
            ->whereMonth('created_at', date('m', strtotime($month)))
            ->get();

        return response()->json([
            'data' => $subCategories,
            'message' => 'Subkategori berhasil diambil berdasarkan bulan',
            'status' => '200'
        ], 200);
    }

}
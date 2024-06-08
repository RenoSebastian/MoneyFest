<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create(
            'SubKategori', function (Blueprint $table) {
                $table->id();
                $table->foreignId('user_id')->constrained()->onDelete('cascade');
                $table->string('NamaSub');
                $table->unsignedBigInteger('uang');
                $table->unsignedBigInteger('kategori_id');
                $table->foreign('kategori_id')->references('id')->on('kategori')->onDelete('cascade');
                $table->timestampsTz();
            }
        );
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('SubKategori');
    }
};
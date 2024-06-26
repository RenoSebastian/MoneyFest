<?php

namespace Database\Seeders;

use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use App\Models\User;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\Hash;


class UserSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        User::create([
            'email' => 'timsar@gmail.com',
            'username' => 'timsar',
            'NickName' => 'tim',
            'password' => Hash::make('123456'),
        ]);

        User::create([
            'email' => 'syira@gmail.com',
            'username' => 'syr',
            'NickName' => 'syira',
            'password' => Hash::make('123456'),
        ]);
    }
}
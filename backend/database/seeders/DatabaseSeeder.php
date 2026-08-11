<?php

namespace Database\Seeders;

use App\Models\Company;
use App\Models\User;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\Hash;

class DatabaseSeeder extends Seeder
{
    public function run(): void
    {
        $company = Company::updateOrCreate(['slug' => 'tech-corp'], ['name' => 'Tech Corp', 'plan' => 'enterprise']);
        User::updateOrCreate(['email' => 'admin@techcorp.test'], ['name' => 'Tech Admin', 'password' => Hash::make('password'), 'company_id' => $company->id, 'role' => 'admin', 'salary' => 15000]);
        User::updateOrCreate(['email' => 'hr@techcorp.test'], ['name' => 'Tech HR', 'password' => Hash::make('password'), 'company_id' => $company->id, 'role' => 'hr', 'salary' => 12000]);
        foreach ([['name' => 'Ahmed Employee', 'email' => 'ahmed@techcorp.test', 'salary' => 8000], ['name' => 'Sara Employee', 'email' => 'sara@techcorp.test', 'salary' => 8500]] as $emp) {
            User::updateOrCreate(['email' => $emp['email']], $emp + ['password' => Hash::make('password'), 'company_id' => $company->id, 'role' => 'employee']);
        }
    }
}

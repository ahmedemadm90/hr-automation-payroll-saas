<?php

namespace App\Http\Controllers;

use App\Models\Company;
use App\Models\User;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Str;
use Illuminate\Validation\ValidationException;

class AuthController extends Controller
{
    public function register(Request $request): JsonResponse
    {
        $data = $request->validate(['name' => ['required', 'string', 'max:120'], 'email' => ['required', 'email', 'unique:users,email'], 'password' => ['required', 'string', 'min:8', 'confirmed'], 'company_name' => ['required', 'string', 'max:120']]);
        [$user, $company] = DB::transaction(function () use ($data) {
            $company = Company::create(['name' => $data['company_name'], 'slug' => Str::slug($data['company_name']) . '-' . Str::lower(Str::random(5))]);
            $user = User::create($data + ['company_id' => $company->id, 'role' => 'admin']);
            return [$user, $company];
        });
        return response()->json(['user' => $user, 'company' => $company, 'token' => $user->createToken('hr-mobile')->plainTextToken], 201);
    }

    public function login(Request $request): JsonResponse
    {
        $data = $request->validate(['email' => ['required', 'email'], 'password' => ['required', 'string']]);
        $user = User::where('email', $data['email'])->with('company')->first();
        if (!$user || !Hash::check($data['password'], $user->password)) throw ValidationException::withMessages(['email' => ['Invalid credentials.']]);
        $user->tokens()->delete();
        return response()->json(['user' => $user, 'token' => $user->createToken('hr-mobile')->plainTextToken]);
    }

    public function logout(Request $request): JsonResponse { $request->user()->currentAccessToken()?->delete(); return response()->json(['message' => 'Logged out successfully.']); }
}

<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Payroll extends Model
{
    use HasFactory;
    protected $fillable = ['company_id', 'user_id', 'month', 'base_salary', 'allowances', 'deductions', 'net_salary', 'status'];
    protected $casts = ['base_salary' => 'decimal:2', 'allowances' => 'decimal:2', 'deductions' => 'decimal:2', 'net_salary' => 'decimal:2'];
    public function company() { return $this->belongsTo(Company::class); }
    public function user() { return $this->belongsTo(User::class); }
}

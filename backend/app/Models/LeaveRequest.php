<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class LeaveRequest extends Model
{
    use HasFactory;
    protected $fillable = ['user_id', 'type', 'start_date', 'end_date', 'reason', 'status', 'actioned_by'];
    public function user() { return $this->belongsTo(User::class); }
    public function actioner() { return $this->belongsTo(User::class, 'actioned_by'); }
}

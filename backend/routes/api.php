<?php

use App\Http\Controllers\AuthController;
use App\Http\Controllers\EmployeeController;
use App\Http\Controllers\HRController;
use Illuminate\Support\Facades\Route;

Route::prefix('v1')->group(function () {
    Route::post('auth/register', [AuthController::class, 'register']);
    Route::post('auth/login', [AuthController::class, 'login']);

    Route::middleware('auth:sanctum')->group(function () {
        Route::post('auth/logout', [AuthController::class, 'logout']);
        
        // Employee routes
        Route::get('employee/attendance', [EmployeeController::class, 'attendance']);
        Route::post('employee/attendance/clock-in', [EmployeeController::class, 'clockIn']);
        Route::post('employee/attendance/clock-out', [EmployeeController::class, 'clockOut']);
        Route::get('employee/leave-requests', [EmployeeController::class, 'leaveRequests']);
        Route::post('employee/leave-requests', [EmployeeController::class, 'storeLeaveRequest']);

        // HR Admin routes
        Route::get('hr/employees', [HRController::class, 'employees']);
        Route::get('hr/leaves/pending', [HRController::class, 'pendingLeaves']);
        Route::post('hr/leaves/{leave}/approve', [HRController::class, 'approveLeave']);
        Route::post('hr/payroll/generate', [HRController::class, 'generatePayroll']);
    });
});

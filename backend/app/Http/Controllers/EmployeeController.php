<?php

namespace App\Http\Controllers;

use App\Models\Attendance;
use App\Models\LeaveRequest;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class EmployeeController extends Controller
{
    public function attendance(Request $request): JsonResponse
    {
        return response()->json($request->user()->attendance()->latest()->limit(30)->get());
    }

    public function clockIn(Request $request): JsonResponse
    {
        $data = $request->validate(['latitude' => ['nullable', 'string'], 'longitude' => ['nullable', 'string']]);
        $attendance = Attendance::updateOrCreate(['user_id' => $request->user()->id, 'date' => now()->toDateString()], ['clock_in' => now()->toTimeString(), 'status' => 'present', 'latitude' => $data['latitude'] ?? null, 'longitude' => $data['longitude'] ?? null]);
        return response()->json($attendance);
    }

    public function clockOut(Request $request): JsonResponse
    {
        $attendance = Attendance::where('user_id', $request->user()->id)->where('date', now()->toDateString())->firstOrFail();
        $attendance->update(['clock_out' => now()->toTimeString()]);
        return response()->json($attendance);
    }

    public function leaveRequests(Request $request): JsonResponse
    {
        return response()->json($request->user()->leaveRequests()->latest()->get());
    }

    public function storeLeaveRequest(Request $request): JsonResponse
    {
        $data = $request->validate(['type' => ['required', 'in:sick,annual,casual'], 'start_date' => ['required', 'date'], 'end_date' => ['required', 'date', 'after_or_equal:start_date'], 'reason' => ['nullable', 'string']]);
        $leave = $request->user()->leaveRequests()->create($data + ['status' => 'pending']);
        return response()->json($leave, 201);
    }
}

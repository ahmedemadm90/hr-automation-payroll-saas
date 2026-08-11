<?php

namespace App\Http\Controllers;

use App\Models\LeaveRequest;
use App\Models\Payroll;
use App\Models\User;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class HRController extends Controller
{
    public function employees(Request $request): JsonResponse
    {
        $this->ensureHR($request);
        return response()->json(User::where('company_id', $request->user()->company_id)->where('id', '!=', $request->user()->id)->get());
    }

    public function pendingLeaves(Request $request): JsonResponse
    {
        $this->ensureHR($request);
        return response()->json(LeaveRequest::whereHas('user', fn ($q) => $query = $q->where('company_id', $request->user()->company_id))->where('status', 'pending')->with('user:id,name')->get());
    }

    public function approveLeave(Request $request, LeaveRequest $leave): JsonResponse
    {
        $this->ensureHR($request);
        $leave->update(['status' => 'approved', 'actioned_by' => $request->user()->id]);
        return response()->json($leave);
    }

    public function generatePayroll(Request $request): JsonResponse
    {
        $this->ensureHR($request);
        $month = $request->validate(['month' => ['required', 'string', 'regex:/^\d{4}-\d{2}$/']])['month'];
        $employees = User::where('company_id', $request->user()->company_id)->get();
        $payrolls = [];
        foreach ($employees as $emp) {
            $payrolls[] = Payroll::updateOrCreate(['user_id' => $emp->id, 'month' => $month], ['company_id' => $emp->company_id, 'base_salary' => $emp->salary, 'net_salary' => $emp->salary, 'status' => 'draft']);
        }
        return response()->json($payrolls);
    }

    private function ensureHR(Request $request): void { abort_unless(in_array($request->user()->role, ['admin', 'hr']), 403, 'Unauthorized.'); }
}

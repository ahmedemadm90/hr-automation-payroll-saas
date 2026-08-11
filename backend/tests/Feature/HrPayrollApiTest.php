<?php

namespace Tests\Feature;

use App\Models\Company;
use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

class HrPayrollApiTest extends TestCase
{
    use RefreshDatabase;

    public function test_employee_can_clock_in_and_request_leave(): void
    {
        $company = Company::create(['name' => 'Tech', 'slug' => 'tech']);
        $employee = User::factory()->create(['company_id' => $company->id, 'role' => 'employee']);

        $this->actingAs($employee)->postJson('/api/v1/employee/attendance/clock-in', ['latitude' => '30.0', 'longitude' => '31.0'])->assertOk()->assertJsonPath('status', 'present');
        $this->actingAs($employee)->postJson('/api/v1/employee/leave-requests', ['type' => 'sick', 'start_date' => '2026-09-01', 'end_date' => '2026-09-02', 'reason' => 'Fever'])->assertCreated()->assertJsonPath('status', 'pending');
    }

    public function test_hr_can_approve_leave_and_generate_payroll(): void
    {
        $company = Company::create(['name' => 'Tech', 'slug' => 'tech']);
        $hr = User::factory()->create(['company_id' => $company->id, 'role' => 'hr']);
        $emp = User::factory()->create(['company_id' => $company->id, 'role' => 'employee', 'salary' => 5000]);
        $leave = $emp->leaveRequests()->create(['type' => 'annual', 'start_date' => '2026-10-01', 'end_date' => '2026-10-05']);

        $this->actingAs($hr)->postJson("/api/v1/hr/leaves/{$leave->id}/approve")->assertOk()->assertJsonPath('status', 'approved');
        $this->actingAs($hr)->postJson('/api/v1/hr/payroll/generate', ['month' => '2026-08'])->assertOk()->assertJsonCount(2);
        $this->assertDatabaseHas('payrolls', ['user_id' => $emp->id, 'month' => '2026-08', 'net_salary' => '5000.00']);
    }
}

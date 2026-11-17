//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_import

import 'package:one_of_serializer/any_of_serializer.dart';
import 'package:one_of_serializer/one_of_serializer.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/serializer.dart';
import 'package:built_value/standard_json_plugin.dart';
import 'package:built_value/iso_8601_date_time_serializer.dart';
import 'package:fp_api/src/date_serializer.dart';
import 'package:fp_api/src/model/date.dart';

import 'package:fp_api/src/model/account_change.dart';
import 'package:fp_api/src/model/account_record.dart';
import 'package:fp_api/src/model/account_status.dart';
import 'package:fp_api/src/model/admin_dashboard.dart';
import 'package:fp_api/src/model/admin_monthly_flow.dart';
import 'package:fp_api/src/model/admin_payout_request.dart';
import 'package:fp_api/src/model/admin_payout_request_detail.dart';
import 'package:fp_api/src/model/admin_payout_request_page.dart';
import 'package:fp_api/src/model/admin_team_user_update.dart';
import 'package:fp_api/src/model/admin_transaction.dart';
import 'package:fp_api/src/model/admin_transaction_page.dart';
import 'package:fp_api/src/model/admin_user.dart';
import 'package:fp_api/src/model/admin_user_create.dart';
import 'package:fp_api/src/model/admin_user_detail.dart';
import 'package:fp_api/src/model/admin_user_page.dart';
import 'package:fp_api/src/model/admin_user_tenant.dart';
import 'package:fp_api/src/model/allocation_import_preview.dart';
import 'package:fp_api/src/model/allocation_import_request.dart';
import 'package:fp_api/src/model/allocation_import_row.dart';
import 'package:fp_api/src/model/allocation_line.dart';
import 'package:fp_api/src/model/allocation_preview.dart';
import 'package:fp_api/src/model/allocation_preview_employee.dart';
import 'package:fp_api/src/model/allocation_preview_line.dart';
import 'package:fp_api/src/model/allocation_preview_request.dart';
import 'package:fp_api/src/model/allocation_request.dart';
import 'package:fp_api/src/model/allocation_result.dart';
import 'package:fp_api/src/model/allocation_template.dart';
import 'package:fp_api/src/model/allocation_template_input.dart';
import 'package:fp_api/src/model/allocation_template_list.dart';
import 'package:fp_api/src/model/allocation_type_amount.dart';
import 'package:fp_api/src/model/approval.dart';
import 'package:fp_api/src/model/approval_commission_grid.dart';
import 'package:fp_api/src/model/approval_legal_form_change.dart';
import 'package:fp_api/src/model/approval_page.dart';
import 'package:fp_api/src/model/approval_reject_request.dart';
import 'package:fp_api/src/model/approval_status.dart';
import 'package:fp_api/src/model/approval_type.dart';
import 'package:fp_api/src/model/audit_log_entry.dart';
import 'package:fp_api/src/model/audit_log_page.dart';
import 'package:fp_api/src/model/cashier_register_assignment.dart';
import 'package:fp_api/src/model/category_balance.dart';
import 'package:fp_api/src/model/checkout.dart';
import 'package:fp_api/src/model/checkout_create.dart';
import 'package:fp_api/src/model/checkout_refusal.dart';
import 'package:fp_api/src/model/checkout_refusal_reason.dart';
import 'package:fp_api/src/model/checkout_refused_problem.dart';
import 'package:fp_api/src/model/checkout_refused_problem_all_of_details.dart';
import 'package:fp_api/src/model/checkout_status.dart';
import 'package:fp_api/src/model/commission_grid.dart';
import 'package:fp_api/src/model/commission_grid_change_request.dart';
import 'package:fp_api/src/model/commission_tier.dart';
import 'package:fp_api/src/model/company_account.dart';
import 'package:fp_api/src/model/company_account_page.dart';
import 'package:fp_api/src/model/company_create.dart';
import 'package:fp_api/src/model/company_dashboard.dart';
import 'package:fp_api/src/model/company_monthly_flow.dart';
import 'package:fp_api/src/model/company_overview.dart';
import 'package:fp_api/src/model/company_update.dart';
import 'package:fp_api/src/model/confirm_payment_request403_response.dart';
import 'package:fp_api/src/model/contact_message.dart';
import 'package:fp_api/src/model/contact_message_create.dart';
import 'package:fp_api/src/model/contact_message_handle.dart';
import 'package:fp_api/src/model/contact_message_page.dart';
import 'package:fp_api/src/model/contact_message_receipt.dart';
import 'package:fp_api/src/model/contact_message_status.dart';
import 'package:fp_api/src/model/contact_requester_type.dart';
import 'package:fp_api/src/model/credit_batch_status.dart';
import 'package:fp_api/src/model/credit_order.dart';
import 'package:fp_api/src/model/credit_order_create.dart';
import 'package:fp_api/src/model/credit_order_decision_reason.dart';
import 'package:fp_api/src/model/credit_order_detail.dart';
import 'package:fp_api/src/model/credit_order_event.dart';
import 'package:fp_api/src/model/credit_order_event_action.dart';
import 'package:fp_api/src/model/credit_order_line.dart';
import 'package:fp_api/src/model/credit_order_page.dart';
import 'package:fp_api/src/model/credit_order_quote.dart';
import 'package:fp_api/src/model/credit_order_quote_request.dart';
import 'package:fp_api/src/model/credit_type.dart';
import 'package:fp_api/src/model/credit_type_amount.dart';
import 'package:fp_api/src/model/credit_type_settings.dart';
import 'package:fp_api/src/model/currency.dart';
import 'package:fp_api/src/model/customer_checkout.dart';
import 'package:fp_api/src/model/customer_summary.dart';
import 'package:fp_api/src/model/decision_reason.dart';
import 'package:fp_api/src/model/department.dart';
import 'package:fp_api/src/model/department_assignment.dart';
import 'package:fp_api/src/model/department_create.dart';
import 'package:fp_api/src/model/department_list.dart';
import 'package:fp_api/src/model/direction.dart';
import 'package:fp_api/src/model/dispute.dart';
import 'package:fp_api/src/model/dispute_detail.dart';
import 'package:fp_api/src/model/dispute_note.dart';
import 'package:fp_api/src/model/dispute_note_create.dart';
import 'package:fp_api/src/model/dispute_open.dart';
import 'package:fp_api/src/model/dispute_page.dart';
import 'package:fp_api/src/model/dispute_status.dart';
import 'package:fp_api/src/model/employee.dart';
import 'package:fp_api/src/model/employee_assignment.dart';
import 'package:fp_api/src/model/employee_assignment_result.dart';
import 'package:fp_api/src/model/employee_bulk_status_change.dart';
import 'package:fp_api/src/model/employee_bulk_status_result.dart';
import 'package:fp_api/src/model/employee_bulk_status_result_results_inner.dart';
import 'package:fp_api/src/model/employee_create.dart';
import 'package:fp_api/src/model/employee_department.dart';
import 'package:fp_api/src/model/employee_import_confirm.dart';
import 'package:fp_api/src/model/employee_import_preview.dart';
import 'package:fp_api/src/model/employee_import_request.dart';
import 'package:fp_api/src/model/employee_import_result.dart';
import 'package:fp_api/src/model/employee_notification.dart';
import 'package:fp_api/src/model/employee_notification_kind.dart';
import 'package:fp_api/src/model/employee_notification_page.dart';
import 'package:fp_api/src/model/employee_operation.dart';
import 'package:fp_api/src/model/employee_operation_detail.dart';
import 'package:fp_api/src/model/employee_operation_page.dart';
import 'package:fp_api/src/model/employee_operation_status.dart';
import 'package:fp_api/src/model/employee_operation_type.dart';
import 'package:fp_api/src/model/employee_page.dart';
import 'package:fp_api/src/model/employee_payment_create.dart';
import 'package:fp_api/src/model/employee_payment_request.dart';
import 'package:fp_api/src/model/employee_payment_request_list.dart';
import 'package:fp_api/src/model/employee_profile.dart';
import 'package:fp_api/src/model/employee_status.dart';
import 'package:fp_api/src/model/employee_wallet.dart';
import 'package:fp_api/src/model/expired_credits_destination.dart';
import 'package:fp_api/src/model/family_accounts_setting.dart';
import 'package:fp_api/src/model/family_list.dart';
import 'package:fp_api/src/model/family_member.dart';
import 'package:fp_api/src/model/family_member_balance.dart';
import 'package:fp_api/src/model/family_member_create.dart';
import 'package:fp_api/src/model/family_member_created.dart';
import 'package:fp_api/src/model/family_reclaim.dart';
import 'package:fp_api/src/model/family_reclaim_result.dart';
import 'package:fp_api/src/model/family_relationship.dart';
import 'package:fp_api/src/model/family_transfer.dart';
import 'package:fp_api/src/model/family_transfer_result.dart';
import 'package:fp_api/src/model/field_error.dart';
import 'package:fp_api/src/model/field_error_code.dart';
import 'package:fp_api/src/model/field_error_params_value.dart';
import 'package:fp_api/src/model/first_validation.dart';
import 'package:fp_api/src/model/fraud_alert.dart';
import 'package:fp_api/src/model/fraud_alert_kind.dart';
import 'package:fp_api/src/model/fraud_alert_page.dart';
import 'package:fp_api/src/model/fraud_alert_severity.dart';
import 'package:fp_api/src/model/fraud_alert_status.dart';
import 'package:fp_api/src/model/funding_bank_account.dart';
import 'package:fp_api/src/model/health_status.dart';
import 'package:fp_api/src/model/iban_change_request.dart';
import 'package:fp_api/src/model/idempotency_in_progress_problem.dart';
import 'package:fp_api/src/model/import_issue.dart';
import 'package:fp_api/src/model/import_issue_code.dart';
import 'package:fp_api/src/model/import_row.dart';
import 'package:fp_api/src/model/inline_object.dart';
import 'package:fp_api/src/model/inline_object1.dart';
import 'package:fp_api/src/model/inline_object2.dart';
import 'package:fp_api/src/model/insufficient_funds_problem.dart';
import 'package:fp_api/src/model/insufficient_funds_problem_all_of_details.dart';
import 'package:fp_api/src/model/invoice.dart';
import 'package:fp_api/src/model/invoice_page.dart';
import 'package:fp_api/src/model/invoice_status.dart';
import 'package:fp_api/src/model/kyc_account_type.dart';
import 'package:fp_api/src/model/kyc_corrections.dart';
import 'package:fp_api/src/model/kyc_corrections_corrections_inner.dart';
import 'package:fp_api/src/model/kyc_document.dart';
import 'package:fp_api/src/model/kyc_document_status.dart';
import 'package:fp_api/src/model/kyc_document_type.dart';
import 'package:fp_api/src/model/kyc_event.dart';
import 'package:fp_api/src/model/kyc_file.dart';
import 'package:fp_api/src/model/kyc_file_page.dart';
import 'package:fp_api/src/model/kyc_file_summary.dart';
import 'package:fp_api/src/model/kyc_piece.dart';
import 'package:fp_api/src/model/kyc_status.dart';
import 'package:fp_api/src/model/legal_form.dart';
import 'package:fp_api/src/model/legal_form_change_request.dart';
import 'package:fp_api/src/model/limit_exceeded_problem.dart';
import 'package:fp_api/src/model/limit_exceeded_problem_all_of_details.dart';
import 'package:fp_api/src/model/limit_type.dart';
import 'package:fp_api/src/model/login_request.dart';
import 'package:fp_api/src/model/login_result.dart';
import 'package:fp_api/src/model/me.dart';
import 'package:fp_api/src/model/me_mfa.dart';
import 'package:fp_api/src/model/merchant_account.dart';
import 'package:fp_api/src/model/merchant_account_page.dart';
import 'package:fp_api/src/model/merchant_category.dart';
import 'package:fp_api/src/model/merchant_create.dart';
import 'package:fp_api/src/model/merchant_credit_types.dart';
import 'package:fp_api/src/model/merchant_dashboard.dart';
import 'package:fp_api/src/model/merchant_document.dart';
import 'package:fp_api/src/model/merchant_document_page.dart';
import 'package:fp_api/src/model/merchant_document_type.dart';
import 'package:fp_api/src/model/merchant_lookup.dart';
import 'package:fp_api/src/model/merchant_monthly_flow.dart';
import 'package:fp_api/src/model/merchant_overview.dart';
import 'package:fp_api/src/model/merchant_payment.dart';
import 'package:fp_api/src/model/merchant_payment_detail.dart';
import 'package:fp_api/src/model/merchant_payment_page.dart';
import 'package:fp_api/src/model/merchant_profile.dart';
import 'package:fp_api/src/model/merchant_update.dart';
import 'package:fp_api/src/model/mfa_challenge_result.dart';
import 'package:fp_api/src/model/mfa_enrollment.dart';
import 'package:fp_api/src/model/mfa_enrollment_confirm_request.dart';
import 'package:fp_api/src/model/mfa_enrollment_confirm_result.dart';
import 'package:fp_api/src/model/mfa_proof_request.dart';
import 'package:fp_api/src/model/mfa_re_enrollment_request.dart';
import 'package:fp_api/src/model/mfa_verify_request.dart';
import 'package:fp_api/src/model/mfa_verify_with_recovery_code.dart';
import 'package:fp_api/src/model/mfa_verify_with_totp.dart';
import 'package:fp_api/src/model/mobile_login200_response.dart';
import 'package:fp_api/src/model/mobile_login_request.dart';
import 'package:fp_api/src/model/mobile_mfa_verify_request.dart';
import 'package:fp_api/src/model/mobile_refresh_request.dart';
import 'package:fp_api/src/model/mobile_session.dart';
import 'package:fp_api/src/model/my_kyc_file.dart';
import 'package:fp_api/src/model/order_status.dart';
import 'package:fp_api/src/model/overview_allocation.dart';
import 'package:fp_api/src/model/overview_employee.dart';
import 'package:fp_api/src/model/overview_invoice.dart';
import 'package:fp_api/src/model/overview_kyc.dart';
import 'package:fp_api/src/model/overview_order.dart';
import 'package:fp_api/src/model/overview_payout.dart';
import 'package:fp_api/src/model/overview_sale.dart';
import 'package:fp_api/src/model/overview_user.dart';
import 'package:fp_api/src/model/page_count.dart';
import 'package:fp_api/src/model/page_info.dart';
import 'package:fp_api/src/model/paginated_envelope.dart';
import 'package:fp_api/src/model/password_change_request.dart';
import 'package:fp_api/src/model/password_forgot_request.dart';
import 'package:fp_api/src/model/password_policy.dart';
import 'package:fp_api/src/model/password_policy_rule.dart';
import 'package:fp_api/src/model/password_policy_rule_code.dart';
import 'package:fp_api/src/model/password_reset_request.dart';
import 'package:fp_api/src/model/password_reset_with_otp.dart';
import 'package:fp_api/src/model/password_reset_with_token.dart';
import 'package:fp_api/src/model/payment_code.dart';
import 'package:fp_api/src/model/payment_event.dart';
import 'package:fp_api/src/model/payment_initiate_request.dart';
import 'package:fp_api/src/model/payment_status.dart';
import 'package:fp_api/src/model/payout_event.dart';
import 'package:fp_api/src/model/payout_payment.dart';
import 'package:fp_api/src/model/payout_payment_record.dart';
import 'package:fp_api/src/model/payout_quote.dart';
import 'package:fp_api/src/model/payout_quote_request.dart';
import 'package:fp_api/src/model/payout_request.dart';
import 'package:fp_api/src/model/payout_request_create.dart';
import 'package:fp_api/src/model/payout_request_detail.dart';
import 'package:fp_api/src/model/payout_request_page.dart';
import 'package:fp_api/src/model/payout_request_status.dart';
import 'package:fp_api/src/model/pin_change.dart';
import 'package:fp_api/src/model/pin_confirmation.dart';
import 'package:fp_api/src/model/pin_refused_problem.dart';
import 'package:fp_api/src/model/pin_refused_problem_all_of_details.dart';
import 'package:fp_api/src/model/platform_settings.dart';
import 'package:fp_api/src/model/platform_settings_change.dart';
import 'package:fp_api/src/model/platform_settings_withholding.dart';
import 'package:fp_api/src/model/platform_terms.dart';
import 'package:fp_api/src/model/point_of_sale.dart';
import 'package:fp_api/src/model/position_list.dart';
import 'package:fp_api/src/model/problem.dart';
import 'package:fp_api/src/model/problem_base.dart';
import 'package:fp_api/src/model/problem_code.dart';
import 'package:fp_api/src/model/rate_limited_problem.dart';
import 'package:fp_api/src/model/receivable.dart';
import 'package:fp_api/src/model/receivable_page.dart';
import 'package:fp_api/src/model/recovery_codes.dart';
import 'package:fp_api/src/model/register.dart';
import 'package:fp_api/src/model/register_create.dart';
import 'package:fp_api/src/model/register_list.dart';
import 'package:fp_api/src/model/register_status.dart';
import 'package:fp_api/src/model/register_sticker.dart';
import 'package:fp_api/src/model/register_update.dart';
import 'package:fp_api/src/model/rename_department_request.dart';
import 'package:fp_api/src/model/retry_after_details.dart';
import 'package:fp_api/src/model/role.dart';
import 'package:fp_api/src/model/service_unavailable_problem.dart';
import 'package:fp_api/src/model/session_next_step.dart';
import 'package:fp_api/src/model/session_result.dart';
import 'package:fp_api/src/model/settlement.dart';
import 'package:fp_api/src/model/settlement_batch.dart';
import 'package:fp_api/src/model/settlement_batch_detail.dart';
import 'package:fp_api/src/model/settlement_batch_page.dart';
import 'package:fp_api/src/model/settlement_batch_status.dart';
import 'package:fp_api/src/model/settlement_page.dart';
import 'package:fp_api/src/model/settlement_status.dart';
import 'package:fp_api/src/model/staff_member.dart';
import 'package:fp_api/src/model/sub_role.dart';
import 'package:fp_api/src/model/team_sub_role.dart';
import 'package:fp_api/src/model/team_user.dart';
import 'package:fp_api/src/model/team_user_create.dart';
import 'package:fp_api/src/model/team_user_created.dart';
import 'package:fp_api/src/model/team_user_list.dart';
import 'package:fp_api/src/model/team_user_password.dart';
import 'package:fp_api/src/model/team_user_update.dart';
import 'package:fp_api/src/model/template_auto_run.dart';
import 'package:fp_api/src/model/temporary_credentials.dart';
import 'package:fp_api/src/model/tenant_summary.dart';
import 'package:fp_api/src/model/transfer_declaration.dart';
import 'package:fp_api/src/model/transfer_proof.dart';
import 'package:fp_api/src/model/user_audit_entry.dart';
import 'package:fp_api/src/model/user_role_change.dart';
import 'package:fp_api/src/model/user_status.dart';
import 'package:fp_api/src/model/user_status_change.dart';
import 'package:fp_api/src/model/validation_problem.dart';
import 'package:fp_api/src/model/validation_problem_all_of_details.dart';

part 'serializers.g.dart';

@SerializersFor([
  AccountChange,
  AccountRecord,
  AccountStatus,
  AdminDashboard,
  AdminMonthlyFlow,
  AdminPayoutRequest,
  AdminPayoutRequestDetail,
  AdminPayoutRequestPage,
  AdminTeamUserUpdate,
  AdminTransaction,
  AdminTransactionPage,
  AdminUser,$AdminUser,
  AdminUserCreate,
  AdminUserDetail,
  AdminUserPage,
  AdminUserTenant,
  AllocationImportPreview,
  AllocationImportRequest,
  AllocationImportRow,
  AllocationLine,
  AllocationPreview,
  AllocationPreviewEmployee,
  AllocationPreviewLine,
  AllocationPreviewRequest,
  AllocationRequest,
  AllocationResult,
  AllocationTemplate,
  AllocationTemplateInput,
  AllocationTemplateList,
  AllocationTypeAmount,
  Approval,
  ApprovalCommissionGrid,
  ApprovalLegalFormChange,
  ApprovalPage,
  ApprovalRejectRequest,
  ApprovalStatus,
  ApprovalType,
  AuditLogEntry,
  AuditLogPage,
  CashierRegisterAssignment,
  CategoryBalance,
  Checkout,
  CheckoutCreate,
  CheckoutRefusal,
  CheckoutRefusalReason,
  CheckoutRefusedProblem,
  CheckoutRefusedProblemAllOfDetails,
  CheckoutStatus,
  CommissionGrid,
  CommissionGridChangeRequest,
  CommissionTier,
  CompanyAccount,
  CompanyAccountPage,
  CompanyCreate,
  CompanyDashboard,
  CompanyMonthlyFlow,
  CompanyOverview,
  CompanyUpdate,
  ConfirmPaymentRequest403Response,
  ContactMessage,
  ContactMessageCreate,
  ContactMessageHandle,
  ContactMessagePage,
  ContactMessageReceipt,
  ContactMessageStatus,
  ContactRequesterType,
  CreditBatchStatus,
  CreditOrder,
  CreditOrderCreate,
  CreditOrderDecisionReason,
  CreditOrderDetail,
  CreditOrderEvent,
  CreditOrderEventAction,
  CreditOrderLine,
  CreditOrderPage,
  CreditOrderQuote,
  CreditOrderQuoteRequest,
  CreditType,
  CreditTypeAmount,
  CreditTypeSettings,
  Currency,
  CustomerCheckout,
  CustomerSummary,
  DecisionReason,
  Department,
  DepartmentAssignment,
  DepartmentCreate,
  DepartmentList,
  Direction,
  Dispute,$Dispute,
  DisputeDetail,
  DisputeNote,
  DisputeNoteCreate,
  DisputeOpen,
  DisputePage,
  DisputeStatus,
  Employee,
  EmployeeAssignment,
  EmployeeAssignmentResult,
  EmployeeBulkStatusChange,
  EmployeeBulkStatusResult,
  EmployeeBulkStatusResultResultsInner,
  EmployeeCreate,
  EmployeeDepartment,
  EmployeeImportConfirm,
  EmployeeImportPreview,
  EmployeeImportRequest,
  EmployeeImportResult,
  EmployeeNotification,
  EmployeeNotificationKind,
  EmployeeNotificationPage,
  EmployeeOperation,
  EmployeeOperationDetail,
  EmployeeOperationPage,
  EmployeeOperationStatus,
  EmployeeOperationType,
  EmployeePage,
  EmployeePaymentCreate,
  EmployeePaymentRequest,
  EmployeePaymentRequestList,
  EmployeeProfile,
  EmployeeStatus,
  EmployeeWallet,
  ExpiredCreditsDestination,
  FamilyAccountsSetting,
  FamilyList,
  FamilyMember,
  FamilyMemberBalance,
  FamilyMemberCreate,
  FamilyMemberCreated,
  FamilyReclaim,
  FamilyReclaimResult,
  FamilyRelationship,
  FamilyTransfer,
  FamilyTransferResult,
  FieldError,
  FieldErrorCode,
  FieldErrorParamsValue,
  FirstValidation,
  FraudAlert,
  FraudAlertKind,
  FraudAlertPage,
  FraudAlertSeverity,
  FraudAlertStatus,
  FundingBankAccount,
  HealthStatus,
  IbanChangeRequest,
  IdempotencyInProgressProblem,
  ImportIssue,
  ImportIssueCode,
  ImportRow,
  InlineObject,
  InlineObject1,
  InlineObject2,
  InsufficientFundsProblem,
  InsufficientFundsProblemAllOfDetails,
  Invoice,
  InvoicePage,
  InvoiceStatus,
  KycAccountType,
  KycCorrections,
  KycCorrectionsCorrectionsInner,
  KycDocument,
  KycDocumentStatus,
  KycDocumentType,
  KycEvent,
  KycFile,
  KycFilePage,
  KycFileSummary,
  KycPiece,
  KycStatus,
  LegalForm,
  LegalFormChangeRequest,
  LimitExceededProblem,
  LimitExceededProblemAllOfDetails,
  LimitType,
  LoginRequest,
  LoginResult,
  Me,
  MeMfa,
  MerchantAccount,
  MerchantAccountPage,
  MerchantCategory,
  MerchantCreate,
  MerchantCreditTypes,
  MerchantDashboard,
  MerchantDocument,
  MerchantDocumentPage,
  MerchantDocumentType,
  MerchantLookup,
  MerchantMonthlyFlow,
  MerchantOverview,
  MerchantPayment,
  MerchantPaymentDetail,
  MerchantPaymentPage,
  MerchantProfile,
  MerchantUpdate,
  MfaChallengeResult,
  MfaEnrollment,
  MfaEnrollmentConfirmRequest,
  MfaEnrollmentConfirmResult,
  MfaProofRequest,
  MfaReEnrollmentRequest,
  MfaVerifyRequest,
  MfaVerifyWithRecoveryCode,
  MfaVerifyWithTotp,
  MobileLogin200Response,
  MobileLoginRequest,
  MobileMfaVerifyRequest,
  MobileRefreshRequest,
  MobileSession,
  MyKycFile,
  OrderStatus,
  OverviewAllocation,
  OverviewEmployee,
  OverviewInvoice,
  OverviewKyc,
  OverviewOrder,
  OverviewPayout,
  OverviewSale,
  OverviewUser,
  PageCount,
  PageInfo,
  PaginatedEnvelope,
  PasswordChangeRequest,
  PasswordForgotRequest,
  PasswordPolicy,
  PasswordPolicyRule,
  PasswordPolicyRuleCode,
  PasswordResetRequest,
  PasswordResetWithOtp,
  PasswordResetWithToken,
  PaymentCode,
  PaymentEvent,
  PaymentInitiateRequest,
  PaymentStatus,
  PayoutEvent,
  PayoutPayment,
  PayoutPaymentRecord,
  PayoutQuote,
  PayoutQuoteRequest,
  PayoutRequest,
  PayoutRequestCreate,
  PayoutRequestDetail,
  PayoutRequestPage,
  PayoutRequestStatus,
  PinChange,
  PinConfirmation,
  PinRefusedProblem,
  PinRefusedProblemAllOfDetails,
  PlatformSettings,
  PlatformSettingsChange,
  PlatformSettingsWithholding,
  PlatformTerms,
  PointOfSale,
  PositionList,
  Problem,
  ProblemBase,$ProblemBase,
  ProblemCode,
  RateLimitedProblem,
  Receivable,
  ReceivablePage,
  RecoveryCodes,
  Register,
  RegisterCreate,
  RegisterList,
  RegisterStatus,
  RegisterSticker,
  RegisterUpdate,
  RenameDepartmentRequest,
  RetryAfterDetails,
  Role,
  ServiceUnavailableProblem,
  SessionNextStep,
  SessionResult,
  Settlement,
  SettlementBatch,
  SettlementBatchDetail,
  SettlementBatchPage,
  SettlementBatchStatus,
  SettlementPage,
  SettlementStatus,
  StaffMember,
  SubRole,
  TeamSubRole,
  TeamUser,
  TeamUserCreate,
  TeamUserCreated,
  TeamUserList,
  TeamUserPassword,
  TeamUserUpdate,
  TemplateAutoRun,
  TemporaryCredentials,
  TenantSummary,
  TransferDeclaration,
  TransferProof,
  UserAuditEntry,
  UserRoleChange,
  UserStatus,
  UserStatusChange,
  ValidationProblem,
  ValidationProblemAllOfDetails,
])
Serializers serializers = (_$serializers.toBuilder()
      ..addBuilderFactory(
        const FullType(BuiltList, [FullType(Approval)]),
        () => ListBuilder<Approval>(),
      )
      ..addBuilderFactory(
        const FullType(BuiltList, [FullType(CreditTypeSettings)]),
        () => ListBuilder<CreditTypeSettings>(),
      )
      ..addBuilderFactory(
        const FullType(BuiltList, [FullType(PayoutRequest)]),
        () => ListBuilder<PayoutRequest>(),
      )
      ..addBuilderFactory(
        const FullType(BuiltList, [FullType(KycDocument)]),
        () => ListBuilder<KycDocument>(),
      )
      ..addBuilderFactory(
        const FullType(BuiltList, [FullType(EmployeePaymentRequest)]),
        () => ListBuilder<EmployeePaymentRequest>(),
      )
      ..addBuilderFactory(
        const FullType(BuiltList, [FullType(CreditOrderLine)]),
        () => ListBuilder<CreditOrderLine>(),
      )
      ..addBuilderFactory(
        const FullType(BuiltList, [FullType(AdminUser)]),
        () => ListBuilder<AdminUser>(),
      )
      ..addBuilderFactory(
        const FullType(BuiltList, [FullType(AdminTransaction)]),
        () => ListBuilder<AdminTransaction>(),
      )
      ..addBuilderFactory(
        const FullType(BuiltList, [FullType(Receivable)]),
        () => ListBuilder<Receivable>(),
      )
      ..addBuilderFactory(
        const FullType(BuiltList, [FullType(FraudAlert)]),
        () => ListBuilder<FraudAlert>(),
      )
      ..addBuilderFactory(
        const FullType(BuiltList, [FullType(ImportIssue)]),
        () => ListBuilder<ImportIssue>(),
      )
      ..addBuilderFactory(
        const FullType(BuiltList, [FullType(OverviewInvoice)]),
        () => ListBuilder<OverviewInvoice>(),
      )
      ..addBuilderFactory(
        const FullType(BuiltList, [FullType(UserAuditEntry)]),
        () => ListBuilder<UserAuditEntry>(),
      )
      ..addBuilderFactory(
        const FullType(BuiltList, [FullType(SettlementBatch)]),
        () => ListBuilder<SettlementBatch>(),
      )
      ..addBuilderFactory(
        const FullType(BuiltList, [FullType(Employee)]),
        () => ListBuilder<Employee>(),
      )
      ..addBuilderFactory(
        const FullType(BuiltList, [FullType(MerchantPayment)]),
        () => ListBuilder<MerchantPayment>(),
      )
      ..addBuilderFactory(
        const FullType(BuiltSet, [FullType(String)]),
        () => SetBuilder<String>(),
      )
      ..addBuilderFactory(
        const FullType(BuiltList, [FullType(OverviewPayout)]),
        () => ListBuilder<OverviewPayout>(),
      )
      ..addBuilderFactory(
        const FullType(BuiltList, [FullType(KycEvent)]),
        () => ListBuilder<KycEvent>(),
      )
      ..addBuilderFactory(
        const FullType(BuiltList, [FullType(FieldError)]),
        () => ListBuilder<FieldError>(),
      )
      ..addBuilderFactory(
        const FullType(BuiltList, [FullType(AdminMonthlyFlow)]),
        () => ListBuilder<AdminMonthlyFlow>(),
      )
      ..addBuilderFactory(
        const FullType(BuiltList, [FullType(EmployeeOperation)]),
        () => ListBuilder<EmployeeOperation>(),
      )
      ..addBuilderFactory(
        const FullType(BuiltList, [FullType(AllocationPreviewEmployee)]),
        () => ListBuilder<AllocationPreviewEmployee>(),
      )
      ..addBuilderFactory(
        const FullType(BuiltList, [FullType.nullable(JsonObject)]),
        () => ListBuilder<JsonObject>(),
      )
      ..addBuilderFactory(
        const FullType(BuiltList, [FullType(PasswordPolicyRule)]),
        () => ListBuilder<PasswordPolicyRule>(),
      )
      ..addBuilderFactory(
        const FullType(BuiltList, [FullType(Invoice)]),
        () => ListBuilder<Invoice>(),
      )
      ..addBuilderFactory(
        const FullType(BuiltList, [FullType(CreditTypeAmount)]),
        () => ListBuilder<CreditTypeAmount>(),
      )
      ..addBuilderFactory(
        const FullType(BuiltList, [FullType(OverviewAllocation)]),
        () => ListBuilder<OverviewAllocation>(),
      )
      ..addBuilderFactory(
        const FullType(BuiltList, [FullType(DisputeNote)]),
        () => ListBuilder<DisputeNote>(),
      )
      ..addBuilderFactory(
        const FullType(BuiltSet, [FullType(KycDocumentType)]),
        () => SetBuilder<KycDocumentType>(),
      )
      ..addBuilderFactory(
        const FullType(BuiltList, [FullType(AllocationLine)]),
        () => ListBuilder<AllocationLine>(),
      )
      ..addBuilderFactory(
        const FullType(BuiltList, [FullType(KycFileSummary)]),
        () => ListBuilder<KycFileSummary>(),
      )
      ..addBuilderFactory(
        const FullType(BuiltList, [FullType(KycPiece)]),
        () => ListBuilder<KycPiece>(),
      )
      ..addBuilderFactory(
        const FullType(BuiltList, [FullType(CreditOrder)]),
        () => ListBuilder<CreditOrder>(),
      )
      ..addBuilderFactory(
        const FullType(BuiltList, [FullType(CompanyMonthlyFlow)]),
        () => ListBuilder<CompanyMonthlyFlow>(),
      )
      ..addBuilderFactory(
        const FullType(BuiltList, [FullType(ContactMessage)]),
        () => ListBuilder<ContactMessage>(),
      )
      ..addBuilderFactory(
        const FullType(BuiltList, [FullType(KycCorrectionsCorrectionsInner)]),
        () => ListBuilder<KycCorrectionsCorrectionsInner>(),
      )
      ..addBuilderFactory(
        const FullType(BuiltList, [FullType(CommissionTier)]),
        () => ListBuilder<CommissionTier>(),
      )
      ..addBuilderFactory(
        const FullType(BuiltList, [FullType(EmployeeBulkStatusResultResultsInner)]),
        () => ListBuilder<EmployeeBulkStatusResultResultsInner>(),
      )
      ..addBuilderFactory(
        const FullType(BuiltList, [FullType(MerchantDocument)]),
        () => ListBuilder<MerchantDocument>(),
      )
      ..addBuilderFactory(
        const FullType(BuiltList, [FullType(AllocationTypeAmount)]),
        () => ListBuilder<AllocationTypeAmount>(),
      )
      ..addBuilderFactory(
        const FullType(BuiltList, [FullType(FamilyMember)]),
        () => ListBuilder<FamilyMember>(),
      )
      ..addBuilderFactory(
        const FullType(BuiltList, [FullType(PaymentEvent)]),
        () => ListBuilder<PaymentEvent>(),
      )
      ..addBuilderFactory(
        const FullType(BuiltList, [FullType(Department)]),
        () => ListBuilder<Department>(),
      )
      ..addBuilderFactory(
        const FullType(BuiltList, [FullType(OverviewOrder)]),
        () => ListBuilder<OverviewOrder>(),
      )
      ..addBuilderFactory(
        const FullType(BuiltList, [FullType(Settlement)]),
        () => ListBuilder<Settlement>(),
      )
      ..addBuilderFactory(
        const FullType(BuiltMap, [FullType(String), FullType(int)]),
        () => MapBuilder<String, int>(),
      )
      ..addBuilderFactory(
        const FullType(BuiltList, [FullType(AllocationTemplate)]),
        () => ListBuilder<AllocationTemplate>(),
      )
      ..addBuilderFactory(
        const FullType(BuiltList, [FullType(CategoryBalance)]),
        () => ListBuilder<CategoryBalance>(),
      )
      ..addBuilderFactory(
        const FullType(BuiltList, [FullType(AuditLogEntry)]),
        () => ListBuilder<AuditLogEntry>(),
      )
      ..addBuilderFactory(
        const FullType(BuiltList, [FullType(StaffMember)]),
        () => ListBuilder<StaffMember>(),
      )
      ..addBuilderFactory(
        const FullType(BuiltList, [FullType(AllocationImportRow)]),
        () => ListBuilder<AllocationImportRow>(),
      )
      ..addBuilderFactory(
        const FullType(BuiltList, [FullType(CommissionGrid)]),
        () => ListBuilder<CommissionGrid>(),
      )
      ..addBuilderFactory(
        const FullType(BuiltList, [FullType(AccountChange)]),
        () => ListBuilder<AccountChange>(),
      )
      ..addBuilderFactory(
        const FullType(BuiltList, [FullType(PointOfSale)]),
        () => ListBuilder<PointOfSale>(),
      )
      ..addBuilderFactory(
        const FullType(BuiltList, [FullType(TeamUser)]),
        () => ListBuilder<TeamUser>(),
      )
      ..addBuilderFactory(
        const FullType(BuiltList, [FullType(AdminPayoutRequest)]),
        () => ListBuilder<AdminPayoutRequest>(),
      )
      ..addBuilderFactory(
        const FullType(BuiltList, [FullType(EmployeeNotification)]),
        () => ListBuilder<EmployeeNotification>(),
      )
      ..addBuilderFactory(
        const FullType(BuiltList, [FullType(Dispute)]),
        () => ListBuilder<Dispute>(),
      )
      ..addBuilderFactory(
        const FullType(BuiltMap, [FullType(String), FullType(FieldErrorParamsValue)]),
        () => MapBuilder<String, FieldErrorParamsValue>(),
      )
      ..addBuilderFactory(
        const FullType(BuiltList, [FullType(OverviewUser)]),
        () => ListBuilder<OverviewUser>(),
      )
      ..addBuilderFactory(
        const FullType(BuiltList, [FullType(CompanyAccount)]),
        () => ListBuilder<CompanyAccount>(),
      )
      ..addBuilderFactory(
        const FullType(BuiltList, [FullType(OverviewSale)]),
        () => ListBuilder<OverviewSale>(),
      )
      ..addBuilderFactory(
        const FullType(BuiltList, [FullType(MerchantMonthlyFlow)]),
        () => ListBuilder<MerchantMonthlyFlow>(),
      )
      ..addBuilderFactory(
        const FullType(BuiltList, [FullType(ImportRow)]),
        () => ListBuilder<ImportRow>(),
      )
      ..addBuilderFactory(
        const FullType(BuiltList, [FullType(Register)]),
        () => ListBuilder<Register>(),
      )
      ..addBuilderFactory(
        const FullType(BuiltList, [FullType(OverviewEmployee)]),
        () => ListBuilder<OverviewEmployee>(),
      )
      ..addBuilderFactory(
        const FullType(BuiltList, [FullType(int)]),
        () => ListBuilder<int>(),
      )
      ..addBuilderFactory(
        const FullType(BuiltList, [FullType(CreditOrderEvent)]),
        () => ListBuilder<CreditOrderEvent>(),
      )
      ..addBuilderFactory(
        const FullType(BuiltSet, [FullType(CreditType)]),
        () => SetBuilder<CreditType>(),
      )
      ..addBuilderFactory(
        const FullType(BuiltList, [FullType(String)]),
        () => ListBuilder<String>(),
      )
      ..addBuilderFactory(
        const FullType(BuiltList, [FullType(FamilyMemberBalance)]),
        () => ListBuilder<FamilyMemberBalance>(),
      )
      ..addBuilderFactory(
        const FullType(BuiltList, [FullType(MerchantAccount)]),
        () => ListBuilder<MerchantAccount>(),
      )
      ..addBuilderFactory(
        const FullType(BuiltList, [FullType(PayoutEvent)]),
        () => ListBuilder<PayoutEvent>(),
      )
      ..addBuilderFactory(
        const FullType(BuiltList, [FullType(AllocationPreviewLine)]),
        () => ListBuilder<AllocationPreviewLine>(),
      )
      ..add(AdminUser.serializer)
      ..add(Dispute.serializer)
      ..add(ProblemBase.serializer)
      ..add(const OneOfSerializer())
      ..add(const AnyOfSerializer())
      ..add(const DateSerializer())
      ..add(Iso8601DateTimeSerializer())
    ).build();

Serializers standardSerializers =
    (serializers.toBuilder()..addPlugin(StandardJsonPlugin())).build();

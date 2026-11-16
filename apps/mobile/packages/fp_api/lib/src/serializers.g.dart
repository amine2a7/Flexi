// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'serializers.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializers _$serializers =
    (Serializers().toBuilder()
          ..add($AdminUser.serializer)
          ..add($Dispute.serializer)
          ..add($ProblemBase.serializer)
          ..add(AccountChange.serializer)
          ..add(AccountChangeFieldsEnum.serializer)
          ..add(AccountRecord.serializer)
          ..add(AccountRecordKindEnum.serializer)
          ..add(AccountStatus.serializer)
          ..add(AdminDashboard.serializer)
          ..add(AdminMonthlyFlow.serializer)
          ..add(AdminPayoutRequest.serializer)
          ..add(AdminPayoutRequestDetail.serializer)
          ..add(AdminPayoutRequestPage.serializer)
          ..add(AdminTeamUserUpdate.serializer)
          ..add(AdminTransaction.serializer)
          ..add(AdminTransactionPage.serializer)
          ..add(AdminUserCreate.serializer)
          ..add(AdminUserCreateSubRoleEnum.serializer)
          ..add(AdminUserDetail.serializer)
          ..add(AdminUserPage.serializer)
          ..add(AdminUserTenant.serializer)
          ..add(AllocationImportPreview.serializer)
          ..add(AllocationImportRequest.serializer)
          ..add(AllocationImportRow.serializer)
          ..add(AllocationImportRowIssuesEnum.serializer)
          ..add(AllocationLine.serializer)
          ..add(AllocationPreview.serializer)
          ..add(AllocationPreviewEmployee.serializer)
          ..add(AllocationPreviewLine.serializer)
          ..add(AllocationPreviewRequest.serializer)
          ..add(AllocationRequest.serializer)
          ..add(AllocationResult.serializer)
          ..add(AllocationTemplate.serializer)
          ..add(AllocationTemplateInput.serializer)
          ..add(AllocationTemplateList.serializer)
          ..add(AllocationTypeAmount.serializer)
          ..add(Approval.serializer)
          ..add(ApprovalCommissionGrid.serializer)
          ..add(ApprovalLegalFormChange.serializer)
          ..add(ApprovalPage.serializer)
          ..add(ApprovalRejectRequest.serializer)
          ..add(ApprovalStatus.serializer)
          ..add(ApprovalType.serializer)
          ..add(AuditLogEntry.serializer)
          ..add(AuditLogPage.serializer)
          ..add(CategoryBalance.serializer)
          ..add(CommissionGrid.serializer)
          ..add(CommissionGridChangeRequest.serializer)
          ..add(CommissionTier.serializer)
          ..add(CompanyAccount.serializer)
          ..add(CompanyAccountPage.serializer)
          ..add(CompanyCreate.serializer)
          ..add(CompanyDashboard.serializer)
          ..add(CompanyMonthlyFlow.serializer)
          ..add(CompanyOverview.serializer)
          ..add(CompanyUpdate.serializer)
          ..add(ConfirmPaymentRequest403Response.serializer)
          ..add(ContactMessage.serializer)
          ..add(ContactMessageCreate.serializer)
          ..add(ContactMessageHandle.serializer)
          ..add(ContactMessagePage.serializer)
          ..add(ContactMessageReceipt.serializer)
          ..add(ContactMessageStatus.serializer)
          ..add(ContactRequesterType.serializer)
          ..add(CreditBatchStatus.serializer)
          ..add(CreditOrder.serializer)
          ..add(CreditOrderCreate.serializer)
          ..add(CreditOrderDecisionReason.serializer)
          ..add(CreditOrderDetail.serializer)
          ..add(CreditOrderEvent.serializer)
          ..add(CreditOrderEventAction.serializer)
          ..add(CreditOrderLine.serializer)
          ..add(CreditOrderPage.serializer)
          ..add(CreditOrderQuote.serializer)
          ..add(CreditOrderQuoteRequest.serializer)
          ..add(CreditType.serializer)
          ..add(CreditTypeAmount.serializer)
          ..add(CreditTypeSettings.serializer)
          ..add(Currency.serializer)
          ..add(CustomerSummary.serializer)
          ..add(DecisionReason.serializer)
          ..add(Department.serializer)
          ..add(DepartmentAssignment.serializer)
          ..add(DepartmentCreate.serializer)
          ..add(DepartmentList.serializer)
          ..add(Direction.serializer)
          ..add(DisputeDetail.serializer)
          ..add(DisputeNote.serializer)
          ..add(DisputeNoteCreate.serializer)
          ..add(DisputeOpen.serializer)
          ..add(DisputePage.serializer)
          ..add(DisputeStatus.serializer)
          ..add(Employee.serializer)
          ..add(EmployeeAssignment.serializer)
          ..add(EmployeeAssignmentResult.serializer)
          ..add(EmployeeBulkStatusChange.serializer)
          ..add(EmployeeBulkStatusChangeActionEnum.serializer)
          ..add(EmployeeBulkStatusResult.serializer)
          ..add(EmployeeBulkStatusResultResultsInner.serializer)
          ..add(EmployeeBulkStatusResultResultsInnerOutcomeEnum.serializer)
          ..add(EmployeeCreate.serializer)
          ..add(EmployeeDepartment.serializer)
          ..add(EmployeeImportConfirm.serializer)
          ..add(EmployeeImportPreview.serializer)
          ..add(EmployeeImportRequest.serializer)
          ..add(EmployeeImportResult.serializer)
          ..add(EmployeeOperation.serializer)
          ..add(EmployeeOperationDetail.serializer)
          ..add(EmployeeOperationPage.serializer)
          ..add(EmployeeOperationStatus.serializer)
          ..add(EmployeeOperationType.serializer)
          ..add(EmployeePage.serializer)
          ..add(EmployeePaymentCreate.serializer)
          ..add(EmployeePaymentRequest.serializer)
          ..add(EmployeePaymentRequestList.serializer)
          ..add(EmployeeProfile.serializer)
          ..add(EmployeeStatus.serializer)
          ..add(EmployeeWallet.serializer)
          ..add(ExpiredCreditsDestination.serializer)
          ..add(FamilyAccountsSetting.serializer)
          ..add(FamilyList.serializer)
          ..add(FamilyMember.serializer)
          ..add(FamilyMemberBalance.serializer)
          ..add(FamilyMemberCreate.serializer)
          ..add(FamilyMemberCreated.serializer)
          ..add(FamilyReclaim.serializer)
          ..add(FamilyReclaimResult.serializer)
          ..add(FamilyRelationship.serializer)
          ..add(FamilyTransfer.serializer)
          ..add(FamilyTransferResult.serializer)
          ..add(FieldError.serializer)
          ..add(FieldErrorCode.serializer)
          ..add(FieldErrorIn_Enum.serializer)
          ..add(FieldErrorParamsValue.serializer)
          ..add(FirstValidation.serializer)
          ..add(FraudAlert.serializer)
          ..add(FraudAlertKind.serializer)
          ..add(FraudAlertPage.serializer)
          ..add(FraudAlertSeverity.serializer)
          ..add(FraudAlertStatus.serializer)
          ..add(FundingBankAccount.serializer)
          ..add(HealthStatus.serializer)
          ..add(HealthStatusStatusEnum.serializer)
          ..add(IbanChangeRequest.serializer)
          ..add(IdempotencyInProgressProblem.serializer)
          ..add(ImportIssue.serializer)
          ..add(ImportIssueCode.serializer)
          ..add(ImportIssueFieldEnum.serializer)
          ..add(ImportRow.serializer)
          ..add(InlineObject.serializer)
          ..add(InlineObject1.serializer)
          ..add(InlineObject2.serializer)
          ..add(InsufficientFundsProblem.serializer)
          ..add(InsufficientFundsProblemAllOfDetails.serializer)
          ..add(Invoice.serializer)
          ..add(InvoicePage.serializer)
          ..add(InvoiceStatus.serializer)
          ..add(KycAccountType.serializer)
          ..add(KycCorrections.serializer)
          ..add(KycCorrectionsCorrectionsInner.serializer)
          ..add(KycDocument.serializer)
          ..add(KycDocumentContentTypeEnum.serializer)
          ..add(KycDocumentStatus.serializer)
          ..add(KycDocumentType.serializer)
          ..add(KycEvent.serializer)
          ..add(KycEventActionEnum.serializer)
          ..add(KycFile.serializer)
          ..add(KycFilePage.serializer)
          ..add(KycFileSummary.serializer)
          ..add(KycPiece.serializer)
          ..add(KycPieceContentTypeEnum.serializer)
          ..add(KycPieceStatusEnum.serializer)
          ..add(KycStatus.serializer)
          ..add(LegalForm.serializer)
          ..add(LegalFormChangeRequest.serializer)
          ..add(LimitExceededProblem.serializer)
          ..add(LimitExceededProblemAllOfDetails.serializer)
          ..add(LimitType.serializer)
          ..add(LoginRequest.serializer)
          ..add(LoginResult.serializer)
          ..add(Me.serializer)
          ..add(MeMfa.serializer)
          ..add(MerchantAccount.serializer)
          ..add(MerchantAccountPage.serializer)
          ..add(MerchantCategory.serializer)
          ..add(MerchantCreate.serializer)
          ..add(MerchantCreditTypes.serializer)
          ..add(MerchantDashboard.serializer)
          ..add(MerchantDocument.serializer)
          ..add(MerchantDocumentPage.serializer)
          ..add(MerchantDocumentType.serializer)
          ..add(MerchantLookup.serializer)
          ..add(MerchantMonthlyFlow.serializer)
          ..add(MerchantOverview.serializer)
          ..add(MerchantPayment.serializer)
          ..add(MerchantPaymentDetail.serializer)
          ..add(MerchantPaymentPage.serializer)
          ..add(MerchantProfile.serializer)
          ..add(MerchantUpdate.serializer)
          ..add(MfaChallengeResult.serializer)
          ..add(MfaChallengeResultNextStepEnum.serializer)
          ..add(MfaEnrollment.serializer)
          ..add(MfaEnrollmentConfirmRequest.serializer)
          ..add(MfaEnrollmentConfirmResult.serializer)
          ..add(MfaProofRequest.serializer)
          ..add(MfaReEnrollmentRequest.serializer)
          ..add(MfaVerifyRequest.serializer)
          ..add(MfaVerifyWithRecoveryCode.serializer)
          ..add(MfaVerifyWithTotp.serializer)
          ..add(MyKycFile.serializer)
          ..add(OrderStatus.serializer)
          ..add(OverviewAllocation.serializer)
          ..add(OverviewEmployee.serializer)
          ..add(OverviewInvoice.serializer)
          ..add(OverviewKyc.serializer)
          ..add(OverviewOrder.serializer)
          ..add(OverviewPayout.serializer)
          ..add(OverviewSale.serializer)
          ..add(OverviewUser.serializer)
          ..add(PageCount.serializer)
          ..add(PageInfo.serializer)
          ..add(PaginatedEnvelope.serializer)
          ..add(PasswordChangeRequest.serializer)
          ..add(PasswordForgotRequest.serializer)
          ..add(PasswordPolicy.serializer)
          ..add(PasswordPolicyRule.serializer)
          ..add(PasswordPolicyRuleCode.serializer)
          ..add(PasswordResetRequest.serializer)
          ..add(PasswordResetWithOtp.serializer)
          ..add(PasswordResetWithToken.serializer)
          ..add(PaymentCode.serializer)
          ..add(PaymentEvent.serializer)
          ..add(PaymentInitiateRequest.serializer)
          ..add(PaymentStatus.serializer)
          ..add(PayoutEvent.serializer)
          ..add(PayoutPayment.serializer)
          ..add(PayoutPaymentRecord.serializer)
          ..add(PayoutQuote.serializer)
          ..add(PayoutQuoteRequest.serializer)
          ..add(PayoutRequest.serializer)
          ..add(PayoutRequestCreate.serializer)
          ..add(PayoutRequestDetail.serializer)
          ..add(PayoutRequestPage.serializer)
          ..add(PayoutRequestStatus.serializer)
          ..add(PinChange.serializer)
          ..add(PinConfirmation.serializer)
          ..add(PinRefusedProblem.serializer)
          ..add(PinRefusedProblemAllOfDetails.serializer)
          ..add(PlatformSettings.serializer)
          ..add(PlatformSettingsChange.serializer)
          ..add(PlatformSettingsWithholding.serializer)
          ..add(PlatformTerms.serializer)
          ..add(PointOfSale.serializer)
          ..add(PositionList.serializer)
          ..add(Problem.serializer)
          ..add(ProblemCode.serializer)
          ..add(RateLimitedProblem.serializer)
          ..add(Receivable.serializer)
          ..add(ReceivablePage.serializer)
          ..add(RecoveryCodes.serializer)
          ..add(RenameDepartmentRequest.serializer)
          ..add(RetryAfterDetails.serializer)
          ..add(Role.serializer)
          ..add(ServiceUnavailableProblem.serializer)
          ..add(SessionNextStep.serializer)
          ..add(SessionResult.serializer)
          ..add(Settlement.serializer)
          ..add(SettlementBatch.serializer)
          ..add(SettlementBatchDetail.serializer)
          ..add(SettlementBatchPage.serializer)
          ..add(SettlementBatchStatus.serializer)
          ..add(SettlementPage.serializer)
          ..add(SettlementStatus.serializer)
          ..add(StaffMember.serializer)
          ..add(SubRole.serializer)
          ..add(TeamSubRole.serializer)
          ..add(TeamUser.serializer)
          ..add(TeamUserCreate.serializer)
          ..add(TeamUserCreated.serializer)
          ..add(TeamUserList.serializer)
          ..add(TeamUserPassword.serializer)
          ..add(TeamUserUpdate.serializer)
          ..add(TemplateAutoRun.serializer)
          ..add(TemplateAutoRunStatusEnum.serializer)
          ..add(TemporaryCredentials.serializer)
          ..add(TenantSummary.serializer)
          ..add(TransferDeclaration.serializer)
          ..add(TransferProof.serializer)
          ..add(TransferProofContentTypeEnum.serializer)
          ..add(UserAuditEntry.serializer)
          ..add(UserRoleChange.serializer)
          ..add(UserStatus.serializer)
          ..add(UserStatusChange.serializer)
          ..add(ValidationProblem.serializer)
          ..add(ValidationProblemAllOfDetails.serializer)
          ..addBuilderFactory(
            const FullType(BuiltList, const [
              const FullType(AccountChangeFieldsEnum),
            ]),
            () => ListBuilder<AccountChangeFieldsEnum>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [
              const FullType(AdminPayoutRequest),
            ]),
            () => ListBuilder<AdminPayoutRequest>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [
              const FullType(AdminPayoutRequest),
            ]),
            () => ListBuilder<AdminPayoutRequest>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [const FullType(AdminTransaction)]),
            () => ListBuilder<AdminTransaction>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [const FullType(AdminUser)]),
            () => ListBuilder<AdminUser>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [
              const FullType(AllocationImportRow),
            ]),
            () => ListBuilder<AllocationImportRow>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [const FullType(AllocationLine)]),
            () => ListBuilder<AllocationLine>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [const FullType(CreditTypeAmount)]),
            () => ListBuilder<CreditTypeAmount>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [const FullType(AllocationLine)]),
            () => ListBuilder<AllocationLine>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [
              const FullType(AllocationPreviewEmployee),
            ]),
            () => ListBuilder<AllocationPreviewEmployee>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [
              const FullType(AllocationPreviewLine),
            ]),
            () => ListBuilder<AllocationPreviewLine>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [
              const FullType(AllocationTemplate),
            ]),
            () => ListBuilder<AllocationTemplate>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [
              const FullType(AllocationTypeAmount),
            ]),
            () => ListBuilder<AllocationTypeAmount>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [
              const FullType(AllocationTypeAmount),
            ]),
            () => ListBuilder<AllocationTypeAmount>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [const FullType(Approval)]),
            () => ListBuilder<Approval>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [const FullType(AuditLogEntry)]),
            () => ListBuilder<AuditLogEntry>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [const FullType(CategoryBalance)]),
            () => ListBuilder<CategoryBalance>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [const FullType(CommissionGrid)]),
            () => ListBuilder<CommissionGrid>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [const FullType(AccountChange)]),
            () => ListBuilder<AccountChange>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [const FullType(Approval)]),
            () => ListBuilder<Approval>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [const FullType(CommissionTier)]),
            () => ListBuilder<CommissionTier>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [const FullType(CommissionTier)]),
            () => ListBuilder<CommissionTier>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [const FullType(CommissionTier)]),
            () => ListBuilder<CommissionTier>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [const FullType(CommissionTier)]),
            () => ListBuilder<CommissionTier>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [const FullType(CommissionTier)]),
            () => ListBuilder<CommissionTier>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [const FullType(CompanyAccount)]),
            () => ListBuilder<CompanyAccount>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [const FullType(ContactMessage)]),
            () => ListBuilder<ContactMessage>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [const FullType(CreditOrder)]),
            () => ListBuilder<CreditOrder>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [const FullType(CreditOrderLine)]),
            () => ListBuilder<CreditOrderLine>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [const FullType(CreditOrderLine)]),
            () => ListBuilder<CreditOrderLine>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [const FullType(CreditOrderLine)]),
            () => ListBuilder<CreditOrderLine>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [const FullType(CreditOrderLine)]),
            () => ListBuilder<CreditOrderLine>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [const FullType(CreditOrderLine)]),
            () => ListBuilder<CreditOrderLine>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [const FullType(CreditOrderEvent)]),
            () => ListBuilder<CreditOrderEvent>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [const FullType(CreditTypeAmount)]),
            () => ListBuilder<CreditTypeAmount>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [const FullType(CreditTypeAmount)]),
            () => ListBuilder<CreditTypeAmount>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [const FullType(AdminMonthlyFlow)]),
            () => ListBuilder<AdminMonthlyFlow>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [const FullType(CreditTypeAmount)]),
            () => ListBuilder<CreditTypeAmount>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [
              const FullType(AllocationImportRowIssuesEnum),
            ]),
            () => ListBuilder<AllocationImportRowIssuesEnum>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [const FullType(CreditTypeAmount)]),
            () => ListBuilder<CreditTypeAmount>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [const FullType(CreditOrder)]),
            () => ListBuilder<CreditOrder>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [
              const FullType(CompanyMonthlyFlow),
            ]),
            () => ListBuilder<CompanyMonthlyFlow>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [const FullType(Department)]),
            () => ListBuilder<Department>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [const FullType(Dispute)]),
            () => ListBuilder<Dispute>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [const FullType(DisputeNote)]),
            () => ListBuilder<DisputeNote>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [const FullType(Employee)]),
            () => ListBuilder<Employee>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [
              const FullType(EmployeeBulkStatusResultResultsInner),
            ]),
            () => ListBuilder<EmployeeBulkStatusResultResultsInner>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [
              const FullType(EmployeeOperation),
            ]),
            () => ListBuilder<EmployeeOperation>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [
              const FullType(EmployeePaymentRequest),
            ]),
            () => ListBuilder<EmployeePaymentRequest>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [const FullType(FamilyMember)]),
            () => ListBuilder<FamilyMember>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [
              const FullType(FamilyMemberBalance),
            ]),
            () => ListBuilder<FamilyMemberBalance>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [const FullType(FieldError)]),
            () => ListBuilder<FieldError>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [const FullType(FraudAlert)]),
            () => ListBuilder<FraudAlert>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [const FullType(ImportIssue)]),
            () => ListBuilder<ImportIssue>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [const FullType(ImportRow)]),
            () => ListBuilder<ImportRow>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [const FullType(Invoice)]),
            () => ListBuilder<Invoice>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [
              const FullType(KycCorrectionsCorrectionsInner),
            ]),
            () => ListBuilder<KycCorrectionsCorrectionsInner>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [const FullType(KycFileSummary)]),
            () => ListBuilder<KycFileSummary>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [const FullType(KycPiece)]),
            () => ListBuilder<KycPiece>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [const FullType(KycPiece)]),
            () => ListBuilder<KycPiece>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [const FullType(KycDocument)]),
            () => ListBuilder<KycDocument>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [const FullType(KycEvent)]),
            () => ListBuilder<KycEvent>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [const FullType(MerchantAccount)]),
            () => ListBuilder<MerchantAccount>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [const FullType(MerchantDocument)]),
            () => ListBuilder<MerchantDocument>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [const FullType(MerchantPayment)]),
            () => ListBuilder<MerchantPayment>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [const FullType(MerchantPayment)]),
            () => ListBuilder<MerchantPayment>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [const FullType(CreditTypeAmount)]),
            () => ListBuilder<CreditTypeAmount>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [
              const FullType(MerchantMonthlyFlow),
            ]),
            () => ListBuilder<MerchantMonthlyFlow>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [const FullType(OverviewUser)]),
            () => ListBuilder<OverviewUser>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [const FullType(Department)]),
            () => ListBuilder<Department>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [const FullType(OverviewEmployee)]),
            () => ListBuilder<OverviewEmployee>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [const FullType(CreditTypeAmount)]),
            () => ListBuilder<CreditTypeAmount>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [const FullType(OverviewOrder)]),
            () => ListBuilder<OverviewOrder>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [
              const FullType(OverviewAllocation),
            ]),
            () => ListBuilder<OverviewAllocation>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [
              const FullType(AllocationTemplate),
            ]),
            () => ListBuilder<AllocationTemplate>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [const FullType(OverviewInvoice)]),
            () => ListBuilder<OverviewInvoice>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [const FullType(OverviewUser)]),
            () => ListBuilder<OverviewUser>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [const FullType(OverviewSale)]),
            () => ListBuilder<OverviewSale>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [const FullType(OverviewPayout)]),
            () => ListBuilder<OverviewPayout>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [
              const FullType(PasswordPolicyRule),
            ]),
            () => ListBuilder<PasswordPolicyRule>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [const FullType(PaymentEvent)]),
            () => ListBuilder<PaymentEvent>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [const FullType(PayoutEvent)]),
            () => ListBuilder<PayoutEvent>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [const FullType(PayoutEvent)]),
            () => ListBuilder<PayoutEvent>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [const FullType(PayoutRequest)]),
            () => ListBuilder<PayoutRequest>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [const FullType(Receivable)]),
            () => ListBuilder<Receivable>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [const FullType(Settlement)]),
            () => ListBuilder<Settlement>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [const FullType(SettlementBatch)]),
            () => ListBuilder<SettlementBatch>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [const FullType(String)]),
            () => ListBuilder<String>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [const FullType(String)]),
            () => ListBuilder<String>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [const FullType(String)]),
            () => ListBuilder<String>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [const FullType(String)]),
            () => ListBuilder<String>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [
              const FullType(AllocationTypeAmount),
            ]),
            () => ListBuilder<AllocationTypeAmount>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [const FullType(TeamUser)]),
            () => ListBuilder<TeamUser>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [const FullType(UserAuditEntry)]),
            () => ListBuilder<UserAuditEntry>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [const FullType(int)]),
            () => ListBuilder<int>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltSet, const [const FullType(KycDocumentType)]),
            () => SetBuilder<KycDocumentType>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [
              const FullType(CreditTypeSettings),
            ]),
            () => ListBuilder<CreditTypeSettings>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [
              const FullType.nullable(JsonObject),
            ]),
            () => ListBuilder<JsonObject?>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltMap, const [
              const FullType(String),
              const FullType(FieldErrorParamsValue),
            ]),
            () => MapBuilder<String, FieldErrorParamsValue>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltMap, const [
              const FullType(String),
              const FullType(int),
            ]),
            () => MapBuilder<String, int>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltSet, const [const FullType(CreditType)]),
            () => SetBuilder<CreditType>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltSet, const [const FullType(CreditType)]),
            () => SetBuilder<CreditType>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltSet, const [const FullType(CreditType)]),
            () => SetBuilder<CreditType>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltSet, const [const FullType(CreditType)]),
            () => SetBuilder<CreditType>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [const FullType(CommissionTier)]),
            () => ListBuilder<CommissionTier>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltSet, const [const FullType(CreditType)]),
            () => SetBuilder<CreditType>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [const FullType(PointOfSale)]),
            () => ListBuilder<PointOfSale>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [const FullType(StaffMember)]),
            () => ListBuilder<StaffMember>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltSet, const [const FullType(String)]),
            () => SetBuilder<String>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltSet, const [const FullType(String)]),
            () => SetBuilder<String>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltSet, const [const FullType(String)]),
            () => SetBuilder<String>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltSet, const [const FullType(String)]),
            () => SetBuilder<String>(),
          ))
        .build();

// ignore_for_file: deprecated_member_use_from_same_package,type=lint

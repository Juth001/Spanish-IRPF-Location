
namespace Excelia.IRPF;
using Microsoft.Finance.GeneralLedger.Journal;
using Microsoft.Purchases.Vendor;
using Microsoft.Foundation.Address;
using Microsoft.Finance.GeneralLedger.Setup;
tableextension 86302 "EXC Gen. Journal Line" extends "Gen. Journal Line"
{
    fields
    {
        field(86300; "Perception Type"; Code[10])
        {
            DataClassification = CustomerContent;
            TableRelation = "EXC Perception Type".Code;
            Caption = 'Perception Type';
            Description = 'Type of perception associated with the retention.';
            Tooltip = 'Type of perception associated with the retention.';
            Editable = true;
        }
        field(86301; "Perception Key"; code[10])
        {
            DataClassification = CustomerContent;
            TableRelation = if ("Account Type" = const(Customer)) "EXC Perception Keys".Code WHERE("Cust/Vend" = const(Customer))
            else if ("Account Type" = const(Vendor)) "EXC Perception Keys".Code WHERE("Cust/Vend" = const(Vendor));
            Caption = 'Perception Key';
            Description = 'Perception Key associated with the retention.';
            Tooltip = 'Perception Key associated with the retention.';
            Editable = true;

            trigger OnValidate()
            var
                GLSetup: record "General Ledger Setup";
            begin
                GLSetup.Get();
                CALCFIELDS("Retention %");
                if ("Retention %" <> 0) then "Retention Base" := round("Retention Amount" / ("Retention %" / 100), GLSetup."Amount Rounding Precision");
                Validate(Amount, "Retention Amount");
                "Year Accrual" := DATE2DMY(WorkDate(), 3);
            end;
        }
        field(86302; "Retention Base"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Retention Base';
            Description = 'Base amount for calculating the retention.';
            Tooltip = 'Base amount for calculating the retention.';
            Editable = true;
        }
        field(86303; "Retention Amount"; decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Retention Amount';
            Description = 'Amount of retention to be applied.';
            Tooltip = 'Amount of retention to be applied.';
            Editable = true;

            trigger OnValidate()
            var
                GLSetup: record "General Ledger Setup";
            begin
                GLSetup.Get();
                CALCFIELDS("Retention %");
                if ("Retention %" <> 0) then "Retention Base" := round("Retention Amount" / ("Retention %" / 100), GLSetup."Amount Rounding Precision");
                Validate(Amount, "Retention Amount");
            end;
        }
        field(86304; "Retention %"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Lookup("EXC Perception Keys"."Retention %" WHERE("Code" = FIELD("perception Key")));
            Editable = false;
            Caption = 'Retention %';
            Description = 'Percentage of retention applied.';
            Tooltip = 'Percentage of retention applied.';
        }
        field(86305; "Retention Entry"; Integer)
        {
            DataClassification = CustomerContent;
            Editable = false;
            Caption = 'Deduction Entry';
            Description = 'Entry number of the retention.';
            Tooltip = 'Entry number of the retention.';
        }
        field(86306; "Year Accrual"; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Year Accrual';
            Editable = false;
            Description = 'Year of accrual for the retention.';
            Tooltip = 'Year of accrual for the retention.';
        }
        field(86307; "Retention Document No."; code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Retention Document No.';
            Description = 'Document number associated with the retention.';
            Tooltip = 'Document number associated with the retention.';
        }
        field(86308; "Liq. Retention"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Liq. Retention';
            Description = 'Indicates if the line is for retention liquidation.';
            Tooltip = 'Indicates if the line is for retention liquidation.';
        }
        field(86309; "Post Code"; code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "Post Code";
            Caption = 'Post Code';
            Description = 'Post code associated with the retention.';
            Tooltip = 'Post code associated with the retention.';
        }
        field(86310; "Cust/Vend"; Option)
        {
            DataClassification = CustomerContent;
            Caption = 'Cust/Vend';
            OptionMembers = "Customer","Vendor";
            OptionCaption = 'Customer,Vendor';
            Description = 'Indicates whether the line is for a customer or vendor.';
            Tooltip = 'Indicates whether the line is for a customer or vendor.';
        }
        field(86311; "Customer/Vendor No."; code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Customer/Vendor No.';
            Description = 'Number of the customer or vendor associated with the retention.';
            Tooltip = 'Number of the customer or vendor associated with the retention.';
        }
        field(86312; "Invoice Amount"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Invoice Amount';
            Description = 'Amount of the invoice associated with the retention.';
            Tooltip = 'Amount of the invoice associated with the retention.';
        }
        field(86313; Invoice; Option)
        {
            DataClassification = CustomerContent;
            Caption = 'Invoice';
            OptionMembers = "With invoice;No invocie";
            OptionCaption = 'With invoice, No invoice';
            Description = 'Indicates whether the retention is associated with an invoice.';
            Tooltip = 'Indicates whether the retention is associated with an invoice.';
        }
        field(86314; Bill; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Bill';
            Description = 'Indicates whether the retention is billed.';
            Tooltip = 'Indicates whether the retention is billed.';
        }
        field(86315; "Settlement Type"; Option)
        {
            DataClassification = CustomerContent;
            Caption = 'Settlement Type';
            OptionMembers = "Customer/Vendor","Bank","Account";
            OptionCaption = 'Customer/Vendor,Bank,Account';
            Description = 'Type of settlement for the retention.';
            Tooltip = 'Type of settlement for the retention.';
        }
        field(86316; "Nº mov. retención"; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Nº mov. retención';
            Description = 'Number of the retention movement.';
            Tooltip = 'Number of the retention movement.';
        }
    }
    var

    procedure CreaLinRetencionVentas()
    var
        Vendor: record Vendor;
        GenJournalLine: record "Gen. Journal Line";
        PerceptionKey: Record "EXC Perception Keys";
        TextRet0001: Label 'No se puede hacer retención con cuenta de contrapartida.';
        ImportCuentAcum: Decimal;
        ImportReten: Decimal;

    begin
        GenJournalLine.Reset();
        GenJournalLine.Setrange(GenJournalLine."Journal Template Name", "Journal Template Name");
        GenJournalLine.Setrange(GenJournalLine."Journal Batch Name", "Journal Batch Name");
        GenJournalLine.Setrange(GenJournalLine."Account Type", GenJournalLine."Account Type"::Vendor);
        if GenJournalLine.FindLast() then;
        if GenJournalLine."Bal. Account No." <> '' then ERROR(TextRet0001);
        if Vendor.Get(GenJournalLine."Account No.") then;
        Vendor.Testfield(Vendor."Perception Key");
        PerceptionKey.Get(Vendor."Perception Key");
        GenJournalLine."Journal Template Name" := GenJournalLine."Journal Template Name";
        GenJournalLine."Journal Batch Name" := GenJournalLine."Journal Batch Name";
        GenJournalLine."Line No." := GenJournalLine."Line No." + 10000;
        GenJournalLine.Insert();

        GenJournalLine."Posting Date" := GenJournalLine."Posting Date";
        GenJournalLine."Document No." := GenJournalLine."Document No.";
        GenJournalLine."Account Type" := GenJournalLine."Account Type"::"G/L Account";
        GenJournalLine.Validate(GenJournalLine."Account No.", PerceptionKey."Retention Acc.");
        GenJournalLine."Gen. Bus. Posting Group" := '';
        GenJournalLine."Gen. Prod. Posting Group" := '';
        GenJournalLine.Amount := GenJournalLine.Amount;
        GenJournalLine."Perception Type" := Vendor."Perception Type";
        GenJournalLine."Perception Key" := Vendor."Perception Key";
        GenJournalLine."Retention %" := PerceptionKey."Retention %";
        GenJournalLine."Cust/Vend" := GenJournalLine."Cust/Vend"::Vendor;
        GenJournalLine."Customer/Vendor No." := GenJournalLine."Account No.";
        GenJournalLine."Invoice Amount" := GenJournalLine.Amount;
        clear(ImportCuentAcum);

        GenJournalLine.Setrange(GenJournalLine."Journal Template Name", "Journal Template Name");
        GenJournalLine.Setrange(GenJournalLine."Journal Batch Name", "Journal Batch Name");
        GenJournalLine.Setrange(GenJournalLine."Account Type", GenJournalLine."Account Type"::"G/L Account");

        if GenJournalLine.FindFIRST() then
            repeat
                GenJournalLine."Retention Base" += ABS(GenJournalLine."VAT Base Amount");
                ImportCuentAcum += GenJournalLine.Amount;
            until GenJournalLine.Next() = 0;

        if GenJournalLine."Bal. Account No." <> '' then ERROR(TextRet0001);

        if GenJournalLine.Amount < 0 then begin
            if PerceptionKey."Calculation Type" = PerceptionKey."Calculation Type"::Base then begin
                GenJournalLine."Retention Amount" := ((GenJournalLine."Retention Base") * PerceptionKey."Retention %") / 100;
                GenJournalLine.Validate(GenJournalLine.Amount, -GenJournalLine."Retention Amount");
                GenJournalLine.Validate(GenJournalLine.Amount, (GenJournalLine.Amount + GenJournalLine."Retention Amount"));
                GenJournalLine.Modify();
            end
            else begin
                clear(ImportReten);
                ImportReten := ((ImportCuentAcum * PerceptionKey."Retention %") / 100);
                GenJournalLine.Validate(GenJournalLine."Retention Amount", -ImportReten);
                GenJournalLine.Validate(GenJournalLine.Amount, (GenJournalLine.Amount - GenJournalLine."Retention Amount"));
                GenJournalLine.Modify();
            end;
        end
        else
            if PerceptionKey."Calculation Type" = PerceptionKey."Calculation Type"::Base then begin
                GenJournalLine."Retention Amount" := ((GenJournalLine."Retention Base") * PerceptionKey."Retention %") / 100;
                GenJournalLine.Validate(GenJournalLine.Amount, GenJournalLine."Retention Amount");
                GenJournalLine.Validate(GenJournalLine.Amount, GenJournalLine.Amount - GenJournalLine."Retention Amount");
                GenJournalLine.Modify();
            end
            else begin
                clear(ImportReten);
                ImportReten := ((ImportCuentAcum * PerceptionKey."Retention %") / 100);
                GenJournalLine.Validate(GenJournalLine."Retention Amount", ABS(ImportReten));
                GenJournalLine.Validate(GenJournalLine.Amount, GenJournalLine.Amount - GenJournalLine."Retention Amount");
                GenJournalLine.Modify();
            end;

        GenJournalLine."Year Accrual" := DATE2DMY(GenJournalLine."Posting Date", 3);
        GenJournalLine.Modify();
    end;

    procedure CrearLinRetencionCompras()
    var
        RVendor: record Vendor;
        LinDiario: record "Gen. Journal Line";
        RClavPercep: Record "EXC Perception Keys";
        LinDiarioRet: Record "Gen. Journal Line";
        LinDiarioCuent: Record "Gen. Journal Line";
        TextRet0001: Label 'No se puede hacer retención con cuenta de contrapartida.';
        ImportCuentAcum: Decimal;
        ImportReten: Decimal;
    begin
        LinDiario.Reset();
        LinDiario.Setrange(LinDiario."Journal Template Name", "Journal Template Name");
        LinDiario.Setrange(LinDiario."Journal Batch Name", "Journal Batch Name");
        LinDiario.Setrange(LinDiario."Account Type", LinDiario."Account Type"::Vendor);
        if LinDiario.FindLast() then;
        if LinDiario."Bal. Account No." <> '' then ERROR(TextRet0001);
        if RVEndor.Get(LinDiario."Account No.") then;
        RVEndor.Testfield(RVEndor."Perception Key");
        RClavPercep.Get(RVEndor."Perception Key");
        LinDiarioRet."Journal Template Name" := LinDiario."Journal Template Name";
        LinDiarioRet."Journal Batch Name" := LinDiario."Journal Batch Name";
        LinDiarioRet."Line No." := LinDiario."Line No." + 10000;
        LinDiarioRet.Insert();
        LinDiarioRet."Posting Date" := LinDiario."Posting Date";
        LinDiarioRet."Document No." := LinDiario."Document No.";
        LinDiarioRet."Account Type" := LinDiarioRet."Account Type"::"G/L Account";
        LinDiarioRet.Validate(LinDiarioRet."Account No.", RClavPercep."Retention Acc.");
        LinDiarioRet."Gen. Bus. Posting Group" := '';
        LinDiarioRet."Gen. Prod. Posting Group" := '';
        LinDiarioRet.Amount := LinDiario.Amount;
        LinDiarioRet."Perception Type" := RVEndor."Perception Type";
        LinDiarioRet."Perception Key" := RVEndor."Perception Key";
        LinDiarioRet."Retention %" := RClavPercep."Retention %";
        LinDiarioRet."Cust/Vend" := LinDiarioRet."Cust/Vend"::Vendor;
        LinDiarioRet."Customer/Vendor No." := LinDiario."Account No.";
        LinDiarioRet."Invoice Amount" := LinDiario.Amount;
        clear(ImportCuentAcum);
        LinDiarioCuent.Setrange(LinDiarioCuent."Journal Template Name", "Journal Template Name");
        LinDiarioCuent.Setrange(LinDiarioCuent."Journal Batch Name", "Journal Batch Name");
        LinDiarioCuent.Setrange(LinDiarioCuent."Account Type", LinDiario."Account Type"::"G/L Account");
        if LinDiarioCuent.FindFIRST() then
            repeat
                LinDiarioRet."Retention Base" += ABS(LinDiarioCuent."VAT Base Amount");
                ImportCuentAcum += LinDiarioCuent.Amount;
            until LinDiarioCuent.Next() = 0;
        if LinDiarioCuent."Bal. Account No." <> '' then ERROR(TextRet0001);
        if LinDiario.Amount < 0 then begin
            if RClavPercep."Calculation Type" = RClavPercep."Calculation Type"::Base then begin
                LinDiarioRet."Retention Amount" := ((LinDiarioRet."Retention Base") * RClavPercep."Retention %") / 100;
                LinDiarioRet.Validate(LinDiarioRet.Amount, -LinDiarioRet."Retention Amount");
                LinDiario.Validate(LinDiario.Amount, (LinDiario.Amount + LinDiarioRet."Retention Amount"));
                LinDiario.Modify();
            end
            else begin
                clear(ImportReten);
                ImportReten := ((ImportCuentAcum * RClavPercep."Retention %") / 100);
                LinDiarioRet.Validate(LinDiarioRet."Retention Amount", -ImportReten);
                LinDiario.Validate(LinDiario.Amount, (LinDiario.Amount - LinDiarioRet."Retention Amount"));
                LinDiario.Modify();
            end;
        end
        else
            if RClavPercep."Calculation Type" = RClavPercep."Calculation Type"::Base then begin
                LinDiarioRet."Retention Amount" := ((LinDiarioRet."Retention Base") * RClavPercep."Retention %") / 100;
                LinDiarioRet.Validate(LinDiarioRet.Amount, LinDiarioRet."Retention Amount");
                LinDiario.Validate(LinDiario.Amount, LinDiario.Amount - LinDiarioRet."Retention Amount");
                LinDiario.Modify();
            end
            else begin
                clear(ImportReten);
                ImportReten := ((ImportCuentAcum * RClavPercep."Retention %") / 100);
                LinDiarioRet.Validate(LinDiarioRet."Retention Amount", ABS(ImportReten));
                LinDiario.Validate(LinDiario.Amount, LinDiario.Amount - LinDiarioRet."Retention Amount");
                LinDiario.Modify();
            end;

        LinDiarioRet."Year Accrual" := DATE2DMY(LinDiarioRet."Posting Date", 3);
        LinDiarioRet.Modify();
    end;
}

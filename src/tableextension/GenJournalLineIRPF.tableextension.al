namespace ScriptumVita.IRPF;
tableextension 86302 "Gen. Journal Line_IRPF" extends "Gen. Journal Line"
{
    fields
    {
        field(60500; "Tipo Percepción"; Code[10])
        {
            DataClassification = CustomerContent;
            TableRelation = "IND Perception Type (IRPF)".Código;
            //CaptionML = ENU = 'Perception Type', ESP = 'Tipo Percepción';
            Caption = 'Tipo Percepción'; //'Perception Type';
            Editable = true;
        }
        field(60501; "Clave percepción"; code[10])
        {
            DataClassification = CustomerContent;
            TableRelation = IF ("Account Type" = CONST(Customer)) "IND Perception Keys (IRPF)"."Código" WHERE("Cli/Prov" = CONST(Cliente))
            ELSE IF ("Account Type" = CONST(Vendor)) "IND Perception Keys (IRPF)"."Código" WHERE("Cli/Prov" = CONST(Proveedor));
            //CaptionML = ENU = 'Perception Key', ESP = 'Clave percepción';
            Caption = 'Clave percepción'; //'Perception Key';
            Editable = true;

            trigger OnValidate()
            var
                GLSetup: record "General Ledger Setup";
            begin
                //TECNOCOM - TecnoRet
                GLSetup.GET;
                CALCFIELDS("Porcentaje retención");
                IF ("Porcentaje retención" <> 0) THEN "Base retención" := ROUND("Importe retención" / ("Porcentaje retención" / 100), GLSetup."Amount Rounding Precision");
                VALIDATE(Amount, "Importe retención");
                "Año devengo" := DATE2DMY(WORKDATE, 3);
                //FIN TECNOCOM - TecnoRet
            end;
        }
        field(60502; "Base retención"; Decimal)
        {
            DataClassification = CustomerContent;
            //CaptionML = ENU = 'Retention Base', ESP = 'Base retención';
            Caption = 'Base retención'; //'Retention Base';
            Editable = true;
        }
        field(60503; "Importe retención"; decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Importe retención'; //'Retention Amount';
            //CaptionML = ENU = 'Retention Amount', ESP = 'Importe retención';
            Editable = true;

            trigger OnValidate()
            var
                GLSetup: record "General Ledger Setup";
            begin
                //TECNOCOM - TecnoRet
                GLSetup.GET;
                CALCFIELDS("Porcentaje retención");
                IF ("Porcentaje retención" <> 0) THEN "Base retención" := ROUND("Importe retención" / ("Porcentaje retención" / 100), GLSetup."Amount Rounding Precision");
                VALIDATE(Amount, "Importe retención");
                //FIN TECNOCOM - TecnoRet 
            end;
        }
        field(60504; "Porcentaje retención"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Lookup("IND Perception Keys (IRPF)"."% Retención" WHERE("Código" = FIELD("Clave percepción")));
            Editable = false;
            //CaptionML = ENU = 'Retention percentage', ESP = 'Porcentaje retención';
            Caption = 'Porcentaje retención'; //'Retention percentage';
        }
        field(60505; "Mov. retención"; Integer)
        {
            DataClassification = CustomerContent;
            Editable = false;
            //CaptionML = ENU = 'Entry. Retention', ESP = 'Mov. retención';
            Caption = 'Mov. retención'; //'Entry. Retention';
        }
        field(60506; "Año devengo"; Integer)
        {
            DataClassification = CustomerContent;
            //CaptionML = ENU = 'Year Accrual', ESP = 'Año devengo';
            Caption = 'Año devengo'; //'Year Accrual';
            Editable = false;
        }
        field(60507; "Nº doc. retención"; code[20])
        {
            DataClassification = CustomerContent;
            //Caption = 'No. doc. retention', ESP = 'Nº doc. retención';
            Caption = 'No. doc. retention';
        }
        field(60508; "Liq. retención"; Boolean)
        {
            DataClassification = CustomerContent;
            //CaptionML = ENU = 'Liq. Retention', ESP = 'Liq. retención';
            Caption = 'Liq. Retention';
        }
        field(60509; "C.P."; code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "Post Code";
            //CaptionML = ENU = 'P.C.', ESP = 'C.P.';
            Caption = 'C.P.';
        }
        field(60510; "Cliente/Proveedor"; Option)
        {
            DataClassification = CustomerContent;
            //CaptionML = ESP = 'Cliente/Proveedor', ENU = 'Customer/Vendor';
            //OptionCaptionML = ESP = 'Cliente,Proveedor', ENU = 'Customer,Vendor';
            Caption = 'Cliente,Proveedor'; //'Customer/Vendor';
            OptionMembers = "Cliente","Proveedor";
            OptionCaption = 'Cliente,Proveedor'; //'Customer,Vendor';
        }
        field(60511; "Nº Cliente/Proveedor"; code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Nº Cliente/Proveedor'; //'Customer/Vendor No.';
                                              //CaptionML = ESP = 'Nº Cliente/Proveedor', ENU = 'Customer/Vendor No.';
        }
        field(60512; "Importe Factura"; Decimal)
        {
            DataClassification = CustomerContent;
            //CaptionML = ENU = 'Invoice Amount', ESP = 'Importe Factura';
            Caption = 'Importe Factura'; //'Invoice Amount';
        }
        field(60513; Factura; Option)
        {
            DataClassification = CustomerContent;
            //CaptionML = ENU = 'Invoice', ESP = 'Factura';
            Caption = 'Factura'; //'Invoice';
            OptionMembers = "Con factura","Sin factura";
            //OptionCaptionML = ENU = 'With invoice, No invocie', ESP = 'Con factura,Sin factura';
            OptionCaption = 'Con factura,Sin factura'; //'With invoice, No invoice';
        }
        field(60514; Efecto; Boolean)
        {
            DataClassification = CustomerContent;
            //CaptionML = ENU = 'Bill', ESP = 'Efecto';
            Caption = 'Efecto'; //'Bill';
        }
        field(60515; "Tipo Liquidacion"; Option)
        {
            DataClassification = CustomerContent;
            //CaptionML = ENU = 'Type Liquidation', ESP = 'Tipo liquidación';
            Caption = 'Tipo liquidación'; //'Type Liquidation';
            OptionMembers = "Cliente/Proveedor","Banco","Cuenta";
            //OptionCaptionML = ENU = 'Customer/Vendor,Bank,Account', ESP = 'Cliente/Proveedor,Banco,Cuenta';
            OptionCaption = 'Cliente/Proveedor,Banco,Cuenta'; //'Customer/Vendor,Bank,Account';
        }
        field(60516; "Nº mov. retención"; Integer)
        {
            DataClassification = CustomerContent;
            //CaptionML = ENU = 'Level 7', ESP = 'Nivel 7';
            Caption = 'Nivel 7'; //'Level 7';
        }
    }
    var
        LinDiario: record "Gen. Journal Line";
        TextRet0001: Label 'No se puede hacer retención con cuenta de contrapartida.';
        RClavPercep: Record "IND Perception Keys (IRPF)";
        LinDiarioRet: Record "Gen. Journal Line";
        ImportCuentAcum: Decimal;
        LinDiarioCuent: Record "Gen. Journal Line";
        ImportReten: Decimal;
        TextRet0002: Label 'No se puede cambiar pago por pagar‚ si se ha generado pagar‚. Elimine el pagar‚ antes de desmarcar.';
        TextRet0003: Label 'Si se realiza pago mediante pagar‚, no debe informarse %1';
        SalesSetup: Record "Sales & Receivables Setup";

    procedure CreaLinRetencionVentas()
    var
        RCust: record Customer;
        ImportRet: Decimal;
        RVendor: record vendor;
    begin
        LinDiario.RESET;
        LinDiario.SETRANGE(LinDiario."Journal Template Name", "Journal Template Name");
        LinDiario.SETRANGE(LinDiario."Journal Batch Name", "Journal Batch Name");
        LinDiario.SETRANGE(LinDiario."Account Type", LinDiario."Account Type"::Vendor);
        IF LinDiario.FINDLAST THEN;
        IF LinDiario."Bal. Account No." <> '' THEN ERROR(TextRet0001);
        IF RVEndor.GET(LinDiario."Account No.") THEN;
        RVEndor.TESTFIELD(RVEndor."Clave Percepción");
        RClavPercep.GET(RVEndor."Clave Percepción");
        LinDiarioRet."Journal Template Name" := LinDiario."Journal Template Name";
        LinDiarioRet."Journal Batch Name" := LinDiario."Journal Batch Name";
        LinDiarioRet."Line No." := LinDiario."Line No." + 10000;
        LinDiarioRet.INSERT;
        LinDiarioRet."Posting Date" := LinDiario."Posting Date";
        LinDiarioRet."Document No." := LinDiario."Document No.";
        LinDiarioRet."Account Type" := LinDiarioRet."Account Type"::"G/L Account";
        LinDiarioRet.VALIDATE(LinDiarioRet."Account No.", RClavPercep."Cta. retención");
        LinDiarioRet."Gen. Bus. Posting Group" := '';
        LinDiarioRet."Gen. Prod. Posting Group" := '';
        LinDiarioRet.Amount := LinDiario.Amount;
        LinDiarioRet."Tipo Percepción" := RVEndor."Tipo Percepción";
        LinDiarioRet."Clave percepción" := RVEndor."Clave Percepción";
        LinDiarioRet."Porcentaje retención" := RClavPercep."% retención";
        LinDiarioRet."Cliente/Proveedor" := LinDiarioRet."Cliente/Proveedor"::Proveedor;
        LinDiarioRet."Nº Cliente/Proveedor" := LinDiario."Account No.";
        LinDiarioRet."Importe Factura" := LinDiario.Amount;
        CLEAR(ImportCuentAcum);
        LinDiarioCuent.SETRANGE(LinDiarioCuent."Journal Template Name", "Journal Template Name");
        LinDiarioCuent.SETRANGE(LinDiarioCuent."Journal Batch Name", "Journal Batch Name");
        LinDiarioCuent.SETRANGE(LinDiarioCuent."Account Type", LinDiario."Account Type"::"G/L Account");
        IF LinDiarioCuent.FINDFIRST THEN
            REPEAT
                LinDiarioRet."Base retención" += ABS(LinDiarioCuent."VAT Base Amount");
                ImportCuentAcum += LinDiarioCuent.Amount;
            UNTIL LinDiarioCuent.NEXT = 0;
        IF LinDiarioCuent."Bal. Account No." <> '' THEN ERROR(TextRet0001);
        IF LinDiario.Amount < 0 THEN BEGIN
            IF RClavPercep."Tipo cálculo" = RClavPercep."Tipo cálculo"::Base THEN BEGIN
                LinDiarioRet."Importe retención" := ((LinDiarioRet."Base retención") * RClavPercep."% retención") / 100;
                LinDiarioRet.VALIDATE(LinDiarioRet.Amount, -LinDiarioRet."Importe retención");
                LinDiario.VALIDATE(LinDiario.Amount, (LinDiario.Amount + LinDiarioRet."Importe retención"));
                LinDiario.MODIFY;
            END
            ELSE BEGIN
                CLEAR(ImportReten);
                ImportReten := ((ImportCuentAcum * RClavPercep."% retención") / 100);
                LinDiarioRet.VALIDATE(LinDiarioRet."Importe retención", -ImportReten);
                LinDiario.VALIDATE(LinDiario.Amount, (LinDiario.Amount - LinDiarioRet."Importe retención"));
                LinDiario.MODIFY;
            END;
        END
        ELSE BEGIN
            IF RClavPercep."Tipo cálculo" = RClavPercep."Tipo cálculo"::Base THEN BEGIN
                LinDiarioRet."Importe retención" := ((LinDiarioRet."Base retención") * RClavPercep."% retención") / 100;
                LinDiarioRet.VALIDATE(LinDiarioRet.Amount, LinDiarioRet."Importe retención");
                LinDiario.VALIDATE(LinDiario.Amount, LinDiario.Amount - LinDiarioRet."Importe retención");
                LinDiario.MODIFY;
            END
            ELSE BEGIN
                CLEAR(ImportReten);
                ImportReten := ((ImportCuentAcum * RClavPercep."% Retención") / 100);
                LinDiarioRet.VALIDATE(LinDiarioRet."Importe retención", ABS(ImportReten));
                LinDiario.VALIDATE(LinDiario.Amount, LinDiario.Amount - LinDiarioRet."Importe retención");
                LinDiario.MODIFY;
            END;
        END;
        LinDiarioRet."Año devengo" := DATE2DMY(LinDiarioRet."Posting Date", 3);
        LinDiarioRet.MODIFY;
    end;

    procedure CrearLinRetencionCompras()
    var
        RVendor: record Vendor;
    begin
        LinDiario.RESET;
        LinDiario.SETRANGE(LinDiario."Journal Template Name", "Journal Template Name");
        LinDiario.SETRANGE(LinDiario."Journal Batch Name", "Journal Batch Name");
        LinDiario.SETRANGE(LinDiario."Account Type", LinDiario."Account Type"::Vendor);
        IF LinDiario.FINDLAST THEN;
        IF LinDiario."Bal. Account No." <> '' THEN ERROR(TextRet0001);
        IF RVEndor.GET(LinDiario."Account No.") THEN;
        RVEndor.TESTFIELD(RVEndor."Clave Percepción");
        RClavPercep.GET(RVEndor."Clave Percepción");
        LinDiarioRet."Journal Template Name" := LinDiario."Journal Template Name";
        LinDiarioRet."Journal Batch Name" := LinDiario."Journal Batch Name";
        LinDiarioRet."Line No." := LinDiario."Line No." + 10000;
        LinDiarioRet.INSERT;
        LinDiarioRet."Posting Date" := LinDiario."Posting Date";
        LinDiarioRet."Document No." := LinDiario."Document No.";
        LinDiarioRet."Account Type" := LinDiarioRet."Account Type"::"G/L Account";
        LinDiarioRet.VALIDATE(LinDiarioRet."Account No.", RClavPercep."Cta. retención");
        LinDiarioRet."Gen. Bus. Posting Group" := '';
        LinDiarioRet."Gen. Prod. Posting Group" := '';
        LinDiarioRet.Amount := LinDiario.Amount;
        LinDiarioRet."Tipo percepción" := RVEndor."Tipo Percepción";
        LinDiarioRet."Clave percepción" := RVEndor."Clave Percepción";
        LinDiarioRet."Porcentaje retención" := RClavPercep."% Retención";
        LinDiarioRet."Cliente/Proveedor" := LinDiarioRet."Cliente/Proveedor"::Proveedor;
        LinDiarioRet."Nº Cliente/Proveedor" := LinDiario."Account No.";
        LinDiarioRet."Importe Factura" := LinDiario.Amount;
        CLEAR(ImportCuentAcum);
        LinDiarioCuent.SETRANGE(LinDiarioCuent."Journal Template Name", "Journal Template Name");
        LinDiarioCuent.SETRANGE(LinDiarioCuent."Journal Batch Name", "Journal Batch Name");
        LinDiarioCuent.SETRANGE(LinDiarioCuent."Account Type", LinDiario."Account Type"::"G/L Account");
        IF LinDiarioCuent.FINDFIRST THEN
            REPEAT
                LinDiarioRet."Base retención" += ABS(LinDiarioCuent."VAT Base Amount");
                ImportCuentAcum += LinDiarioCuent.Amount;
            UNTIL LinDiarioCuent.NEXT = 0;
        IF LinDiarioCuent."Bal. Account No." <> '' THEN ERROR(TextRet0001);
        IF LinDiario.Amount < 0 THEN BEGIN
            IF RClavPercep."Tipo cálculo" = RClavPercep."Tipo cálculo"::Base THEN BEGIN
                LinDiarioRet."Importe retención" := ((LinDiarioRet."Base retención") * RClavPercep."% Retención") / 100;
                LinDiarioRet.VALIDATE(LinDiarioRet.Amount, -LinDiarioRet."Importe retención");
                LinDiario.VALIDATE(LinDiario.Amount, (LinDiario.Amount + LinDiarioRet."Importe retención"));
                LinDiario.MODIFY;
            END
            ELSE BEGIN
                CLEAR(ImportReten);
                ImportReten := ((ImportCuentAcum * RClavPercep."% Retención") / 100);
                LinDiarioRet.VALIDATE(LinDiarioRet."Importe retención", -ImportReten);
                LinDiario.VALIDATE(LinDiario.Amount, (LinDiario.Amount - LinDiarioRet."Importe retención"));
                LinDiario.MODIFY;
            END;
        END
        ELSE BEGIN
            IF RClavPercep."Tipo cálculo" = RClavPercep."Tipo cálculo"::Base THEN BEGIN
                LinDiarioRet."Importe retención" := ((LinDiarioRet."Base retención") * RClavPercep."% Retención") / 100;
                LinDiarioRet.VALIDATE(LinDiarioRet.Amount, LinDiarioRet."Importe retención");
                LinDiario.VALIDATE(LinDiario.Amount, LinDiario.Amount - LinDiarioRet."Importe retención");
                LinDiario.MODIFY;
            END
            ELSE BEGIN
                CLEAR(ImportReten);
                ImportReten := ((ImportCuentAcum * RClavPercep."% Retención") / 100);
                LinDiarioRet.VALIDATE(LinDiarioRet."Importe retención", ABS(ImportReten));
                LinDiario.VALIDATE(LinDiario.Amount, LinDiario.Amount - LinDiarioRet."Importe retención");
                LinDiario.MODIFY;
            END;
        END;
        LinDiarioRet."Año devengo" := DATE2DMY(LinDiarioRet."Posting Date", 3);
        LinDiarioRet.MODIFY;
    end;
}

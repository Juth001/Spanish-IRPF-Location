namespace ScriptumVita.IRPF;
tableextension 86313 "Reversal Entry_IRPF" extends "Reversal Entry"
{
    fields
    {
        field(60500; "Entry Type IRPF"; Option)
        {
            DataClassification = CustomerContent;
            //OptionCaptionML = ENU = ' ,G/L Account,Customer,Vendor,Bank Account,Fixed Asset,Maintenance,VAT,Retention', ESP = ' ,Cuenta,Cliente,Proveedor,Banco,Activo fijo,Mantenimiento,IVA,Retención';
            OptionCaption = ' ,Cuenta,Cliente,Proveedor,Banco,Activo fijo,Mantenimiento,IVA,Retención'; //' ,G/L Account,Customer,Vendor,Bank Account,Fixed Asset,Maintenance,VAT,Retention';
            OptionMembers = " ","G/L Account","Customer","Vendor","Bank Account","Fixed Asset","Maintenance","VAT","Retención";
            Description = 'TecnoRet';
            //CaptionML = ENU = 'Entry Type', ESP = 'Tipo Movimiento';
            Caption = 'Tipo Movimiento'; //'Entry Type';
        }
    }
    var
        MovRetención: record "IND Witholding Tax registers";

    PROCEDURE CopyReverseFiltersIRPF(VAR GLEntry2: Record 17; VAR CustLedgEntry2: Record 21; VAR VendLedgEntry2: Record 25; VAR BankAccLedgEntry2: Record 271; VAR VATEntry2: Record 254; VAR FALedgEntry2: Record 5601; VAR MaintenanceLedgEntry2: Record 5625; VAR MovRetención2: Record "IND Witholding Tax registers");
    var
        //Va a estar mal buscar donde se llama a esta función
        GLEntry: record "G/L Entry";
        CustLedgEntry: record "Cust. Ledger Entry";
        VendLedgEntry: record "Vendor Ledger Entry";
        BankAccLedgEntry: record "Bank Account Ledger Entry";
        VATEntry: record "VAT Entry";
        FALedgEntry: record "FA Ledger Entry";
        MaintenanceLedgEntry: record "Maintenance Ledger Entry";
    BEGIN
        GLEntry2.COPY(GLEntry);
        CustLedgEntry2.COPY(CustLedgEntry);
        VendLedgEntry2.COPY(VendLedgEntry);
        BankAccLedgEntry2.COPY(BankAccLedgEntry);
        VATEntry2.COPY(VATEntry);
        FALedgEntry2.COPY(FALedgEntry);
        MaintenanceLedgEntry2.COPY(MaintenanceLedgEntry);
        MovRetención2.COPY(MovRetención); //TecnoRet
    END;
}

namespace ScriptumVita.IRPF;
report 86305 "IND Prov - Dec. Anual_Reten"
{
    // version INDRA
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    RDLCLayout = './Reports/Layout/INDRA Prov - Dec. Anual_Reten.rdl';
    Caption = 'Proveedor - Dec. Anual_Retenciones';

    dataset
    {
        dataitem(Vendor; Vendor)
        {
            RequestFilterFields = "No.", "Vendor Posting Group", "Date Filter";
            CalcFields = "Inv. Amounts (LCY)", "Cr. Memo Amounts (LCY)";

            column(FORMAT_TODAY_0_4_; FORMAT(TODAY, 0, 4))
            {
            }
            column(COMPANYNAME; COMPANYNAME)
            {
            }
            column(CurrReport_PAGENO; 1)
            {
            }
            column(USERID; USERID)
            {
            }
            column(Vendor_TABLECAPTION__________VendFilter; Vendor.TABLECAPTION + ': ' + VendFilter)
            {
            }
            column(VendFilter; VendFilter)
            {
            }
            column(Text1100000___FORMAT_MinAmount_; Text1100000 + FORMAT(MinAmount))
            {
            }
            column(GroupNo; GroupNo)
            {
            }
            column(Vendor__No__; "No.")
            {
            }
            column(VendAddr_1_; VendAddr[1])
            {
            }
            column(VendAddr_2_; VendAddr[2])
            {
            }
            column(VendAddr_3_; VendAddr[3])
            {
            }
            column(VendAddr_4_; VendAddr[4])
            {
            }
            column(VendAddr_5_; VendAddr[5])
            {
            }
            column(VendAddr_6_; VendAddr[6])
            {
            }
            column(VendAddr_7_; VendAddr[7])
            {
            }
            column(Vendor__VAT_Registration_No__; "VAT Registration No.")
            {
            }
            column(PurchaseAmt; PurchaseAmt)
            {
                DecimalPlaces = 0 : 2;
            }
            column(VendAddr_8_; VendAddr[8])
            {
            }
            column(AcumPurchasesAmount; AcumPurchasesAmount)
            {
                DecimalPlaces = 0 : 2;
            }
            column(Vendors___Annual_DeclarationCaption; Vendors___Annual_DeclarationCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Vendor__No__Caption; FIELDCAPTION("No."))
            {
            }
            column(Vendor__VAT_Registration_No__Caption; FIELDCAPTION("VAT Registration No."))
            {
            }
            column(Name_and_AddressCaption; Name_and_AddressCaptionLbl)
            {
            }
            column(PurchaseAmtCaption; PurchaseAmtCaptionLbl)
            {
            }
            trigger OnPreDataItem()
            begin
                IF GUIALLOWED THEN BEGIN
                    BlocksPerPage := 6;
                    Counter := 0;
                    GroupNo := 0;
                END;
                //TecnoRet
                ImptRet := 0;
                //FIN TecnoRet
            end;

            trigger OnAfterGetRecord()
            begin
                PurchaseAmt := "Inv. Amounts (LCY)" - "Cr. Memo Amounts (LCY)";
                IF PurchaseAmt <= MinAmount THEN CurrReport.SKIP;
                VendEntries.SETCURRENTKEY("Document Type", "Vendor No.", "Posting Date", "Currency Code");
                VendEntries.SETRANGE("Document Type", VendEntries."Document Type"::Invoice, VendEntries."Document Type"::"Credit Memo");
                VendEntries.SETRANGE("Vendor No.", "No.");
                VendEntries.SETRANGE("Posting Date", GETRANGEMIN("Date Filter"), GETRANGEMAX("Date Filter"));
                //TecnoRet
                CLEAR(ImptRet);
                ImptRet := CalculaRetencionProv("No.", GETRANGEMIN("Date Filter"), GETRANGEMAX("Date Filter"));
                ImprRetLiq := CalculaImpRetLiq("No.", GETRANGEMIN("Date Filter"), GETRANGEMAX("Date Filter"));
                //FIN TecnoRet
                IF VendEntries.FIND('-') THEN
                    REPEAT
                        GLEntries.SETCURRENTKEY("Document No.", "Posting Date");
                        GLEntries.SETRANGE("Document No.", VendEntries."Document No.");
                        GLEntries.SETRANGE("Posting Date", VendEntries."Posting Date");
                        GLEntries.SETRANGE("Gen. Posting Type", GLEntries."Gen. Posting Type"::Purchase);
                        IF GLEntries.FIND('-') THEN
                            REPEAT
                                Account.GET(GLEntries."G/L Account No.");
                                IF Account."Ignore in 347 Report" THEN PurchaseAmt := PurchaseAmt - (GLEntries.Amount + GLEntries."VAT Amount");
                            UNTIL GLEntries.NEXT = 0;
                    UNTIL VendEntries.NEXT = 0;
                //TecnoRet
                PurchaseAmt := PurchaseAmt + ImptRet - ImprRetLiq;
                //FIN TecnoRet
                AcumPurchasesAmount := AcumPurchasesAmount + PurchaseAmt;
                FormatAddress.FormatAddr(VendAddr, Name, "Name 2", '', Address, "Address 2", City, "Post Code", County, "Country/Region Code");
                IF GUIALLOWED THEN BEGIN
                    IF (GroupNo = 0) AND (Counter = 0) THEN Counter := Counter + 1;
                    IF Counter = BlocksPerPage THEN BEGIN
                        GroupNo := GroupNo + 1;
                        Counter := 0;
                    END;
                    Counter := Counter + 1;
                END;
            END;
        }
    }
    requestpage
    {
        layout
        {
            area(Content)
            {
                group(Opciones)
                {
                    //CaptionML = ENU = 'Options', ESP = 'Opciones';
                    Caption = 'Options';

                    field(MinAmount; MinAmount)
                    {
                        ApplicationArea = All;
                        //Caption = 'Amounts greater than', ESP = 'Importe mayor que';
                        Caption = 'Amounts greater than';
                    }
                }
            }
        }
    }
    trigger OnPreReport()
    begin
        VendFilter := Vendor.GETFILTERS;
    end;

    var
        Text1100000: Label 'Importe mayor que ';
        VendEntries: Record 25;
        GLEntries: Record 17;
        Account: Record 15;
        FormatAddress: Codeunit 365;
        VendFilter: Text[250];
        VendAddr: ARRAY[8] OF Text[50];
        PurchaseAmt: Decimal;
        MinAmount: Decimal;
        AcumPurchasesAmount: Decimal;
        GroupNo: Integer;
        Counter: Integer;
        BlocksPerPage: Integer;
        "--TecnoRet": Integer;
        ImptRet: Decimal;
        ImprRetLiq: Decimal;
        Vendors___Annual_DeclarationCaptionLbl: Label 'Proveedores - Declaración anual';
        CurrReport_PAGENOCaptionLbl: Label 'Pag.';
        Name_and_AddressCaptionLbl: Label 'Nombre y dirección';
        PurchaseAmtCaptionLbl: Label 'Importe (DL)';

    procedure CalculaRetencionProv(Pvendor: Code[20]; desdeFecha: Date; hastaFecha: Date): Decimal
    var
        SumaRet: Decimal;
        reRetencion: Record "IND Witholding Tax registers";
    begin
        CLEAR(SumaRet);
        reRetencion.RESET;
        reRetencion.SETCURRENTKEY("Cli/Prov", "Nº Proveedor / Nº Cliente", "Tipo percepción", "Fecha registro");
        reRetencion.SETRANGE("Cli/Prov", reRetencion."Cli/Prov"::Proveedor);
        reRetencion.SETRANGE("Nº Proveedor / Nº Cliente", Pvendor);
        reRetencion.SETRANGE("Fecha registro", desdeFecha, hastaFecha);
        reRetencion.SETFILTER("Base retención", '<>%1', 0);
        reRetencion.SETRANGE("Liquidado por Movimiento", '');
        IF reRetencion.FIND('-') THEN
            REPEAT
                IF reRetencion."Tipo Documento" = reRetencion."Tipo Documento"::Invoice THEN
                    SumaRet += ABS(reRetencion."Importe retención (DL)")
                ELSE
                    SumaRet -= ABS(reRetencion."Importe retención (DL)") UNTIL reRetencion.NEXT = 0;
        EXIT(SumaRet);
    end;

    PROCEDURE CalculaImpRetLiq(pProveedor: Code[20]; desdeFecha: Date; hastaFecha: Date) RestaRet: Decimal;
    VAR
        reLinHtoFacCp: Record 123;
    BEGIN
        CLEAR(RestaRet);
        reLinHtoFacCp.RESET;
        reLinHtoFacCp.SETRANGE("Buy-from Vendor No.", pProveedor);
        reLinHtoFacCp.SETRANGE("Posting Date", desdeFecha, hastaFecha);
        reLinHtoFacCp.SETRANGE("Lín. retención", TRUE);
        reLinHtoFacCp.SETFILTER("Mov. retención", '<>%1', 0);
        IF reLinHtoFacCp.FIND('-') THEN
            REPEAT
                RestaRet += ABS(reLinHtoFacCp."Line Amount");
            UNTIL reLinHtoFacCp.NEXT = 0;
    END;
}

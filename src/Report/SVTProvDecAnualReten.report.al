namespace Excelia.IRPF;
using Microsoft.Purchases.Vendor;
report 86305 "SVT Prov - Dec. Anual_Reten"
{
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
                if GUIALLOWED then begin
                    BlocksPerPage := 6;
                    Counter := 0;
                    GroupNo := 0;
                end;
                //TecnoRet
                ImptRet := 0;
                //FIN TecnoRet
            end;

            trigger OnAfterGetRecord()
            begin
                PurchaseAmt := "Inv. Amounts (LCY)" - "Cr. Memo Amounts (LCY)";
                if PurchaseAmt <= MinAmount then CurrReport.SKIP();
                VendEntries.Setcurrentkey("Document Type", "Vendor No.", "Posting Date", "Currency Code");
                VendEntries.Setrange("Document Type", VendEntries."Document Type"::Invoice, VendEntries."Document Type"::"Credit Memo");
                VendEntries.Setrange("Vendor No.", "No.");
                VendEntries.Setrange("Posting Date", GETRANGEMIN("Date Filter"), GETRANGEMAX("Date Filter"));
                //TecnoRet
                clear(ImptRet);
                ImptRet := CalculaRetencionProv("No.", GETRANGEMIN("Date Filter"), GETRANGEMAX("Date Filter"));
                ImprRetLiq := CalculaImpRetLiq("No.", GETRANGEMIN("Date Filter"), GETRANGEMAX("Date Filter"));
                //FIN TecnoRet
                if VendEntries.Find('-') then
                    repeat
                        GLEntries.Setcurrentkey("Document No.", "Posting Date");
                        GLEntries.Setrange("Document No.", VendEntries."Document No.");
                        GLEntries.Setrange("Posting Date", VendEntries."Posting Date");
                        GLEntries.Setrange("Gen. Posting Type", GLEntries."Gen. Posting Type"::Purchase);
                        if GLEntries.Find('-') then
                            repeat
                                Account.Get(GLEntries."G/L Account No.");
                                if Account."Ignore in 347 Report" then PurchaseAmt := PurchaseAmt - (GLEntries.Amount + GLEntries."VAT Amount");
                            until GLEntries.Next() = 0;
                    until VendEntries.Next() = 0;

                PurchaseAmt := PurchaseAmt + ImptRet - ImprRetLiq;

                AcumPurchasesAmount := AcumPurchasesAmount + PurchaseAmt;
                FormatAddress.FormatAddr(VendAddr, Name, "Name 2", '', Address, "Address 2", City, "Post Code", County, "Country/Region Code");
                if GUIALLOWED then begin
                    if (GroupNo = 0) AND (Counter = 0) then Counter := Counter + 1;
                    if Counter = BlocksPerPage then begin
                        GroupNo := GroupNo + 1;
                        Counter := 0;
                    end;
                    Counter := Counter + 1;
                end;
            end;
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
        VendFilter := Vendor.GETFILTERS();
    end;

    var

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
        ImptRet: Decimal;
        ImprRetLiq: Decimal;
        Vendors___Annual_DeclarationCaptionLbl: Label 'Proveedores - Declaración anual';
        CurrReport_PAGENOCaptionLbl: Label 'Pag.';
        Name_and_AddressCaptionLbl: Label 'Nombre y dirección';
        PurchaseAmtCaptionLbl: Label 'Importe (DL)';
        Text1100000: Label 'Importe mayor que ';

    procedure CalculaRetencionProv(Pvendor: Code[20]; desdeFecha: Date; hastaFecha: Date): Decimal
    var
        reRetencion: Record "EXC Retention Tax registers";
        SumaRet: Decimal;

    begin
        clear(SumaRet);
        reRetencion.Reset();
        reRetencion.Setcurrentkey("Cust/Vend", "Nº Proveedor / Nº Cliente", "Tipo percepción", "Fecha registro");
        reRetencion.Setrange("Cust/Vend", reRetencion."Cust/Vend"::Vendor);
        reRetencion.Setrange("Nº Proveedor / Nº Cliente", Pvendor);
        reRetencion.Setrange("Fecha registro", desdeFecha, hastaFecha);
        reRetencion.SETFILTER("Base retención", '<>%1', 0);
        reRetencion.Setrange("Liquidado por Movimiento", '');
        if reRetencion.Find('-') then
            repeat
                if reRetencion."Tipo Documento" = reRetencion."Tipo Documento"::Invoice then
                    SumaRet += ABS(reRetencion."Importe retención (DL)")
                else
                    SumaRet -= ABS(reRetencion."Importe retención (DL)") until reRetencion.Next() = 0;
        exit(SumaRet);
    end;

    procedure CalculaImpRetLiq(pProveedor: Code[20]; desdeFecha: Date; hastaFecha: Date) RestaRet: Decimal;
    VAR
        reLinHtoFacCp: Record 123;
    begin
        clear(RestaRet);
        reLinHtoFacCp.Reset();
        reLinHtoFacCp.Setrange("Buy-from Vendor No.", pProveedor);
        reLinHtoFacCp.Setrange("Posting Date", desdeFecha, hastaFecha);
        reLinHtoFacCp.Setrange("Retention Line", true);
        reLinHtoFacCp.SETFILTER("Retention Entry", '<>%1', 0);
        if reLinHtoFacCp.Find('-') then
            repeat
                RestaRet += ABS(reLinHtoFacCp."Line Amount");
            until reLinHtoFacCp.Next() = 0;
    end;
}

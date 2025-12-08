namespace ScriptumVita.IRPF;
report 86301 "IND Client- Dec. Anual_Reten"
{
    // version INDRA
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    Caption = 'Cliente - Dec. Anual_Retenciones';
    RDLCLayout = './Reports/Layout/INDRA Client - Dec. Anual.Reten.rdl';

    dataset
    {
        dataitem(Customer; Customer)
        {
            RequestFilterFields = "No.", "Customer Posting Group", "Date Filter";
            CalcFields = "Inv. Amounts (LCY)", "Cr. Memo Amounts (LCY)";

            column(FORMAT_TODAY_04_; FORMAT(TODAY, 0, 4))
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
            column(Customer_TABLECAPTION__________CustFilter; Customer.TABLECAPTION + ': ' + CustFilter)
            {
            }
            column(CustFilter; CustFilter)
            {
            }
            column(Text1100000___FORMAT_MinAmount_; Text1100000 + FORMAT(MinAmount))
            {
            }
            column(GroupNo; GroupNo)
            {
            }
            column(Customer__No__; "No.")
            {
            }
            column(CustAddr_1_; CustAddr[1])
            {
            }
            column(CustAddr_2_; CustAddr[2])
            {
            }
            column(CustAddr_3_; CustAddr[3])
            {
            }
            column(CustAddr_4_; CustAddr[4])
            {
            }
            column(CustAddr_5_; CustAddr[5])
            {
            }
            column(CustAddr_6_; CustAddr[6])
            {
            }
            column(CustAddr_7_; CustAddr[7])
            {
            }
            column(Customer__VAT_Registration_No__; "VAT Registration No.")
            {
            }
            column(SalesAmt; SalesAmt)
            {
                DecimalPlaces = 0 : 2;
            }
            column(CustAddr_8_; CustAddr[8])
            {
            }
            column(AcumSalesAmount; AcumSalesAmount)
            {
                DecimalPlaces = 0 : 2;
            }
            column(Customers___Annual_DeclarationCaption; Customers___Annual_DeclarationCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Customer__No__Caption; FIELDCAPTION("No."))
            {
            }
            column(Customer__VAT_Registration_No__Caption; FIELDCAPTION("VAT Registration No."))
            {
            }
            column(Name_and_AddressCaption; Name_and_AddressCaptionLbl)
            {
            }
            column(SalesAmtCaption; SalesAmtCaptionLbl)
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
                SalesAmt := "Inv. Amounts (LCY)" - "Cr. Memo Amounts (LCY)";
                IF SalesAmt <= MinAmount THEN CurrReport.SKIP;
                CustEntries.SETCURRENTKEY("Document Type", "Customer No.", "Posting Date", "Currency Code");
                CustEntries.SETRANGE("Document Type", CustEntries."Document Type"::Invoice, CustEntries."Document Type"::"Credit Memo");
                CustEntries.SETRANGE("Customer No.", "No.");
                CustEntries.SETRANGE("Posting Date", GETRANGEMIN("Date Filter"), GETRANGEMAX("Date Filter"));
                //TecnoRet
                ImptRet := CalculaRetencionCli("No.", GETRANGEMIN("Date Filter"), GETRANGEMAX("Date Filter"));
                ImprRetLiq := CalculaImpRetLiq("No.", GETRANGEMIN("Date Filter"), GETRANGEMAX("Date Filter"));
                //FIN TecnoRet
                IF CustEntries.FIND('-') THEN
                    REPEAT
                        GLEntries.SETCURRENTKEY("Document No.", "Posting Date");
                        GLEntries.SETRANGE("Document No.", CustEntries."Document No.");
                        GLEntries.SETRANGE("Posting Date", CustEntries."Posting Date");
                        GLEntries.SETRANGE("Gen. Posting Type", GLEntries."Gen. Posting Type"::Sale);
                        IF GLEntries.FIND('-') THEN
                            REPEAT
                                Account.GET(GLEntries."G/L Account No.");
                                IF Account."Ignore in 347 Report" THEN SalesAmt := SalesAmt + (GLEntries.Amount + GLEntries."VAT Amount");
                            UNTIL GLEntries.NEXT = 0;
                    UNTIL CustEntries.NEXT = 0;
                //TecnoRet
                SalesAmt := SalesAmt + ImptRet - ImprRetLiq;
                //FIN TecnoRet
                AcumSalesAmount := AcumSalesAmount + SalesAmt;
                FormatAddress.FormatAddr(CustAddr, Name, "Name 2", '', Address, "Address 2", City, "Post Code", County, "Country/Region Code");
                IF GUIALLOWED THEN BEGIN
                    IF (GroupNo = 0) AND (Counter = 0) THEN Counter := Counter + 1;
                    IF Counter = BlocksPerPage THEN BEGIN
                        GroupNo := GroupNo + 1;
                        Counter := 0;
                    END;
                    Counter := Counter + 1;
                END;
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
                        //CaptionML = ENU = 'Amounts greater than', ESP = 'Importe mayor que';
                        Caption = 'Amounts greater than';
                    }
                }
            }
        }
        actions
        {
            area(processing)
            {
                action(ActionName)
                {
                    ApplicationArea = All;
                }
            }
        }
    }
    trigger OnPreReport()
    begin
        CustFilter := Customer.GETFILTERS;
    end;

    var
        Text1100000: Label 'Importe mayor que ';
        CustEntries: Record "Cust. Ledger Entry";
        GLEntries: Record 17;
        Account: Record 15;
        FormatAddress: Codeunit 365;
        CustFilter: Text[250];
        CustAddr: ARRAY[8] OF Text[50];
        SalesAmt: Decimal;
        MinAmount: Decimal;
        AcumSalesAmount: Decimal;
        GroupNo: Integer;
        Counter: Integer;
        BlocksPerPage: Integer;
        "--TecnoRet": Integer;
        ImptRet: Decimal;
        ImprRetLiq: Decimal;
        Customers___Annual_DeclarationCaptionLbl: Label 'Clientes - Declaración anual';
        CurrReport_PAGENOCaptionLbl: Label 'Pag.';
        Name_and_AddressCaptionLbl: Label 'Nombre y dirección';
        SalesAmtCaptionLbl: Label 'Importe (DL)';

    PROCEDURE CalculaRetencionCli(pCliente: Code[20]; desdeFecha: Date; hastaFecha: Date): Decimal;
    VAR
        SumaRet: Decimal;
        reRetencion: Record "IND Witholding Tax registers";
    BEGIN
        CLEAR(SumaRet);
        reRetencion.RESET;
        reRetencion.SETCURRENTKEY("Cli/Prov", "Nº Proveedor / Nº Cliente", "Tipo percepción", "Fecha registro");
        reRetencion.SETRANGE("Cli/Prov", reRetencion."Cli/Prov"::Cliente);
        reRetencion.SETRANGE("Nº Proveedor / Nº Cliente", pCliente);
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
    END;

    PROCEDURE CalculaImpRetLiq(pCliente: Code[20]; desdeFecha: Date; hastaFecha: Date) RestaRet: Decimal;
    VAR
        reLinHtoFacVt: Record 113;
    BEGIN
        CLEAR(RestaRet);
        reLinHtoFacVt.RESET;
        reLinHtoFacVt.SETRANGE("Sell-to Customer No.", pCliente);
        reLinHtoFacVt.SETRANGE("Posting Date", desdeFecha, hastaFecha);
        reLinHtoFacVt.SETRANGE("Lín. retención", TRUE);
        reLinHtoFacVt.SETFILTER("Mov. retención", '<>%1', 0);
        IF reLinHtoFacVt.FIND('-') THEN
            REPEAT
                RestaRet += ABS(reLinHtoFacVt."Line Amount");
            UNTIL reLinHtoFacVt.NEXT = 0;
    END;
}

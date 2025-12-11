namespace Excelia.IRPF;
using Microsoft.Sales.Receivables;
using Microsoft.Sales.Customer;
report 86301 "EXC Client- Dec. Anual_Reten"
{

    //     UsageCategory = ReportsAndAnalysis;
    //     ApplicationArea = All;
    //     Caption = 'Cliente - Dec. Anual_Retenciones';
    //     RDLCLayout = './Reports/Layout/INDRA Client - Dec. Anual.Reten.rdl';

    //     dataset
    //     {
    //         dataitem(Customer; Customer)
    //         {
    //             RequestFilterFields = "No.", "Customer Posting Group", "Date Filter";
    //             CalcFields = "Inv. Amounts (LCY)", "Cr. Memo Amounts (LCY)";

    //             column(FORMAT_TODAY_04_; FORMAT(TODAY, 0, 4))
    //             {
    //             }
    //             column(COMPANYNAME; COMPANYNAME)
    //             {
    //             }
    //             column(CurrReport_PAGENO; 1)
    //             {
    //             }
    //             column(USERID; USERID)
    //             {
    //             }
    //             column(Customer_TABLECAPTION__________CustFilter; Customer.TABLECAPTION + ': ' + CustFilter)
    //             {
    //             }
    //             column(CustFilter; CustFilter)
    //             {
    //             }
    //             column(Text1100000___FORMAT_MinAmount_; Text1100000 + FORMAT(MinAmount))
    //             {
    //             }
    //             column(GroupNo; GroupNo)
    //             {
    //             }
    //             column(Customer__No__; "No.")
    //             {
    //             }
    //             column(CustAddr_1_; CustAddr[1])
    //             {
    //             }
    //             column(CustAddr_2_; CustAddr[2])
    //             {
    //             }
    //             column(CustAddr_3_; CustAddr[3])
    //             {
    //             }
    //             column(CustAddr_4_; CustAddr[4])
    //             {
    //             }
    //             column(CustAddr_5_; CustAddr[5])
    //             {
    //             }
    //             column(CustAddr_6_; CustAddr[6])
    //             {
    //             }
    //             column(CustAddr_7_; CustAddr[7])
    //             {
    //             }
    //             column(Customer__VAT_Registration_No__; "VAT Registration No.")
    //             {
    //             }
    //             column(SalesAmt; SalesAmt)
    //             {
    //                 DecimalPlaces = 0 : 2;
    //             }
    //             column(CustAddr_8_; CustAddr[8])
    //             {
    //             }
    //             column(AcumSalesAmount; AcumSalesAmount)
    //             {
    //                 DecimalPlaces = 0 : 2;
    //             }
    //             column(Customers___Annual_DeclarationCaption; Customers___Annual_DeclarationCaptionLbl)
    //             {
    //             }
    //             column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
    //             {
    //             }
    //             column(Customer__No__Caption; FIELDCAPTION("No."))
    //             {
    //             }
    //             column(Customer__VAT_Registration_No__Caption; FIELDCAPTION("VAT Registration No."))
    //             {
    //             }
    //             column(Name_and_AddressCaption; Name_and_AddressCaptionLbl)
    //             {
    //             }
    //             column(SalesAmtCaption; SalesAmtCaptionLbl)
    //             {
    //             }
    //             trigger OnPreDataItem()
    //             begin
    //                 if GUIALLOWED then begin
    //                     BlocksPerPage := 6;
    //                     Counter := 0;
    //                     GroupNo := 0;
    //                 end;
    //                 ImptRet := 0;
    //             end;

    //             trigger OnAfterGetRecord()
    //             begin
    //                 SalesAmt := "Inv. Amounts (LCY)" - "Cr. Memo Amounts (LCY)";
    //                 if SalesAmt <= MinAmount then CurrReport.SKIP();
    //                 CustEntries.Setcurrentkey("Document Type", "Customer No.", "Posting Date", "Currency Code");
    //                 CustEntries.Setrange("Document Type", CustEntries."Document Type"::Invoice, CustEntries."Document Type"::"Credit Memo");
    //                 CustEntries.Setrange("Customer No.", "No.");
    //                 CustEntries.Setrange("Posting Date", GETRANGEMIN("Date Filter"), GETRANGEMAX("Date Filter"));

    //                 ImptRet := CalculaRetencionCli("No.", GETRANGEMIN("Date Filter"), GETRANGEMAX("Date Filter"));
    //                 ImprRetLiq := CalculaImpRetLiq("No.", GETRANGEMIN("Date Filter"), GETRANGEMAX("Date Filter"));

    //                 if CustEntries.Find('-') then
    //                     repeat
    //                         GLEntries.Setcurrentkey("Document No.", "Posting Date");
    //                         GLEntries.Setrange("Document No.", CustEntries."Document No.");
    //                         GLEntries.Setrange("Posting Date", CustEntries."Posting Date");
    //                         GLEntries.Setrange("Gen. Posting Type", GLEntries."Gen. Posting Type"::Sale);
    //                         if GLEntries.Find('-') then
    //                             repeat
    //                                 Account.Get(GLEntries."G/L Account No.");
    //                                 if Account."Ignore in 347 Report" then SalesAmt := SalesAmt + (GLEntries.Amount + GLEntries."VAT Amount");
    //                             until GLEntries.Next() = 0;
    //                     until CustEntries.Next() = 0;

    //                 SalesAmt := SalesAmt + ImptRet - ImprRetLiq;

    //                 AcumSalesAmount := AcumSalesAmount + SalesAmt;
    //                 FormatAddress.FormatAddr(CustAddr, Name, "Name 2", '', Address, "Address 2", City, "Post Code", County, "Country/Region Code");
    //                 if GUIALLOWED then begin
    //                     if (GroupNo = 0) AND (Counter = 0) then Counter := Counter + 1;
    //                     if Counter = BlocksPerPage then begin
    //                         GroupNo := GroupNo + 1;
    //                         Counter := 0;
    //                     end;
    //                     Counter := Counter + 1;
    //                 end;
    //             end;
    //         }
    //     }
    //     requestpage
    //     {
    //         layout
    //         {
    //             area(Content)
    //             {
    //                 group(Opciones)
    //                 {
    //                     Caption = 'Options';

    //                     field(MinAmount; MinAmount)
    //                     {
    //                         ApplicationArea = All;
    //                         Caption = 'Amounts greater than';
    //                     }
    //                 }
    //             }
    //         }
    //         actions
    //         {
    //             area(processing)
    //             {
    //                 action(ActionName)
    //                 {
    //                     ApplicationArea = All;
    //                 }
    //             }
    //         }
    //     }
    //     trigger OnPreReport()
    //     begin
    //         CustFilter := Customer.GETFILTERS();
    //     end;

    //     var

    //         CustEntries: Record "Cust. Ledger Entry";
    //         GLEntries: Record 17;
    //         Account: Record 15;
    //         FormatAddress: Codeunit 365;
    //         CustFilter: Text[250];
    //         CustAddr: ARRAY[8] OF Text[50];
    //         SalesAmt: Decimal;
    //         MinAmount: Decimal;
    //         AcumSalesAmount: Decimal;
    //         GroupNo: Integer;
    //         Counter: Integer;
    //         BlocksPerPage: Integer;
    //         ImptRet: Decimal;
    //         ImprRetLiq: Decimal;
    //         Customers___Annual_DeclarationCaptionLbl: Label 'Clientes - Declaración anual';
    //         CurrReport_PAGENOCaptionLbl: Label 'Pag.';
    //         Name_and_AddressCaptionLbl: Label 'Nombre y dirección';
    //         SalesAmtCaptionLbl: Label 'Importe (DL)';
    //         Text1100000: Label 'Importe mayor que ';

    //     procedure CalculaRetencionCli(pCliente: Code[20]; desdeFecha: Date; hastaFecha: Date): Decimal;
    //     VAR

    //         reRetencion: Record "EXC Retention Tax registers";
    //         SumaRet: Decimal;
    //     begin
    //         clear(SumaRet);
    //         reRetencion.Reset();
    //         reRetencion.Setcurrentkey("Cust/Vend", "Nº Proveedor / Nº Cliente", "Tipo percepción", "Fecha registro");
    //         reRetencion.Setrange("Cust/Vend", reRetencion."Cust/Vend"::Customer);
    //         reRetencion.Setrange("Nº Proveedor / Nº Cliente", pCliente);
    //         reRetencion.Setrange("Fecha registro", desdeFecha, hastaFecha);
    //         reRetencion.SETFILTER("Base retención", '<>%1', 0);
    //         //reRetencion.Setrange("Liquidado por Movimiento", '');
    //         if reRetencion.Find('-') then
    //             repeat
    //                 if reRetencion."Tipo Documento" = reRetencion."Tipo Documento"::Invoice then
    //                     SumaRet += ABS(reRetencion."Importe retención (DL)")
    //                 else
    //                     SumaRet -= ABS(reRetencion."Importe retención (DL)") until reRetencion.Next() = 0;
    //         exit(SumaRet);
    //     end;

    //     procedure CalculaImpRetLiq(pCliente: Code[20]; desdeFecha: Date; hastaFecha: Date) RestaRet: Decimal;
    //     VAR
    //         reLinHtoFacVt: Record 113;
    //     begin
    //         clear(RestaRet);
    //         reLinHtoFacVt.Reset();
    //         reLinHtoFacVt.Setrange("Sell-to Customer No.", pCliente);
    //         reLinHtoFacVt.Setrange("Posting Date", desdeFecha, hastaFecha);
    //         reLinHtoFacVt.Setrange("Deduction Line", true);
    //         reLinHtoFacVt.SETFILTER("Deduction Entry", '<>%1', 0);
    //         if reLinHtoFacVt.Find('-') then
    //             repeat
    //                 RestaRet += ABS(reLinHtoFacVt."Line Amount");
    //             until reLinHtoFacVt.Next() = 0;
    //     end;
}

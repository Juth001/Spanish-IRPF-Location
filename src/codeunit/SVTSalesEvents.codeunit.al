// namespace Excelia.IRPF;
// using Microsoft.Sales.Document;
// using Microsoft.Sales.History;
// using Microsoft.Sales.Posting;
// using Microsoft.Finance.GeneralLedger.Account;
// using Microsoft.Foundation.Company;
// using Microsoft.Sales.Customer;
// using Microsoft.Finance.GeneralLedger.Posting;
// using Microsoft.Projects.Resources.Resource;
// using Microsoft.Purchases.Vendor;
// using Microsoft.Foundation.Address;
// using Microsoft.Projects.Resources.Setup;
// using Microsoft.Finance.GeneralLedger.Ledger;
// using Microsoft.Finance.GeneralLedger.Journal;
// using Microsoft.Purchases.History;
// using Microsoft.Finance.GeneralLedger.Setup;
// using Microsoft.Finance.Currency;
// using Microsoft.Foundation.AuditCodes;
// codeunit 86304 "SVT Sales Events"
// {
//     [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnAfterPostSalesLines', '', true, true)]
//     local procedure CreateDeductionLines(var SalesHeader: Record "Sales Header"; var SalesShipmentHeader: Record "Sales Shipment Header"; var SalesInvoiceHeader: Record "Sales Invoice Header"; var SalesCrMemoHeader: Record "Sales Cr.Memo Header"; var ReturnReceiptHeader: Record "Return Receipt Header"; WhseShip: Boolean; WhseReceive: Boolean; var SalesLinesProcessed: Boolean; CommitIsSuppressed: Boolean; EverythingInvoiced: Boolean)
//     var
//         SalesLine: record "Sales Line";
//     begin
//         SalesLine.Reset();
//         SalesLine.Setrange("Document Type", SalesHeader."Document Type");
//         SalesLine.Setrange("Document No.", SalesHeader."No.");
//         SalesLine.SetRange("Deduction Line", true);

//         if SalesLine.FindSet() then
//             repeat
//                 PostWithholdingEntries(SalesLine, SalesInvoiceHeader."No.");
//             until SalesLine.Next() = 0;

//         if SalesHeader.Invoice then begin
//             SalesLine.Reset();
//             SalesLine.Setrange("Document Type", SalesHeader."Document Type");
//             SalesLine.Setrange("Document No.", SalesHeader."No.");
//             SalesLine.SetFilter("Deduction Entry", '<>%1', 0);

//             if SalesLine.FindFirst() then
//                 "CreateWithholdingSettlement"(SalesHeader, SalesInvoiceHeader."No.");
//         end;
//     end;

//     procedure PostWithholdingEntries(xSalesLine: record "Sales Line"; SalesInvHdrNo: code[20])
//     var
//         GLAccount: record "G/L Account";
//         SalesHeader: record "Sales Header";
//         SourceCodeSetup: record "Source Code Setup";
//         SalesInvHeader: record "Sales Invoice Header";
//         GenJnlLineDocType: integer;
//         GenJnlLineDocNo: code[20];
//         SrcCode: code[10];
//         TotalAmountInclVAT: decimal;
//         TotalAmountExclVAT: decimal;
//     begin

//         if not GLAccount.Get(xSalesLine."No.") then
//             exit;

//         GenJnlLineDocNo := SalesInvHdrNo;

//         if (xSalesLine."Deduction Entry" = 0) then begin

//             SourceCodeSetup.Get();
//             SrcCode := SourceCodeSetup.Sales;
//             SalesHeader.Get(xSalesLine."Document Type", xSalesline."Document No.");

//             case SalesHeader."Document Type" of
//                 "Sales Document Type"::Invoice:
//                     GenJnlLineDocType := SalesHeader."Document Type"::Invoice.AsInteger();

//                 "Sales Document Type"::"Credit Memo":
//                     GenJnlLineDocType := SalesHeader."Document Type"::"Credit Memo".AsInteger();
//                 else
//                     exit;
//             end;

//             SalesHeader.CALCFIELDS(Amount, "Amount Including VAT");

//             if SalesInvHeader.Get(SalesInvHdrNo) then begin
//                 SalesInvHeader.CALCFIELDS("Amount Including VAT", Amount);
//                 TotalAmountInclVAT := SalesInvHeader."Amount Including VAT";
//                 TotalAmountExclVAT := SalesInvHeader.Amount;
//             end else begin
//                 TotalAmountInclVAT := SalesHeader."Amount Including VAT";
//                 TotalAmountExclVAT := SalesHeader.Amount;
//             end;

//             if (GLAccount."Retention Account Type" = GLAccount."Retention Account Type"::Vendor) AND (xSalesLine."Deduction Entry" = 0) then
//                 CreateIRPFSalesDeduction(GenJnlLineDocType, GenJnlLineDocNo, xSalesLine.Amount, SrcCode, xSalesLine."Perception Type", xSalesLine."Perception Key", xSalesLine."Qty. to Invoice", xSalesLine."Job No.", SalesHeader."Posting Description", SalesHeader."Document Date", SalesHeader."Posting Date", SalesHeader.Amount, SalesHeader."Sell-to Post Code", SalesHeader."Currency Code", -(xSalesLine."Unit Price" * 100), SalesHeader."Sell-to Customer No.", SalesHeader."VAT Registration No.", SalesHeader."Amount Including VAT");

//             if (GLAccount."Retention Account Type" = GLAccount."Retention Account Type"::Customer) AND (xSalesLine."Deduction Entry" = 0) then
//                 CrearRetencionIRPFVt(GenJnlLineDocType, GenJnlLineDocNo, xSalesLine.Amount, SrcCode, xSalesLine."Perception Type", xSalesLine."Perception Key", xSalesLine."Qty. to Invoice", xSalesLine."Job No.", SalesHeader."Posting Description", SalesHeader."Document Date", SalesHeader."Posting Date", TotalAmountInclVAT, SalesHeader."Sell-to Post Code", SalesHeader."Currency Code", -(xSalesLine."Unit Price" * 100), SalesHeader."Sell-to Customer No.", SalesHeader."VAT Registration No.", TotalAmountExclVAT);
//         end;

//         if (xSalesLine."Deduction Entry" <> 0) then
//             LiqRetencion(GenJnlLineDocNo, xSalesLine."Deduction Entry", xSalesLine.Amount);
//     end;

//     procedure "CreateWithholdingSettlement"(pReCbVenta: Record "Sales Header"; NumDoc: Code[20])
//     var
//         SalesLine: record "Sales Line";
//         CurrExchRate: Record "Currency Exchange Rate";
//         OriginalDeductionEntry: record "EXC Retention Tax registers";
//         LiquidationEntry: record "EXC Retention Tax registers";
//         NextEntryNo: integer;
//         AmountToApplyFCY: Decimal;

//     begin
//         SalesLine.Reset();
//         SalesLine.Setrange("Document Type", pReCbVenta."Document Type");
//         SalesLine.Setrange("Document No.", pReCbVenta."No.");
//         SalesLine.SetFilter("Deduction Entry", '<>%1', 0);

//         if SalesLine.FindSet() then
//             repeat
//                 if OriginalDeductionEntry.Get(SalesLine."Deduction Entry") then begin
//                     AmountToApplyFCY := ABS(SalesLine."Line Amount");

//                     if OriginalDeductionEntry."Importe Pendiente" < 0 then
//                         OriginalDeductionEntry."Importe Pendiente" += AmountToApplyFCY
//                     else
//                         OriginalDeductionEntry."Importe Pendiente" -= AmountToApplyFCY;

//                     if OriginalDeductionEntry."Importe Pendiente" = 0 then begin
//                         OriginalDeductionEntry.Pendiente := false;
//                         OriginalDeductionEntry."Importe Pendiente (DL)" := 0;

//                     end else
//                         OriginalDeductionEntry."Importe Pendiente (DL)" := CurrExchRate.ExchangeAmtFCYToLCY(WorkDate(), OriginalDeductionEntry."Cód. divisa", OriginalDeductionEntry."Importe Pendiente", CurrExchRate.ExchangeRate(WorkDate, OriginalDeductionEntry."Cód. divisa"));

//                     OriginalDeductionEntry."Importe a Liquidar" := OriginalDeductionEntry."Importe Pendiente";
//                     OriginalDeductionEntry."Importe a Liquidar (DL)" := OriginalDeductionEntry."Importe Pendiente (DL)";

//                     OriginalDeductionEntry."Shortcut Dimension 1 Code" := SalesLine."Shortcut Dimension 1 Code";
//                     OriginalDeductionEntry."Shortcut Dimension 2 Code" := SalesLine."Shortcut Dimension 2 Code";
//                     OriginalDeductionEntry.Modify();

//                     LiquidationEntry.Reset();
//                     LiquidationEntry.Copy(OriginalDeductionEntry);

//                     LiquidationEntry."Entry No." := NextEntryNo; // Usar el número generado de forma segura
//                     LiquidationEntry.Description := 'Liq. Retención ' + OriginalDeductionEntry."Nº documento";
//                     //TODO:LiquidationEntry."Nº documento" := RegisteredDocNo;
//                     LiquidationEntry."Fecha registro" := WorkDate();

//                     LiquidationEntry."Importe factura iva incl." := 0;
//                     LiquidationEntry."Importe Factura (DL)" := 0;
//                     // ... (otros campos a cero)
//                     LiquidationEntry."Importe retención" := -AmountToApplyFCY; // Usar el negativo del monto aplicado

//                     // Recalcular el monto en DL para el movimiento de liquidación
//                     LiquidationEntry."Importe retención (DL)" := CurrExchRate.ExchangeAmtFCYToLCY(
//                         WorkDate(),
//                         LiquidationEntry."Cód. divisa",
//                         LiquidationEntry."Importe retención",
//                         CurrExchRate.ExchangeRate(WorkDate(), LiquidationEntry."Cód. divisa"));

//                     // Estado y Referencia
//                     LiquidationEntry."Importe Pendiente" := 0;
//                     LiquidationEntry.Pendiente := false;
//                     LiquidationEntry."Liquidado por Movimiento" := Format(SalesLine."Deduction Entry");

//                     LiquidationEntry.Insert(true);
//                 end;
//             until SalesLine.Next() = 0;
//     end;



//                 //TODO: NextEntryNo := OriginalDeductionEntry."Nº mov." + 1;

//                 //TODO: LiquidationEntry.Reset();
//                 if LiquidationEntry.Get(SalesLine."Deduction Entry") then begin
//                     if LiquidationEntry."Importe Pendiente" < 0 then
//                         LiquidationEntry."Importe Pendiente" := LiquidationEntry."Importe Pendiente" + ABS(SalesLine."Line Amount")
//                     else
//                         LiquidationEntry."Importe Pendiente" := LiquidationEntry."Importe Pendiente" - ABS(SalesLine."Line Amount");
//                     if LiquidationEntry."Importe Pendiente" = 0 then begin
//                         LiquidationEntry.Pendiente := false;
//                         LiquidationEntry."Importe Pendiente (DL)" := 0;
//                     end
//                     else
//                         LiquidationEntry."Importe Pendiente (DL)" := CurrExchRate.ExchangeAmtFCYToLCY(WorkDate, LiquidationEntry."Cód. divisa", LiquidationEntry."Importe Pendiente", CurrExchRate.ExchangeRate(WorkDate, LiquidationEntry."Cód. divisa"));

//                     LiquidationEntry."Importe a Liquidar" := LiquidationEntry."Importe Pendiente";
//                     LiquidationEntry."Importe a Liquidar (DL)" := LiquidationEntry."Importe Pendiente (DL)";
//                     LiquidationEntry."Shortcut Dimension 1 Code" := SalesLine."Shortcut Dimension 1 Code";
//                     LiquidationEntry."Shortcut Dimension 2 Code" := SalesLine."Shortcut Dimension 2 Code";
//                     LiquidationEntry.Modify();
//                     MovRetencion4.Reset();
//                     MovRetencion4 := LiquidationEntry;
//                     MovRetencion4."Nº mov." := NextEntryNo;
//                     MovRetencion4.Descripción := 'Liq. Retención ' + LiquidationEntry."Nº documento";
//                     MovRetencion4."Nº documento" := NumDoc;
//                     MovRetencion4."Fecha registro" := WorkDate();
//                     MovRetencion4."Importe factura iva incl." := 0;
//                     MovRetencion4."Importe Factura (DL)" := 0;
//                     MovRetencion4."Base retención" := 0;
//                     MovRetencion4."Base retencion (DL)" := 0;
//                     MovRetencion4."% retención" := 0;
//                     MovRetencion4."Cód. divisa" := LiquidationEntry."Cód. divisa";
//                     MovRetencion4."Importe retención" := -ABS(SalesLine."Line Amount");
//                     MovRetencion4."Importe retención (DL)" := CurrExchRate.ExchangeAmtFCYToLCY(WorkDate(), MovRetencion4."Cód. divisa", MovRetencion4."Importe retención", CurrExchRate.ExchangeRate(WorkDate, MovRetencion4."Cód. divisa"));
//                     MovRetencion4."Importe Pendiente" := 0;
//                     MovRetencion4."Liquidado por Movimiento" := FORMAT(SalesLine."Deduction Entry");
//                     MovRetencion4."Importe a Liquidar" := 0;
//                     MovRetencion4."Importe a Liquidar (DL)" := 0;
//                     MovRetencion4.Pendiente := false;
//                     MovRetencion4."Shortcut Dimension 1 Code" := SalesLine."Shortcut Dimension 1 Code";
//                     MovRetencion4."Shortcut Dimension 2 Code" := SalesLine."Shortcut Dimension 2 Code";
//                     MovRetencion4.Insert();
//                 end;
//             until SalesLine.Next() = 0;
//     end;

//     [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnAfterReleaseSalesDoc', '', false, false)]
//     local procedure CrearLineaRetencionPedido(var SalesHeader: Record "Sales Header")
//     begin
//         if (SalesHeader."Document Type" IN [SalesHeader."Document Type"::Order, SalesHeader."Document Type"::"Return Order"]) AND (SalesHeader."Key Perception" <> '') AND SalesHeader.Invoice then SalesHeader.CreaLinRetencionPedido(SalesHeader);
//     end;

//     [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnAfterFinalizePosting', '', false, false)]
//     local procedure OnAfterFinalizePosting(var SalesShipmentHeader: Record "Sales Shipment Header"; var SalesInvoiceHeader: Record "Sales Invoice Header"; var SalesHeader: Record "Sales Header"; CommitIsSuppressed: Boolean; PreviewMode: Boolean; var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line"; var
//                                                                                                                                                                                                                                                                                                               ReturnReceiptHeader: Record "Return Receipt Header";

//     var
//         SalesCrMemoHeader: Record "Sales Cr.Memo Header")
//     var
//         SalesLine: record "Sales Line";
//     begin
//         if (SalesHeader."Document Type" IN [SalesHeader."Document Type"::Order, SalesHeader."Document Type"::"Return Order"]) AND (SalesHeader."Key Perception" <> '') AND SalesHeader.Invoice then begin
//             clear(SalesLine);
//             SalesLine.Setrange("Document Type", SalesHeader."Document Type");
//             SalesLine.Setrange("Document No.", SalesHeader."No.");
//             SalesLine.Setrange("Deduction Line", true);
//             SalesLine.DeleteAll();
//         end;
//     end;

//     [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnAfterSalesShptLineInsert', '', false, false)]
//     local procedure BorrarLineaInsertadaAlb(var SalesShipmentLine: Record "Sales Shipment Line"; SalesLine: Record "Sales Line")
//     begin
//         if SalesLine."Deduction Line" = true then
//             SalesShipmentLine.Delete(true);
//     end;

//     [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnAfterReturnRcptLineInsert', '', false, false)]
//     local procedure BorrarLineaInsertadaDev(var ReturnRcptLine: Record "Return Receipt Line"; SalesLine: Record "Sales Line")
//     begin
//         if SalesLine."Deduction Line" = true then ReturnRcptLine.Delete(true);
//     end;

//     procedure CreateIRPFSalesDeduction(Tipo: option " ",Payment,Invoice,"Credit Memo","Finance Charge Memo",Reminder,Refund,,,,,,,,,,,,,,,Bill; Num: Code[20]; Imp: Decimal; SourcCode: Code[10]; Tipopercep: Code[10]; Clavepercep: Code[10]; BaseRet: Decimal; Proy: Code[20]; Desc: Text[50]; DocDate: Date; PostDate: Date; ImpFactura: Decimal; CP: Code[20]; CurrencyCode: Code[10]; PorcRet: Decimal; ProvCLi: Code[20]; CifNif: Text[20]; ImpFacturaSinIva: Decimal)
//     var
//         InfoEmp1: Record "Company Information";
//         ConfConta: Record "General Ledger Setup";
//         FacVenta1: Record "Sales Invoice Header";
//         LinFacVenta1: Record "Sales Invoice Line";
//         AboVenta1: Record "Sales Cr.Memo Header";
//         LinAboVenta1: Record "Sales Cr.Memo Line";
//         GLSetup: record "General Ledger Setup";
//         NoMovRet1: Integer;
//         Proyecto: code[20];
//         NMovRentencion: integer;
//     begin

//         CASE Tipo OF
//             Tipo::" ":
//                 begin
//                     ConfConta.Get();
//                     InfoEmp1.Get();
//                     if (Tipopercep = GLSetup."Tipo perceptor liq.") then
//                         if (Tipopercep <> ConfConta."Tipo perceptor liq.") then begin
//                             NoMovRet1 := TraerNoMovRetencion();
//                             Proyecto := Proy;
//                             if Imp < 0 then
//                                 CrearmovretenciónIRPF(NoMovRet1, ProvCLi, Desc, CifNif, DocDate, PostDate, Num, ImpFacturaSinIva, BaseRet, PorcRet, Tipopercep, Clavepercep, Imp, ImpFactura, CP, SourcCode, CurrencyCode, Tipo::" ")
//                             else
//                                 CrearmovretenciónIRPF(NoMovRet1, ProvCLi, Desc, CifNif, DocDate, PostDate, Num, ImpFacturaSinIva, BaseRet, PorcRet, Tipopercep, Clavepercep, Imp, ImpFactura, CP, SourcCode, CurrencyCode, Tipo::" ")
//                         end;
//                 end;

//             Tipo::Invoice:

//                 if FacVenta1.Get(Num) then begin
//                     FacVenta1.CALCFIELDS("Amount Including VAT", Amount);
//                     LinFacVenta1.Reset();
//                     LinFacVenta1.Setrange("Document No.", FacVenta1."No.");
//                     LinFacVenta1.Setrange("Deduction Line", true);
//                     if LinFacVenta1.Find('-') then begin
//                         NoMovRet1 := TraerNoMovRetencion();
//                         Proyecto := LinFacVenta1."Job No.";
//                         CrearmovretenciónIRPF(NoMovRet1, FacVenta1."Bill-to Customer No.", FacVenta1."Bill-to Name", FacVenta1."VAT Registration No.", FacVenta1."Document Date", FacVenta1."Posting Date", FacVenta1."No.", ImpFacturaSinIva, -BaseRet, PorcRet, Tipopercep, Clavepercep, Imp, ImpFactura, FacVenta1."Bill-to Post Code", SourcCode, FacVenta1."Currency Code", Tipo::Invoice);
//                         NMovRentencion := UltMovRetención();
//                         PasarDimensionesRet(LinFacVenta1."Document No.", LinFacVenta1."Line No.", NMovRentencion, true, false);
//                     end;

//                 end;

//             Tipo::"Credit Memo":

//                 //Traemos el documento.
//                 if AboVenta1.Get(Num) then begin
//                     AboVenta1.CALCFIELDS("Amount Including VAT", Amount);
//                     LinAboVenta1.Reset();
//                     LinAboVenta1.Setrange("Document No.", AboVenta1."No.");
//                     LinAboVenta1.Setrange("Deduction Line", true);
//                     if LinAboVenta1.Find('-') then begin
//                         NoMovRet1 := TraerNoMovRetencion();
//                         Proyecto := LinAboVenta1."Job No.";
//                         CrearmovretenciónIRPF(NoMovRet1, AboVenta1."Bill-to Customer No.", AboVenta1."Bill-to Name", AboVenta1."VAT Registration No.", AboVenta1."Document Date", AboVenta1."Posting Date", //AboCompra1."No.",AboCompra1."Amount Including VAT",BaseRet,PorcRet,Tipopercep,Clavepercep,
//                         AboVenta1."No.", -ImpFacturaSinIva, BaseRet, PorcRet, Tipopercep, Clavepercep, //-Imp,AboCompra1.Amount,AboCompra1."Pay-to Post Code",SourcCode,AboCompra1."Currency Code",
//                         -Imp, -ImpFactura, AboVenta1."Bill-to Post Code", SourcCode, AboVenta1."Currency Code", Tipo::"Credit Memo");

//                         NMovRentencion := UltMovRetención();
//                         PasarDimensionesRet(LinAboVenta1."Document No.", LinAboVenta1."Line No.", NMovRentencion, false, false);

//                     end;
//                 end;
//         end;
//     end;

//     procedure CrearRetencionIRPFVt(Tipo: Option " ",Payment,Invoice,"Credit Memo","Finance Charge Memo",Reminder,Refund,,,,,,,,,,,,,,,"Bill"; Num: Code[20]; Imp: Decimal; SourcCode: Code[10]; Tipopercep: Code[10]; Clavepercep: Code[10]; BaseRet: Decimal; Proy: Code[20]; Desc: Text[50]; DocDate: Date; PostDate: Date; ImpFactura: Decimal; CP: Code[20]; CurrencyCode: Code[10]; PorcRet: Decimal; ProvCLi: Code[20]; CifNif: Text[20]; ImpFacturaSinIva: Decimal)
//     var
//         FacVenta1: record "Sales Invoice Header";
//         LinFacVenta1: record "Sales Invoice Line";
//         AboVenta1: Record "Sales Cr.Memo Header";
//         LinAboVenta1: Record "Sales Cr.Memo Line";
//         ClavesPrecep: Record "SVT Perception Keys (IRPF)";
//         NoMovRet1: Integer;
//         Proyecto: code[20];
//         NMovRentencion: integer;
//         RetGener: Boolean;
//     begin
//         CASE Tipo OF
//             Tipo::Invoice:
//                 if FacVenta1.Get(Num) then begin
//                     FacVenta1.CALCFIELDS("Amount Including VAT", Amount);
//                     LinFacVenta1.Reset();
//                     LinFacVenta1.Setrange("Document No.", FacVenta1."No.");
//                     LinFacVenta1.Setrange("Deduction Line", true);
//                     if LinFacVenta1.Find('-') then
//                         repeat
//                             NoMovRet1 := TraerNoMovRetencion();
//                             Proyecto := LinFacVenta1."Job No.";
//                             ClavesPrecep.Get(Clavepercep);
//                             CrearmovretenciónIRPF(NoMovRet1, FacVenta1."Bill-to Customer No.", FacVenta1."Bill-to Name", FacVenta1."VAT Registration No.", FacVenta1."Document Date", FacVenta1."Posting Date", FacVenta1."No.", ImpFactura, LinFacVenta1.Quantity, PorcRet, Tipopercep, Clavepercep, -Imp, ImpFacturaSinIva, FacVenta1."Bill-to Post Code", SourcCode, FacVenta1."Currency Code", Tipo::Invoice);
//                             NMovRentencion := UltMovRetención();
//                             PasarDimensionesRet(LinFacVenta1."Document No.", LinFacVenta1."Line No.", NMovRentencion, true, true);
//                             RetGener := true;
//                         until (LinFacVenta1.Next() = 0) OR (RetGener);
//                 end;

//         end;
//         CASE Tipo OF
//             Tipo::"Credit Memo":
//                 //Abono de venta
//                 //Traemos el documento.
//                 if AboVenta1.Get(Num) then begin
//                     AboVenta1.CALCFIELDS("Amount Including VAT", Amount);
//                     LinAboVenta1.Reset;
//                     LinAboVenta1.Setrange("Document No.", AboVenta1."No.");
//                     LinAboVenta1.Setrange("Deduction Line", true);
//                     if LinAboVenta1.Find('-') then
//                         repeat
//                             NoMovRet1 := TraerNoMovRetencion;
//                             Proyecto := LinAboVenta1."Job No.";
//                             CrearmovretenciónIRPF(NoMovRet1, AboVenta1."Bill-to Customer No.", AboVenta1."Bill-to Name", AboVenta1."VAT Registration No.", AboVenta1."Document Date", AboVenta1."Posting Date", AboVenta1."No.", ImpFactura, LinAboVenta1.Quantity, PorcRet, Tipopercep, Clavepercep, Imp, ImpFacturaSinIva, AboVenta1."Bill-to Post Code", SourcCode, AboVenta1."Currency Code", Tipo::"Credit Memo");
//                             //TECNOCOM - EFS - 070912
//                             NMovRentencion := UltMovRetención;
//                             PasarDimensionesRet(LinAboVenta1."Document No.", LinAboVenta1."Line No.", NMovRentencion, false, true);
//                             //FIN TECNOCOM - EFS - 070912
//                             RetGener := true;
//                         until (LinAboVenta1.Next = 0) OR (RetGener);
//                 end;
//         end;
//     end;

//     procedure LiqRetencion(VAR Ndocuemnto: Code[20]; NumMov: Integer; Importep: Decimal)
//     var
//         HistFactCompra: Record "Purch. Inv. Header";
//         HistAbonCompra: Record "Purch. Cr. Memo Hdr.";
//         HistFactVenta: Record "Sales Invoice Header";
//         HistAbonVenta: Record "Sales Cr.Memo Header";
//         MovRetencion2: record "SVT Witholding Tax registers";
//         MovRetencion3: record "SVT Witholding Tax registers";
//         MovRetencion4: record "SVT Witholding Tax registers";
//         GlobalRETGenJnlLine: record "Gen. Journal Line";
//         CurrExchRate: record "Currency Exchange Rate";
//         GlobalRETGLEntry: record "G/L Entry";
//         LastDocNo: code[20];
//         Abono: Boolean;
//         VNumMovReten: integer;
//     begin
//         MovRetencion2.LockTable();
//         MovRetencion2.Reset();
//         if MovRetencion2.Find('+') then
//             VNumMovReten := MovRetencion2."Nº mov." + 1;

//         MovRetencion3.Reset();
//         MovRetencion3.Setrange(MovRetencion3."Nº documento", Ndocuemnto);
//         if NumMov <> 0 then MovRetencion3.Setrange("Nº mov.", NumMov);
//         if MovRetencion3.Find('-') then begin
//             if MovRetencion3."Cli/Prov" = MovRetencion3."Cli/Prov"::Cliente then begin
//                 if NOT HistFactVenta.Get(Ndocuemnto) then if HistAbonVenta.Get(Ndocuemnto) then Abono := true;
//             end
//             else
//                 if NOT HistFactCompra.Get(Ndocuemnto) then if HistAbonCompra.Get(Ndocuemnto) then Abono := true;

//             if MovRetencion3."Importe Pendiente" < 0 then
//                 MovRetencion3."Importe Pendiente (DL)" := MovRetencion3."Importe Pendiente (DL)" + ABS(Importep)
//             else
//                 MovRetencion3."Importe Pendiente (DL)" := MovRetencion3."Importe Pendiente (DL)" - ABS(Importep);
//             if MovRetencion3."Importe Pendiente (DL)" = 0 then begin
//                 MovRetencion3.Pendiente := false;
//                 MovRetencion3."Importe Pendiente" := 0;
//             end
//             else
//                 MovRetencion3."Importe Pendiente" := CurrExchRate.ExchangeAmtLCYToFCY(WorkDate(), MovRetencion3."Cód. divisa", MovRetencion3."Importe Pendiente (DL)", CurrExchRate.ExchangeRate(WorkDate, MovRetencion3."Cód. divisa"));

//             MovRetencion3."Importe a Liquidar" := MovRetencion3."Importe Pendiente";
//             MovRetencion3."Importe a Liquidar (DL)" := MovRetencion3."Importe Pendiente (DL)";
//             MovRetencion3."Liquidado por Movimiento" := FORMAT(VNumMovReten);
//             MovRetencion3.Modify();
//             MovRetencion4.Reset();
//             MovRetencion4 := MovRetencion3;
//             MovRetencion4."Nº documento" := LastDocNo;
//             MovRetencion4."Nº mov." := VNumMovReten;
//             MovRetencion4."Tipo Documento" := MovRetencion4."Tipo Documento"::" ";
//             MovRetencion4.Descripción := 'Liq. Retención ' + MovRetencion3."Nº documento";
//             MovRetencion4."Fecha registro" := GlobalRETGLEntry."Posting Date";
//             MovRetencion4."Importe factura iva incl." := 0;
//             MovRetencion4."Base retención" := 0;
//             MovRetencion4."% retención" := 0;
//             MovRetencion4."Nº asiento" := 0;
//             MovRetencion4.Revertido := false;
//             MovRetencion4."Revertido por el movimiento nº" := 0;
//             MovRetencion4."Nº movimiento revertido" := 0;
//             if Abono then begin
//                 if MovRetencion3."Cli/Prov" = MovRetencion3."Cli/Prov"::Cliente then
//                     MovRetencion4."Importe retención (DL)" := ABS(Importep)
//                 else
//                     MovRetencion4."Importe retención (DL)" := -ABS(Importep);
//             end
//             else
//                 if MovRetencion3."Cli/Prov" = MovRetencion3."Cli/Prov"::Cliente then
//                     MovRetencion4."Importe retención (DL)" := -ABS(Importep)
//                 else
//                     MovRetencion4."Importe retención (DL)" := ABS(Importep);
//         end;
//         MovRetencion4."Cód. divisa" := MovRetencion3."Cód. divisa";
//         MovRetencion4."Importe retención" := CurrExchRate.ExchangeAmtLCYToFCY(WorkDate(), MovRetencion4."Cód. divisa", MovRetencion4."Importe retención (DL)", CurrExchRate.ExchangeRate(WorkDate, MovRetencion4."Cód. divisa"));
//         MovRetencion4."Importe Pendiente" := 0;
//         MovRetencion4."Importe Pendiente (DL)" := 0;
//         MovRetencion4."Liquidado por Movimiento" := FORMAT(MovRetencion3."Nº mov.");
//         MovRetencion4."Importe a Liquidar" := 0;
//         MovRetencion4."Importe a Liquidar (DL)" := 0;
//         MovRetencion4.Pendiente := false;
//         MovRetencion4.Factura := GlobalRETGenJnlLine.Invoice;
//         MovRetencion4.Efecto := GlobalRETGenJnlLine.Efecto;
//         MovRetencion4."Tipo Liquidacion" := GlobalRETGenJnlLine."Tipo Liquidacion";
//         MovRetencion4."Liquidado por Movimiento" := FORMAT(MovRetencion3."Nº mov.");
//         MovRetencion4."Shortcut Dimension 1 Code" := MovRetencion3."Shortcut Dimension 1 Code";
//         MovRetencion4."Shortcut Dimension 2 Code" := MovRetencion3."Shortcut Dimension 2 Code";
//         MovRetencion4."Shortcut Dimension 3 Code" := MovRetencion3."Shortcut Dimension 3 Code";
//         MovRetencion4."Shortcut Dimension 4 Code" := MovRetencion3."Shortcut Dimension 4 Code";
//         MovRetencion4.Insert();
//     end;

//     procedure TraerNoMovRetencion(): integer
//     var
//         MovRet: record "SVT Witholding Tax registers";
//     begin
//         MovRet.LockTable();
//         MovRet.Reset();
//         if MovRet.Find('+') then
//             exit(MovRet."Nº mov.")
//         else
//             exit(0);
//     end;

//     procedure CrearmovretenciónIRPF(NoMov1: Integer; NoProv1: Code[20]; Descrip1: Text[50]; CifNif1: Text[20]; FEmiDoc1: Date; FReg1: Date; NoDoc1: Code[20]; ImpFactura1: Decimal; BaseRet1: Decimal; "%Ret1": Decimal; TipoPer1: Code[10]; ClavePer1: Code[10]; ImpRet1: Decimal; ImpFacSinIva: Decimal; CP1: Code[10]; CodOrigen1: Code[10]; CodDivisa1: Code[10]; AuxTipo: option " ",Payment,Invoice,"Credit Memo","Finance Charge Memo",Reminder,Refund)
//     var
//         MovRet1: Record "SVT Witholding Tax registers";
//         Regdivisa1: Record Currency;
//         Confrecursos1: Record "Resources Setup";
//         Clavepercepcionl1: Record "SVT Perception Keys (IRPF)";
//         CPl1: Record "Post Code";
//         Proveedorl1: Record Vendor;
//         Recursol1: Record Resource;
//         Hisfaccompral: Record "Purch. Inv. Header";
//         Hisabonocompral: Record "Purch. Cr. Memo Hdr.";
//         FactCompra: Record "Purch. Inv. Header";
//         AbonoCompra: Record "Purch. Cr. Memo Hdr.";
//         SalesInvoiceHeaderLocal: Record "Sales Invoice Header";
//         SalesCrMemoHeaderLocal: Record "Sales Cr.Memo Header";
//         GLSetup: record "General Ledger Setup";
//         CurrExchRate: record "Currency Exchange Rate";
//         NextTransactionNo: integer;
//         Proyecto: code[20];
//     begin
//         Confrecursos1.Get();
//         MovRet1."Nº mov." := NoMov1 + 1;
//         MovRet1."Nº Proveedor / Nº Cliente" := NoProv1;
//         MovRet1.Descripción := Descrip1;
//         MovRet1."Cif/Nif" := CifNif1;
//         MovRet1."Fecha emisión documento" := FEmiDoc1;
//         MovRet1."Fecha registro" := FReg1;
//         MovRet1."Nº documento" := NoDoc1;
//         MovRet1."Tipo Documento" := AuxTipo;
//         MovRet1."Importe factura iva incl." := ImpFactura1;
//         MovRet1."Importe factura" := ImpFacSinIva;
//         MovRet1."Base retención" := ABS(BaseRet1);
//         MovRet1."% retención" := "%Ret1";
//         MovRet1."Tipo de Perceptor" := TipoPer1;
//         MovRet1."Clave de Percepción" := ClavePer1;
//         MovRet1."C.P" := CP1;
//         MovRet1."Cód. divisa" := CodDivisa1;
//         MovRet1.Pendiente := true;
//         MovRet1.Validate("Nº Proyecto", Proyecto);
//         MovRet1."Nº asiento" := NextTransactionNo;
//         MovRet1."Cód. origen" := CodOrigen1;
//         Proveedorl1.Reset();
//         Recursol1.Reset();
//         if Proveedorl1.Get(NoProv1) then begin
//             MovRet1."Nombre 1" := Proveedorl1.Name;
//             MovRet1."Nombre 2/Apellidos" := Proveedorl1."Name 2";
//         end
//         else if Recursol1.Get(NoProv1) then begin
//             MovRet1."Nombre 1" := Recursol1.Name;
//             MovRet1."Nombre 2/Apellidos" := Recursol1."Name 2";
//         end;
//         CPl1.Reset();
//         if CPl1.Get(CP1, Proveedorl1.City) then begin
//             MovRet1."C.P" := CP1;
//             //MovRet1."Código provincia" := CPl1.County;
//             MovRet1."Código provincia" := CPl1."County Code";
//         end;
//         MovRet1."Año devengo" := DATE2DMY(MovRet1."Fecha registro", 3);
//         Clavepercepcionl1.Reset();
//         if Clavepercepcionl1.Get(ClavePer1) then begin
//             MovRet1."Clave de Percepción" := ClavePer1;
//             MovRet1."Cta. retención" := Clavepercepcionl1."Deduction Acc.";
//             MovRet1."Clave IRPF" := Clavepercepcionl1."IRPF Key";
//             MovRet1."Subclave IRPF" := Clavepercepcionl1."RPF SubKey";
//             MovRet1."Tipo percepción" := Clavepercepcionl1."Perception Type";
//             MovRet1."Cli/Prov" := Clavepercepcionl1."Cust/Vend";
//             MovRet1."Tipo Retención" := Clavepercepcionl1."Deduction Type";
//         end;
//         MovRet1."Importe retención" := ImpRet1;
//         if Regdivisa1.Get(CodDivisa1) then MovRet1."Importe retención" := round(MovRet1."Importe retención", Regdivisa1."Amount Rounding Precision");

//         if AuxTipo = AuxTipo::Invoice then begin

//             if Clavepercepcionl1."Cust/Vend" = Clavepercepcionl1."Cust/Vend"::Vendor then begin
//                 GLSetup.Get();
//                 FactCompra.Reset();
//                 FactCompra.Get(NoDoc1);
//                 MovRet1."Base retencion (DL)" := CurrExchRate.ExchangeAmtFCYToLCY(WorkDate(), MovRet1."Cód. divisa", MovRet1."Base retención", FactCompra."Currency Factor");
//                 MovRet1."Base retencion (DL)" := round(MovRet1."Base retencion (DL)", GLSetup."Amount Rounding Precision");
//                 MovRet1."Importe retención (DL)" := CurrExchRate.ExchangeAmtFCYToLCY(WorkDate(), MovRet1."Cód. divisa", MovRet1."Importe retención", FactCompra."Currency Factor");
//                 MovRet1."Importe retención (DL)" := round(MovRet1."Importe retención (DL)", GLSetup."Amount Rounding Precision");
//                 MovRet1."Importe Factura (DL)" := CurrExchRate.ExchangeAmtFCYToLCY(WorkDate(), MovRet1."Cód. divisa", MovRet1."Importe factura iva incl.", FactCompra."Currency Factor");
//                 MovRet1."Importe Factura (DL)" := round(MovRet1."Importe Factura (DL)", GLSetup."Amount Rounding Precision");
//                 MovRet1."Importe Pendiente" := MovRet1."Importe retención";
//                 MovRet1.Pendiente := true;
//                 MovRet1."Importe a Liquidar" := MovRet1."Importe retención";
//                 MovRet1."Importe Pendiente (DL)" := MovRet1."Importe retención (DL)";
//                 MovRet1."Importe a Liquidar (DL)" := MovRet1."Importe retención (DL)";
//                 MovRet1."Shortcut Dimension 1 Code" := FactCompra."Shortcut Dimension 1 Code";
//                 MovRet1."Shortcut Dimension 2 Code" := FactCompra."Shortcut Dimension 2 Code";
//             end
//             else begin
//                 GLSetup.Get();
//                 SalesInvoiceHeaderLocal.Reset();
//                 SalesInvoiceHeaderLocal.Get(NoDoc1);
//                 MovRet1."Base retencion (DL)" := CurrExchRate.ExchangeAmtFCYToLCY(WorkDate(), MovRet1."Cód. divisa", MovRet1."Base retención", SalesInvoiceHeaderLocal."Currency Factor");
//                 MovRet1."Base retencion (DL)" := round(MovRet1."Base retencion (DL)", GLSetup."Amount Rounding Precision");
//                 MovRet1."Importe retención (DL)" := CurrExchRate.ExchangeAmtFCYToLCY(WorkDate(), MovRet1."Cód. divisa", MovRet1."Importe retención", SalesInvoiceHeaderLocal."Currency Factor");
//                 MovRet1."Importe retención (DL)" := round(MovRet1."Importe retención (DL)", GLSetup."Amount Rounding Precision");
//                 MovRet1."Importe Factura (DL)" := CurrExchRate.ExchangeAmtFCYToLCY(WorkDate(), MovRet1."Cód. divisa", MovRet1."Importe factura iva incl.", SalesInvoiceHeaderLocal."Currency Factor");
//                 MovRet1."Importe Factura (DL)" := round(MovRet1."Importe Factura (DL)", GLSetup."Amount Rounding Precision");
//                 MovRet1."Importe Pendiente" := MovRet1."Importe retención";
//                 MovRet1.Pendiente := true;
//                 MovRet1."Importe a Liquidar" := MovRet1."Importe retención";
//                 MovRet1."Importe Pendiente (DL)" := MovRet1."Importe retención (DL)";
//                 MovRet1."Importe a Liquidar (DL)" := MovRet1."Importe retención (DL)";
//                 MovRet1."Shortcut Dimension 1 Code" := SalesInvoiceHeaderLocal."Shortcut Dimension 1 Code";
//                 MovRet1."Shortcut Dimension 2 Code" := SalesInvoiceHeaderLocal."Shortcut Dimension 2 Code";
//             end;
//         end
//         else
//             if AuxTipo = AuxTipo::"Credit Memo" then
//                 if Clavepercepcionl1."Cust/Vend" = Clavepercepcionl1."Cust/Vend"::Vendor then begin
//                     GLSetup.Get();
//                     AbonoCompra.Reset();
//                     AbonoCompra.Get(NoDoc1);
//                     MovRet1."Base retencion (DL)" := CurrExchRate.ExchangeAmtFCYToLCY(WorkDate(), MovRet1."Cód. divisa", MovRet1."Base retención", AbonoCompra."Currency Factor");
//                     MovRet1."Base retencion (DL)" := round(MovRet1."Base retencion (DL)", GLSetup."Amount Rounding Precision");
//                     MovRet1."Importe retención (DL)" := CurrExchRate.ExchangeAmtFCYToLCY(WorkDate(), MovRet1."Cód. divisa", MovRet1."Importe retención", AbonoCompra."Currency Factor");
//                     MovRet1."Importe retención (DL)" := round(MovRet1."Importe retención (DL)", GLSetup."Amount Rounding Precision");
//                     MovRet1."Importe Factura (DL)" := CurrExchRate.ExchangeAmtFCYToLCY(WorkDate(), MovRet1."Cód. divisa", MovRet1."Importe factura iva incl.", AbonoCompra."Currency Factor");
//                     MovRet1."Importe Factura (DL)" := round(MovRet1."Importe Factura (DL)", GLSetup."Amount Rounding Precision");
//                     MovRet1."Importe Pendiente" := MovRet1."Importe retención";
//                     MovRet1.Pendiente := true;
//                     MovRet1."Importe a Liquidar" := MovRet1."Importe retención";
//                     MovRet1."Importe Pendiente (DL)" := MovRet1."Importe retención (DL)";
//                     MovRet1."Importe a Liquidar (DL)" := MovRet1."Importe retención (DL)";
//                     MovRet1."Shortcut Dimension 1 Code" := AbonoCompra."Shortcut Dimension 1 Code";
//                     MovRet1."Shortcut Dimension 2 Code" := AbonoCompra."Shortcut Dimension 2 Code";
//                 end
//                 else begin
//                     GLSetup.Get();
//                     SalesCrMemoHeaderLocal.Reset();
//                     SalesCrMemoHeaderLocal.Get(NoDoc1);
//                     MovRet1."Base retencion (DL)" := CurrExchRate.ExchangeAmtFCYToLCY(WorkDate(), MovRet1."Cód. divisa", MovRet1."Base retención", SalesCrMemoHeaderLocal."Currency Factor");
//                     MovRet1."Base retencion (DL)" := round(MovRet1."Base retencion (DL)", GLSetup."Amount Rounding Precision");
//                     MovRet1."Importe retención (DL)" := CurrExchRate.ExchangeAmtFCYToLCY(WorkDate(), MovRet1."Cód. divisa", MovRet1."Importe retención", SalesCrMemoHeaderLocal."Currency Factor");
//                     MovRet1."Importe retención (DL)" := round(MovRet1."Importe retención (DL)", GLSetup."Amount Rounding Precision");
//                     MovRet1."Importe Factura (DL)" := CurrExchRate.ExchangeAmtFCYToLCY(WorkDate(), MovRet1."Cód. divisa", MovRet1."Importe factura iva incl.", SalesCrMemoHeaderLocal."Currency Factor");
//                     MovRet1."Importe Factura (DL)" := round(MovRet1."Importe Factura (DL)", GLSetup."Amount Rounding Precision");
//                     MovRet1."Importe Pendiente" := MovRet1."Importe retención";
//                     MovRet1.Pendiente := true;
//                     MovRet1."Importe a Liquidar" := MovRet1."Importe retención";
//                     MovRet1."Importe Pendiente (DL)" := MovRet1."Importe retención (DL)";
//                     MovRet1."Importe a Liquidar (DL)" := MovRet1."Importe retención (DL)";
//                     MovRet1."Shortcut Dimension 1 Code" := SalesCrMemoHeaderLocal."Shortcut Dimension 1 Code";
//                     MovRet1."Shortcut Dimension 2 Code" := SalesCrMemoHeaderLocal."Shortcut Dimension 2 Code";
//                 end;

//         if AuxTipo = AuxTipo::"Credit Memo" then begin
//             MovRet1."Base retencion (DL)" := -MovRet1."Base retencion (DL)";
//             MovRet1."Base retención" := -MovRet1."Base retención";
//         end;
//         clear(Hisfaccompral);
//         Hisfaccompral.Reset();
//         if Hisfaccompral.Get(NoDoc1) then
//             MovRet1.País := Hisfaccompral."Buy-from Country/Region Code";

//         else begin
//             clear(Hisabonocompral);
//             Hisabonocompral.Reset;
//             if Hisabonocompral.Get(NoDoc1) then MovRet1.País := Hisabonocompral."Buy-from Country/Region Code";
//         end;
//         clear(SalesInvoiceHeaderLocal);
//         SalesInvoiceHeaderLocal.Reset();
//         if SalesInvoiceHeaderLocal.Get(NoDoc1) then
//             MovRet1.País := SalesInvoiceHeaderLocal."Sell-to Country/Region Code"

//         else begin
//             clear(SalesCrMemoHeaderLocal);
//             SalesCrMemoHeaderLocal.Reset();
//             if SalesCrMemoHeaderLocal.Get(NoDoc1) then
//                 MovRet1.País := SalesCrMemoHeaderLocal."Sell-to Country/Region Code";
//         end;
//         MovRet1.Insert();
//     end;

//     procedure UltMovRetención(): Integer;
//     VAR
//         AuxMovRetención: Record "SVT Witholding Tax registers";
//     begin
//         AuxMovRetención.Reset();
//         if AuxMovRetención.FindLast() then exit(AuxMovRetención."Nº mov.");
//     end;

//     procedure PasarDimensionesRet(Ndoc: Code[20]; Nlinea: Integer; UltimoMovRet: Integer; Factura: Boolean; Venta: Boolean);
//     VAR
//         HistFactLinCompra: Record "Purch. Inv. Line";
//         HistFactLinVenta: Record "Sales Invoice Line";
//         HistAbonoLinCompra: Record "Purch. Cr. Memo Line";
//         HistAbonoLinVenta: Record "Sales Cr.Memo Line";
//         RcdMovRet: Record "SVT Witholding Tax registers";
//     begin
//         RcdMovRet.Get(UltimoMovRet);
//         if Factura then begin
//             if Venta then begin
//                 HistFactLinVenta.Get(Ndoc, Nlinea);
//                 RcdMovRet."Shortcut Dimension 1 Code" := HistFactLinVenta."Shortcut Dimension 1 Code";
//                 RcdMovRet."Shortcut Dimension 2 Code" := HistFactLinVenta."Shortcut Dimension 2 Code";
//             end
//             else begin
//                 HistFactLinCompra.Get(Ndoc, Nlinea);
//                 RcdMovRet."Shortcut Dimension 1 Code" := HistFactLinCompra."Shortcut Dimension 1 Code";
//                 RcdMovRet."Shortcut Dimension 2 Code" := HistFactLinCompra."Shortcut Dimension 2 Code";
//             end;
//         end
//         else begin
//             if Venta then
//                 HistAbonoLinVenta.Get(Ndoc, Nlinea);
//             RcdMovRet."Shortcut Dimension 1 Code" := HistAbonoLinVenta."Shortcut Dimension 1 Code";
//             RcdMovRet."Shortcut Dimension 2 Code" := HistAbonoLinVenta."Shortcut Dimension 2 Code";
//         end
//         else begin
//             HistAbonoLinCompra.Get(Ndoc, Nlinea);
//             RcdMovRet."Shortcut Dimension 1 Code" := HistAbonoLinCompra."Shortcut Dimension 1 Code";
//             RcdMovRet."Shortcut Dimension 2 Code" := HistAbonoLinCompra."Shortcut Dimension 2 Code";
//         end;

//         RcdMovRet.Modify();
//     end;

//     [EventSubscriber(ObjectType::Table: 36, 'OnAfterValidateEvent', 'Sell-to Customer No.', false, false)]
//     local procedure ValidarPercepciones(var Rec: Record "Sales Header")
//     var
//         Cust: record Customer;
//     begin
//         Cust.Reset();
//         if Cust.Get(Rec."Sell-to Customer No.") then begin
//             Rec."Key Perception" := Cust."Clave Percepción";
//             Rec."Type Perception" := Cust."Tipo Percepción";
//         end;
//     end;
// }

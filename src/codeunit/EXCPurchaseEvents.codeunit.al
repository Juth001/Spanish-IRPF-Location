// namespace Excelia.IRPF;
// using Microsoft.Purchases.Document;
// using Microsoft.Purchases.Posting;
// using Microsoft.Foundation.Company;
// using Microsoft.Finance.GeneralLedger.Journal;
// using Microsoft.Finance.GeneralLedger.Account;
// using Microsoft.Foundation.AuditCodes;
// using Microsoft.Purchases.Setup;
// using Microsoft.Projects.Resources.Resource;
// using Microsoft.Purchases.Vendor;
// using Microsoft.Foundation.Address;
// using Microsoft.Projects.Resources.Setup;
// using Microsoft.Finance.Currency;
// using Microsoft.Finance.GeneralLedger.Setup;
// using Microsoft.Sales.History;
// using Microsoft.Purchases.History;

// codeunit 86300 "EXC Purchase Events"
// {

//     [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnAfterProcessPurchLines', '', false, false)]
//     local procedure CrearRetencionesLineas(var PurchHeader: Record "Purchase Header"; var PurchInvHeader: Record "Purch. Inv. Header"; var PurchCrMemoHdr: Record "Purch. Cr. Memo Hdr.")
//     var
//         PurchaseLine: Record "Purchase Line";
//     begin
//         PurchaseLine.Reset();
//         PurchaseLine.Setrange("Document Type", PurchHeader."Document Type");
//         PurchaseLine.Setrange("Document No.", PurchHeader."No.");
//         if PurchaseLine.Findset() then
//             repeat
//                 if PurchaseLine."Retention Line" then
//                     CreaRetencionesCompras(PurchaseLine, PurchHeader, PurchInvHeader, PurchCrMemoHdr);
//             until PurchaseLine.Next() = 0;
//     end;

//     procedure CreaRetencionesCompras(PurchLine: record "Purchase Line"; PurchHeader: Record "Purchase Header"; PurchInvHeader: Record "Purch. Inv. Header"; PurchInvCrMemo: record "Purch. Cr. Memo Hdr.")
//     var
//         GLAccount: record "G/L Account";
//         SourceCodeSetup: record "Source Code Setup";
//         GenJournalLine: Record "Gen. Journal Line";
//         SrcCode: code[10];
//         GenJnlLineDocType: Integer;
//         GenJnlLineDocNo: code[20];
//         ImpTotal: decimal;
//         ImpTotalSinIVA: decimal;

//     begin
//         GLAccount.Get(PurchLine."No.");
//         if (PurchLine."Retention Entry" = 0) then begin
//             SourceCodeSetup.Get();
//             SrcCode := SourceCodeSetup.Sales;

//             if PurchHeader."Document Type" = PurchHeader."Document Type"::Invoice then begin
//                 GenJnlLineDocType := GenJournalLine."Document Type"::Invoice.AsInteger();
//                 GenJnlLineDocNo := PurchInvHeader."No.";
//             end
//             else begin
//                 GenJnlLineDocType := GenJournalLine."Document Type"::"Credit Memo".AsInteger();
//                 GenJnlLineDocNo := PurchInvCrMemo."No.";
//             end;

//             PurchHeader.CALCFIELDS(Amount, "Amount Including VAT");
//             PurchHeader.CALCFIELDS("IRPF Amount", "Importe IVA incl.IRPF");
//             if (GLAccount."Retention Account Type" = GLAccount."Retention Account Type"::Vendor) AND (Purchline."Retention Entry" = 0) then begin
//                 if Purchline."Document Type" = Purchline."Document Type"::Order then begin
//                     PurchInvHeader.CALCFIELDS("Amount Including VAT", Amount);
//                     ImpTotal := PurchInvHeader."Amount Including VAT";
//                     ImpTotalSinIva := PurchInvHeader.Amount;
//                 end
//                 else begin
//                     ImpTotal := PurchHeader."Importe IVA incl.IRPF";
//                     ImpTotalSinIva := PurchHeader."IRPF Amount";
//                 end;
//                 CrearRetencionIRPF(GenJnlLineDocType, GenJnlLineDocNo, PurchLine.Amount, SrcCode, PurchLine."Perception Type", PurchLine."Perception key", PurchLine."Qty. to Invoice", PurchLine."Job No.", PurchHeader."Posting Description", PurchHeader."Document Date", PurchHeader."Posting Date", ImpTotalSinIva, PurchHeader."Buy-from Post Code", PurchHeader."Currency Code", -(PurchLine."Direct Unit Cost" * 100), PurchHeader."Buy-from Vendor No.", PurchHeader."VAT Registration No.", ImpTotal);
//             end;
//             if (GLAccount."Retention Account Type" = GLAccount."Retention Account Type"::Customer) AND (PurchLine."Retention Entry" = 0) then CrearRetencionIRPF(GenJnlLineDocType, GenJnlLineDocNo, PurchLine.Amount, SrcCode, PurchLine."Perception Type", PurchLine."Perception key", PurchLine."Qty. to Invoice", PurchLine."Job No.", PurchHeader."Posting Description", PurchHeader."Document Date", PurchHeader."Posting Date", PurchHeader.Amount, PurchHeader."Buy-from Post Code", PurchHeader."Currency Code", -(PurchLine."Direct Unit Cost" * 100), PurchHeader."Buy-from Vendor No.", PurchHeader."VAT Registration No.", PurchHeader."Amount Including VAT");
//         end
//         else
//             if (PurchLine."Retention Entry" <> 0) then LiqRetencion(PurchInvHeader."No.", PurchLine."Retention Entry", PurchLine.Amount, PurchInvHeader."Posting Date");
//     end;

//     procedure CrearRetencionIRPF(Tipo: option " ",Payment,Invoice,"Credit Memo","Finance Charge Memo",Reminder,Refund,,,,,,,,,,,,,,,Bill; Num: Code[20]; Imp: Decimal; SourcCode: Code[10]; Tipopercep: Code[10]; Clavepercep: Code[10]; BaseRet: Decimal; Proy: Code[20]; Desc: Text[50]; DocDate: Date; PostDate: Date; ImpFactura: Decimal; CP: Code[20]; CurrencyCode: Code[10]; PorcRet: Decimal; ProvCLi: Code[20]; CifNif: Text[20]; ImpFacturaSinIva: Decimal)
//     var
//         InfoEmp1: Record "Company Information";
//         ConfConta: Record "General Ledger Setup";
//         FacCompra1: Record "Purch. Inv. Header";
//         LinFacCompra1: Record "Purch. Inv. Line";
//         AboCompra1: Record "Purch. Cr. Memo Hdr.";
//         LinAboCompra1: Record "Purch. Cr. Memo Line";
//         GLSetup: record "General Ledger Setup";
//         NoMovRet1: Integer;
//         NMovRentencion: integer;
//     begin
//         CASE Tipo OF
//             Tipo::" ":
//                 begin
//                     ConfConta.Get();
//                     InfoEmp1.Get();
//                     if (Tipopercep = GLSetup."Type beneficiary liq.") then
//                         if (Tipopercep <> ConfConta."Type beneficiary liq.") then begin
//                             NoMovRet1 := TraerNoMovRetencion();
//                             if Imp < 0 then
//                                 CrearmovretenciónIRPF(NoMovRet1, ProvCLi, Desc, CifNif, DocDate, PostDate, Num, ImpFacturaSinIva, BaseRet, PorcRet, Tipopercep, Clavepercep, Imp, ImpFactura, CP, SourcCode, CurrencyCode, Tipo::" ")
//                             else
//                                 CrearmovretenciónIRPF(NoMovRet1, ProvCLi, Desc, CifNif, DocDate, PostDate, Num, ImpFacturaSinIva, BaseRet, PorcRet, Tipopercep, Clavepercep, Imp, ImpFactura, CP, SourcCode, CurrencyCode, Tipo::" ")
//                         end;
//                 end;
//             Tipo::Invoice:
//                 if FacCompra1.Get(Num) then begin
//                     FacCompra1.CALCFIELDS("Amount Including VAT", Amount);
//                     LinFacCompra1.Reset();
//                     LinFacCompra1.Setrange("Document No.", FacCompra1."No.");
//                     LinFacCompra1.Setrange("Retention Line", true);
//                     if LinFacCompra1.Find('-') then begin
//                         NoMovRet1 := TraerNoMovRetencion();
//                         CrearmovretenciónIRPF(NoMovRet1, FacCompra1."Pay-to Vendor No.", FacCompra1."Pay-to Name", FacCompra1."VAT Registration No.", FacCompra1."Document Date", FacCompra1."Posting Date", FacCompra1."No.", ImpFacturaSinIva, -BaseRet, PorcRet, Tipopercep, Clavepercep, Imp, ImpFactura, FacCompra1."Pay-to Post Code", SourcCode, FacCompra1."Currency Code", Tipo::Invoice);
//                         NMovRentencion := UltMovRetención();
//                         PasarDimensionesRet(LinFacCompra1."Document No.", LinFacCompra1."Line No.", NMovRentencion, true, false);
//                     end;
//                 end;


//             Tipo::"Credit Memo":
//                 if AboCompra1.Get(Num) then begin
//                     AboCompra1.CALCFIELDS("Amount Including VAT", Amount);
//                     LinAboCompra1.Reset();
//                     LinAboCompra1.Setrange("Document No.", AboCompra1."No.");
//                     LinAboCompra1.Setrange("Deduction Line", true);
//                     if LinAboCompra1.Find('-') then begin
//                         NoMovRet1 := TraerNoMovRetencion();
//                         CrearmovretenciónIRPF(NoMovRet1, AboCompra1."Pay-to Vendor No.", AboCompra1."Pay-to Name", AboCompra1."VAT Registration No.", AboCompra1."Document Date", AboCompra1."Posting Date",
//                         AboCompra1."No.", ImpFacturaSinIva, BaseRet, PorcRet, Tipopercep, Clavepercep,
//                         Imp, ImpFactura, AboCompra1."Pay-to Post Code", SourcCode, AboCompra1."Currency Code", //-- OT2-055642
//                         Tipo::"Credit Memo");
//                         NMovRentencion := UltMovRetención();
//                         PasarDimensionesRet(LinAboCompra1."Document No.", LinAboCompra1."Line No.", NMovRentencion, false, false);
//                     end;
//                 end;
//         end;

//     end;

//     procedure TraerNoMovRetencion(): integer
//     var
//         MovRet: record "EXC Retention Tax registers";
//     begin
//         MovRet.LockTable();
//         MovRet.Reset();
//         if MovRet.Find('+') then
//             exit(MovRet."Entry No.")
//         else
//             exit(0);
//     end;

//     procedure CrearmovretenciónIRPF(NoMov1: Integer; NoProv1: Code[20]; Descrip1: Text[50]; CifNif1: Text[20]; FEmiDoc1: Date; FReg1: Date; NoDoc1: Code[20]; ImpFactura1: Decimal; BaseRet1: Decimal; "%Ret1": Decimal; TipoPer1: Code[10]; ClavePer1: Code[10]; ImpRet1: Decimal; ImpFacSinIva: Decimal; CP1: Code[10]; CodOrigen1: Code[10]; CodDivisa1: Code[10]; AuxTipo: option " ",Payment,Invoice,"Credit Memo","Finance Charge Memo",Reminder,Refund)
//     var
//         PurchaseInvHeader: Record "Purch. Inv. Header";
//         PurchCrMemoHdr: Record "Purch. Cr. Memo Hdr.";
//         SalesInvoiceHeader: Record "Sales Invoice Header";
//         MovRet1: Record "EXC Retention Tax registers";
//         Currency: Record Currency;
//         ResourceSetup: Record "Resources Setup";
//         Clavepercepcionl1: Record "EXC Perception Keys (IRPF)";
//         SalesCrMemoHeader: Record "Sales Cr.Memo Header";
//         PostCode: Record "Post Code";
//         Vendor: Record Vendor;
//         Resource: Record Resource;
//         PurchInvHeader: Record "Purch. Inv. Header";
//         PurchCrNemoHdr: Record "Purch. Cr. Memo Hdr.";
//         GeneralLedgerSetup: record "General Ledger Setup";
//         CurrencyExchangeRate: record "Currency Exchange Rate";
//         Job: code[20];
//         NextTransactionNo: integer;
//     begin
//         ResourceSetup.Get();
//         MovRet1."Entry No." := NoMov1 + 1;
//         MovRet1."Nº Proveedor / Nº Cliente" := NoProv1;
//         MovRet1.Description := Descrip1;
//         MovRet1."CIF/NIF" := CifNif1;
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
//         MovRet1.Validate("Nº Proyecto", Job);
//         MovRet1."Nº asiento" := NextTransactionNo;
//         MovRet1."Cód. origen" := CodOrigen1;
//         Vendor.Reset();
//         Resource.Reset();
//         if Vendor.Get(NoProv1) then begin
//             MovRet1."Nombre 1" := Vendor.Name;
//             MovRet1."Nombre 2/Apellidos" := Vendor."Name 2";
//         end
//         else
//             if Resource.Get(NoProv1) then begin
//                 MovRet1."Nombre 1" := Resource.Name;
//                 MovRet1."Nombre 2/Apellidos" := Resource."Name 2";
//             end;
//         PostCode.Reset();
//         if PostCode.Get(CP1, Vendor.City) then begin
//             MovRet1."C.P" := CP1;
//             MovRet1."Código provincia" := PostCode."County Code";
//         end;
//         MovRet1."Año devengo" := DATE2DMY(MovRet1."Fecha registro", 3);
//         Clavepercepcionl1.Reset();
//         if Clavepercepcionl1.Get(ClavePer1) then begin
//             MovRet1."Clave de Percepción" := ClavePer1;
//             MovRet1."Cta. retención" := Clavepercepcionl1."Deduction Acc.";
//             MovRet1."Clave IRPF" := Clavepercepcionl1."IRPF Key";
//             MovRet1."Subclave IRPF" := Clavepercepcionl1."RPF SubKey";
//             MovRet1."Tipo percepción" := Clavepercepcionl1."Perception Type";
//             MovRet1."Cust/Vend" := Clavepercepcionl1."Cust/Vend";
//             MovRet1."Tipo Retención" := Clavepercepcionl1."Deduction Type";
//         end;
//         MovRet1."Importe retención" := ImpRet1;
//         if Currency.Get(CodDivisa1) then MovRet1."Importe retención" := round(MovRet1."Importe retención", Currency."Amount Rounding Precision");
//         if AuxTipo = AuxTipo::Invoice then begin
//             if Clavepercepcionl1."Cust/Vend" = Clavepercepcionl1."Cust/Vend"::Vendor then begin
//                 GeneralLedgerSetup.Get();
//                 PurchaseInvHeader.Reset();
//                 PurchaseInvHeader.Get(NoDoc1);
//                 MovRet1."Base retencion (DL)" := CurrencyExchangeRate.ExchangeAmtFCYToLCY(WorkDate(), MovRet1."Cód. divisa", MovRet1."Base retención", PurchaseInvHeader."Currency Factor");
//                 MovRet1."Base retencion (DL)" := round(MovRet1."Base retencion (DL)", GeneralLedgerSetup."Amount Rounding Precision");
//                 MovRet1."Importe retención (DL)" := CurrencyExchangeRate.ExchangeAmtFCYToLCY(WorkDate(), MovRet1."Cód. divisa", MovRet1."Importe retención", PurchaseInvHeader."Currency Factor");
//                 MovRet1."Importe retención (DL)" := round(MovRet1."Importe retención (DL)", GeneralLedgerSetup."Amount Rounding Precision");
//                 MovRet1."Importe Factura (DL)" := CurrencyExchangeRate.ExchangeAmtFCYToLCY(WorkDate(), MovRet1."Cód. divisa", MovRet1."Importe factura iva incl.", PurchaseInvHeader."Currency Factor");
//                 MovRet1."Importe Factura (DL)" := round(MovRet1."Importe Factura (DL)", GeneralLedgerSetup."Amount Rounding Precision");
//                 MovRet1."Importe Pendiente" := MovRet1."Importe retención";
//                 MovRet1.Pendiente := true;
//                 MovRet1."Importe a Liquidar" := MovRet1."Importe retención";
//                 MovRet1."Importe Pendiente (DL)" := MovRet1."Importe retención (DL)";
//                 MovRet1."Importe a Liquidar (DL)" := MovRet1."Importe retención (DL)";
//                 MovRet1."Shortcut Dimension 1 Code" := PurchaseInvHeader."Shortcut Dimension 1 Code";
//                 MovRet1."Shortcut Dimension 2 Code" := PurchaseInvHeader."Shortcut Dimension 2 Code";
//             end
//             else begin
//                 GeneralLedgerSetup.Get();
//                 SalesInvoiceHeader.Reset();
//                 SalesInvoiceHeader.Get(NoDoc1);
//                 MovRet1."Base retencion (DL)" := CurrencyExchangeRate.ExchangeAmtFCYToLCY(WorkDate(), MovRet1."Cód. divisa", MovRet1."Base retención", SalesInvoiceHeader."Currency Factor");
//                 MovRet1."Base retencion (DL)" := round(MovRet1."Base retencion (DL)", GeneralLedgerSetup."Amount Rounding Precision");
//                 MovRet1."Importe retención (DL)" := CurrencyExchangeRate.ExchangeAmtFCYToLCY(WorkDate(), MovRet1."Cód. divisa", MovRet1."Importe retención", SalesInvoiceHeader."Currency Factor");
//                 MovRet1."Importe retención (DL)" := round(MovRet1."Importe retención (DL)", GeneralLedgerSetup."Amount Rounding Precision");
//                 MovRet1."Importe Factura (DL)" := CurrencyExchangeRate.ExchangeAmtFCYToLCY(WorkDate(), MovRet1."Cód. divisa", MovRet1."Importe factura iva incl.", SalesInvoiceHeader."Currency Factor");
//                 MovRet1."Importe Factura (DL)" := round(MovRet1."Importe Factura (DL)", GeneralLedgerSetup."Amount Rounding Precision");
//                 MovRet1."Importe Pendiente" := MovRet1."Importe retención";
//                 MovRet1.Pendiente := true;
//                 MovRet1."Importe a Liquidar" := MovRet1."Importe retención";
//                 MovRet1."Importe Pendiente (DL)" := MovRet1."Importe retención (DL)";
//                 MovRet1."Importe a Liquidar (DL)" := MovRet1."Importe retención (DL)";
//                 MovRet1."Shortcut Dimension 1 Code" := SalesInvoiceHeader."Shortcut Dimension 1 Code";
//                 MovRet1."Shortcut Dimension 2 Code" := SalesInvoiceHeader."Shortcut Dimension 2 Code";
//             end;
//         end
//         else
//             if AuxTipo = AuxTipo::"Credit Memo" then
//                 if Clavepercepcionl1."Cust/Vend" = Clavepercepcionl1."Cust/Vend"::Vendor then begin
//                     GeneralLedgerSetup.Get();
//                     PurchCrMemoHdr.Reset();
//                     PurchCrMemoHdr.Get(NoDoc1);
//                     MovRet1."Base retencion (DL)" := CurrencyExchangeRate.ExchangeAmtFCYToLCY(WorkDate(), MovRet1."Cód. divisa", MovRet1."Base retención", PurchCrMemoHdr."Currency Factor");
//                     MovRet1."Base retencion (DL)" := round(MovRet1."Base retencion (DL)", GeneralLedgerSetup."Amount Rounding Precision");
//                     MovRet1."Importe retención (DL)" := CurrencyExchangeRate.ExchangeAmtFCYToLCY(WorkDate(), MovRet1."Cód. divisa", MovRet1."Importe retención", PurchCrMemoHdr."Currency Factor");
//                     MovRet1."Importe retención (DL)" := round(MovRet1."Importe retención (DL)", GeneralLedgerSetup."Amount Rounding Precision");
//                     MovRet1."Importe Factura (DL)" := CurrencyExchangeRate.ExchangeAmtFCYToLCY(WorkDate(), MovRet1."Cód. divisa", MovRet1."Importe factura iva incl.", PurchCrMemoHdr."Currency Factor");
//                     MovRet1."Importe Factura (DL)" := round(MovRet1."Importe Factura (DL)", GeneralLedgerSetup."Amount Rounding Precision");
//                     MovRet1."Importe Pendiente" := MovRet1."Importe retención";
//                     MovRet1.Pendiente := true;
//                     MovRet1."Importe a Liquidar" := MovRet1."Importe retención";
//                     MovRet1."Importe Pendiente (DL)" := MovRet1."Importe retención (DL)";
//                     MovRet1."Importe a Liquidar (DL)" := MovRet1."Importe retención (DL)";
//                     MovRet1."Shortcut Dimension 1 Code" := PurchCrMemoHdr."Shortcut Dimension 1 Code";
//                     MovRet1."Shortcut Dimension 2 Code" := PurchCrMemoHdr."Shortcut Dimension 2 Code";
//                 end
//                 else begin
//                     GeneralLedgerSetup.Get();
//                     SalesCrMemoHeader.Reset();
//                     SalesCrMemoHeader.Get(NoDoc1);
//                     MovRet1."Base retencion (DL)" := CurrencyExchangeRate.ExchangeAmtFCYToLCY(WorkDate(), MovRet1."Cód. divisa", MovRet1."Base retención", SalesCrMemoHeader."Currency Factor");
//                     MovRet1."Base retencion (DL)" := round(MovRet1."Base retencion (DL)", GeneralLedgerSetup."Amount Rounding Precision");
//                     MovRet1."Importe retención (DL)" := CurrencyExchangeRate.ExchangeAmtFCYToLCY(WorkDate(), MovRet1."Cód. divisa", MovRet1."Importe retención", SalesCrMemoHeader."Currency Factor");
//                     MovRet1."Importe retención (DL)" := round(MovRet1."Importe retención (DL)", GeneralLedgerSetup."Amount Rounding Precision");
//                     MovRet1."Importe Factura (DL)" := CurrencyExchangeRate.ExchangeAmtFCYToLCY(WorkDate(), MovRet1."Cód. divisa", MovRet1."Importe factura iva incl.", SalesCrMemoHeader."Currency Factor");
//                     MovRet1."Importe Factura (DL)" := round(MovRet1."Importe Factura (DL)", GeneralLedgerSetup."Amount Rounding Precision");
//                     MovRet1."Importe Pendiente" := MovRet1."Importe retención";
//                     MovRet1.Pendiente := true;
//                     MovRet1."Importe a Liquidar" := MovRet1."Importe retención";
//                     MovRet1."Importe Pendiente (DL)" := MovRet1."Importe retención (DL)";
//                     MovRet1."Importe a Liquidar (DL)" := MovRet1."Importe retención (DL)";
//                     MovRet1."Shortcut Dimension 1 Code" := SalesCrMemoHeader."Shortcut Dimension 1 Code";
//                     MovRet1."Shortcut Dimension 2 Code" := SalesCrMemoHeader."Shortcut Dimension 2 Code";
//                 end;
//         if AuxTipo = AuxTipo::"Credit Memo" then begin
//             MovRet1."Base retencion (DL)" := -MovRet1."Base retencion (DL)";
//             MovRet1."Base retención" := -MovRet1."Base retención";
//         end;

//         clear(PurchInvHeader);
//         PurchInvHeader.Reset();
//         if PurchInvHeader.Get(NoDoc1) then
//             MovRet1.País := PurchInvHeader."Buy-from Country/Region Code"
//         else begin
//             clear(PurchCrNemoHdr);
//             PurchCrNemoHdr.Reset();
//             if PurchCrNemoHdr.Get(NoDoc1) then MovRet1.País := PurchCrNemoHdr."Buy-from Country/Region Code";
//         end;
//         clear(SalesInvoiceHeader);
//         SalesInvoiceHeader.Reset();
//         if SalesInvoiceHeader.Get(NoDoc1) then
//             MovRet1.País := SalesInvoiceHeader."Sell-to Country/Region Code"
//         else begin
//             clear(SalesCrMemoHeader);
//             SalesCrMemoHeader.Reset();
//             if SalesCrMemoHeader.Get(NoDoc1) then
//                 MovRet1.País := SalesCrMemoHeader."Sell-to Country/Region Code";
//         end;
//         MovRet1.Insert();
//     end;

//     procedure LiqRetencion(VAR Ndocuemnto: Code[20]; NumMov: Integer; Importep: Decimal; FechaReg: Date)
//     var
//         HistFactCompra: Record "Purch. Inv. Header";
//         HistAbonCompra: Record "Purch. Cr. Memo Hdr.";
//         HistFactVenta: Record "Sales Invoice Header";
//         HistAbonVenta: Record "Sales Cr.Memo Header";
//         MovRetencion2: record "EXC Retention Tax registers";
//         MovRetencion3: record "EXC Retention Tax registers";
//         MovRetencion4: record "EXC Retention Tax registers";
//         CurrExchRate: record "Currency Exchange Rate";
//         Abono: Boolean;
//         VNumMovReten: integer;
//     begin
//         MovRetencion2.LockTable();
//         MovRetencion2.Reset();
//         if MovRetencion2.Find('+') then
//             VNumMovReten := MovRetencion2."Entry No." + 1;

//         MovRetencion3.Reset();
//         if NumMov <> 0 then MovRetencion3.Setrange("Entry No.", NumMov);
//         if MovRetencion3.Find('-') then begin
//             if MovRetencion3."Cust/Vend" = MovRetencion3."Cust/Vend"::Cliente then begin
//                 if NOT HistFactVenta.Get(Ndocuemnto) then
//                     if HistAbonVenta.Get(Ndocuemnto) then Abono := true;
//             end
//             else
//                 if NOT HistFactCompra.Get(Ndocuemnto) then
//                     if HistAbonCompra.Get(Ndocuemnto) then Abono := true;

//             if MovRetencion3."Importe Pendiente" < 0 then
//                 MovRetencion3."Importe Pendiente (DL)" := MovRetencion3."Importe Pendiente (DL)" + ABS(Importep)
//             else
//                 MovRetencion3."Importe Pendiente (DL)" := MovRetencion3."Importe Pendiente (DL)" - ABS(Importep);
//             if MovRetencion3."Importe Pendiente (DL)" = 0 then begin
//                 MovRetencion3.Pendiente := false;
//                 MovRetencion3."Importe Pendiente" := 0;
//             end
//             else
//                 MovRetencion3."Importe Pendiente" := CurrExchRate.ExchangeAmtLCYToFCY(WorkDate(), MovRetencion3."Cód. divisa", MovRetencion3."Importe Pendiente (DL)", CurrExchRate.ExchangeRate(WorkDate(), MovRetencion3."Cód. divisa"));

//             MovRetencion3."Importe a Liquidar" := MovRetencion3."Importe Pendiente";
//             MovRetencion3."Importe a Liquidar (DL)" := MovRetencion3."Importe Pendiente (DL)";
//             MovRetencion3."Liquidado por Movimiento" := FORMAT(VNumMovReten);
//             MovRetencion3.Modify();
//             MovRetencion4.Reset();
//             MovRetencion4 := MovRetencion3;
//             MovRetencion4."Nº documento" := Ndocuemnto;
//             MovRetencion4."Entry No." := VNumMovReten;
//             MovRetencion4."Tipo Documento" := MovRetencion4."Tipo Documento"::" ";
//             MovRetencion4.Description := 'Liq. Retención ' + MovRetencion3."Nº documento";
//             MovRetencion4."Fecha registro" := FechaReg;
//             MovRetencion4."Importe factura iva incl." := 0;
//             MovRetencion4."Base retención" := 0;
//             MovRetencion4."% retención" := 0;
//             MovRetencion4."Nº asiento" := 0;
//             MovRetencion4.Revertido := false;
//             MovRetencion4."Revertido por el movimiento nº" := 0;
//             MovRetencion4."Nº movimiento revertido" := 0;
//             if Abono then begin
//                 if MovRetencion3."Cust/Vend" = MovRetencion3."Cust/Vend"::Cliente then
//                     MovRetencion4."Importe retención (DL)" := ABS(Importep)
//                 else
//                     MovRetencion4."Importe retención (DL)" := -ABS(Importep);
//             end
//             else
//                 if MovRetencion3."Cust/Vend" = MovRetencion3."Cust/Vend"::Cliente then
//                     MovRetencion4."Importe retención (DL)" := -ABS(Importep)
//                 else
//                     MovRetencion4."Importe retención (DL)" := ABS(Importep);

//             MovRetencion4."Cód. divisa" := MovRetencion3."Cód. divisa";
//             MovRetencion4."Importe retención" := CurrExchRate.ExchangeAmtLCYToFCY(WorkDate(), MovRetencion4."Cód. divisa", MovRetencion4."Importe retención (DL)", CurrExchRate.ExchangeRate(WorkDate(), MovRetencion4."Cód. divisa"));
//             MovRetencion4."Importe Pendiente" := 0;
//             MovRetencion4."Importe Pendiente (DL)" := 0;
//             MovRetencion4."Liquidado por Movimiento" := FORMAT(MovRetencion3."Entry No.");
//             MovRetencion4."Importe a Liquidar" := 0;
//             MovRetencion4."Importe a Liquidar (DL)" := 0;
//             MovRetencion4.Pendiente := false;
//             MovRetencion4.Factura := MovRetencion4.Factura::"Con factura";
//             MovRetencion4.Efecto := MovRetencion3.Efecto;
//             MovRetencion4."Tipo Liquidacion" := MovRetencion3."Tipo Liquidacion";
//             MovRetencion4."Liquidado por Movimiento" := FORMAT(MovRetencion3."Entry No.");
//             MovRetencion4."Shortcut Dimension 1 Code" := MovRetencion3."Shortcut Dimension 1 Code";
//             MovRetencion4."Shortcut Dimension 2 Code" := MovRetencion3."Shortcut Dimension 2 Code";
//             MovRetencion4."Shortcut Dimension 3 Code" := MovRetencion3."Shortcut Dimension 3 Code";
//             MovRetencion4."Shortcut Dimension 4 Code" := MovRetencion3."Shortcut Dimension 4 Code";
//             MovRetencion4.Insert();
//         end;
//     end;

//     procedure UltMovRetención(): Integer;
//     VAR
//         AuxMovRetención: Record "EXC Retention Tax registers";
//     begin
//         AuxMovRetención.Reset();
//         if AuxMovRetención.FindLast() then exit(AuxMovRetención."Entry No.");
//     end;

//     procedure PasarDimensionesRet(Ndoc: Code[20]; Nlinea: Integer; UltimoMovRet: Integer; Factura: Boolean; Venta: Boolean);
//     VAR
//         HistFactLinCompra: Record "Purch. Inv. Line";
//         HistFactLinVenta: Record "Sales Invoice Line";
//         HistAbonoLinCompra: Record "Purch. Cr. Memo Line";
//         HistAbonoLinVenta: Record "Sales Cr.Memo Line";
//         RcdMovRet: Record "EXC Retention Tax registers";
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
//         else
//             if Venta then begin
//                 HistAbonoLinVenta.Get(Ndoc, Nlinea);
//                 RcdMovRet."Shortcut Dimension 1 Code" := HistAbonoLinVenta."Shortcut Dimension 1 Code";
//                 RcdMovRet."Shortcut Dimension 2 Code" := HistAbonoLinVenta."Shortcut Dimension 2 Code";
//             end
//             else begin
//                 HistAbonoLinCompra.Get(Ndoc, Nlinea);
//                 RcdMovRet."Shortcut Dimension 1 Code" := HistAbonoLinCompra."Shortcut Dimension 1 Code";
//                 RcdMovRet."Shortcut Dimension 2 Code" := HistAbonoLinCompra."Shortcut Dimension 2 Code";
//             end;

//         RcdMovRet.Modify();
//     end;

//     [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnAfterCheckPurchDoc', '', false, false)]
//     local procedure CrearLineaRetencionPedidoCm(var PurchHeader: Record "Purchase Header")
//     begin
//         if (PurchHeader."Document Type" IN [PurchHeader."Document Type"::Order, PurchHeader."Document Type"::"Return Order"]) AND (PurchHeader."Perception Key" <> '') AND PurchHeader.Invoice then PurchHeader.CreaLinRetencionPedido(PurchHeader);
//     end;

//     [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnAfterDeleteAfterPosting', '', false, false)]
//     local procedure EliminarLineas(PurchHeader: Record "Purchase Header")
//     var
//         PurchLine: record "Purchase Line";
//     begin

//         if (PurchHeader."Document Type" IN [PurchHeader."Document Type"::Order, PurchHeader."Document Type"::"Return Order"]) AND (PurchHeader."Perception Key" <> '') AND PurchHeader.Invoice then begin
//             clear(PurchLine);
//             PurchLine.Setrange("Document Type", PurchHeader."Document Type");
//             PurchLine.Setrange("Document No.", PurchHeader."No.");
//             PurchLine.Setrange("Retention Line", true);
//             PurchLine.DeleteAll();
//         end;
//     end;

//     [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post (Yes/No)", 'OnBeforeConfirmPost', '', false, false)]
//     local procedure ComprobarLineasRetencion(var PurchaseHeader: Record "Purchase Header")
//     var
//         PurchSetup: record "Purchases & Payables Setup";
//     begin
//         if NOT PurchSetup."Post with Job Queue" then begin

//             if (PurchaseHeader."Document Type" = PurchaseHeader."Document Type"::Invoice) AND (PurchaseHeader."Retention Type" <> '') then //++001 IND
//                 CompruebaLinRet(PurchaseHeader);

//             if (PurchaseHeader."Document Type" = PurchaseHeader."Document Type"::"credit memo") AND (PurchaseHeader."Perception Key" <> '') then //++001 IND
//                 CompruebaLinRet(PurchaseHeader);

//         end;
//     end;

//     procedure CompruebaLinRet(CabCompra: Record 38);
//     VAR
//         LinCompra: Record 39;
//         LocalText002: Label 'El proceso se ha interrumpido.';
//         Text001: Label '¿Confirma que desea registrar el/la %1?';
//         LocalText003: Label 'Se va a calcular la retención.';
//     begin
//         clear(LinCompra);
//         LinCompra.Setrange("Document Type", CabCompra."Document Type");
//         LinCompra.Setrange("Document No.", CabCompra."No.");
//         LinCompra.Setrange("Deduction Line", true);
//         if NOT LinCompra.FindFIRST() then
//             if NOT CONFIRM(LocalText003 + Text001, false, CabCompra."Document Type") then ERROR(LocalText002);
//     end;

//     [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post (Yes/No)", 'OnAfterConfirmPost', '', true, true)]
//     local procedure OnAfterConfirmPost_PurchPostYN(PurchaseHeader: Record "Purchase Header")
//     var
//         recpurchline: record "Purchase Line";
//     begin
//         if (PurchaseHeader."Document Type" = PurchaseHeader."Document Type"::Invoice) or (PurchaseHeader."Document Type" = PurchaseHeader."Document Type"::"Credit Memo") then begin
//             recpurchline.Reset();
//             recpurchline.Setrange("Document Type", PurchaseHeader."Document Type");
//             recpurchline.Setrange("Document No.", PurchaseHeader."No.");
//             recpurchline.Setrange("Apply Deduction", true);
//             if recpurchline.FindFIRST() then recpurchline.CrearAutoLinRetencionAlRegistrar(recpurchline);
//         end;
//     end;

//     [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post + Print", 'OnAfterConfirmPost', '', false, false)]
//     local procedure CompruebaLineaRet(PurchaseHeader: Record "Purchase Header")
//     var
//         PurchSetup: record "Purchases & Payables Setup";
//     begin
//         PurchSetup.Get();
//         if NOT PurchSetup."Post & Print with Job Queue" then
//             if (PurchaseHeader."Document Type" = PurchaseHeader."Document Type"::Invoice) AND (PurchaseHeader."Perception Key" <> '') then CompruebaLinRet(PurchaseHeader);
//     end;

//     [EventSubscriber(ObjectType::Table, 38, 'OnAfterValidateEvent', 'Buy-from Vendor No.', false, false)]
//     local procedure ValidarPercepciones(var Rec: Record "Purchase Header")
//     var
//         Vend: record vendor;
//     begin
//         Vend.Reset();
//         if Vend.Get(Rec."Buy-from Vendor No.") then begin
//             Rec."Perception Key" := Vend."Perception Key";
//             Rec."Perception Type" := Vend."Perception Type";
//         end;
//     end;
// }

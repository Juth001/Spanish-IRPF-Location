// namespace Excelia.IRPF;
// using Microsoft.Foundation.Navigate;
// using Microsoft.Finance.GeneralLedger.Journal;
// using Microsoft.Finance.ReceivablesPayables;
// codeunit 86303 "SVT Eventos paginas"
// {
//     [EventSubscriber(ObjectType::Page, page::Navigate, 'OnAfterNavigateFindRecords', '', false, false)]
//     local procedure InsertIntoDocEntryReten(var DocumentEntry: Record "Document Entry"; PostingDateFilter: Text; DocNoFilter: Text)
//     var
//         MovRet: record "EXC Retention Tax registers";
//         Navigate: page Navigate;
//     begin

//         if MovRet.READPERMISSION then begin
//             MovRet.Reset();
//             MovRet.Setcurrentkey("Nº documento", "Fecha registro");
//             MovRet.SETFILTER("Nº documento", DocNoFilter);
//             MovRet.SETFILTER("Fecha registro", PostingDateFilter);
//             Navigate.InsertIntoDocEntry(DocumentEntry, DATABASE::"EXC Retention Tax registers", enum::"Document Entry Document Type"::" ", MovRet.TABLECAPTION, MovRet.COUNT());
//         end;
//     end;

//     [EventSubscriber(ObjectType::Page, page::Navigate, 'OnAfterShowRecords', '', false, false)]
//     local procedure ShowRec(var TempDocumentEntry: Record "Document Entry"; TableID: Integer; PostingDateFilter: Text; ItemTrackingSearch: Boolean; DocNoFilter: Text)
//     var
//         MovRet: record "EXC Retention Tax registers";
//     begin
//         Case TableID OF
//             DATABASE::"EXC Retention Tax registers":
//                 begin
//                     MovRet.Reset();
//                     MovRet.Setcurrentkey("Nº documento", "Fecha registro");
//                     MovRet.SETFILTER("Nº documento", DocNoFilter);
//                     MovRet.SETFILTER("Fecha registro", PostingDateFilter);
//                     PAGE.RUN(0, MovRet);
//                 end;
//         end;
//     end;

//     [EventSubscriber(ObjectType::Page, page::"Cartera Journal", 'OnOpenPageEvent', '', false, false)]
//     local procedure AbrirDiarioRetencion(var Rec: Record "Gen. Journal Line")
//     begin
//     end;
// }

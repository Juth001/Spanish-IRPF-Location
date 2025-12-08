namespace ScriptumVita.IRPF;
codeunit 86303 "IND Eventos paginas"
{
    // version INDRA
    [EventSubscriber(ObjectType::Page, page::Navigate, 'OnAfterNavigateFindRecords', '', false, false)]
    local procedure InsertIntoDocEntryReten(var DocumentEntry: Record "Document Entry"; PostingDateFilter: Text; DocNoFilter: Text)
    var
        MovRet: record "IND Witholding Tax registers";
        Navigate: page Navigate;
    begin
        //TecnoRet
        IF MovRet.READPERMISSION THEN BEGIN
            MovRet.RESET;
            MovRet.SETCURRENTKEY("Nº documento", "Fecha registro");
            MovRet.SETFILTER("Nº documento", DocNoFilter);
            MovRet.SETFILTER("Fecha registro", PostingDateFilter);
            //++ OT2-051963
            //Navigate.InsertIntoDocEntry(DocumentEntry, DATABASE::"IND Witholding Tax registers", 0, MovRet.TABLECAPTION, MovRet.COUNT());
            Navigate.InsertIntoDocEntry(DocumentEntry, DATABASE::"IND Witholding Tax registers", enum::"Document Entry Document Type"::" ", MovRet.TABLECAPTION, MovRet.COUNT());
            //-- OT2-051963
        END;
        //FIN TecnoRet
    end;

    [EventSubscriber(ObjectType::Page, page::Navigate, 'OnAfterNavigateShowRecords', '', false, false)]
    local procedure ShowRec(var TempDocumentEntry: Record "Document Entry"; TableID: Integer; PostingDateFilter: Text; ItemTrackingSearch: Boolean; DocNoFilter: Text)
    var
        MovRet: record "IND Witholding Tax registers";
    begin
        //TecnoRet
        Case TableID OF
            DATABASE::"IND Witholding Tax registers":
                begin
                    MovRet.RESET;
                    MovRet.SETCURRENTKEY("Nº documento", "Fecha registro");
                    MovRet.SETFILTER("Nº documento", DocNoFilter);
                    MovRet.SETFILTER("Fecha registro", PostingDateFilter);
                    PAGE.RUN(0, MovRet);
                end;
        //FIN TecnoRet
        end;
    end;

    [EventSubscriber(ObjectType::Page, page::"Cartera Journal", 'OnOpenPageEvent', '', false, false)]
    local procedure AbrirDiarioRetencion(var Rec: Record "Gen. Journal Line")
    begin
        //IF rec."Liq. retención" then 
    end;
}

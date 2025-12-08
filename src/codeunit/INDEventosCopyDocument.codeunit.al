namespace ScriptumVita.IRPF;
codeunit 86301 "IND Eventos Copy Document"
{
    // version INDRA
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Copy Document Mgt.", 'OnAfterUpdateSalesLine', '', false, false)]
    local procedure CopySalesLine(var ToSalesLine: Record "Sales Line"; var FromSalesLine: Record "Sales Line")
    begin
        //TecnoRet
        ToSalesLine."Tipo Percepción" := FromSalesLine."Tipo Percepción";
        ToSalesLine."Clave Percepción" := FromSalesLine."Clave Percepción";
        ToSalesLine."Lín. retención" := FromSalesLine."Lín. retención";
        //Fin TecnoRet
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Copy Document Mgt.", 'OnAfterUpdatePurchLine', '', false, false)]
    local procedure CopyPurchaseLine(var ToPurchLine: Record "Purchase Line"; var FromPurchLine: Record "Purchase Line")
    begin
        //TecnoRet
        ToPurchLine."Tipo Percepción" := FromPurchLine."Tipo Percepción";
        ToPurchLine."Clave Percepción" := FromPurchLine."Clave Percepción";
        ToPurchLine."Lín. retención" := FromPurchLine."Lín. retención";
        //FIN TecnoRet
    end;
}

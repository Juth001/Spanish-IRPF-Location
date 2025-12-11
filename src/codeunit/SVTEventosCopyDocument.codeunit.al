namespace Excelia.IRPF;
using Microsoft.Sales.Document;
using Microsoft.Utilities;
using Microsoft.Purchases.Document;
codeunit 86301 "SVT Eventos Copy Document"
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Copy Document Mgt.", 'OnAfterUpdateSalesLine', '', false, false)]
    local procedure CopySalesLine(var ToSalesLine: Record "Sales Line"; var FromSalesLine: Record "Sales Line")
    begin
        ToSalesLine."Perception Type" := FromSalesLine."Perception Type";
        ToSalesLine."Perception Key" := FromSalesLine."Perception Key";
        ToSalesLine."Deduction Line" := FromSalesLine."Deduction Line";
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Copy Document Mgt.", 'OnAfterUpdatePurchLine', '', false, false)]
    local procedure CopyPurchaseLine(var ToPurchLine: Record "Purchase Line"; var FromPurchLine: Record "Purchase Line")
    begin
        ToPurchLine."Perception Type" := FromPurchLine."Perception Type";
        ToPurchLine."Perception key" := FromPurchLine."Perception key";
        ToPurchLine."Retention Line" := FromPurchLine."Retention Line";
    end;
}

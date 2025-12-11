namespace Excelia.IRPF;
using Microsoft.Purchases.History;

tableextension 86309 "Purch. InvHeader" extends "Purch. Inv. Header"
{
    fields
    {
        field(86300; "Perception Type"; code[10])
        {
            DataClassification = CustomerContent;
            TableRelation = "EXC Perception Type".Code;
            Caption = 'Perception Type';
            Description = 'Tipo de percepción asociado a este encabezado de compra.';
            ToolTip = 'Muestra el tipo de percepción asociado a este encabezado de compra.';
        }
        field(86301; "Perception Key"; code[10])
        {
            DataClassification = CustomerContent;
            TableRelation = "EXC Perception Keys".Code WHERE("Cust/Vend" = const(Vendor));
            Caption = 'Key Perception';
            Description = 'Clave de percepción asociada a este encabezado de compra.';
            ToolTip = 'Muestra la clave de percepción asociada a este encabezado de compra.';
        }
        field(86302; "IRPF Amount"; Decimal)
        {
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = Sum("Purch. Inv. Line".Amount WHERE("Document No." = FIELD("No."), "Apply Deduction" = const(true)));
            Caption = 'IRPF Amount';
            Description = 'Importe total de IRPF asociado a este encabezado de compra.';
            ToolTip = 'Muestra el importe total de IRPF asociado a este encabezado de compra.';
        }
        field(86303; "Importe IVA incl.IRPF"; Decimal)
        {
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = Sum("Purch. Inv. Line"."Amount Including VAT" WHERE("Document No." = FIELD("No."), "Apply Deduction" = const(true)));
            Caption = 'Amount VAT incl.IRPF';
            Description = 'Importe total de IVA incluido IRPF asociado a este encabezado de compra.';
            ToolTip = 'Muestra el importe total de IVA incluido IRPF asociado a este encabezado de compra.';
        }
    }
}

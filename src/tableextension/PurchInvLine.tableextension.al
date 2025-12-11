namespace Excelia.IRPF;
using Microsoft.Purchases.History;

tableextension 86310 "Purch. Inv.Line" extends "Purch. Inv. Line"
{
    fields
    {
        field(86300; "Apply Deduction"; boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Apply Deduction';
            Description = 'Generar automáticamente la línea de retención para esta línea de compra.';
            ToolTip = 'Indica si se debe generar automáticamente la línea de retención para esta línea de compra.';
        }
        field(86301; "Retention Entry"; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Deduction Entry';
            Description = 'Número de movimiento de retención asociado a esta línea de compra.';
            ToolTip = 'Muestra el número de movimiento de retención asociado a esta línea de compra.';
        }
        field(86302; "Perception Type"; Code[10])
        {
            DataClassification = CustomerContent;
            TableRelation = "EXC Perception Type".Code;
            Caption = 'Perception Type';
            Description = 'Tipo de percepción asociado a esta línea de compra.';
            ToolTip = 'Muestra el tipo de percepción asociado a esta línea de compra.';
        }
        field(86303; "Perception key"; code[10])
        {
            DataClassification = CustomerContent;
            TableRelation = "EXC Perception Keys".Code WHERE("Cust/Vend" = const(Vendor));
            Caption = 'Perception key';
            Description = 'Clave de percepción asociada a esta línea de compra.';
            ToolTip = 'Muestra la clave de percepción asociada a esta línea de compra.';
        }
        field(86304; "Retention Line"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Deduction Line';
            Description = 'Indica si esta línea de compra es una línea de retención.';
            ToolTip = 'Indica si esta línea de compra es una línea de retención.';
        }
        field(86305; "Retention Account"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Retention Account';
            Description = 'Indica si la cuenta de la línea de compra es de retención.';
            ToolTip = 'Indica si la cuenta de la línea de compra es de retención.';
        }
        field(86306; "IRPF %"; Decimal)
        {
            DataClassification = CustomerContent;
            Editable = false;
            Caption = 'IRPF %';
            Description = 'Porcentaje de retención IRPF aplicado a esta línea de compra.';
            ToolTip = 'Muestra el porcentaje de retención IRPF aplicado a esta línea de compra.';
        }
    }
}

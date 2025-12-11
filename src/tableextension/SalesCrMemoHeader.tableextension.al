namespace Excelia.IRPF;
using Microsoft.Sales.History;

tableextension 86314 "Sales Cr.Memo Header" extends "Sales Cr.Memo Header"
{
    fields
    {
        field(86300; "Type Perception"; code[10])
        {
            DataClassification = CustomerContent;
            TableRelation = "EXC Perception Type".Code;
            Caption = 'Type Perception';
        }
        field(86301; "Key Perception"; code[10])
        {
            DataClassification = CustomerContent;
            TableRelation = "EXC Perception Keys".Code WHERE("Cust/Vend" = const(Customer));
            Caption = 'Key Perception';
        }
    }
}

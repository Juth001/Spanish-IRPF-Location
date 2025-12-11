namespace Excelia.IRPF;
using Microsoft.Purchases.History;
tableextension 86311 "Purch. RcptHeader" extends "Purch. Rcpt. Header"
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
            TableRelation = "EXC Perception Keys".Code WHERE("Cust/Vend" = const(Vendor));
            Caption = 'Key Perception';
        }
    }
}

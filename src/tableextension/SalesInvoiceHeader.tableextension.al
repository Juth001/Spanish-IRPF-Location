namespace Excelia.IRPF;
using Microsoft.Sales.History;
tableextension 86317 "Sales Invoice Header" extends "Sales Invoice Header"
{
    fields
    {
        field(86300; "Tipo Percepción"; code[10])
        {
            DataClassification = CustomerContent;
            TableRelation = "EXC Perception Type".Code;
            //CaptionML = ENU = 'Type Perception', ESP = 'Tipo Percepcion';
            Caption = 'Tipo Percepcion'; //'Type Perception';
        }
        field(86301; "Clave Percepción"; code[10])
        {
            DataClassification = CustomerContent;
            TableRelation = "EXC Perception Keys".Code WHERE("Cust/Vend" = const(Customer));
            //CaptionML = ENU = 'Key Perception', ESP = 'Clave Percepción';
            Caption = 'Clave Percepción'; //'Key Perception';
        }
    }
}

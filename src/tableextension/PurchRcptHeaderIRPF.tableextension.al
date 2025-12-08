namespace ScriptumVita.IRPF;
tableextension 86311 "Purch. RcptHeader_IRPF" extends "Purch. Rcpt. Header"
{
    fields
    {
        field(50500; "Tipo Percepción"; code[10])
        {
            DataClassification = CustomerContent;
            TableRelation = "IND Perception Type (IRPF)"."Código";
            //Caption = 'Type Perception', ESP = 'Tipo Percepcion';
            Caption = 'Tipo Percepcion'; //'Type Perception';
        }
        field(50501; "Clave Percepción"; code[10])
        {
            DataClassification = CustomerContent;
            TableRelation = "IND Perception Keys (IRPF)"."Código" WHERE("Cli/Prov" = CONST(Proveedor));
            //CaptionML = ENU = 'Key Perception', ESP = 'Clave Percepción';
            Caption = 'Clave Percepción'; //'Key Perception';
        }
    }
}

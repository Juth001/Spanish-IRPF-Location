namespace ScriptumVita.IRPF;
tableextension 86317 "Sales Invoice Header_IRPF" extends "Sales Invoice Header"
{
    fields
    {
        field(60502; "Tipo Percepción"; code[10])
        {
            DataClassification = CustomerContent;
            TableRelation = "IND Perception Type (IRPF)"."Código";
            //CaptionML = ENU = 'Type Perception', ESP = 'Tipo Percepcion';
            Caption = 'Tipo Percepcion'; //'Type Perception';
        }
        field(60503; "Clave Percepción"; code[10])
        {
            DataClassification = CustomerContent;
            TableRelation = "IND Perception Keys (IRPF)"."Código" WHERE("Cli/Prov" = CONST(Cliente));
            //CaptionML = ENU = 'Key Perception', ESP = 'Clave Percepción';
            Caption = 'Clave Percepción'; //'Key Perception';
        }
    }
}

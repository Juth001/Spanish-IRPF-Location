namespace ScriptumVita.IRPF;
tableextension 86308 "Purch. CrMemoLine_IRPF" extends "Purch. Cr. Memo Line"
{
    fields
    {
        field(60500; "Mov. retención"; Integer)
        {
            DataClassification = CustomerContent;
            //CaptionML = ENU = 'Deduction Entry', ESP = 'Mov. retención';
            Caption = 'Mov. retención'; //''Deduction Entry';
        }
        field(60501; "Tipo Percepción"; Code[10])
        {
            DataClassification = CustomerContent;
            TableRelation = "IND Perception Type (IRPF)"."Código";
            //CaptionML = ENU = 'Perception Type', ESP = 'Tipo Percepción';
            Caption = 'Tipo Percepción'; //'Perception Type';
        }
        field(60502; "Clave Percepción"; code[10])
        {
            DataClassification = CustomerContent;
            TableRelation = "IND Perception Keys (IRPF)"."Código" WHERE("Cli/Prov" = CONST(Proveedor));
            //Caption  = 'Perception key', ESP = 'Clave Percepción';
            Caption = 'Clave percepción'; //'Perception key';
        }
        field(60503; "Lín. retención"; Boolean)
        {
            DataClassification = CustomerContent;
            //CaptionML = ENU = 'Deduction Line', ESP = 'Lín. retención';
            Caption = 'Lín. retención'; //'Deduction Line';
        }
        field(60504; "Cuenta de Retención"; Boolean)
        {
            DataClassification = CustomerContent;
            //CaptionML = ENU = 'Retention Account', ESP = 'Cuenta de Retención';
            Caption = 'Cuenta de retención'; //'Retention Account';
        }
        field(60505; "Porc.IRPF"; Decimal)
        {
            DataClassification = CustomerContent;
            Editable = false;
            Caption = '% IRPF';
        }
    }
}

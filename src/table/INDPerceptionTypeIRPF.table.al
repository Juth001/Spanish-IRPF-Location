namespace ScriptumVita.IRPF;
table 86302 "IND Perception Type (IRPF)"
{
    // version INDRA
    DataClassification = CustomerContent;
    LookupPageId = "IND Subform Perception Type";
    DrillDownPageId = "IND Subform Perception Type";

    fields
    {
        field(1; Código; Code[10])
        {
            DataClassification = CustomerContent;
            //CaptionML = ENU = 'Code', ESP = 'Código';
            Caption = 'Código'; //'Code';
        }
        field(2; Descripción; Text[30])
        {
            DataClassification = CustomerContent;
            //CaptionML = ENU = 'Description', ESP = 'Descripción';
            Caption = 'Descripción'; //'Description';
        }
    }
    keys
    {
        key(PK; "Código")
        {
            Clustered = true;
        }
    }
    trigger OnInsert()
    begin
    end;

    trigger OnModify()
    begin
    end;

    trigger OnDelete()
    begin
    end;

    trigger OnRename()
    begin
    end;
}

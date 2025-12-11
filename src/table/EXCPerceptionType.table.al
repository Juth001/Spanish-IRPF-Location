namespace Excelia.IRPF;
table 86302 "EXC Perception Type"
{
    DataClassification = CustomerContent;
    LookupPageId = "EXC Subform Perception Type";
    DrillDownPageId = "EXC Subform Perception Type";

    fields
    {
        field(86302; Code; Code[10])
        {
            DataClassification = CustomerContent;
            AllowInCustomizations = AsReadOnly;
            Caption = 'Code';
        }
        field(86303; Description; Text[30])
        {
            DataClassification = CustomerContent;
            AllowInCustomizations = AsReadOnly;
            Caption = 'Description';
        }
    }
    keys
    {
        key(PK; Code)
        {
            Clustered = true;
        }
    }
}

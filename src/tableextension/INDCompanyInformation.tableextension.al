namespace ScriptumVita.IRPF;
tableextension 86304 "IND Company Information" extends "Company Information"
{
    fields
    {
        field(60500; "Código administración mod. 110"; code[5])
        {
            DataClassification = CustomerContent;
            //Caption = 'Código administración mod. 110', ESP = 'Código administración mod. 110';
            Caption = 'Código administración mod. 110';
        }
    }
}

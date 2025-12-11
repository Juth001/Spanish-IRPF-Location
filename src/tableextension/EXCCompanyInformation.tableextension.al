namespace Excelia.IRPF;
using Microsoft.Foundation.Company;

tableextension 86304 "EXC Company Information" extends "Company Information"
{
    fields
    {
        field(86300; "Código administración mod. 110"; code[5])
        {
            DataClassification = CustomerContent;
            Caption = 'Código administración mod. 110';
        }
    }
}

namespace ScriptumVita.IRPF;
tableextension 86303 "G_L Account_IRPF" extends "G/L Account"
{
    fields
    {
        field(60500; "Tipo Cuenta retención"; Option)
        {
            DataClassification = CustomerContent;
            OptionMembers = " ","Proveedor","Cliente";
            Caption = 'Tipo Cuenta Retención'; //'Account type Deduction';
            OptionCaption = ' ,Proveedor,Cliente'; //' ,Vendor,Customer';
                                                   //OptionCaptionML = ENU = ' ,Vendor,Customer', ESP = ' ,Proveedor,Cliente';
                                                   //CaptionML = ENU = 'Account type Deduction', ESP = 'Tipo Cuenta Retención';
        }
    }
}

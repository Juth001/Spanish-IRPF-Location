namespace Excelia.IRPF;
using Microsoft.Foundation.NoSeries;
using Microsoft.Finance.GeneralLedger.Account;

table 86301 "EXC Perception Keys"
{
    DataClassification = CustomerContent;
    LookupPageId = "EXC Subform Perception Keys";
    DrillDownPageId = "EXC Subform Perception Keys";

    fields
    {
        field(86301; "Code"; Code[10])
        {
            DataClassification = CustomerContent;
            Caption = 'Code';
            Description = 'Código de la clave de percepción.';
            ToolTip = 'Muestra el código de la clave de percepción.';
        }
        field(86302; "Description"; Text[30])
        {
            DataClassification = CustomerContent;
            Caption = 'Description';
            Description = 'Descripción de la clave de percepción.';
            ToolTip = 'Muestra la descripción de la clave de percepción.';
        }
        field(86303; "Retention %"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Retention %';
            Description = 'Porcentaje de retención asociado a esta clave de percepción.';
            ToolTip = 'Muestra el porcentaje de retención asociado a esta clave de percepción.';
        }
        field(86304; "Retention Acc."; text[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Deduction Acc';
            //TODO: TableRelation = if ("Cust/Vend" = const(Customer)) "G/L Account"."No." where("Tipo Cuenta Retención" = const(Cliente))
            //TODO: else if ("Cli/Prov" = const(Proveedor)) "G/L Account"."No." where("Tipo Cuenta retención" = const(Proveedor));
            Description = 'Cuenta de mayor utilizada para registrar las retenciones asociadas a esta clave de percepción.';
            ToolTip = 'Muestra la cuenta de mayor utilizada para registrar las retenciones asociadas a esta clave de percepción.';
        }
        field(86305; "Perception Type"; Option)
        {
            DataClassification = CustomerContent;
            OptionMembers = "Cash","In-kind","Withheld imputed income";
            OptionCaption = 'Cash,Species,Entry into account impact';
            Caption = 'Perception Type';
            Description = 'Tipo de percepción asociado a esta clave de percepción.';
            ToolTip = 'Muestra el tipo de percepción asociado a esta clave de percepción.';
        }
        field(86306; "Calculation Type"; Option)
        {
            DataClassification = CustomerContent;
            OptionMembers = "Base","Base+VAT";
            OptionCaption = 'Base,Base+VAT';
            Caption = 'Calculation Type';
            Description = 'Tipo de cálculo utilizado para determinar la base de la retención asociada a esta clave de percepción.';
            ToolTip = 'Muestra el tipo de cálculo utilizado para determinar la base de la retención asociada a esta clave de percepción.';
        }
        field(86307; "IRPF Key"; Option)
        {
            DataClassification = CustomerContent;
            OptionMembers = " ","A","B","C","D","E","F","G","H","I","J","K","L","19";
            OptionCaption = ' ,A,B,C,D,E,F,G,H,I,J,K,L,19';
            Caption = 'IRPF Key';
            Description = 'Clave IRPF asociada a esta clave de percepción.';
            ToolTip = 'Muestra la clave IRPF asociada a esta clave de percepción.';
        }
        field(86308; "IRPF SubKey"; Option)
        {
            DataClassification = CustomerContent;
            OptionMembers = " ","01","02","03","04","05","06","07","08","09","10","11","12","13","14","15","16";
            OptionCaption = ' ,01,02,03,04,05,06,07,08,09,10,11,12,13,14,15,16';
            Caption = 'IRPF SubKey';
            Description = 'Subclave IRPF asociada a esta clave de percepción.';
            ToolTip = 'Muestra la subclave IRPF asociada a esta clave de percepción.';
        }
        field(86309; "Cust/Vend"; Option)
        {
            DataClassification = CustomerContent;
            OptionMembers = "Customer","Vendor";
            OptionCaption = 'Customer,Vendor';
            Caption = 'Cust/Vend';
            Description = 'Indica si esta clave de percepción es para clientes o proveedores.';
            ToolTip = 'Muestra si esta clave de percepción es para clientes o proveedores.';
        }
        field(86310; "Retention Type"; Option)
        {
            DataClassification = CustomerContent;
            OptionMembers = "Rent","Guaranty","Professional","Others";
            OptionCaption = 'Rent,Guaranty,Professional,Others';
            Caption = 'Retention Type';
            Description = 'Tipo de retención asociado a esta clave de percepción.';
            ToolTip = 'Muestra el tipo de retención asociado a esta clave de percepción.';
        }
        field(86311; "IRPF Series No."; Code[20])
        {
            Caption = 'IRPF Series No.';
            TableRelation = "No. Series";
            DataClassification = CustomerContent;
            Description = 'Número de serie utilizado para las retenciones IRPF asociadas a esta clave de percepción.';
            ToolTip = 'Muestra el número de serie utilizado para las retenciones IRPF asociadas a esta clave de percepción.';
        }
    }
    keys
    {
        key(PK; Code)
        {
            Clustered = true;
        }
    }
    fieldgroups
    {
        fieldgroup(DropDown; Code, Description)
        {
        }
    }
}

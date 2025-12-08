namespace ScriptumVita.IRPF;
table 86301 "IND Perception Keys (IRPF)"
{
    // version INDRA
    DataClassification = CustomerContent;
    LookupPageId = "IND Subform Perception Keys";
    DrillDownPageId = "IND Subform Perception Keys";

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
        field(3; "% Retención"; Decimal)
        {
            DataClassification = CustomerContent;
            //CaptionMl = ENU = '% Deduction', ESP = '% Retención';
            Caption = '% retención'; //'% Deduction';
        }
        field(4; "Cta. retención"; text[20])
        {
            DataClassification = CustomerContent;
            //CaptionMl = ENU = 'Deduction Acc', ESP = 'Cta. retención';
            Caption = 'Cta. retención'; //'Deduction Acc';
            TableRelation = if ("Cli/Prov" = const(Cliente)) "G/L Account"."No." where("Tipo Cuenta Retención" = const(Cliente))
            else if ("Cli/Prov" = const(Proveedor)) "G/L Account"."No." where("Tipo Cuenta retención" = const(Proveedor));
        }
        field(5; "Tipo percepción"; Option)
        {
            DataClassification = CustomerContent;
            OptionMembers = "Dineraria","Especie","Ingreso a cuenta repercutido";
            //OptionCaptionML = ENU = 'Cash,Species,Entry into account impact', ESP = 'Dineraria,Especie,Ingreso a cuenta repercutido';
            OptionCaption = 'Dineraria,Especie,Ingreso a cuenta repercutido'; //'Cash,Species,Entry into account impact';
            //CaptionML = ENU = 'Perception Type', ESP = 'Tipo percepción';
            Caption = 'Tipo percepción'; //'Perception Type';
        }
        field(6; "Tipo cálculo"; Option)
        {
            DataClassification = CustomerContent;
            OptionMembers = "Base","Base+Iva";
            //OptionCaptionML = ENU = 'Base,Base+VAT', ESP = 'Base,Base+IVA';
            OptionCaption = 'Base,Base+IVA'; //'Base,Base+VAT';
            //CaptionML = ENU = 'Calculation Type', ESP = 'Tipo cálculo';
            Caption = 'Tipo cálculo'; //'Calculation Type';
        }
        field(7; "Clave IRPF"; Option)
        {
            DataClassification = CustomerContent;
            OptionMembers = " ","A","B","C","D","E","F","G","H","I","J","K","L","19";
            //OptionCaptionML = ENU = ' ,A,B,C,D,E,F,G,H,I,J,K,L,19', ESP = ' ,A,B,C,D,E,F,G,H,I,J,K,L,19';            
            OptionCaption = ' ,A,B,C,D,E,F,G,H,I,J,K,L,19';
            //CaptionML = ENU = 'IRPF Key', ESP = 'Clave IRPF';
            Caption = 'Clave IRPF'; //'IRPF Key';
        }
        field(8; "Subclave IRPF"; Option)
        {
            DataClassification = CustomerContent;
            OptionMembers = " ","01","02","03","04","05","06","07","08","09","10","11","12","13","14","15","16";
            //OptionCaptionML = ENU = ' ,01,02,03,04,05,06,07,08,09,10,11,12,13,14,15,16', ESP = ' ,01,02,03,04,05,06,07,08,09,10,11,12,13,14,15,16';
            OptionCaption = ' ,01,02,03,04,05,06,07,08,09,10,11,12,13,14,15,16';
            //CaptionML = ENU = 'IRPF SubKey', ESP = 'Subclave';
            Caption = 'Subclave IRPF'; //'IRPF SubKey';
        }
        field(9; "Cli/Prov"; Option)
        {
            DataClassification = CustomerContent;
            OptionMembers = "Cliente","Proveedor";
            //OptionCaptionML = ENU = 'Customer,Vendor', ESP = 'Cliente,Proveedor';
            OptionCaption = 'Cliente,Proveedor'; //'Customer,Vendor';
            //CaptionML = ENU = 'Cust/Vend', ESP = 'Cli/Prov';
            Caption = 'Cli/Prov'; //'Cust/Vend';
        }
        field(10; "Tipo Retención"; Option)
        {
            DataClassification = CustomerContent;
            OptionMembers = "Alquiler","Garantía","Profesionales","Otros";
            //OptionCaptionML = ENU = 'Rent,Guaranty,Professional,Others', ESP = 'Alquiler,Garantía,Profesionales,Otros';
            OptionCaption = 'Alquiler,Garantía,Profesionales,Otros'; //'Rent,Guaranty,Professional,Others';
            //CaptionML = ENU = 'Deduction Type', ESP = 'Tipo Retención';
            //CaptionML = ENU = 'Deduction Type', ESP = 'Tipo Retención';
            Caption = 'Tipo retención'; //'Deduction Type';
        }
        //REQ_FIN011
        field(50000; "No. serie IRPF"; Code[20])
        {
            //CaptionML = ENU = 'IRPF Series No.', ESP = 'Nº serie IRPF';
            Caption = 'Nº serie IRPF'; //'IRPF Series No.';
            TableRelation = "No. Series";
        }
    }
    keys
    {
        key(PK; "Código")
        {
            Clustered = true;
        }
    }
    fieldgroups
    {
        fieldgroup(DropDown; "Código", "Descripción")
        {
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

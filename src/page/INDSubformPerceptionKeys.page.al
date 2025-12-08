namespace ScriptumVita.IRPF;
page 86300 "IND Subform Perception Keys"
{
    // version INDRA
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "IND Perception Keys (IRPF)";
    DelayedInsert = true;
    //CaptionML = ENU = 'Subform Perception Keys (IRPF)'; //Claves percepcion
    Caption = 'Subform Perception Keys (IRPF)';

    layout
    {
        area(Content)
        {
            repeater(Perception)
            {
                field("Código"; "Código")
                {
                    ApplicationArea = All;
                }
                field("Descripción"; "Descripción")
                {
                    ApplicationArea = All;
                }
                field("Cli/Prov"; "Cli/Prov")
                {
                    ApplicationArea = All;
                }
                field("% Retención"; "% Retención")
                {
                    ApplicationArea = All;
                }
                field("Cta. retención"; "Cta. retención")
                {
                    ApplicationArea = All;
                }
                field("Tipo percepción"; "Tipo percepción")
                {
                    ApplicationArea = All;
                }
                field("Tipo cálculo"; "Tipo cálculo")
                {
                    ApplicationArea = All;
                }
                field("Clave IRPF"; "Clave IRPF")
                {
                    ApplicationArea = All;
                }
                field("Subclave IRPF"; "Subclave IRPF")
                {
                    ApplicationArea = All;
                }
                field("Tipo Retención"; "Tipo Retención")
                {
                    ApplicationArea = All;
                }
                //REQ_FIN011
                field("No. serie IRPF"; "No. serie IRPF")
                {
                    ApplicationArea = all;
                }
            }
        }
    }
}

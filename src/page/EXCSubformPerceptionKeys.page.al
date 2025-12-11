namespace Excelia.IRPF;

page 86300 "EXC Subform Perception Keys"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "EXC Perception Keys";
    DelayedInsert = true;
    Caption = 'Subform Perception Keys';

    layout
    {
        area(Content)
        {
            repeater(Perception)
            {
                field("Code"; Rec.Code)
                {
                    ApplicationArea = All;
                }
                field("Description"; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field("Cust/Vend"; Rec."Cust/Vend")
                {
                    ApplicationArea = All;
                }
                field("% Retención"; Rec."Retention %")
                {
                    ApplicationArea = All;
                }
                field("Cta. retención"; Rec."Retention Acc.")
                {
                    ApplicationArea = All;
                }
                field("Tipo percepción"; Rec."Perception Type")
                {
                    ApplicationArea = All;
                }
                field("Tipo cálculo"; Rec."Calculation Type")
                {
                    ApplicationArea = All;
                }
                field("Clave IRPF"; Rec."IRPF Key")
                {
                    ApplicationArea = All;
                }
                field("Subclave IRPF"; Rec."IRPF SubKey")
                {
                    ApplicationArea = All;
                }
                field("Tipo Retención"; Rec."Retention Type")
                {
                    ApplicationArea = All;
                }
                field("No. serie IRPF"; Rec."IRPF Series No.")
                {
                    ApplicationArea = all;
                }
            }
        }
    }
}


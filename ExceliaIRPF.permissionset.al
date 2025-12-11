namespace Excelia.IRPF;

using Excelia.IRPF;

permissionset 86300 "Excelia.IRPF"
{
    Assignable = true;
    Permissions = tabledata "EXC Aux. liq mov. retención"=RIMD,
        tabledata "EXC Perception Keys"=RIMD,
        tabledata "EXC Perception Type"=RIMD,
        tabledata "EXC Retention Tax registers"=RIMD,
        table "EXC Aux. liq mov. retención"=X,
        table "EXC Perception Keys"=X,
        table "EXC Perception Type"=X,
        table "EXC Retention Tax registers"=X,
        report "EXC Client- Dec. Anual_Reten"=X,
        report "IND Modelo 190"=X,
        report "IND Retenciones IRPF"=X,
        report "SVT Prov - Dec. Anual_Reten"=X,
        codeunit "SVT Eventos Copy Document"=X,
        page "EXC Retention Journal"=X,
        page "EXC Retention Tax Registers"=X,
        page "EXC Subform Perception Keys"=X,
        page "EXC Subform Perception Type"=X;
}
// namespace Excelia.IRPF;
// using System.Utilities;
// report 86303 "IND Modelo 111"
// {
//     // version INDRA
//     UsageCategory = ReportsAndAnalysis;
//     ApplicationArea = All;
//     //CaptionML = ENU = 'Modelo 111', ESP = 'Modelo 111';
//     Caption = 'Modelo 111';
//     ProcessingOnly = true;

//     dataset
//     {
//         dataitem("INDRA Witholding Tax registers"; "EXC Retention Tax registers")
//         {
//             DataItemTableView = SORTING("Entry No.") ORDER(Ascending) WHERE(Pendiente = const(true), "Tipo Retención" = const(Profesionales), "Cust/Vend" = const(Proveedor));

//             trigger OnPreDataItem()
//             begin
//                 ConfConta.Get();
//                 tempblob.CreateOutStream(OutStr);
//                 InfoEmprev.Get();
//                 if TipoPeriodo = TipoPeriodo::Trimestral then begin
//                     CASE Periodo OF
//                         Periodo::"1T":
//                             begin
//                                 FechaIni := DMY2DATE(1, 1, Ejercicio);
//                                 FechaFin := DMY2DATE(31, 3, Ejercicio);
//                                 Setrange("Fecha registro", FechaIni, FechaFin);
//                             end;
//                         Periodo::"2T":
//                             begin
//                                 FechaIni := DMY2DATE(1, 4, Ejercicio);
//                                 FechaFin := DMY2DATE(30, 6, Ejercicio);
//                                 Setrange("Fecha registro", FechaIni, FechaFin);
//                             end;
//                         Periodo::"3T":
//                             begin
//                                 FechaIni := DMY2DATE(1, 7, Ejercicio);
//                                 FechaFin := DMY2DATE(30, 9, Ejercicio);
//                                 Setrange("Fecha registro", FechaIni, FechaFin);
//                             end;
//                         Periodo::"4T":
//                             begin
//                                 FechaIni := DMY2DATE(1, 10, Ejercicio);
//                                 FechaFin := DMY2DATE(31, 12, Ejercicio);
//                                 Setrange("Fecha registro", FechaIni, FechaFin);
//                             end;
//                     end;
//                 end
//                 else begin
//                     FechaIni := DMY2DATE(1, PeriodoMeses + 1, Ejercicio);
//                     FechaFin := CALCDATE('<CM>', FechaIni);
//                     Setrange("Fecha registro", FechaIni, FechaFin);
//                 end;
//                 NoRegDistinto0 := 0;
//                 BaseReten := 0;
//                 ImporteReten := 0;
//                 NoRegDistinto0 := 0;
//                 BaseRetenIgualCero := 0;
//                 SETFILTER(País, InfoEmprev."Country/Region Code");
//                 if NOT VBanco then clear(TBanco);
//             end;

//             trigger OnAfterGetRecord()
//             begin
//                 if "% retención" <> 0 then begin
//                     NoRegDistinto0 += 1;
//                     BaseReten += "Base retención";
//                     ImporteReten += "Importe retención";
//                 end
//                 else begin
//                     NoRegIgual0 += 1;
//                     BaseRetenIgualCero += "Base retención";
//                 end;
//             end;

//             trigger OnPostDataItem()
//             begin
//                 CASE TipoDec OF
//                     TipoDec::Ingreso:
//                         TipoD := 'I';
//                     TipoDec::Negativa:
//                         TipoD := 'N';
//                     TipoDec::"Domiciliación del ingreso en CCC":
//                         TipoD := 'U';
//                     TipoDec::"Cuenta corriente tributaria-ingreso":
//                         TipoD := 'G';
//                 end;
//                 TextoEfectivo := ' ';
//                 TextoBanco := ' ';
//                 //001 Exportamos el per¡odo
//                 if TipoPeriodo = TipoPeriodo::Mensual then
//                     PeriodoExportar := FORMAT(PeriodoMeses)
//                 else
//                     PeriodoExportar := FORMAT(Periodo);
//                 if VEfectivo then TextoEfectivo := 'X';
//                 if VBanco then TextoBanco := 'X';
//                 //002 ampliamos el registro exportado
//                 TextoSalida := '<T1110' + PADSTR(FORMAT(Ejercicio), 4, ' ') + PADSTR(FORMAT(PeriodoExportar), 2, ' ') + '0000><AUX>';
//                 TextoSalida := TextoSalida + PADSTR(' ', 300, ' ') + '</AUX>';
//                 //<T111020151T0000><AUX>
//                 //Registro
//                 TextoSalida := TextoSalida + '<T11101000>' + //Concepto fiscal y pagina
//  ' ' + //Indicador de p gina complementaria
//  TipoD + //Tipo declaraci¢n
//          //InfoEmprev."C¢digo administraci¢n mod. 110" +               //C¢digo administraci¢n
// PADSTR(InfoEmprev."VAT Registration No.", 9, ' ') + //NIF
//                                                     //PADSTR(' ',4,' ') +                                         //Comienzo primer apellido
//                                                     //PADSTR(InfoEmprev.Name,30,' ') +                            //Nombre empresa
//                                                     //PADSTR('',15,' ') +                                         //Nombre
// PADSTR(Ascii2Ansi(InfoEmprev.Name), 60, ' ') + //Nombre empresa Identificaci¢n. Sujeto pasivo. Denominaci¢n o Apellidos
//  PADSTR(' ', 20, ' ') + //Nombre
//  PADSTR(FORMAT(Ejercicio), 4, ' ') + //Ejercicio
//                                      //JPG cambiamos el periodo de trimestral a mensual
//     PADSTR(FORMAT(PeriodoExportar), 2, ' ') + //Periodo --> en mes o trimestre
//  AjustaNum(NPerceptores, 8, 0) + //No. perceptores [1]
//  AjustaNum(ImpPerRendTrab, 17, 2) + //Importe percepciones rendimientos trabajo [2]
//  AjustaNum(ImpRetRendTrab, 17, 2) + //Importe retenciones rendimientos trabajo [3]
//  AjustaNum(0, 8, 2) + //No. perceptores en especie [4]
//  AjustaNum(0, 17, 2) + //Valor percep. especie [5]
//  AjustaNum(0, 17, 2) + //Importe ingresos a la cta. [6]
//  PADSTR('', 8 - STRLEN(FORMAT(NProveedores())), '0') + FORMAT(NProveedores()) + //No. perceptores dinerarios [7]
//  AjustaNum(BaseReten, 17, 2) + //Importe percepciones rendimientos trabajo [8]
//  AjustaNum(ImporteReten, 17, 2) + //Importe retenciones rendimientos trabajo [9]
//  AjustaNum(0, 8, 2) + //No. perceptores en especie [10]
//  AjustaNum(0, 17, 2) + //Valor percepci¢n especie [11]
//  AjustaNum(0, 17, 2) + //Importe ingresos a cuenta [12]
//  AjustaNum(0, 8, 2) + //No. perceptores met lico [13]
//  AjustaNum(0, 17, 2) + //Importe percepciones met lico [14]
//  AjustaNum(0, 17, 2) + //Importe retenciones met lico [15]
//  AjustaNum(0, 8, 2) + //No. perceptores en especie premios [16]
//  AjustaNum(0, 17, 2) + //Valor percepciones especie [17]
//  AjustaNum(0, 17, 2) + //Importe ingresos a cuenta en especie [18]
//  AjustaNum(0, 8, 2) + //No. perceptores ganancias [19]
//  AjustaNum(0, 17, 2) + //Importe percepciones ganancias [20]
//  AjustaNum(0, 17, 2) + //Importe retenciones ganancias [21]
//  AjustaNum(0, 8, 2) + //No. perceptores en especie ganancias patrim [22]
//  AjustaNum(0, 17, 2) + //Importe percepciones ganancias patrimoniales [23]
//  AjustaNum(0, 17, 2) + //Importe retenciones ganancias patrimoniales [24]
//  AjustaNum(0, 8, 2) + //No. perceptores cesi¢n derechos de imagen [25]
//  AjustaNum(0, 17, 2) + //Contraprestaciones satisfechas [26]
//  AjustaNum(0, 17, 2) + //Importe de ingresos a cuenta [27]
//  AjustaNum(ABS(ImpRetRendTrab) + ABS(ImporteReten), 17, 2) + //Suma retenciones e ingresos a cuenta
//  AjustaNum(0, 17, 2) + //Resultado anteriores declaraciones
//  AjustaNum(ABS(ImpRetRendTrab) + ABS(ImporteReten), 17, 2) + //Resultado a ingresar [30]
//                                                              //TextoEfectivo +                                             //Ingreso forma de pago en efectivo
//                                                              //TextoBanco +                                                //Forma de pago de adeudo en cuenta
//                 PADSTR(TBanco."No.", 4, ' ') + //Entidad
//  PADSTR(TBanco."CCC Bank Branch No.", 4, ' ') + //Sucursal
//  PADSTR(TBanco."CCC Control Digits", 2, ' ') + //D¡gito control
//  PADSTR(TBanco."CCC Bank Account No.", 10, ' ') + //N£mero de cuenta
//  PADSTR(' ', 13, ' ') + //N£mero de justificante
//  PADSTR(' ', 16, ' ') + //Reservado Administracion
//  PADSTR(' ', 1, ' ') + //Declaraci¢n complementaria
//  PADSTR(' ', 100, ' ') + //PADSTR(PersonaContacto,100,' ') +                           //Persona de contacto
//  PADSTR(' ', 9, ' ') + //PADSTR(TelefonoContacto,9,' ') +                            //Telefono de contacto
//  PADSTR(' ', 9, ' ') + //Movil de contacto
//  PADSTR(' ', 50, ' ') + //Correo electronico
//  PADSTR(' ', 13, ' ') + //Reservado para el sello electr¢nico de la AEAT
//  PADSTR(' ', 1, ' ') + //Reservado Administracion
//  PADSTR(' ', 1, ' '); //Reservado Administracion
//                 /*
//                 PADSTR(' ', 350, ' ') +                                       //Observaciones
//                 PADSTR(InfoEmprev.City, 16, ' ') +                            //Firma (7) Localidad
//                 PADSTR(FORMAT(DATE2DMY(WorkDate, 1)), 2, ' ') +                //Firma (7) D¡a
//                 PADSTR(MesLetra(DATE2DMY(WorkDate, 2)), 10, ' ') +             //Firma (7) Mes
//                 PADSTR(FORMAT(DATE2DMY(WorkDate, 3)), 4, ' ') +                //Firma (7) A¤o
//                 */
//                 //FichModelo110.WRITE(TextoSalida);
//                 //**TempFile.WRITE(TextoSalida);
//                 //***
//                 //Outstr.WRITETEXT(TextoSalida);
//                 //***
//                 TextoSalida := TextoSalida + PADSTR(' ', 218, ' ') + //Reservado Administracion
//  '</T11101000>'; //Fin de registro //002 de p gina
//                 //002 terminamos el fichero
//                 TextoSalida := TextoSalida + '</T1110' + PADSTR(FORMAT(Ejercicio), 4, ' ') + PADSTR(FORMAT(PeriodoExportar), 2, ' ') + '0000>';
//                 //**TempFile.WRITE(TextoSalida);
//                 //***
//                 //Outstr.WRITETEXT;
//                 //Outstr.WRITETEXT(TextoSalida);
//                 OutStr.WriteText(TextoSalida);
//                 //***
//                 //***
//                 //OutFile.CLOSE;
//                 tempblob.CreateInStream(InStr);
//                 DownloadFromStream(InStr, '', '', '', Filename);
//                 //FileManagement.DownloadToFile(ServerTempFileName, FileName);
//                 //***
//                 MESSAGE(Text002, FileName);
//                 //***
//             end;
//         }
//     }
//     requestpage
//     {
//         SaveValues = true;

//         layout
//         {
//             area(Content)
//             {
//                 group(File)
//                 {
//                     field(FileName; FileName)
//                     {
//                         ApplicationArea = All;
//                         //CaptionML = ENU = 'File Name', ESP = 'Nombre archivo';
//                         Caption = 'File Name';
//                         /*
//                             trigger OnAssistEdit()
//                             var
//                                 FileMgt: codeunit "File Management";
//                             begin
//                                 if FileName = '' then
//                                     FileName := '.txt';
//                                 FileName := FileMgt.SaveFileDialog(Text003, FileName, '');
//                             end;
//                             */
//                     }
//                     field("Tipo de Declaración"; TipoDec)
//                     {
//                         ApplicationArea = All;
//                         //CaptionML = ENU = 'Declaration Type', ESP = 'Tipo de declaración';
//                         Caption = 'Declaration Type';
//                     }
//                     field(Ejercicio; Ejercicio)
//                     {
//                         ApplicationArea = All;
//                         //Caption= 'Fiscal year', ESP = 'Ejercicio';
//                         Caption = 'Fiscal year';
//                     }
//                     group(Periodo)
//                     {
//                         field(TipoPeriodo; TipoPeriodo)
//                         {
//                             ApplicationArea = All;
//                             //CaptionML = ENU = 'Type', ESP = 'Tipo';
//                             Caption = 'Type';

//                             trigger OnValidate()
//                             begin
//                                 if TipoPeriodo = TipoPeriodo::Mensual then begin
//                                     PeriodoHabilitadoMensual := true;
//                                     PeriodoHabilitadoTrimestral := false;
//                                 end
//                                 else begin
//                                     PeriodoHabilitadoMensual := false;
//                                     PeriodoHabilitadoTrimestral := true;
//                                 end;
//                             end;
//                         }
//                         field("Periodo mensual"; Periodo)
//                         {
//                             ApplicationArea = All;
//                             //CaptionML = ENU = 'Monthly period', ESP = 'Periodo mensual';
//                             Caption = 'Monthly period';
//                             Enabled = PeriodoHabilitadoMensual;
//                         }
//                         field("Periodo trimestral"; Periodo)
//                         {
//                             ApplicationArea = All;
//                             //CaptionML = ENU = 'Trimestral Period', ESP = 'Periodo trimestral';
//                             Caption = 'Trimestral Period';
//                             Enabled = PeriodoHabilitadoTrimestral;
//                         }
//                         field(PersonaContacto; PersonaContacto)
//                         {
//                             ApplicationArea = All;
//                             //CaptionML = ENU = 'Contact person', ESP = 'Persona de contacto';
//                             Caption = 'Contact person';
//                             visible = false;
//                         }
//                         field(TelefonoContacto; TelefonoContacto)
//                         {
//                             ApplicationArea = All;
//                             //CaptionML = ENU = 'Contact Phone', ESP = 'Teléfono de contacto';
//                             Caption = 'Contact Phone';
//                             visible = false;
//                         }
//                         field(NPerceptores; NPerceptores)
//                         {
//                             ApplicationArea = All;
//                             //CaptionML = ENU = 'Perceptor Numbers', ESP = 'Nº Perceptores';
//                             Caption = 'Perceptor Numbers';
//                             visible = false;
//                         }
//                         field(ImpPerRendTrab; ImpPerRendTrab)
//                         {
//                             ApplicationArea = All;
//                             //CaptionML = ENU = 'Perception rend. amount', ESP = 'Importe Percepciones Rendimientos';
//                             Caption = 'Perception rend. amount';
//                         }
//                         field(ImpRetRendTrab; ImpRetRendTrab)
//                         {
//                             ApplicationArea = All;
//                             //Caption = 'Work Ret. amount', ESP = 'Importe Retenciones Movimientos Trabajo';
//                             Caption = 'Work Ret. amount';
//                         }
//                     }
//                     group("Formas de Pago")
//                     {
//                         field(VEfectivo; VEfectivo)
//                         {
//                             ApplicationArea = All;
//                             //CaptionML = ENU = 'Cash', ESP = 'Efectivo';
//                             Caption = 'Cash';

//                             trigger OnValidate()
//                             begin
//                                 if VEfectivo then
//                                     VBanco := false
//                                 else
//                                     VBanco := true;
//                                 if NOT VBanco then
//                                     bolBancoEditable := false
//                                 else
//                                     bolBancoEditable := true;
//                             end;
//                         }
//                         field(VBanco; VBanco)
//                         {
//                             ApplicationArea = All;
//                             //CaptionML = ENU = 'Bank', ESP = 'Banco';
//                             Caption = 'Bank';

//                             trigger OnValidate()
//                             begin
//                                 if VBanco then
//                                     VEfectivo := false
//                                 else
//                                     VEfectivo := true;
//                                 if NOT VBanco then
//                                     bolBancoEditable := false
//                                 else
//                                     bolBancoEditable := true
//                             end;
//                         }
//                         field(CodeBanco; CodeBanco)
//                         {
//                             ApplicationArea = All;
//                             //CaptionML = ENU = 'Bank code', ESP = 'Cód. banco';
//                             Caption = 'Bank code';
//                             Editable = bolBancoEditable;

//                             trigger OnValidate()
//                             begin
//                                 clear(TBanco);
//                                 if TBanco.Get(CodeBanco) then
//                                     NombreBanco := TBanco.Name
//                                 else
//                                     NombreBanco := '';
//                             end;

//                             trigger OnLookup(var text1: text): Boolean
//                             begin
//                                 if VBanco then begin
//                                     clear(FBanco);
//                                     FBanco.SETTABLEVIEW(TBanco);
//                                     FBanco.LOOKUPMODE := true;
//                                     FBanco.SETRECORD(TBanco);
//                                     if FBanco.RUNMODAL() = ACTION::LookupOK then FBanco.GETRECORD(TBanco);
//                                     CodeBanco := TBanco."No.";
//                                     NombreBanco := TBanco.Name;
//                                 end;
//                             end;
//                         }
//                         field(NombreBanco; NombreBanco)
//                         {
//                             ApplicationArea = All;
//                             Editable = false;
//                         }
//                     }
//                 }
//             }
//         }
//         actions
//         {
//             area(processing)
//             {
//                 action(ActionName)
//                 {
//                     ApplicationArea = All;
//                 }
//             }
//         }
//         trigger OnOpenPage()
//         begin
//             Ejercicio := DATE2DMY(WorkDate(), 3);
//             VEfectivo := true;
//             VBanco := false;
//             bolBancoEditable := false;
//             PeriodoHabilitadoMensual := true;
//             TipoPeriodo := TipoPeriodo::Mensual;
//             PeriodoMeses := PeriodoMeses::"01";
//             PeriodoHabilitadoTrimestral := false;
//             //
//             FileName := 'Y:\IRPF\Modelo111_' + format(CurrentDateTime) + '.txt';
//         end;
//     }
//     var
//         ConfConta: Record 98;
//         InfoEmprev: Record 79;
//         TextoSalida: Text;
//         TipoDec: option "Ingreso","Negativa","Domiciliación del ingreso en CCC","Cuenta corriente tributaria-ingreso";
//         TipoD: Text[30];
//         Periodo: option "1T","2T","3T","4T";
//         Ejercicio: Integer;
//         NoRegDistinto0: Integer;
//         FechaIni: Date;
//         FechaFin: Date;
//         BaseReten: Decimal;
//         ImporteReten: Decimal;
//         NoRegIgual0: Integer;
//         BaseRetenIgualCero: Decimal;
//         TBanco: Record 270;
//         CodeBanco: Code[20];
//         FBanco: Page 371;
//         NombreBanco: Text[30];
//         PersonaContacto: Text[100];
//         TelefonoContacto: Text[10];
//         ImpPerRendTrab: Decimal;
//         ImpRetRendTrab: Decimal;
//         VEfectivo: Boolean;
//         VBanco: Boolean;
//         TextoEfectivo: Text[1];
//         TextoBanco: Text[1];
//         NPerceptores: Integer;
//         bolBancoEditable: Boolean;
//         Outstr: OutStream;
//         FileName: Text[250];
//         Text002: Label 'El modelo 111 se ha exportado correctamente: %1.';
//         PeriodoMeses: option "01","02","03","04","05","06","07","08","09","10","11","12";
//         TipoPeriodo: option "Mensual","Trimestral";
//         PeriodoHabilitadoMensual: Boolean;
//         PeriodoHabilitadoTrimestral: Boolean;
//         PeriodoExportar: Text;
//         AnsiStr: Text[1024];
//         AsciiStr: Text[1024];
//         CharVar: ARRAY[32] OF Char;
//         InStr: InStream;
//         tempBlob: Codeunit "Temp Blob";

//     procedure AjustaNum(Num: decimal; LongENT: integer; LongDEC: integer): text[30]
//     var
//         Numv: text[30];
//     begin
//         //if Num >= 0 then Signov  := '+';
//         //if Num < 0  then Signov  := 'N';
//         Num := round(ABS(Num), 1 / POWER(10, LongDEC));
//         if Num = 0 then
//             Numv := PADSTR('', LongDEC + 1, '0')
//         else
//             Numv := FORMAT(Num * POWER(10, LongDEC));
//         Numv := DELCHR(Numv, '=', '.');
//         Numv := COPYSTR(Numv, 1, STRLEN(Numv) - LongDEC) + COPYSTR(Numv, STRLEN(Numv) - LongDEC + 1, LongDEC);
//         //WHILE STRLEN(Numv) < (LongENT-1) DO
//         WHILE STRLEN(Numv) < (LongENT) DO Numv := '0' + Numv;
//         //Numv := Signov + Numv;
//         exit(Numv);
//     end;

//     procedure NProveedores(): Integer
//     var
//         NProvs: Integer;
//         NifAux: code[10];
//         MovsReten: record "EXC Retention Tax registers";
//     begin
//         NProvs := 0;
//         NifAux := '';
//         MovsReten.Reset();
//         MovsReten.Setcurrentkey("CIF/NIF");
//         MovsReten.COPYFILTERS("INDRA Witholding Tax registers");
//         MovsReten.SETFILTER("% retención", '<>%1', 0);
//         if MovsReten.FindFIRST() then
//             repeat
//                 if NifAux <> MovsReten."CIF/NIF" then begin
//                     NProvs += 1;
//                     NifAux := MovsReten."CIF/NIF";
//                 end;
//             until MovsReten.Next() = 0;
//         exit(NProvs);
//     end;

//     procedure MesLetra(MesNumero: integer) MesL: text[30]
//     begin
//         CASE MesNumero OF
//             1:
//                 MesL := 'Enero';
//             2:
//                 MesL := 'Febrero';
//             3:
//                 MesL := 'Marzo';
//             4:
//                 MesL := 'Abril';
//             5:
//                 MesL := 'Mayo';
//             6:
//                 MesL := 'Junio';
//             7:
//                 MesL := 'Julio';
//             8:
//                 MesL := 'Agosto';
//             9:
//                 MesL := 'Septiembre';
//             10:
//                 MesL := 'Octubre';
//             11:
//                 MesL := 'Noviembre';
//             12:
//                 MesL := 'Diciembre';
//         end;
//     end;

//     procedure Ascii2Ansi(_Text: text[250]): text[250]
//     begin
//         MakeVars();
//         exit(CONVERTSTR(_Text, AsciiStr, AnsiStr));
//     end;

//     procedure MakeVars()
//     begin
//         AsciiStr := ' ÇüéâäàåçêëèïîìÄÅÉæÆôöòûùÿÖÜø£Ø×ƒáíóúñÑªº¿®¬½¼¡«»¦¦¦¦¦ÁÂÀ©¦¦++¢¥++--+-+ãÃ++--¦-+';
//         AsciiStr := AsciiStr + '¤ðÐÊËÈiÍÎÏ++¦_¦Ì¯ÓßÔÒõÕµþÞÚÛÙýÝ¯´­±=¾¶§÷¸°¨·¹³²¦ ';
//         CharVar[1] := 196;
//         CharVar[2] := 197;
//         CharVar[3] := 201;
//         CharVar[4] := 242;
//         CharVar[5] := 220;
//         CharVar[6] := 186;
//         CharVar[7] := 191;
//         CharVar[8] := 188;
//         CharVar[9] := 187;
//         CharVar[10] := 193;
//         CharVar[11] := 194;
//         CharVar[12] := 192;
//         CharVar[13] := 195;
//         CharVar[14] := 202;
//         CharVar[15] := 203;
//         CharVar[16] := 200;
//         CharVar[17] := 205;
//         CharVar[18] := 206;
//         CharVar[19] := 204;
//         CharVar[20] := 175;
//         CharVar[21] := 223;
//         CharVar[22] := 213;
//         CharVar[23] := 254;
//         CharVar[24] := 218;
//         CharVar[25] := 219;
//         CharVar[26] := 217;
//         CharVar[27] := 180;
//         CharVar[28] := 177;
//         CharVar[29] := 176;
//         CharVar[30] := 185;
//         CharVar[31] := 179;
//         CharVar[32] := 178;
//         AnsiStr := ' Ã³ÚÔõÓÕþÛÙÞ´¯ý' + FORMAT(CharVar[1]) + FORMAT(CharVar[2]) + FORMAT(CharVar[3]) + 'µã¶÷' + FORMAT(CharVar[4]);
//         AnsiStr := AnsiStr + '¹¨ Í' + FORMAT(CharVar[5]) + '°úÏÎâßÝ¾·±Ð¬' + FORMAT(CharVar[6]) + FORMAT(CharVar[7]);
//         AnsiStr := AnsiStr + '«¼¢' + FORMAT(CharVar[8]) + 'í½' + FORMAT(CharVar[9]) + '___ªª' + FORMAT(CharVar[10]) + FORMAT(CharVar[11]);
//         AnsiStr := AnsiStr + FORMAT(CharVar[12]) + '®ªª++óÑ++--+-+Ò' + FORMAT(CharVar[13]) + '++--ª-+ñ­ð';
//         AnsiStr := AnsiStr + FORMAT(CharVar[14]) + FORMAT(CharVar[15]) + FORMAT(CharVar[16]) + 'i' + FORMAT(CharVar[17]) + FORMAT(CharVar[18]);
//         AnsiStr := AnsiStr + '¤++__ª' + FORMAT(CharVar[19]) + FORMAT(CharVar[20]) + 'Ë' + FORMAT(CharVar[21]) + 'ÈÊ§';
//         AnsiStr := AnsiStr + FORMAT(CharVar[22]) + 'Á' + FORMAT(CharVar[23]) + 'Ì' + FORMAT(CharVar[24]) + FORMAT(CharVar[25]);
//         AnsiStr := AnsiStr + FORMAT(CharVar[26]) + '²¦»' + FORMAT(CharVar[27]) + '¡' + FORMAT(CharVar[28]) + '=¥Âº¸©' + FORMAT(CharVar[29]);
//         AnsiStr := AnsiStr + '¿À' + FORMAT(CharVar[30]) + FORMAT(CharVar[31]) + FORMAT(CharVar[32]) + '_ ';
//     end;

//     procedure FormateaNombreFichero() Nombrefich: Text[100]
//     var
//         Parte1: Text[30];
//         Parte2: Text[30];
//         Parte3: Text[30];
//         Parte4: Text[30];
//         Parte5: Text[30];
//         Parte6: Text[30];
//     begin
//         Parte1 := PADSTR('', 2 - STRLEN(FORMAT(WorkDate(), 0, '<day>')), '0') + FORMAT(WorkDate(), 0, '<day>');
//         Parte2 := PADSTR('', 2 - STRLEN(FORMAT(WorkDate(), 0, '<month>')), '0') + FORMAT(WorkDate(), 0, '<month>');
//         Parte3 := PADSTR('', 2 - STRLEN(FORMAT(WorkDate(), 0, '<year>')), '0') + FORMAT(WorkDate(), 0, '<year>');
//         Parte4 := COPYSTR(FORMAT(TIME), 1, 2);
//         Parte5 := COPYSTR(FORMAT(TIME), 4, 2);
//         Parte6 := COPYSTR(FORMAT(TIME), 7, 2);
//         exit(Parte1 + Parte2 + Parte3 + Parte4 + Parte5 + Parte6);
//     end;
// }

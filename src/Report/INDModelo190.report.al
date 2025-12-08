namespace ScriptumVita.IRPF;
report 86304 "IND Modelo 190"
{
    // version INDRA
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    //CaptionML = ENU = 'Model 190', ESP = 'Modelo 190';
    Caption = 'Model 190';
    ProcessingOnly = true;

    dataset
    {
        dataitem("INDRA Witholding Tax registers"; "IND Witholding Tax registers")
        {
            // ++OT2-055483
            RequestFilterFields = "Clave de Percepción", "Clave IRPF", Pendiente;
            //DataItemTableView = sorting("Cif/Nif") where(Pendiente = const(True));
            DataItemTableView = sorting("Cif/Nif") WHERE("% RETENCIÓN" = filter(<> 0));

            // --OT2-055483
            trigger OnPreDataItem()
            var
                myInt: Integer;
            begin
                IF (Complementaria OR Sustitutiva) AND (NDeclAnt = '') THEN ERROR(Text002);
                ConfConta.GET;
                //ConfConta.TESTFIELD("Ruta fichero modelo 190");
                //TxModelo190 := ConfConta."Ruta fichero modelo 190" + 'modelo_190_' + FormateaNombreFichero + '.txt';
                //**CLEAR(FILE);
                //***
                /*
                ServerTempFileName := RBMgt.ServerTempFileName('txt');

                CLEAR(OutFile);
                OutFile.TEXTMODE := TRUE;
                OutFile.WRITEMODE := TRUE;
                OutFile.CREATE(ServerTempFileName);
                OutFile.CREATEOUTSTREAM(Outstr);
                */
                tempblob.CreateOutStream(OutStr);
                //***
                InfoEmprev.GET;
                /*
                FichModelo190.TEXTMODE := TRUE;
                FichModelo190.WRITEMODE := TRUE;
                IF NOT EXISTS(TxModelo190) THEN
                    FichModelo190.CREATE(TxModelo190)
                ELSE BEGIN
                    FichModelo190.OPEN(TxModelo190);
                    FichModelo190.SEEK(FichModelo190.LEN);
                END;
                */
                //Fichero temporal en el servidor
                //CLEAR(TempFile);
                //TempFile.CREATETEMPFILE;
                //Construye filtro fecha
                FechaIni := DMY2DATE(1, 1, Ejercicio);
                FechaFin := DMY2DATE(31, 12, Ejercicio);
                SETRANGE("Fecha registro", FechaIni, FechaFin);
                NoRegDistinto0 := 0;
                BaseReten := 0;
                ImporteReten := 0;
                NoRegDistinto0 := 0;
                BaseRetenIgualCero := 0;
                SETFILTER(País, '%1', InfoEmprev."Country/Region Code");
                // Registro de Cabecera
                Tipo1 := ' ';
                Tipo2 := ' ';
                IF Complementaria THEN Tipo1 := 'C';
                IF Sustitutiva THEN Tipo2 := 'S';
                CuentaTotales;
                //++TEC 001
                PersonaContacto := CONVERTSTR(UPPERCASE(PersonaContacto), '¦()', '   ');
                TempNombEmpresa := CONVERTSTR(UPPERCASE(InfoEmprev.Name), '¦()', '   ');
                PersonaContacto := FormatTextName(PersonaContacto);
                TempNombEmpresa := FormatTextName(TempNombEmpresa);
                // ++OT2-055483
                TelefonoContacto := InfoEmprev."Phone No.";
                // ++OT2-055483
                //--TEC 001
                TextoSalida := '1' + //Tipo de registro 1
 '190' + //Modelo declaraci¢n 2 - 4
 PADSTR(FORMAT(Ejercicio), 4, ' ') + //Ejercicio 5 - 8
 PADSTR(InfoEmprev."VAT Registration No.", 9, ' ') + //NIF Declarante 9 - 17
                                                     //++TEC 001
                                                     //PADSTR(Ascii2Ansi(InfoEmprev.Name),40,' ') +                //Apellidos y nombre, raz¢n social 18 - 57
                PADSTR(Ascii2Ansi(TempNombEmpresa), 40, ' ') + //Apellidos y nombre, raz¢n social 18 - 57
                                                               //--TEC 001
                'T' + //Tipo de soporte 58
 PADSTR(TelefonoContacto, 9, ' ') + //Tel‚fono con quien relaccionarse 59 - 107
 PADSTR(PersonaContacto, 40, ' ') + //Persona con quien relaccionarse 59 - 107
 PADSTR(NDecl, 13, ' ') + //N£mero identificativo declaraci¢n 108 - 120
 Tipo1 + //Complementaria 121
 Tipo2 + //Complementaria 122
 PADSTR(NDeclAnt, 13, '0') + //N£mero identificativo declaraci¢n anterior 123 - 135
 AjustaNum(Cuenta, 9, 0) + //N£mero total de percepciones 136 - 144
 ' ' + //Signo
 AjustaNum(BaseReten, 15, 2) + //Importe total de percepciones 146 - 160
 AjustaNum(ImporteReten, 15, 2) + //Importe total de percepciones 161 - 175
 PADSTR('', 62, ' ') + //Blancos 161 - 175
 PADSTR('', 13, ' ') + //Blancos 238 - 250
 PADSTR('', 250, ' '); //Blancos 251 - 500 Relleno a 500
                //FichModelo190.WRITE(TextoSalida);
                //**TempFile.WRITE(TextoSalida);
                //***
                Outstr.WRITETEXT(TextoSalida);
                //***
            END;

            trigger OnAfterGetRecord()
            var
                myInt: Integer;
            begin
                //++TEC 001
                UltimoMov := "INDRA Witholding Tax registers"."Nº mov.";
                //--TEC 001
                ComprobarCIF("INDRA Witholding Tax registers"."Cif/Nif");
                //Control agrupacion por CIF
                IF Encontrado = TRUE THEN BEGIN
                    BaseRetencion += "INDRA Witholding Tax registers"."Base retención";
                    ImporteRetencion += "INDRA Witholding Tax registers"."Importe retención";
                    CurrReport.SKIP;
                END
                ELSE BEGIN
                    BaseRetencion += "INDRA Witholding Tax registers"."Base retención";
                    ImporteRetencion += "INDRA Witholding Tax registers"."Importe retención";
                END;
                IF "% retención" <> 0 THEN BEGIN
                    NoRegDistinto0 += 1;
                    BaseReten += "Base retencion (DL)";
                    ImporteReten += "Importe retención (DL)";
                END
                ELSE BEGIN
                    NoRegIgual0 += 1;
                    BaseRetenIgualCero += "Base retencion (DL)";
                END;
                CeutaMelilla := '0';
                IF ("Código provincia" = '51') OR ("Código provincia" = '52') THEN CeutaMelilla := '1';
                CLEAR(TVend);
                IF TVend.GET("INDRA Witholding Tax registers"."Nº Proveedor / Nº Cliente") THEN;
                //++TEC 001
                TempNombre := CONVERTSTR(UPPERCASE("Nombre 1"), 'ª()', '   ');
                TempNombre := FormatTextName(TempNombre);
                //--TEC 001
                //Registro
                TextoSalida := '2' + //Tipo de registro 1
 '190' + //Modelo declaración 2 - 4
 PADSTR(FORMAT(Ejercicio), 4, ' ') + //Ejercicio 5 - 8
 PADSTR(InfoEmprev."VAT Registration No.", 9, ' ') + //NIF Declarante 9 - 17
 PADSTR("INDRA Witholding Tax registers"."Cif/Nif", 9, ' ') + //NIF del perceptor 18 - 26
 PADSTR('', 9, ' ') + //NIF del representante legal 27 - 35
                      //++TEC 001
                      //PADSTR(Ascii2Ansi("Nombre 1"),40,' ') +                   //Apell. y Nombre o denominación del percepto 36 - 75
PADSTR(Ascii2Ansi(TempNombre), 40, ' ') + //Apell. y Nombre o denominación del percepto 36 - 75
                                          //--TEC 001
PADSTR("Código provincia", 2, ' ') + //Código provincia 76 - 77
 PADSTR(FORMAT("Clave IRPF"), 1, ' ') + //Clave percepción 78
 PADSTR(FORMAT("Subclave IRPF"), 2, ' ') + //Clave percepción 79 - 80
 ' ' + //Signo 81
 AjustaNum(BaseRetencion, 13, 2) + //Percepciones íntegras 82 - 94
 AjustaNum(ImporteRetencion, 13, 2) + //Retenciones practicadas 95 - 107
 ' ' + //Signo 108
 AjustaNum(0, 13, 2) + //Percepciones íntegras 109 - 121
 AjustaNum(0, 13, 2) + //Retenciones practicadas 122 - 134
 AjustaNum(0, 13, 2) + //Ingresos a cuenta repercutidos 135 - 147
 AjustaNum(0, 4, 0) + //Ejercicio devengo 148 - 151
 CeutaMelilla + //Ceuta o Melilla
 PADSTR('', 4, '0') + //Año nacimiento 153 - 156
 PADSTR('', 1, '0') + //Situación familiar 157
 PADSTR('', 9, ' ') + //NIF del cónyuge 158 - 166
 PADSTR('', 1, '0') + //Discapacidad 167
 PADSTR(FORMAT(0), 1, ' ') + //Contrato o Relacción 168
                             //++ OT2-060277
                             //' ' +                                                       //Prolongación actividad laboral 169
                '0' + //Prolongación actividad laboral 169
                      //-- OT2-060277
                '0' + //Movilidad geográfica 170
 PADSTR('', 13, '0') + //Reducciones aplicables 171 - 183
 PADSTR('', 13, '0') + //Gastos deducibles 184 - 196
 PADSTR('', 13, '0') + //Pensiones compensatorias 197 - 209
 PADSTR('', 13, '0') + //Anualidades por alimentos 210 - 222
 PADSTR('', 1, '0') + //Hijos y descendientes <3 años 223
                      //PADSTR(FORMAT(TVend."Hijos men. de 3 años x entero"),1,'0') + //Hijos y descendientes <3 años x entero 224
                PADSTR('', 1, '0') + //PADSTR(FORMAT(TVend."Resto hijos"),2,'0') +                 //Resto hijos 225 - 226
                PADSTR('', 2, '0') + //PADSTR(FORMAT(TVend."Por entero resto hijos"),2,'0') +      //Resto hijos x entero 227 - 228
                PADSTR('', 2, '0') + //PADSTR(FORMAT(TVend."Desc. Discap. >=33% y <36%"),2,'0') +  //>=33% y <65% 229 - 230
                PADSTR('', 2, '0') + //PADSTR(FORMAT(TVend."Discap. >=33% y <36% x entero"),2,'0') +//>=33% y <65% x entero 231 - 232
                PADSTR('', 2, '0') + //PADSTR(FORMAT(TVend."Movilidad reducida"),2,'0') +          //Movilidad reducida 233 - 234
                PADSTR('', 2, '0') + //PADSTR(FORMAT(TVend."Movilidad reducida x entero"),2,'0') + //Movilidad reducida x entero 235 - 236
                PADSTR('', 2, '0') + //PADSTR(FORMAT(TVend."Desc. Discap. >= 65%"),2,'0') +        //Movilidad reducida >=65% 237 - 238
                PADSTR('', 2, '0') + //PADSTR(FORMAT(TVend."Desc. Discap. >= 65% x entero"),2,'0') +//Movilidad reducida >=65% x entero 239 - 240
                PADSTR('', 2, '0') + //PADSTR(FORMAT(TVend."Ascendientes <75%"),1,'0') +           //Ascendientes <75% años 241
                PADSTR('', 1, '0') + //PADSTR(FORMAT(TVend."Ascendientes <75% x entero"),1,'0') +  //Ascendientes <75% años x entero 242
                PADSTR('', 1, '0') + //PADSTR(FORMAT(TVend."Ascendientes >=75%"),1,'0') +          //Ascendientes >=75% años 243
                PADSTR('', 1, '0') + //PADSTR(FORMAT(TVend."Ascen. Discap >=35% y <65%"),1,'0') +  //Ascendientes >=75% años disc 245
                PADSTR('', 1, '0') + //PADSTR(FORMAT(TVend."Ascen. Disc. >=35% y <65% x en"),1,'0') + //Ascendientes >=75% años disc x entero 246
                PADSTR('', 1, '0') + //PADSTR(FORMAT(TVend."Asc. D. >=35% y <65% mov. red."),1,'0') + //247
                PADSTR('', 1, '0') + //PADSTR(FORMAT(TVend."Asc. D. >=35% y <65% mov. x en"),1,'0') + //248
                PADSTR('', 1, '0') + //PADSTR(FORMAT(TVend."Ascen. Discap >=65%"),1,'0') +         //249
                PADSTR('', 1, '0') + //PADSTR(FORMAT(TVend."Ascen. Discap >=65% x entero"),1,'0') + //250
                PADSTR('', 1, '0') + PADSTR('', 5, '0') + ' ' + //POSICION 255
 PADSTR('', 26, '0') + ' ' + // POSICION 282
                             //++ OT2-060277
                             //PADSTR('', 39, '0') +
                PADSTR('', 40, '0') + //-- OT2-060277
                //OT2-065853++
                PADSTR('', 65, '0') + // POSICION 323 - 387
                                      //OT2-065853--
                                      //++TEC 001
                                      //PADSTR('',178,' ');                                         //Blancos 251 - 500 Relleno a 500
                                      //++ OT2-060277 
                                      //OT2-065853++
                                      // PADSTR('', 178, ' ');
                                      //COL-400++
                PADSTR('', 1, '0') + // POSICION 388 - 389
                                     // PADSTR('', 113, ' '); // POSICION 388 - 500
                PADSTR('', 112, ' '); // POSICION 389 - 500
                //COL-400--
                //OT2-065853--
                //-- OT2-060277
                //--TEC 001
                //FichModelo190.WRITE(TextoSalida);
                //**TempFile.WRITE(TextoSalida);
                //***
                Outstr.WRITETEXT;
                Outstr.WRITETEXT(TextoSalida);
                //***
                BaseRetencion := 0;
                ImporteRetencion := 0;
            end;

            trigger OnPostDataItem()
            begin
                //OutFile.CLOSE;
                //FileManagement.DownloadToFile(ServerTempFileName, FileName);
                //++ OT2-055483
                //tempblob.CreateInStream(InStr);
                tempblob.CreateInStream(InStr, TextEncoding::UTF8);
                //-- OT2-055483
                DownloadFromStream(InStr, '', '', '', Filename);
                MESSAGE(Text001);
            end;
        }
    }
    requestpage
    {
        layout
        {
            area(Content)
            {
                field(FilenName; FileName)
                {
                    ApplicationArea = All;
                    //CaptionML = ENU = 'File Name', ESP = 'Nombre Archivo';
                    Caption = 'File Name';
                    /*
                        trigger OnAssistEdit()
                        var
                            FileMgt: codeunit "File Management";
                        begin
                            IF FileName = '' THEN
                                FileName := '.txt';
                            FileName := FileMgt.SaveFileDialog(Text003, FileName, '');
                        end;
                        */
                }
                field(NDecl; NDecl)
                {
                    ApplicationArea = All;
                    //CaptionML = ENU = 'Declaration Number', ESP = 'Número declaración';
                    Caption = 'Declaration Number';

                    trigger OnValidate()
                    begin
                        IF Complementaria THEN Sustitutiva := FALSE;
                        IF Complementaria OR Sustitutiva THEN BEGIN
                            DecAntEditable := TRUE;
                        END
                        ELSE BEGIN
                            DecAntEditable := FALSE;
                            NDeclAnt := '';
                        END;
                    end;
                }
                field(NDeclAnt; NDeclAnt)
                {
                    ApplicationArea = All;
                    //CaptionML = ENU = 'Last Declaration Nº', ESP = 'Nº Declaración anterior';
                    Caption = 'Last Declaration Nº';
                    Editable = DecAntEditable;
                }
                field(Ejercicio; Ejercicio)
                {
                    ApplicationArea = All;
                    //CaptionML = ENU = 'Fiscal year', ESP = 'Ejercicio';
                    Caption = 'Fiscal year';
                }
                field(PersonaContacto; PersonaContacto)
                {
                    ApplicationArea = All;
                    //CaptionML = ENU = 'Contact phone', ESP = 'Persona de contacto';
                    Caption = 'Contact phone';
                }
            }
        }
    }
    trigger OnPreReport()
    begin
        //++TEC 001 - comento
        //UltimoMov := 2;
        //--TEC 001
        //++TEC 001
        IF STRLEN(NDecl) < 13 THEN ERROR(Text004);
        //--TEC 001
        FileName := 'Modelo190_' + format(CurrentDateTime) + '.txt';
    end;

    var
        Text001: Label 'Se ha generado correctamente el fichero';
        Text002: Label 'Al indicar declaración complementaria o sustitutiva debe indicar un número de declaración anterior';
        ConfConta: Record 98;
        TxModelo190: Text[1024];
        InfoEmprev: Record 79;
        FichModelo190: File;
        TextoSalida: Text[1024];
        TipoDec: option "Complementaria","Sustitutiva";
        TipoD: Text[30];
        Periodo: option "1T","2T","3T","4T";
        Ejercicio: Integer;
        NoRegDistinto0: Integer;
        FechaIni: Date;
        FechaFin: Date;
        BaseReten: Decimal;
        ImporteReten: Decimal;
        NoRegIgual0: Integer;
        BaseRetenIgualCero: Decimal;
        TBanco: Record 270;
        CodeBanco: Code[20];
        FBanco: Page "Bank Account List";
        NombreBanco: Text[30];
        PersonaContacto: Text[100];
        TelefonoContacto: Text[10];
        NDecl: Code[13];
        Complementaria: Boolean;
        Sustitutiva: Boolean;
        NDeclAnt: Code[13];
        Tipo1: Text[30];
        Tipo2: Text[30];
        CeutaMelilla: Code[20];
        TVend: Record 23;
        Contrat: Code[20];
        Cuenta: Integer;
        AnsiStr: Text[1024];
        AsciiStr: Text[1024];
        CharVar: ARRAY[32] OF Char;
        DecAntEditable: Boolean;
        TempFile: File;
        NewStream: InStream;
        ToFile: Variant;
        ReturnValue: Boolean;
        OutFile: File;
        ServerTempFileName: Text[1024];
        Outstr: OutStream;
        RBMgt: Codeunit "File Management";
        FileManagement: Codeunit "File Management";
        FileName: Text[250];
        Text003: Label 'Ruta para exportar el archivo 190.';
        UltimoCif: Text[20];
        BaseRetencion: Decimal;
        ImporteRetencion: Decimal;
        Encontrado: Boolean;
        SiguienteCIF: Text[20];
        UltimoMov: Integer;
        Text004: Label 'Número declaración debe tener 13 caracteres';
        "//++TEC 001": Integer;
        TempNombre: Text[50];
        TempNombEmpresa: Text[50];
        cdStringConversionManagement: Codeunit 47;
        //++ OT2-055483
        //SpanishSpecialCharactersTxt: Label 'µ·ÔÒÖÞàãêéë¥š€()"&ïŽÓØ™ûš$''§¦';
        SpanishSpecialCharactersTxt: Label 'µ·ÔÒÖÞàãêéë¥š€()"&ïŽÓØ™ûš$''§¦ÑñÁáÉéÍíÓóÚúÜü';
        //-- OT2-055483
        tempBlob: Codeunit "Temp Blob";
        InStr: InStream;

    procedure FormateaNombreFichero() Nombrefich: Text[100]
    var
        Parte1: Text[30];
        Parte2: Text[30];
        Parte3: Text[30];
        Parte4: Text[30];
        Parte5: Text[30];
        Parte6: Text[30];
    begin
        Parte1 := PADSTR('', 2 - STRLEN(FORMAT(WORKDATE, 0, '<day>')), '0') + FORMAT(WORKDATE, 0, '<day>');
        Parte2 := PADSTR('', 2 - STRLEN(FORMAT(WORKDATE, 0, '<month>')), '0') + FORMAT(WORKDATE, 0, '<month>');
        Parte3 := PADSTR('', 2 - STRLEN(FORMAT(WORKDATE, 0, '<year>')), '0') + FORMAT(WORKDATE, 0, '<year>');
        Parte4 := COPYSTR(FORMAT(TIME), 1, 2);
        Parte5 := COPYSTR(FORMAT(TIME), 4, 2);
        Parte6 := COPYSTR(FORMAT(TIME), 7, 2);
        EXIT(Parte1 + Parte2 + Parte3 + Parte4 + Parte5 + Parte6);
    end;

    procedure AjustaNum(Num: Decimal; LongENT: Integer; LongDEC: Integer): text[30]
    var
        Numv: text[30];
    begin
        //IF Num >= 0 THEN Signov  := '+';
        //IF Num < 0  THEN Signov  := 'N';
        Num := ROUND(ABS(Num), 1 / POWER(10, LongDEC));
        IF Num = 0 THEN
            Numv := PADSTR('', LongDEC + 1, '0')
        ELSE
            Numv := FORMAT(Num * POWER(10, LongDEC));
        Numv := DELCHR(Numv, '=', '.');
        //Numv := COPYSTR(Numv,1,STRLEN(Numv) - LongDEC) + {',' + }COPYSTR(Numv,STRLEN(Numv) - LongDEC + 1,LongDEC);
        //WHILE STRLEN(Numv) < (LongENT-1) DO
        WHILE STRLEN(Numv) < (LongENT) DO Numv := '0' + Numv;
        //Numv := Signov + Numv;
        EXIT(Numv);
    end;

    procedure CuentaTotales()
    var
        MovRetencion: record "IND Witholding Tax registers";
    begin
        Cuenta := 0;
        BaseReten := 0;
        ImporteReten := 0;
        MovRetencion.RESET;
        MovRetencion.COPYFILTERS("INDRA Witholding Tax registers");
        IF MovRetencion.FINDFIRST THEN
            REPEAT
                Cuenta += 1;
                BaseReten += MovRetencion."Base retención";
                ImporteReten += MovRetencion."Importe retención";
            UNTIL MovRetencion.NEXT = 0;
    end;

    procedure Ansi2Ascii(_Text: text[300]): text[300]
    begin
        MakeVars;
        EXIT(CONVERTSTR(_Text, AnsiStr, AsciiStr));
    end;

    procedure Ascii2Ansi(_Text: text[250]): text[250]
    begin
        MakeVars;
        EXIT(CONVERTSTR(_Text, AsciiStr, AnsiStr));
    end;

    procedure MakeVars()
    begin
        AsciiStr := ' ÇüéâäàåçêëèïîìÄÅÉæÆôöòûùÿÖÜø£Ø×ƒáíóúñÑªº¿®¬½¼¡«»¦¦¦¦¦ÁÂÀ©¦¦++¢¥++--+-+ãÃ++--¦-+';
        //prueba AsciiStr := AsciiStr +'¤ðÐÊËÈiÍÎÏ++¦_¦Ì¯ÓßÔÒõÕµþÞÚÛÙýÝ¯´­±=¾¶§÷¸°¨·¹³²¦ ';
        AsciiStr := AsciiStr + '¤ðÑÊËÈiÍÎÏ++¦_¦Ì¯ÓßÔÒõÕµþÞÚÛÙýÝ¯´­±=¾¶§÷¸°¨·¹³²¦ ';
        //fin prueba
        CharVar[1] := 196;
        CharVar[2] := 197;
        CharVar[3] := 201;
        CharVar[4] := 242;
        CharVar[5] := 220;
        CharVar[6] := 186;
        CharVar[7] := 191;
        CharVar[8] := 188;
        CharVar[9] := 187;
        CharVar[10] := 193;
        CharVar[11] := 194;
        CharVar[12] := 192;
        CharVar[13] := 195;
        CharVar[14] := 202;
        CharVar[15] := 203;
        CharVar[16] := 200;
        CharVar[17] := 205;
        CharVar[18] := 206;
        CharVar[19] := 204;
        CharVar[20] := 175;
        CharVar[21] := 223;
        CharVar[22] := 213;
        CharVar[23] := 254;
        CharVar[24] := 218;
        CharVar[25] := 219;
        CharVar[26] := 217;
        CharVar[27] := 180;
        CharVar[28] := 177;
        CharVar[29] := 176;
        CharVar[30] := 185;
        CharVar[31] := 179;
        CharVar[32] := 178;
        AnsiStr := ' Ã³ÚÔõÓÕþÛÙÞ´¯ý' + FORMAT(CharVar[1]) + FORMAT(CharVar[2]) + FORMAT(CharVar[3]) + 'µã¶÷' + FORMAT(CharVar[4]);
        AnsiStr := AnsiStr + '¹¨ Í' + FORMAT(CharVar[5]) + '°úÏÎâßÝ¾·±Ð¬' + FORMAT(CharVar[6]) + FORMAT(CharVar[7]);
        AnsiStr := AnsiStr + '«¼¢' + FORMAT(CharVar[8]) + 'í½' + FORMAT(CharVar[9]) + '___ªª' + FORMAT(CharVar[10]) + FORMAT(CharVar[11]);
        AnsiStr := AnsiStr + FORMAT(CharVar[12]) + '®ªª++óÑ++--+-+Ò' + FORMAT(CharVar[13]) + '++--ª-+ñ­ð';
        AnsiStr := AnsiStr + FORMAT(CharVar[14]) + FORMAT(CharVar[15]) + FORMAT(CharVar[16]) + 'i' + FORMAT(CharVar[17]) + FORMAT(CharVar[18]);
        AnsiStr := AnsiStr + '¤++__ª' + FORMAT(CharVar[19]) + FORMAT(CharVar[20]) + 'Ë' + FORMAT(CharVar[21]) + 'ÈÊ§';
        AnsiStr := AnsiStr + FORMAT(CharVar[22]) + 'Á' + FORMAT(CharVar[23]) + 'Ì' + FORMAT(CharVar[24]) + FORMAT(CharVar[25]);
        AnsiStr := AnsiStr + FORMAT(CharVar[26]) + '²¦»' + FORMAT(CharVar[27]) + '¡' + FORMAT(CharVar[28]) + '=¥Âº¸©' + FORMAT(CharVar[29]);
        AnsiStr := AnsiStr + '¿À' + FORMAT(CharVar[30]) + FORMAT(CharVar[31]) + FORMAT(CharVar[32]) + '_ ';
    end;

    procedure CambiaChar(Valor: text[500]): text[500]
    var
        cinicial: text[15];
        cfinal: text[15];
        cfg: char;
        cfg1: Char;
        cfg2: Char;
        cfg3: Char;
        cfg4: Char;
        cfg5: Char;
        cfg6: Char;
        cfg7: Char;
        cfg8: Char;
        cfg9: Char;
        cfg10: Char;
        cfg11: Char;
        cfg12: Char;
        cfg13: Char;
        cfg14: Char;
    begin
        cinicial := '';
        cfg := 186;
        cfg1 := 193;
        cfg2 := 201;
        cfg3 := 205;
        cfg4 := 211;
        cfg5 := 218;
        cfg6 := 225;
        cfg7 := 233;
        cfg8 := 237;
        cfg9 := 243;
        cfg10 := 250;
        cfg11 := 241;
        cfg12 := 209;
        cfg13 := 170;
        cfg14 := 180;
        cinicial := cinicial + FORMAT(cfg1, 1, '<char>');
        cinicial := cinicial + FORMAT(cfg2, 1, '<char>');
        cinicial := cinicial + FORMAT(cfg3, 1, '<char>');
        cinicial := cinicial + FORMAT(cfg4, 1, '<char>');
        cinicial := cinicial + FORMAT(cfg5, 1, '<char>');
        cinicial := cinicial + FORMAT(cfg6, 1, '<char>');
        cinicial := cinicial + FORMAT(cfg7, 1, '<char>');
        cinicial := cinicial + FORMAT(cfg8, 1, '<char>');
        cinicial := cinicial + FORMAT(cfg9, 1, '<char>');
        cinicial := cinicial + FORMAT(cfg10, 1, '<char>');
        cinicial := cinicial + FORMAT(cfg11, 1, '<char>');
        cinicial := cinicial + FORMAT(cfg12, 1, '<char>');
        cinicial := cinicial + FORMAT(cfg13, 1, '<char>');
        cinicial := cinicial + FORMAT(cfg, 1, '<char>');
        cinicial := cinicial + FORMAT(cfg14, 1, '<char>');
        cfinal := 'ÁÉÍÓÚáéíóúñÑªº´';
        EXIT(CONVERTSTR(Valor, cinicial, cfinal));
    end;

    procedure ComprobarCIF(pCif: Text[20])
    var
        MovRetencion2: record "IND Witholding Tax registers";
    begin
        //++TEC 001 - Código nuevo
        UltimoMov := UltimoMov + 1;
        MovRetencion2.RESET;
        MovRetencion2.SETCURRENTKEY(MovRetencion2."Cif/Nif");
        //++ OT2-055483
        MovRetencion2.CopyFilters("INDRA Witholding Tax registers");
        MovRetencion2.SetRange("Cif/Nif", pCif);
        //-- OT2-055483
        MovRetencion2.SETRANGE("Nº mov.", "INDRA Witholding Tax registers"."Nº mov.");
        MovRetencion2.SETRANGE(MovRetencion2."Fecha registro", FechaIni, FechaFin);
        MovRetencion2.SETFILTER(País, '%1', InfoEmprev."Country/Region Code");
        IF MovRetencion2.FIND('-') THEN BEGIN
            MovRetencion2.SETRANGE("Nº mov.");
            IF MovRetencion2.NEXT(+1) <> 0 THEN
                SiguienteCIF := MovRetencion2."Cif/Nif"
            ELSE
                SiguienteCIF := '';
        END
        ELSE
            SiguienteCIF := '';
        UltimoCif := pCif;
        IF UltimoCif = SiguienteCIF THEN
            Encontrado := TRUE
        ELSE
            Encontrado := FALSE;
        //--TEC 001
        //++TEC 001
        /*Código antiguo
            MovRetencion2.RESET;
                    MovRetencion2.SETRANGE("Nº mov.", UltimoMov);
                    IF MovRetencion2.FIND('-') THEN
                        SiguienteCIF := MovRetencion2."Cif/Nif";

                    UltimoCif := pCif;

                    IF UltimoCif = SiguienteCIF THEN
                        Encontrado := TRUE
                    ELSE
                        Encontrado := FALSE;

                    UltimoMov := MovRetencion2."Nº mov." + 1;

                    Fin código antiguo*/
        //--TEC 001
    end;

    procedure FormatTextName(NameString: Text) result: text
    var
        Tempstring: text;
        Tempstring1: text[1];
    begin
        CLEAR(Result);
        //++ OT2-055483
        //TempString := CONVERTSTR(UPPERCASE(NameString), SpanishSpecialCharactersTxt, 'AAEEEIIOOUUUÐUÃ     AEIOOOU    ');
        TempString := CONVERTSTR(UPPERCASE(NameString), SpanishSpecialCharactersTxt, 'AAEEEIIOOUUUÐUÃ     AEIOOOU    NnAaEeIiOoUuUu');
        //-- OT2-055483
        IF STRLEN(TempString) > 0 THEN
            REPEAT
                TempString1 := COPYSTR(TempString, 1, 1);
                //++ OT2-055483
                //IF TempString1 IN ['A' .. 'Z', '0' .. '9', 'Ñ', 'Ç', ' ', '-'] THEN
                IF TempString1 IN ['A' .. 'Z', '0' .. '9', 'Ç', ' ', '-'] THEN //-- OT2-055483
                    Result := Result + TempString1;
                TempString := DELSTR(TempString, 1, 1);
            UNTIL STRLEN(TempString) = 0;
        EXIT(Result);
    end;
}

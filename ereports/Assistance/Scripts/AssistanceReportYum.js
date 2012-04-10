
    function initDataGrid(piCurrentYear, piPreviousYear, isReport)
    {
        var _class  = " class='descriptionTabla' style='border: solid rgb(0,0,0) 0px; font-size:11px;  background-color: transparent;' ";

        loGrid.isReport   = true;
        if(!isReport)
        {
            loGrid.bHeaderFix = true;
            loGrid.height = 300;
        }   
        else
            loGrid.bHeaderFix = false;

        loGrid.padding    = 4;

        if(gaDataset.length > 0)
        {

            mheaders = new Array(
                     {text: 'Reporte de Asistencias', align: 'center', hclass: 'right', bclass: 'right', colspan: 7});

            headers  = new Array(
            // 0:  No. Ticket
                     {text:'No. empl',width:'10%', align:'right', hclass: 'right', bclass: 'right'},
            // 1:  Hora en que se sirvio
                     {text:'Nombre', width:'15%', align: 'right', hclass: 'right', bclass: 'right'},
            // 2:  Nombre del empleado
                     {text:'Hora Entrada 1', width:'15%', align: 'right', hclass: 'right', bclass: 'right'},
            // 3:  autorizado por
                     {text:'Hora Salida 1',width:'15%', align: 'right', hclass: 'right', bclass: 'right'},
            // 4:  Total IVA
                     {text:'Hora Entrada 2',width:'15%', align: 'right', hclass: 'right', bclass: 'right'},
            // 5:  Total Neto
                     {text:'Hora Salida 2',width:'15%', align: 'right', hclass: 'right', bclass: 'right'},
            // 6:  Total bruto 
                     {text:'Total horas',width:'15%', hclass: 'right', bclass: 'right', align:'right'});

            props    = new Array(null,null,null,null,null,null,null,{hide: true});

            loGrid.setMainHeaders(mheaders);
            loGrid.setHeaders(headers);
            loGrid.setDataProps(props);
            loGrid.setData(gaDataset);        
            loGrid.drawInto('goDataGrid');
        }
    }

    function customDataset(paDataset)
    {
    }




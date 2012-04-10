DELETE FROM ss_option_group;
DELETE FROM ss_option_company;
DELETE FROM ss_option_time;

DELETE FROM ss_cat_menu_option;

SELECT setval('ss_cat_menu_option_option_id_seq',1, false);

INSERT INTO ss_cat_menu_option (option_org, option_desc, action_desc, target, option_key, icon_id, visible) -- 1 --
VALUES ('20','Inventario',NULL,NULL,NULL,20,1);

INSERT INTO ss_cat_menu_option (option_org, option_desc, action_desc, target, option_key, icon_id, visible) -- 2 --
VALUES ('2030','Control de Ordenes de Compra',NULL,NULL,NULL,NULL,1);

INSERT INTO ss_cat_menu_option (option_org, option_desc, action_desc, target, option_key, icon_id, visible) -- 3 --
VALUES ('203015','Orden de Compra','/Inventory/PurchaseOrder/Entry/OrderYum.jsp','ifrMainContainer',NULL,500,1);

INSERT INTO ss_cat_menu_option (option_org, option_desc, action_desc, target, option_key, icon_id, visible) -- 4 --
VALUES ('2050','Control de Inventario',NULL,NULL,NULL,NULL,1);

INSERT INTO ss_cat_menu_option (option_org, option_desc, action_desc, target, option_key, icon_id, visible) -- 5 --
VALUES ('205010','Transferencias de entrada/salida','/Inventory/Transfers/Entry/TransferYum.jsp','ifrMainContainer',NULL,500,1);

INSERT INTO ss_cat_menu_option (option_org, option_desc, action_desc, target, option_key, icon_id, visible) -- 6 --
VALUES ('205030','Inventario semanal','/Inventory/WeeklyInventory/Entry/InventoryYum.jsp','ifrMainContainer',NULL,500,1);

INSERT INTO ss_cat_menu_option (option_org, option_desc, action_desc, target, option_key, icon_id, visible) -- 7 --
VALUES ('2060','Reportes',NULL,NULL,NULL,NULL,1);

INSERT INTO ss_cat_menu_option (option_org, option_desc, action_desc, target, option_key, icon_id, visible) -- 8 -- 
VALUES ('206010','Inventario semanal','/Inventory/WeeklyInventory/Rpt/InventoryReportYum.jsp','ifrMainContainer',NULL,510,1);

INSERT INTO ss_cat_menu_option (option_org, option_desc, action_desc, target, option_key, icon_id, visible) -- 9 --
VALUES ('206020','Transferencias de entrada','/Inventory/Transfers/Rpt/TransferReportYum.jsp?type=input','ifrMainContainer',NULL,510,1);

INSERT INTO ss_cat_menu_option (option_org, option_desc, action_desc, target, option_key, icon_id, visible) -- 10 -- 
VALUES ('206030','Transferencias de salida','/Inventory/Transfers/Rpt/TransferReportYum.jsp?type=output','ifrMainContainer',NULL,510,1);

INSERT INTO ss_cat_menu_option (option_org, option_desc, action_desc, target, option_key, icon_id, visible) -- 11 --
VALUES ('50','Ingresos&nbsp;y&nbsp;gastos',NULL,NULL,NULL,50,1);

INSERT INTO ss_cat_menu_option (option_org, option_desc, action_desc, target, option_key, icon_id, visible) -- 12 --
VALUES ('5030','Semivariables',NULL,NULL,NULL,NULL,1);

INSERT INTO ss_cat_menu_option (option_org, option_desc, action_desc, target, option_key, icon_id, visible) -- 13 --
VALUES ('503010','Captura de facturas','/IncomeAndExpense/Semivariable/Entry/InvoiceMasterYum.jsp','ifrMainContainer',NULL,500,1);

INSERT INTO ss_cat_menu_option (option_org, option_desc, action_desc, target, option_key, icon_id, visible) -- 14 -- 
VALUES ('503020','Reportes','/IncomeAndExpense/Semivariable/Rpt/InvoiceReportYum.jsp','ifrMainContainer',NULL,510,1);

INSERT INTO ss_cat_menu_option (option_org, option_desc, action_desc, target, option_key, icon_id, visible) -- 15 --
VALUES ('5050','Reportes',NULL,NULL,NULL,NULL,1);

INSERT INTO ss_cat_menu_option (option_org, option_desc, action_desc, target, option_key, icon_id, visible) -- 16 --  
VALUES ('505010','Comida de Empleados','/IncomeAndExpense/EmployeesMeal/Rpt/EmplMealReportYum.jsp','ifrMainContainer',NULL,500,1);

INSERT INTO ss_cat_menu_option (option_org, option_desc, action_desc, target, option_key, icon_id, visible) -- 17 --
VALUES ('5060','Ventas',NULL,NULL,NULL,NULL,1);

INSERT INTO ss_cat_menu_option (option_org, option_desc, action_desc, target, option_key, icon_id, visible) -- 18 --
VALUES ('506010','Cierre Lote Tarj. Credito','/IncomeAndExpense/CreditCardBatch/Entry/CreditCardBatchYum.jsp','ifrMainContainer',NULL,500,1);

INSERT INTO ss_cat_menu_option (option_org, option_desc, action_desc, target, option_key, icon_id, visible) -- 19 --
VALUES ('70','Estadisticas',NULL,NULL,NULL,30,1);

INSERT INTO ss_cat_menu_option (option_org, option_desc, action_desc, target, option_key, icon_id, visible) -- 20 --
VALUES ('7010','Reportes',NULL,NULL,NULL,NULL,1);

INSERT INTO ss_cat_menu_option (option_org, option_desc, action_desc, target, option_key, icon_id, visible) -- 21 -- 
VALUES ('701010','Coupon Report','/Statistic/CouponReport/Rpt/CouponReportYum.jsp','ifrMainContainer',NULL,510,1);

INSERT INTO ss_cat_menu_option (option_org, option_desc, action_desc, target, option_key, icon_id, visible) -- 22 --
VALUES ('7030','Transacciones por AGEB',NULL,NULL,NULL,NULL,1);

INSERT INTO ss_cat_menu_option (option_org, option_desc, action_desc, target, option_key, icon_id, visible) --23 --
VALUES ('703010','Captura de HH y Objetivos','/Utilities/HouseHold/Entry/HouseholdYum.jsp','ifrMainContainer',NULL,500,1);

INSERT INTO ss_cat_menu_option (option_org, option_desc, action_desc, target, option_key, icon_id, visible)  -- 24 -- 
VALUES ('703020','Reportes','/Utilities/HouseHold/Rpt/HouseholdReportYum.jsp','ifrMainContainer',NULL,510,1);

-- Esta es la pestaña de congelados y sus derivados
INSERT INTO ss_cat_menu_option (option_org, option_desc, action_desc, target, option_key, icon_id, visible) -- 25 --
VALUES ('7050','Congelados',NULL,NULL,NULL,NULL,1);

INSERT INTO ss_cat_menu_option (option_org, option_desc, action_desc, target, option_key, icon_id, visible) -- 26 -- 
VALUES ('705020','No. transacciones','/Graphics/PiecesAndTransactions/Rpt/TransactionsReportYum.jsp','ifrMainContainer',NULL,510,1);

INSERT INTO ss_cat_menu_option (option_org, option_desc, action_desc, target, option_key, icon_id, visible) -- 27 -- 
VALUES ('705030','Indice transacciones por fecha','/Graphics/PiecesAndTransactions/Rpt/TransactionsIndexReportYum.jsp?type=date','ifrMainContainer',NULL,510,1);

INSERT INTO ss_cat_menu_option (option_org, option_desc, action_desc, target, option_key, icon_id, visible) -- 28 -- 
VALUES ('705040','Indice transacciones por dia','/Graphics/PiecesAndTransactions/Rpt/TransactionsIndexReportYum.jsp?type=day','ifrMainContainer',NULL,510,1);

INSERT INTO ss_cat_menu_option (option_org, option_desc, action_desc, target, option_key, icon_id, visible) -- 29 -- 
VALUES ('705050','Indice transacciones por tendencia diaria','/Tendencies/Transactions/Rpt/TendenciesReportYum.jsp','ifrMainContainer',NULL,510,1);

-- Esta es la pestaña de horarios y derivados
INSERT INTO ss_cat_menu_option (option_org, option_desc, action_desc, target, option_key, icon_id, visible) -- 30 --
VALUES ('7060','Horarios',NULL,NULL,NULL,NULL,1);

INSERT INTO ss_cat_menu_option (option_org, option_desc, action_desc, target, option_key, icon_id, visible) -- 31 -- 
VALUES ('706020','Resumen OD Horarios','/Statistic/ReportHours/Rpt/HourTransReportYum.jsp','ifrMainContainer',NULL,510,1);

INSERT INTO ss_cat_menu_option (option_org, option_desc, action_desc, target, option_key, icon_id, visible) -- 32 -- 
VALUES ('706030','Reporte de Asistencia Biom&eacute;trico','/Utilities/Assistance/Rpt/AssistanceReportYum.jsp','ifrMainContainer',NULL,510,1);

-- Esta es la pestaña de volanteo
INSERT INTO ss_cat_menu_option (option_org, option_desc, action_desc, target, option_key, icon_id, visible) -- 33 --
VALUES ('90','Volanteo',NULL,NULL,NULL,10,1);

INSERT INTO ss_cat_menu_option (option_org, option_desc, action_desc, target, option_key, icon_id, visible) -- 34 --
VALUES ('9030','Captura de volanteo',NULL,NULL,NULL,NULL,1);

INSERT INTO ss_cat_menu_option (option_org, option_desc, action_desc, target, option_key, icon_id, visible) -- 35 --
VALUES ('903010','Formato de captura de volanteo','/Promotionalt/PromForm/Entry/TextPromForm.jsp','ifrMainContainer',NULL,500,1);

-- Esta es la pestaña de cambio de destino
INSERT INTO ss_cat_menu_option (option_org, option_desc, action_desc, target, option_key, icon_id, visible) -- 36 --
VALUES ('110','Home&nbsp;Service',NULL,NULL,NULL,60,1);

INSERT INTO ss_cat_menu_option (option_org, option_desc, action_desc, target, option_key, icon_id, visible) -- 37 --
VALUES ('11030','Reportes',NULL,NULL,NULL,NULL,1);

INSERT INTO ss_cat_menu_option (option_org, option_desc, action_desc, target, option_key, icon_id, visible) -- 38 -- 
VALUES ('1103010','Cambio de destino','/HomeService/DestChange/Rpt/DestChangeReportYum.jsp','ifrMainContainer',NULL,510,1);

-- Esta es la opción de reporte de llamadas
INSERT INTO ss_cat_menu_option (option_org, option_desc, action_desc, target, option_key, icon_id, visible) -- 39 --
VALUES ('1103020','Resumen de llamadas','/HomeService/ConmCall/Rpt/ConmCallReportYum.jsp','ifrMainContainer',NULL,510,1);

-- Esta es la opción de reporte de llamadas de salida
INSERT INTO ss_cat_menu_option (option_org, option_desc, action_desc, target, option_key, icon_id, visible) -- 40 --
VALUES ('1103030','Llamadas de salida','/HomeService/CallOut/Rpt/CallOutReportYum.jsp','ifrMainContainer',NULL,510,1);

INSERT INTO ss_cat_menu_option (option_org, option_desc, action_desc, target, option_key, icon_id, visible) -- 41 --
VALUES ('1103040','Clientes potenciales','/HomeService/CustomReport/Entry/CustomYum.jsp','ifrMainContainer',NULL,510,1);

INSERT INTO ss_cat_menu_option (option_org, option_desc, action_desc, target, option_key, icon_id, visible) -- 42 --
VALUES ('1103050','Clientes Frecuentes','/HomeService/CustomFrec/Entry/CustomFrec.jsp','ifrMainContainer',NULL,510,1);

INSERT INTO ss_cat_menu_option (option_org, option_desc, action_desc, target, option_key, icon_id, visible) -- 43 --
VALUES ('1103060','Clientes potenciales por AGEB','/HomeService/CustomReportAgeb/Entry/CustomYumA.jsp','ifrMainContainer',NULL,510,1);

INSERT INTO ss_cat_menu_option (option_org, option_desc, action_desc, target,option_key, icon_id, visible) -- 44 --
VALUES ('1103070','Clientes Frecuentes por AGEB','/HomeService/CustomFrecAgeb/Entry/CustomFrecA.jsp','ifrMainContainer',NULL,510,1);

INSERT INTO ss_cat_menu_option (option_org, option_desc, action_desc, target,option_key, icon_id, visible) -- 45 --
VALUES ('1103080','Reporte de excepciones','/HomeService/ConmCall/Rpt/ExceptionCallReportYum.jsp','ifrMainContainer',NULL,510,1);

INSERT INTO ss_cat_menu_option (option_org, option_desc, action_desc, target, option_key, icon_id, visible) -- 46 --
VALUES ('120','Planeaci&oacute;n',NULL,NULL,NULL,60,1);

INSERT INTO ss_cat_menu_option (option_org, option_desc, action_desc, target, option_key, icon_id, visible) -- 47 --
VALUES ('12010','Uso Ideal Diario','/Planning/IdealUse/Rpt/IdealUseReportYum.jsp','ifrMainContainer',NULL,510,1);

INSERT INTO ss_cat_menu_option (option_org, option_desc, action_desc, target, option_key, icon_id, visible) -- 48 --
VALUES ('12020','Reporte Chuleta','/Planning/WeeklyResults/Rpt/WeeklyResultsReportYum.jsp','ifrMainContainer',NULL,510,1);

INSERT INTO ss_cat_menu_option (option_org, option_desc, action_desc, target, option_key, icon_id, visible) -- 49 --
VALUES ('12030','Aplicaciones',NULL,NULL,NULL,NULL,1);

INSERT INTO ss_cat_menu_option (option_org, option_desc, action_desc, target, option_key, icon_id, visible) -- 50 --
VALUES ('1203010','Plan de masas','/Planning/MassPlan/Entry/MassPlanYum.jsp','ifrMainContainer',NULL,500,1);

-- Menu para usuario manager (100)
INSERT INTO ss_option_group VALUES (100,1);   -- Inventario
INSERT INTO ss_option_group VALUES (100,2);   -- Control de Ordenes de Compra
INSERT INTO ss_option_group VALUES (100,3);   -- Orden de Compra
INSERT INTO ss_option_group VALUES (100,4);   -- Control de Inventario
INSERT INTO ss_option_group VALUES (100,5);   -- Transferencias de entrada/salida
INSERT INTO ss_option_group VALUES (100,6);   -- Inventario semanal
INSERT INTO ss_option_group VALUES (100,7);   -- Reportes
INSERT INTO ss_option_group VALUES (100,8);   -- Inventario semanal
iNSERT INTO ss_option_group VALUES (100,9);   -- Transferencias de entrada
INSERT INTO ss_option_group VALUES (100,10);  -- Transferencias de salida
INSERT INTO ss_option_group VALUES (100,11);  -- Ingresos y gastos
INSERT INTO ss_option_group VALUES (100,12);  -- Semivariables
INSERT INTO ss_option_group VALUES (100,13);  -- Captura de facturas
INSERT INTO ss_option_group VALUES (100,14);  -- Reportes
INSERT INTO ss_option_group VALUES (100,15);  -- Reportes
INSERT INTO ss_option_group VALUES (100,16);  -- Comida de Empleados
INSERT INTO ss_option_group VALUES (100,17);  -- Ventas
INSERT INTO ss_option_group VALUES (100,18);  -- Cierre Lote Tarj. Credito
INSERT INTO ss_option_group VALUES (100,19);  -- Estadisticas
INSERT INTO ss_option_group VALUES (100,20);  -- Reportes
INSERT INTO ss_option_group VALUES (100,21);  -- Coupon Report
INSERT INTO ss_option_group VALUES (100,22);  -- Transacciones por AGEB
INSERT INTO ss_option_group VALUES (100,23);  -- Captura de HH y Objetivos
INSERT INTO ss_option_group VALUES (100,24);  -- Reportes
INSERT INTO ss_option_group VALUES (100,25);  -- Congelados
INSERT INTO ss_option_group VALUES (100,26);  -- No. transacciones
INSERT INTO ss_option_group VALUES (100,27);  -- Indice transacciones por fecha
INSERT INTO ss_option_group VALUES (100,28);  -- Indice transacciones por dia
INSERT INTO ss_option_group VALUES (100,29);  -- Indice transacciones por tendencia diaria
INSERT INTO ss_option_group VALUES (100,30);  -- Horarios
INSERT INTO ss_option_group VALUES (100,31);  -- Resumen OD Horarios
INSERT INTO ss_option_group VALUES (100,32);  -- Reporte asistencia en biometrico
INSERT INTO ss_option_group VALUES (100,33);  -- Volanteo
INSERT INTO ss_option_group VALUES (100,34);  -- Captura de volanteo
INSERT INTO ss_option_group VALUES (100,35);  -- Formato de captura de volanteo
INSERT INTO ss_option_group VALUES (100,36);  -- Home Service
INSERT INTO ss_option_group VALUES (100,37);  -- Reportes
INSERT INTO ss_option_group VALUES (100,38);  -- Cambio de destino
INSERT INTO ss_option_group VALUES (100,39);  -- Resumen de llamadas
INSERT INTO ss_option_group VALUES (100,40);  -- Llamadas de salida
INSERT INTO ss_option_group VALUES (100,41);  -- Clientes potenciales
INSERT INTO ss_option_group VALUES (100,42);  -- Clientes Frecuentes
INSERT INTO ss_option_group VALUES (100,43);  -- Clientes potenciales por AGEB
INSERT INTO ss_option_group VALUES (100,44);  -- Clientes Frecuentes por AGEB
INSERT INTO ss_option_group VALUES (100,45);  -- Reporte de excepciones 
INSERT INTO ss_option_group VALUES (100,46);  -- Planeacion
INSERT INTO ss_option_group VALUES (100,47);  -- Uso ideal diario
INSERT INTO ss_option_group VALUES (100,48);  -- Reporte de chuleta
INSERT INTO ss_option_group VALUES (100,49);  -- Aplicaciones de planeacion
INSERT INTO ss_option_group VALUES (100,50);  -- Plan de preparacion


-- Menu para usuario admin (200)
INSERT INTO ss_option_group VALUES (200,1);   -- Inventario
INSERT INTO ss_option_group VALUES (200,2);   -- Control de Ordenes de Compra
INSERT INTO ss_option_group VALUES (200,3);   -- Orden de Compra
INSERT INTO ss_option_group VALUES (200,4);   -- Control de Inventario
INSERT INTO ss_option_group VALUES (200,5);   -- Transferencias de entrada/salida
INSERT INTO ss_option_group VALUES (200,6);   -- Inventario semanal
INSERT INTO ss_option_group VALUES (200,7);   -- Reportes
INSERT INTO ss_option_group VALUES (200,8);   -- Inventario semanal
iNSERT INTO ss_option_group VALUES (200,9);   -- Transferencias de entrada
INSERT INTO ss_option_group VALUES (200,10);  -- Transferencias de salida
INSERT INTO ss_option_group VALUES (200,11);  -- Ingresos y gastos
INSERT INTO ss_option_group VALUES (200,12);  -- Semivariables
INSERT INTO ss_option_group VALUES (200,13);  -- Captura de facturas
INSERT INTO ss_option_group VALUES (200,14);  -- Reportes
INSERT INTO ss_option_group VALUES (200,15);  -- Reportes
INSERT INTO ss_option_group VALUES (200,16);  -- Comida de Empleados
INSERT INTO ss_option_group VALUES (200,17);  -- Ventas
INSERT INTO ss_option_group VALUES (200,18);  -- Cierre Lote Tarj. Credito
INSERT INTO ss_option_group VALUES (200,19);  -- Estadisticas
INSERT INTO ss_option_group VALUES (200,20);  -- Reportes
INSERT INTO ss_option_group VALUES (200,21);  -- Coupon Report
INSERT INTO ss_option_group VALUES (200,22);  -- Transacciones por AGEB
INSERT INTO ss_option_group VALUES (200,23);  -- Captura de HH y Objetivos
INSERT INTO ss_option_group VALUES (200,24);  -- Reportes
INSERT INTO ss_option_group VALUES (200,25);  -- Congelados
INSERT INTO ss_option_group VALUES (200,26);  -- No. transacciones
INSERT INTO ss_option_group VALUES (200,27);  -- Indice transacciones por fecha
INSERT INTO ss_option_group VALUES (200,28);  -- Indice transacciones por dia
INSERT INTO ss_option_group VALUES (200,29);  -- Indice transacciones por tendencia diaria
INSERT INTO ss_option_group VALUES (200,30);  -- Horarios
INSERT INTO ss_option_group VALUES (200,31);  -- Resumen OD Horarios
INSERT INTO ss_option_group VALUES (200,32);  -- Reporte de asistencia biometrico
INSERT INTO ss_option_group VALUES (200,33);  -- Volanteo
INSERT INTO ss_option_group VALUES (200,34);  -- Captura de volanteo
INSERT INTO ss_option_group VALUES (200,35);  -- Formato de captura de volanteo
INSERT INTO ss_option_group VALUES (200,36);  -- Home Service
INSERT INTO ss_option_group VALUES (200,37);  -- Reportes
INSERT INTO ss_option_group VALUES (200,38);  -- Cambio de destino
INSERT INTO ss_option_group VALUES (200,39);  -- Resumen de llamadas
INSERT INTO ss_option_group VALUES (200,40);  -- Llamadas de salida
INSERT INTO ss_option_group VALUES (200,41);  -- Clientes potenciales
INSERT INTO ss_option_group VALUES (200,42);  -- Clientes Frecuentes
INSERT INTO ss_option_group VALUES (200,43);  -- Clientes potenciales por AGEB
INSERT INTO ss_option_group VALUES (200,44);  -- Clientes Frecuentes por AGEB
INSERT INTO ss_option_group VALUES (200,45);  -- Reporte de excepciones 
INSERT INTO ss_option_group VALUES (200,46);  -- Planeacion
INSERT INTO ss_option_group VALUES (200,47);  -- Uso ideal diario
INSERT INTO ss_option_group VALUES (200,48);  -- Reporte de chuleta
INSERT INTO ss_option_group VALUES (200,49);  -- Aplicaciones de planeacion
INSERT INTO ss_option_group VALUES (200,50);  -- Plan de preparacion

-- Solo para reportes
INSERT INTO ss_option_company VALUES (8,'PH');
INSERT INTO ss_option_company VALUES (9,'PH');
INSERT INTO ss_option_company VALUES (10,'PH');
INSERT INTO ss_option_company VALUES (14,'PH'); 
INSERT INTO ss_option_company VALUES (16,'PH'); 
INSERT INTO ss_option_company VALUES (21,'PH'); 
INSERT INTO ss_option_company VALUES (24,'PH');
INSERT INTO ss_option_company VALUES (26,'PH');
INSERT INTO ss_option_company VALUES (27,'PH');
INSERT INTO ss_option_company VALUES (28,'PH');
INSERT INTO ss_option_company VALUES (29,'PH');
INSERT INTO ss_option_company VALUES (31,'PH');
INSERT INTO ss_option_company VALUES (32,'PH');
INSERT INTO ss_option_company VALUES (38,'PH');
INSERT INTO ss_option_company VALUES (39,'PH');
INSERT INTO ss_option_company VALUES (40,'PH');
INSERT INTO ss_option_company VALUES (41,'PH');
INSERT INTO ss_option_company VALUES (42,'PH');
INSERT INTO ss_option_company VALUES (43,'PH');
INSERT INTO ss_option_company VALUES (44,'PH');
INSERT INTO ss_option_company VALUES (45,'PH');
INSERT INTO ss_option_company VALUES (47,'PH');
INSERT INTO ss_option_company VALUES (48,'PH');

-- Solo Reportes
INSERT INTO ss_option_time VALUES(8,50,50);
INSERT INTO ss_option_time VALUES(9,50,50);
INSERT INTO ss_option_time VALUES(10,50,50);
INSERT INTO ss_option_time VALUES(14,50,50);
INSERT INTO ss_option_time VALUES(16,50,50);
INSERT INTO ss_option_time VALUES(21,50,50);
INSERT INTO ss_option_time VALUES(24,50,50);
INSERT INTO ss_option_time VALUES(26,50,50);
INSERT INTO ss_option_time VALUES(27,50,50);
INSERT INTO ss_option_time VALUES(28,50,50);
INSERT INTO ss_option_time VALUES(29,50,50);
INSERT INTO ss_option_time VALUES(31,50,50);
INSERT INTO ss_option_time VALUES(32,50,50);
INSERT INTO ss_option_time VALUES(38,50,50);
INSERT INTO ss_option_time VALUES(39,50,50);
INSERT INTO ss_option_time VALUES(40,50,50);
INSERT INTO ss_option_time VALUES(41,50,50);
INSERT INTO ss_option_time VALUES(42,50,50);
INSERT INTO ss_option_time VALUES(43,50,50);
INSERT INTO ss_option_time VALUES(44,50,50);
INSERT INTO ss_option_time VALUES(45,50,50);
INSERT INTO ss_option_time VALUES(47,50,50);
INSERT INTO ss_option_time VALUES(48,50,50);

DROP VIEW ss_grl_vw_menu_struct;

CREATE VIEW ss_grl_vw_menu_struct AS


    SELECT user_id, cm.option_id, cm.option_org, cm.option_desc,
"substring"((cm.option_org)::text, 1, (length((cm.option_org)::text) - 2)) AS
father, CASE WHEN (cm.action_desc IS NULL) THEN (('show-menu=sm'::text ||
rtrim((cm.option_org)::text)))::character varying ELSE cm.action_desc END AS
"action", ci.icon_path, cm.target, text(oc.option_id) AS report_opts,
"isnull"(ss_grl_fn_get_exception(cm.option_id), ''::character varying) AS
report_exceptions, option_key,
"isnull"((ss_grl_fn_get_help_options(cm.option_id))::character varying,
''::character varying) AS help_options
FROM (((ss_cat_menu_option cm JOIN ss_option_group og ON ((cm.option_id =
og.option_id))) JOIN ss_user_group ug ON ((ug.group_id = og.group_id))) LEFT
JOIN ss_cat_icon ci ON ((cm.icon_id = ci.icon_id))   
LEFT JOIN ss_option_company oc ON (cm.option_id = oc.option_id AND oc.option_id=og.option_id)
) WHERE (visible = 1) 

UNION
SELECT user_id, cm.option_id, cm.option_org, cm.option_desc,
"substring"((cm.option_org)::text, 1, (length((cm.option_org)::text) - 2)) AS
father, CASE WHEN (cm.action_desc IS NULL) THEN (('show-menu=sm'::text ||
rtrim((cm.option_org)::text)))::character varying ELSE cm.action_desc END AS
"action", ci.icon_path, cm.target, '' AS report_opts,
"isnull"(ss_grl_fn_get_exception(cm.option_id), ''::character varying) AS
report_exceptions, option_key,
"isnull"((ss_grl_fn_get_help_options(cm.option_id))::character varying,
''::character varying) AS help_options FROM ((ss_cat_menu_option cm JOIN
ss_user_group ug ON ((cm.option_id = ug.option_id))) LEFT JOIN ss_cat_icon ci
ON ((cm.icon_id = ci.icon_id))) WHERE (visible = 1);


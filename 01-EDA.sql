-- https://www.dpriver.com/pp/sqlformat.htm
-- Eventos agregados por mes
SELECT Substr(ev_date, 1, 4) yyyy,
       Count(1)              eventNbr,
       Max(ev_date)          eventMaxDt
FROM   EVENTS
GROUP  BY Substr(ev_date, 1, 4)
ORDER  BY 1 DESC; ;

-- tipo de aeronave y tipo de suceso
SELECT ev.ev_type,
       acft.meaning,
       Count(1),
       Count(DISTINCT ev.ev_id)
FROM   EVENTS ev
       inner join aircraft pl
               ON ev.ev_id = pl.ev_id
       left join eadmspub_datadictionary acft
              ON pl.acft_category = acft.code_iaids
GROUP  BY ev.ev_type,
          acft.meaning; 

-- Phase
SELECT 
    CASE 
        WHEN INSTR(Occurrence_Description, '-') > 0 THEN 
            SUBSTR(Occurrence_Description, 1, INSTR(Occurrence_Description, '-') - 1)
        ELSE 
            SUBSTR(Occurrence_Description, 1, INSTR(Occurrence_Description, ' ') - 1)
    END AS Accident_Phase,
    COUNT(1) AS Event_Count
FROM 
    Events_Sequence
WHERE 
    Defining_ev = 1
GROUP BY 
    Accident_Phase
ORDER BY 
    Event_Count DESC;

-- experiencia
SELECT Count(ev_id)
FROM   flight_time
WHERE  crew_no = 1
       AND flight_type = 'TOTL'
       AND flight_craft IN( 'ALL' )
       AND Cast(flight_hours AS INTEGER) < 3000; 

-- consulta extracción dataset
SELECT ev.ev_id, evt.meaning as ev_type, pl.regis_no,ev.ntsb_no,
ev.ev_date, ev.ev_time, ev.ev_city, ev.ev_country,ev.latitude, ev.longitude,
-- distancia aeropuerto? altura ?
plt.meaning as acft_category, pl.acft_make, acft_model,
pl.num_eng, dam.meaning as DAMAGE,
NULL as ACCIDENT_TYPE,
NULL as OPERATION_TYPE,
--'https://data.ntsb.gov/Docket?ProjectID=' || substr(ev.ev_id,-6) as ntsb_docket,
lcond.meaning as light_condition, wmc.meaning wmc,gust_ind, --wx_int_precip,
on_ground_collision,
ev.inj_f_grnd, ev.inj_m_grnd, ev.inj_s_grnd,
ev.inj_tot_f, ev.inj_tot_m, ev.inj_tot_n, ev.inj_tot_s,
ev.inj_tot_t, ev_highest_injury,
'calcular' as flight_phase,
'calcular' as defining_event,
'calcular' as survivors_b,
'POST_1982' as SOURCE
  from events ev
 inner join aircraft pl on ev.ev_id=pl.ev_id
 left join eADMSPUB_DataDictionary evt on ev.ev_type=evt.code_iaids and trim(evt.ct_name)='ct_ev_type'
 left join eADMSPUB_DataDictionary plt on pl.acft_category=plt.code_iaids and trim(plt.ct_name)='ct_acft_cat' 
 left join ct_iaids dam on pl.damage=dam.code_iaids and trim(dam.ct_name)='ct_damage'
 left join ct_iaids lcond on ev.light_cond = lcond.code_iaids and trim(lcond.ct_name)='ct_light_cond'
 left join ct_iaids wmc on ev.wx_cond_basic = wmc.code_iaids and trim(wmc.ct_name)='ct_wx_cond_b'
 --where ev.ev_id in('20251028201932','20250626200391','20190729X43816')
--where ev.ntsb_no='CEN25LA220'
;

--
SELECT ev.ev_id,
       evt.meaning   AS ev_type,
       pl.regis_no,
       ev.ntsb_no,
       ev.ev_date,
       ev.ev_time,
       ev.ev_city,
       ev.ev_country,
       ev.latitude,
       ev.longitude,
       -- aircraft
	   plt.meaning   AS acft_category,
       pl.acft_make,
       acft_model,
       pl.num_eng,
       dam.meaning   AS DAMAGE,
       tfly.meaning   AS flight_type,
       pl.afm_hrs,
       pl.date_last_insp,
       pl.afm_hrs_last_insp,	   
       --'https://data.ntsb.gov/Docket?ProjectID=' || substr(ev.ev_id,-6) as ntsb_docket,
       -- W & conditions
	   lcond.meaning AS light_condition,
       wmc.meaning   wmc,
       gust_ind,--wx_int_precip,
       on_ground_collision,
       -- injures
	   ev.inj_f_grnd,
       ev.inj_m_grnd,
       ev.inj_s_grnd,
       ev.inj_tot_f,
       ev.inj_tot_m,
       ev.inj_tot_n,
       ev.inj_tot_s,
       ev.inj_tot_t,
       ev_highest_injury,
       'calcular'    AS flight_phase,
       'calcular'    AS defining_event,
       case when inj_tot_t=inj_tot_f THEN 'F' ELSE 'T' END    AS survivors_b,
	   'calcular'    AS pilot_flight_time_model,
       'calcular'    AS pilot_flight_time_total,
       'calcular'    AS pilot_flight_time_categ,
       'POST_1982'   AS SOURCE
FROM   EVENTS ev
       inner join aircraft pl
               ON ev.ev_id = pl.ev_id
       left join eadmspub_datadictionary evt
              ON ev.ev_type = evt.code_iaids
                 AND Trim(evt.ct_name) = 'ct_ev_type'
       left join eadmspub_datadictionary plt
              ON pl.acft_category = plt.code_iaids
                 AND Trim(plt.ct_name) = 'ct_acft_cat'
       left join eadmspub_datadictionary tfly
              ON pl.type_fly = tfly.code_iaids
                 AND Trim(tfly.ct_name) = 'ct_type_fly'				 
       left join ct_iaids dam
              ON pl.damage = dam.code_iaids
                 AND Trim(dam.ct_name) = 'ct_damage'
       left join ct_iaids lcond
              ON ev.light_cond = lcond.code_iaids
                 AND Trim(lcond.ct_name) = 'ct_light_cond'
       left join ct_iaids wmc
              ON ev.wx_cond_basic = wmc.code_iaids
                 AND Trim(wmc.ct_name) = 'ct_wx_cond_b'
--where ev.ev_id in('20251028201932','20250626200391','20190729X43816')
--where ev.ntsb_no='CEN25LA220'
--where inj_tot_t=inj_tot_f and inj_tot_f>0
; 
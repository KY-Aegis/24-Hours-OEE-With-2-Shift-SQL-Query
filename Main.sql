WITH 
--view to get historical duration between 19 and 23--
Shift_B_Duration_Draft_a AS (
Select 
max(TimeStamp) as TimeStamp,
CONVERT(Varchar(10),DATEADD(day,1,max(TimeStamp)),20) as NextDay,
SUM(duration) as Total_Duration,
CAST(RIGHT(CONVERT(varchar(13),timestamp,20),2) as int) as hour,
machinename
FROM View_System_Bole
where 
CAST(RIGHT(CONVERT(varchar(13),timestamp,20),2) as int) between 20 and 23 
and CAST(value as int)!=0 
and TimeStamp<CONCAT(CONVERT(Varchar(13),getdate(),20),':00:00') 
group by machinename,CAST(RIGHT(CONVERT(varchar(13),timestamp,20),2) as int), CONVERT(varchar(10),timestamp,23)
),
--view to get historical duration between 0 to 7-
Shift_B_Duration_Draft_B as (
Select 
max(TimeStamp) as TimeStamp,
SUM(duration) as Total_Duration,
CAST(RIGHT(CONVERT(varchar(13),timestamp,20),2) as int) as hour,
machinename
FROM View_System_Bole
where 
CAST(RIGHT(CONVERT(varchar(13),timestamp,20),2) as int) between 0 and 7 
and CAST(value as int)!=0 
and TimeStamp<CONCAT(CONVERT(Varchar(13),getdate(),20),':00:00') 
group by machinename,CAST(RIGHT(CONVERT(varchar(13),timestamp,20),2) as int), CONVERT(varchar(10),timestamp,23)
),
--view to get the currrent duration at 19 to 23--
Shift_B_Duration_Draft_C as (
Select 
max(TimeStamp) as TimeStamp,
CONVERT(Varchar(10),DATEADD(day,1,max(TimeStamp)),20) as NextDay,
SUM(duration) as Total_Duration,
CAST(RIGHT(CONVERT(varchar(13),timestamp,20),2) as int) as hour,
machinename
FROM View_System_Bole
where 
CAST(RIGHT(CONVERT(varchar(13),timestamp,20),2) as int) between 20 and 23 
and CAST(value as int)!=0 
and CONVERT(varchar(10),timestamp,20)= CONVERT(varchar(10),getdate(),20)
and CAST(RIGHT(CONVERT(varchar(13),timestamp,20),2) as int)=CAST(RIGHT(CONVERT(varchar(13),getdate(),20),2) as int)
group by machinename,CAST(RIGHT(CONVERT(varchar(13),timestamp,20),2) as int), CONVERT(varchar(10),timestamp,23)
),
--view to get current duration at 0 to 7--
Shift_B_Duration_Draft_D as (
Select 
max(TimeStamp) as TimeStamp,
SUM(duration) as Total_Duration,
CAST(RIGHT(CONVERT(varchar(13),timestamp,20),2) as int) as hour,
machinename
FROM View_System_Bole
where 
CAST(RIGHT(CONVERT(varchar(13),timestamp,20),2) as int) between 0 and 7
and CAST(value as int)!=0 
and CONVERT(varchar(10),timestamp,20)= CONVERT(varchar(10),getdate(),20)
and CAST(RIGHT(CONVERT(varchar(13),timestamp,20),2) as int)=CAST(RIGHT(CONVERT(varchar(13),getdate(),20),2) as int)
group by machinename,CAST(RIGHT(CONVERT(varchar(13),timestamp,20),2) as int), CONVERT(varchar(10),timestamp,23)
),
--view to get all the latest duration from 8 to 11--
Shift_B_8_to_11 AS (
Select * FROM Shift_B_Duration_Draft_A
UNION 
Select * FROM Shift_B_Duration_Draft_C
),
--view to get latest duration from 0 to 7--
Shift_B_0_to_7 AS (
Select * FROM Shift_B_Duration_Draft_B
UNION 
Select * FROM Shift_B_Duration_Draft_D
),
---view to get sum up duration from 8 to 11--
Shift_B_8_to_11_Total AS(
Select 
NextDay,
machinename,
sum(Total_Duration) as total_duration
FROM Shift_B_8_to_11
group by NextDay,machinename
),
---view to get sum up duration from 8 to 11--
Shift_B_0_to_7_Total AS(
Select 
machinename,
CONVERT(varchar(10),timestamp,20) as timestamp,
sum(Total_Duration) as total_duration
FROM Shift_B_0_to_7
group by machinename,CONVERT(varchar(10),timestamp,20)
),
Combine_all_shift_B_Duration as ( 
Select nextday as timestamp,MachineName,total_duration FROM Shift_B_8_to_11_Total
UNION 
Select timestamp,MachineName,total_duration FROM Shift_B_0_to_7_Total
),
tempLatestVal as (
Select machinename,timestamp,sum(total_duration) as total_duration from Combine_all_shift_B_Duration group by machinename,timestamp
)
,
latestValDuration as (
Select top 2 timestamp,machinename,total_duration FROM tempLatestVal order by timestamp desc
),
--view to get historical duration between 19 and 23--
Shift_B_Duration_Draft_a_running AS (
Select 
max(TimeStamp) as TimeStamp,
CONVERT(Varchar(10),DATEADD(day,1,max(TimeStamp)),20) as NextDay,
SUM(duration) as Total_Duration,
CAST(RIGHT(CONVERT(varchar(13),timestamp,20),2) as int) as hour,
machinename
FROM View_System_Bole
where 
CAST(RIGHT(CONVERT(varchar(13),timestamp,20),2) as int) between 20 and 23 
and CAST(value as int)!=0 and CAST(value as int)!=1
and TimeStamp<CONCAT(CONVERT(Varchar(13),getdate(),20),':00:00') 
group by machinename,CAST(RIGHT(CONVERT(varchar(13),timestamp,20),2) as int), CONVERT(varchar(10),timestamp,23)
),
--view to get historical duration between 0 to 7-
Shift_B_Duration_Draft_B_running as (
Select 
max(TimeStamp) as TimeStamp,
SUM(duration) as Total_Duration,
CAST(RIGHT(CONVERT(varchar(13),timestamp,20),2) as int) as hour,
machinename
FROM View_System_Bole
where 
CAST(RIGHT(CONVERT(varchar(13),timestamp,20),2) as int) between 0 and 7 
and CAST(value as int)!=0 and CAST(value as int)!=1
and TimeStamp<CONCAT(CONVERT(Varchar(13),getdate(),20),':00:00') 
group by machinename,CAST(RIGHT(CONVERT(varchar(13),timestamp,20),2) as int), CONVERT(varchar(10),timestamp,23)
),
--view to get the currrent duration at 19 to 23--
Shift_B_Duration_Draft_C_running as (
Select 
max(TimeStamp) as TimeStamp,
CONVERT(Varchar(10),DATEADD(day,1,max(TimeStamp)),20) as NextDay,
SUM(duration) as Total_Duration,
CAST(RIGHT(CONVERT(varchar(13),timestamp,20),2) as int) as hour,
machinename
FROM View_System_Bole
where 
CAST(RIGHT(CONVERT(varchar(13),timestamp,20),2) as int) between 20 and 23 
and CAST(value as int)!=0 and CAST(value as int)!=1
and CONVERT(varchar(10),timestamp,20)= CONVERT(varchar(10),getdate(),20)
and CAST(RIGHT(CONVERT(varchar(13),timestamp,20),2) as int)=CAST(RIGHT(CONVERT(varchar(13),getdate(),20),2) as int)
group by machinename,CAST(RIGHT(CONVERT(varchar(13),timestamp,20),2) as int), CONVERT(varchar(10),timestamp,23)
),
--view to get current duration at 0 to 7--
Shift_B_Duration_Draft_D_running as (
Select 
max(TimeStamp) as TimeStamp,
SUM(duration) as Total_Duration,
CAST(RIGHT(CONVERT(varchar(13),timestamp,20),2) as int) as hour,
machinename
FROM View_System_Bole
where 
CAST(RIGHT(CONVERT(varchar(13),timestamp,20),2) as int) between 0 and 7
and CAST(value as int)!=0 
and CONVERT(varchar(10),timestamp,20)= CONVERT(varchar(10),getdate(),20)
and CAST(RIGHT(CONVERT(varchar(13),timestamp,20),2) as int)=CAST(RIGHT(CONVERT(varchar(13),getdate(),20),2) as int)
group by machinename,CAST(RIGHT(CONVERT(varchar(13),timestamp,20),2) as int), CONVERT(varchar(10),timestamp,23)
),
--view to get all the latest duration from 8 to 11--
Shift_B_8_to_11_running AS (
Select * FROM Shift_B_Duration_Draft_A_running
UNION 
Select * FROM Shift_B_Duration_Draft_C_running
),
--view to get latest duration from 0 to 7--
Shift_B_0_to_7_running AS (
Select * FROM Shift_B_Duration_Draft_B_running
UNION 
Select * FROM Shift_B_Duration_Draft_D_running
),
---view to get sum up duration from 8 to 11--
Shift_B_8_to_11_Total_running AS(
Select 
NextDay,
machinename,
sum(Total_Duration) as total_duration
FROM Shift_B_8_to_11_running
group by NextDay,machinename
),
---view to get sum up duration from 8 to 11--
Shift_B_0_to_7_Total_running AS(
Select 
machinename,
CONVERT(varchar(10),timestamp,20) as timestamp,
sum(Total_Duration) as total_duration
FROM Shift_B_0_to_7_running
group by machinename,CONVERT(varchar(10),timestamp,20)
),
Combine_all_shift_B_Duration_running as ( 
Select nextday as timestamp,MachineName,total_duration FROM Shift_B_8_to_11_Total_running
UNION 
Select timestamp,MachineName,total_duration FROM Shift_B_0_to_7_Total_running
),
tempLatestValRunning as (
Select machinename,timestamp,sum(total_duration) as total_duration from Combine_all_shift_B_Duration_running group by machinename,timestamp
),
latestValRunning as (
Select top 2 timestamp,machinename,total_duration FROM tempLatestValRunning order by timestamp desc
),
BolePerformancShiftB as( 
Select 
latestValDuration.* ,
ISNULL(latestValRunning.total_duration,0) as "TotalRuntime"
FROM latestValDuration
left join latestValRunning
on latestValDuration.machinename=latestValRunning.machinename
and latestValDuration.timestamp=latestValRunning.timestamp),
--view to get historical duration between 19 and 23--
Shift_B_Duration_Draft_a_haitian AS (
Select 
max(TimeStamp) as TimeStamp,
CONVERT(Varchar(10),DATEADD(day,1,max(TimeStamp)),20) as NextDay,
SUM(duration) as Total_Duration,
CAST(RIGHT(CONVERT(varchar(13),timestamp,20),2) as int) as hour,
machinename
FROM View_System_haitian
where 
CAST(RIGHT(CONVERT(varchar(13),timestamp,20),2) as int) between 20 and 23 
and CAST(value as int)!=0 
and TimeStamp<CONCAT(CONVERT(Varchar(13),getdate(),20),':00:00') 
group by machinename,CAST(RIGHT(CONVERT(varchar(13),timestamp,20),2) as int), CONVERT(varchar(10),timestamp,23)
),
--view to get historical duration between 0 to 7-
Shift_B_Duration_Draft_B_haitian as (
Select 
max(TimeStamp) as TimeStamp,
SUM(duration) as Total_Duration,
CAST(RIGHT(CONVERT(varchar(13),timestamp,20),2) as int) as hour,
machinename
FROM View_System_haitian
where 
CAST(RIGHT(CONVERT(varchar(13),timestamp,20),2) as int) between 0 and 7 
and CAST(value as int)!=0 
and TimeStamp<CONCAT(CONVERT(Varchar(13),getdate(),20),':00:00') 
group by machinename,CAST(RIGHT(CONVERT(varchar(13),timestamp,20),2) as int), CONVERT(varchar(10),timestamp,23)
),
--view to get the currrent duration at 19 to 23--
Shift_B_Duration_Draft_C_haitian as (
Select 
max(TimeStamp) as TimeStamp,
CONVERT(Varchar(10),DATEADD(day,1,max(TimeStamp)),20) as NextDay,
SUM(duration) as Total_Duration,
CAST(RIGHT(CONVERT(varchar(13),timestamp,20),2) as int) as hour,
machinename
FROM View_System_haitian
where 
CAST(RIGHT(CONVERT(varchar(13),timestamp,20),2) as int) between 20 and 23 
and CAST(value as int)!=0 
and CONVERT(varchar(10),timestamp,20)= CONVERT(varchar(10),getdate(),20)
and CAST(RIGHT(CONVERT(varchar(13),timestamp,20),2) as int)=CAST(RIGHT(CONVERT(varchar(13),getdate(),20),2) as int)
group by machinename,CAST(RIGHT(CONVERT(varchar(13),timestamp,20),2) as int), CONVERT(varchar(10),timestamp,23)
),
--view to get current duration at 0 to 7--
Shift_B_Duration_Draft_D_haitian as (
Select 
max(TimeStamp) as TimeStamp,
SUM(duration) as Total_Duration,
CAST(RIGHT(CONVERT(varchar(13),timestamp,20),2) as int) as hour,
machinename
FROM View_System_haitian
where 
CAST(RIGHT(CONVERT(varchar(13),timestamp,20),2) as int) between 0 and 7
and CAST(value as int)!=0 
and CONVERT(varchar(10),timestamp,20)= CONVERT(varchar(10),getdate(),20)
and CAST(RIGHT(CONVERT(varchar(13),timestamp,20),2) as int)=CAST(RIGHT(CONVERT(varchar(13),getdate(),20),2) as int)
group by machinename,CAST(RIGHT(CONVERT(varchar(13),timestamp,20),2) as int), CONVERT(varchar(10),timestamp,23)
),
--view to get all the latest duration from 8 to 11--
Shift_B_8_to_11_haitian AS (
Select * FROM Shift_B_Duration_Draft_A_haitian
UNION 
Select * FROM Shift_B_Duration_Draft_C_haitian
),
--view to get latest duration from 0 to 7--
Shift_B_0_to_7_haitian AS (
Select * FROM Shift_B_Duration_Draft_B_haitian
UNION 
Select * FROM Shift_B_Duration_Draft_D_haitian
),
---view to get sum up duration from 8 to 11--
Shift_B_8_to_11_Total_haitian AS(
Select 
NextDay,
machinename,
sum(Total_Duration) as total_duration
FROM Shift_B_8_to_11_haitian
group by NextDay,machinename
),
---view to get sum up duration from 8 to 11--
Shift_B_0_to_7_Total_haitian AS(
Select 
machinename,
CONVERT(varchar(10),timestamp,20) as timestamp,
sum(Total_Duration) as total_duration
FROM Shift_B_0_to_7_haitian
group by machinename,CONVERT(varchar(10),timestamp,20)
),
Combine_all_shift_B_Duration_haitian as ( 
Select nextday as timestamp,MachineName,total_duration FROM Shift_B_8_to_11_Total_haitian
UNION 
Select timestamp,MachineName,total_duration FROM Shift_B_0_to_7_Total_haitian
),
tempLatestValDurationHaitian as (
Select machinename,timestamp,sum(total_duration) as total_duration from Combine_all_shift_B_Duration_haitian group by machinename,timestamp
),
latestValDuration_haitian as (
Select top 2 timestamp,machinename,total_duration FROM tempLatestValDurationHaitian order by timestamp desc
),
--view to get historical duration between 19 and 23--
Shift_B_Duration_Draft_a_running_haitian AS (
Select 
max(TimeStamp) as TimeStamp,
CONVERT(Varchar(10),DATEADD(day,1,max(TimeStamp)),20) as NextDay,
SUM(duration) as Total_Duration,
CAST(RIGHT(CONVERT(varchar(13),timestamp,20),2) as int) as hour,
machinename
FROM View_System_haitian
where 
CAST(RIGHT(CONVERT(varchar(13),timestamp,20),2) as int) between 20 and 23 
and CAST(value as int)!=0 and CAST(value as int)!=1
and TimeStamp<CONCAT(CONVERT(Varchar(13),getdate(),20),':00:00') 
group by machinename,CAST(RIGHT(CONVERT(varchar(13),timestamp,20),2) as int), CONVERT(varchar(10),timestamp,23)
),
--view to get historical duration between 0 to 7-
Shift_B_Duration_Draft_B_running_haitian as (
Select 
max(TimeStamp) as TimeStamp,
SUM(duration) as Total_Duration,
CAST(RIGHT(CONVERT(varchar(13),timestamp,20),2) as int) as hour,
machinename
FROM View_System_haitian
where 
CAST(RIGHT(CONVERT(varchar(13),timestamp,20),2) as int) between 0 and 7 
and CAST(value as int)!=0 and CAST(value as int)!=1
and TimeStamp<CONCAT(CONVERT(Varchar(13),getdate(),20),':00:00') 
group by machinename,CAST(RIGHT(CONVERT(varchar(13),timestamp,20),2) as int), CONVERT(varchar(10),timestamp,23)
),
--view to get the currrent duration at 19 to 23--
Shift_B_Duration_Draft_C_running_haitian as (
Select 
max(TimeStamp) as TimeStamp,
CONVERT(Varchar(10),DATEADD(day,1,max(TimeStamp)),20) as NextDay,
SUM(duration) as Total_Duration,
CAST(RIGHT(CONVERT(varchar(13),timestamp,20),2) as int) as hour,
machinename
FROM View_System_haitian
where 
CAST(RIGHT(CONVERT(varchar(13),timestamp,20),2) as int) between 20 and 23 
and CAST(value as int)!=0 and CAST(value as int)!=1
and CONVERT(varchar(10),timestamp,20)= CONVERT(varchar(10),getdate(),20)
and CAST(RIGHT(CONVERT(varchar(13),timestamp,20),2) as int)=CAST(RIGHT(CONVERT(varchar(13),getdate(),20),2) as int)
group by machinename,CAST(RIGHT(CONVERT(varchar(13),timestamp,20),2) as int), CONVERT(varchar(10),timestamp,23)
),
--view to get current duration at 0 to 7--
Shift_B_Duration_Draft_D_running_haitian as (
Select 
max(TimeStamp) as TimeStamp,
SUM(duration) as Total_Duration,
CAST(RIGHT(CONVERT(varchar(13),timestamp,20),2) as int) as hour,
machinename
FROM View_System_haitian
where 
CAST(RIGHT(CONVERT(varchar(13),timestamp,20),2) as int) between 0 and 7
and CAST(value as int)!=0 
and CONVERT(varchar(10),timestamp,20)= CONVERT(varchar(10),getdate(),20)
and CAST(RIGHT(CONVERT(varchar(13),timestamp,20),2) as int)=CAST(RIGHT(CONVERT(varchar(13),getdate(),20),2) as int)
group by machinename,CAST(RIGHT(CONVERT(varchar(13),timestamp,20),2) as int), CONVERT(varchar(10),timestamp,23)
),
--view to get all the latest duration from 8 to 11--
Shift_B_8_to_11_running_haitian AS (
Select * FROM Shift_B_Duration_Draft_A_running_haitian
UNION 
Select * FROM Shift_B_Duration_Draft_C_running_haitian
),
--view to get latest duration from 0 to 7--
Shift_B_0_to_7_running_haitian AS (
Select * FROM Shift_B_Duration_Draft_B_running_haitian
UNION 
Select * FROM Shift_B_Duration_Draft_D_running_haitian
),
---view to get sum up duration from 8 to 11--
Shift_B_8_to_11_Total_running_haitian AS(
Select 
NextDay,
machinename,
sum(Total_Duration) as total_duration
FROM Shift_B_8_to_11_running_haitian
group by NextDay,machinename
),
---view to get sum up duration from 8 to 11--
Shift_B_0_to_7_Total_running_haitian AS(
Select 
machinename,
CONVERT(varchar(10),timestamp,20) as timestamp,
sum(Total_Duration) as total_duration
FROM Shift_B_0_to_7_running_haitian
group by machinename,CONVERT(varchar(10),timestamp,20)
),
Combine_all_shift_B_Duration_running_haitian as ( 
Select nextday as timestamp,MachineName,total_duration FROM Shift_B_8_to_11_Total_running_haitian
UNION 
Select timestamp,MachineName,total_duration FROM Shift_B_0_to_7_Total_running_haitian
),
tempLatestValRunningHaitian as (
Select machinename,timestamp,sum(total_duration) as total_duration from Combine_all_shift_B_Duration_running_haitian group by machinename,timestamp
),
latestValRunning_haitian as (
Select top 2 timestamp,machinename,total_duration FROM tempLatestValRunningHaitian order by timestamp desc
),
HaitianPerformancShiftB as( 
select 
latestValDuration_haitian.* ,
ISNULL(latestValRunning_haitian.total_duration,0) as "TotalRuntime"
FROM latestValDuration_haitian
left join latestValRunning_haitian
on latestValDuration_haitian.machinename=latestValRunning_haitian.machinename
and latestValDuration_haitian.timestamp=latestValRunning_haitian.timestamp
),
ShiftBALLDuration as(
Select *,cast(TotalRuntime as float)/cast(total_duration as float)*100 as Availability FROM HaitianPerformancShiftB
UNION
Select *,cast(TotalRuntime as float)/cast(total_duration as float)*100 as Availability FROM  BolePerformancShiftB
),
ShiftBShotCountDraftA as(
Select 
max(TimeStamp) as TimeStamp,
CONVERT(Varchar(10),DATEADD(day,1,max(TimeStamp)),20) as NextDay,
ISNULL(SUM(output),0) as Total_ShotCount,
CAST(RIGHT(CONVERT(varchar(13),timestamp,20),2) as int) as hour,
machinename
FROM P_MachineOutputMin
where 
CAST(RIGHT(CONVERT(varchar(13),timestamp,20),2) as int) between 20 and 23 
and TimeStamp<CONCAT(CONVERT(Varchar(13),getdate(),20),':00:00') 
group by machinename,CAST(RIGHT(CONVERT(varchar(13),timestamp,20),2) as int), CONVERT(varchar(10),timestamp,23)
),
--view to get historical duration between 0 to 7-
ShiftBShotCountDraftB as (
Select 
max(TimeStamp) as TimeStamp,
ISNULL(SUM(output),0) as Total_ShotCount,
CAST(RIGHT(CONVERT(varchar(13),timestamp,20),2) as int) as hour,
machinename
FROM P_MachineOutputMin
where 
CAST(RIGHT(CONVERT(varchar(13),timestamp,20),2) as int) between 0 and 7 
and TimeStamp<CONCAT(CONVERT(Varchar(13),getdate(),20),':00:00') 
group by machinename,CAST(RIGHT(CONVERT(varchar(13),timestamp,20),2) as int), CONVERT(varchar(10),timestamp,23)
),
ShiftBShotCountDraftC as (
Select 
max(TimeStamp) as TimeStamp,
CONVERT(Varchar(10),DATEADD(day,1,max(TimeStamp)),20) as NextDay,
ISNULL(SUM(output),0) as Total_ShotCount,
CAST(RIGHT(CONVERT(varchar(13),timestamp,20),2) as int) as hour,
machinename
FROM P_MachineOutputMin
where 
CAST(RIGHT(CONVERT(varchar(13),timestamp,20),2) as int) between 20 and 23 
and CONVERT(varchar(10),timestamp,20)= CONVERT(varchar(10),getdate(),20)
and CAST(RIGHT(CONVERT(varchar(13),timestamp,20),2) as int)=CAST(RIGHT(CONVERT(varchar(13),getdate(),20),2) as int)
group by machinename,CAST(RIGHT(CONVERT(varchar(13),timestamp,20),2) as int), CONVERT(varchar(10),timestamp,23)
),
ShiftBShotCountDraftD as (
Select 
max(TimeStamp) as TimeStamp,
ISNULL(SUM(Output),0) as Total_ShotCount,
CAST(RIGHT(CONVERT(varchar(13),timestamp,20),2) as int) as hour,
machinename
FROM P_MachineOutputMin
where 
CAST(RIGHT(CONVERT(varchar(13),timestamp,20),2) as int) between 0 and 7
and CONVERT(varchar(10),timestamp,20)= CONVERT(varchar(10),getdate(),20)
and CAST(RIGHT(CONVERT(varchar(13),timestamp,20),2) as int)=CAST(RIGHT(CONVERT(varchar(13),getdate(),20),2) as int)
group by machinename,CAST(RIGHT(CONVERT(varchar(13),timestamp,20),2) as int), CONVERT(varchar(10),timestamp,23)
),
Shift_B_8_to_11_ShotCount AS (
Select * FROM ShiftBShotCountDraftA
UNION 
Select * FROM ShiftBShotCountDraftC
),
--view to get latest duration from 0 to 7--
Shift_B_0_to_7_ShotCount AS (
Select * FROM ShiftBShotCountDraftB
UNION 
Select * FROM ShiftBShotCountDraftD
),
orderinputShiftBdata as(
Select 
OperationDate,
CAST(RIGHT(convert(varchar(13),processtime,20),2)as int) as "hr",
Order_Quantity,
OrderNumber,
machinename,
partnumber,
partname,
toolletter,
ActualCAVRun,
MachineCycleTime
FROM P_MachineOrderHourly
where CAST(RIGHT(convert(varchar(13),processtime,20),2)as int) not between 8 and 19
),
ShiftBShotCountAll as (
Select 
nextday as date,
SUM(Total_ShotCount) as totalshotcount,
hour,
MachineName
FROM Shift_B_8_to_11_ShotCount
group by machinename,CONVERT(varchar(10),timestamp,20),nextday,hour
UNION
Select 
CONVERT(varchar(10),timestamp,20) as date,
SUM(Total_ShotCount) as totalshotcount,
hour,
MachineName
FROM Shift_B_0_to_7_ShotCount
group by machinename,CONVERT(varchar(10),timestamp,20),hour
),
Quality (reject,mac,date,hr) AS 
(
Select SUM(RejectCount),
machinename,
convert(varchar(10),Timestamp,20) as OperationDate,
CAST(substring(convert(varchar,Timestamp,20),12,2)as INT) as OperationHour
FROM
R_ProductionOutputInput
Group by machinename,convert(varchar(10),Timestamp,20),CAST(substring(convert(varchar,Timestamp,20),12,2)as INT)
),
--view to combine all the p and q data for shift B--
OEE_Draft_1 as (
Select 
row_number() OVER(partition by ShiftBShotCountAll.MachineName order by ShiftBShotCountAll.date desc) as rn,
orderinputShiftBdata.*,
ISNULL(Quality.reject,0) as reject,
ShiftBShotCountAll.date as timestamp,
ISNULL(ShiftBShotCountAll.totalshotcount,0) as shotcount,
CAST(3600/orderinputShiftBdata.machinecycletime as int) as targetoutput,
CAST(ShiftBShotCountAll.totalshotcount as float)*orderinputShiftBdata.ActualCAVRun as totalOutput
FROM ShiftBShotCountAll
LEFT JOIN orderinputShiftBdata
ON ShiftBShotCountAll.machinename=orderinputShiftBdata.machinename
and ShiftBShotCountAll.hour=orderinputShiftBdata.hr
and DATEADD(day,-1,ShiftBShotCountAll.date)=orderinputShiftBdata.OperationDate
LEFT JOIN Quality
ON ShiftBShotCountAll.machinename=Quality.mac
and ShiftBShotCountAll.hour=Quality.hr
and DATEADD(day,-1,ShiftBShotCountAll.date)=Quality.date
),
AccumulateTemp as(
Select machinename, timestamp,
SUM (Order_Quantity) as "AccumulatedOrderQuantity",
SUM(actualCAVRUN) as "AccumulatedCavity",
SUM(machinecycletime) as "AccumulatedIdealCycleTime",
SUM(reject) as "AccumulatedReject",
SUM(shotcount) as "AccumulatedShotCount",
SUM(targetoutput) as "AccumulatedTargetOutput",
SUM(totalOutput) as "AccumulatedTotalOutput"
FROM OEE_Draft_1
group by MachineName,timestamp
),
AccumulatedValues as(
select * FROM (Select TOP 4 * FROM AccumulateTemp ORDER BY timestamp DESC)a
),
MaxRowIdentifier as (
Select max(rn) as maxrow,MachineName FROM OEE_Draft_1  group by MachineName,timestamp
),
latestOEEinfoShiftB as (
Select 
CONVERT(varchar(10),timestamp,20) as timestamp,
cast(OEE_Draft_1.Order_Quantity as int) as "CurrentOrderQty", 
cast(OEE_Draft_1.OrderNumber as varchar) as "CurrentOrderNumber",  
cast(OEE_Draft_1.MachineName as varchar) as machinename,  
cast(OEE_Draft_1.partnumber as varchar) as "CurrentPartNumber",  
cast(OEE_Draft_1.partname as varchar) as "CurrentPartName", 
cast(OEE_Draft_1.ToolLetter as varchar) as "CurrentToolLetter",
cast(OEE_Draft_1.ActualCavRun as int) as "CurrentCavity",
cast(OEE_Draft_1.MachineCycleTime as int) as "CurrentIdealCycleTime", 
cast(OEE_Draft_1.Reject as int) as "CurrentReject", 
cast(OEE_Draft_1.ShotCount as int) as "CurrentShotCount",
cast(OEE_Draft_1.targetoutput as int) as "CurrentTargetOutput", 
cast(OEE_Draft_1.totalOutput as int) as "CurrentTotalOutput" 
FROM MaxRowIdentifier
left join OEE_Draft_1
on OEE_Draft_1.rn=MaxRowIdentifier.maxrow
and OEE_Draft_1.MachineName=MaxRowIdentifier.MachineName
),
ShiftBFinalized_P_Q as (
Select 
CAST(AccumulatedValues.AccumulatedOrderQuantity as int) as AccumulatedOrderQuantity,
CAST(AccumulatedValues.AccumulatedCavity as int) as AccumulatedCavity,
CAST(AccumulatedValues.AccumulatedReject as int) as AccumulatedReject,
CAST(AccumulatedValues.AccumulatedShotCount as int) as AccumulatedShotCount,
CAST(AccumulatedValues.AccumulatedTargetOutput as int) as AccumulatedTargetOutput,
CAST(AccumulatedValues.AccumulatedTotalOutput as int) as AccumulatedTotalOutput,
latestOEEinfoShiftB.timestamp,
latestOEEinfoShiftB.CurrentOrderQty,
latestOEEinfoShiftB.CurrentOrderNumber,
latestOEEinfoShiftB.machinename,
latestOEEinfoShiftB.CurrentPartNumber,
latestOEEinfoShiftB.CurrentPartName,
latestOEEinfoShiftB.CurrentToolLetter,
latestOEEinfoShiftB.CurrentCavity,
latestOEEinfoShiftB.CurrentIdealCycleTime,
latestOEEinfoShiftB.CurrentReject,
latestOEEinfoShiftB.CurrentShotCount,
latestOEEinfoShiftB.CurrentTargetOutput,
latestOEEinfoShiftB.CurrentTotalOutput,
case when CAST(AccumulatedValues.AccumulatedTotalOutput as int)<1
then 0
else CAST(AccumulatedValues.AccumulatedShotCount as float)/CAST(AccumulatedValues.AccumulatedTargetOutput as float)*100 
end as Performance,
case when CAST(AccumulatedValues.AccumulatedTotalOutput as int)<1
then 0
else (CAST(AccumulatedValues.AccumulatedTotalOutput as float)-CAST(AccumulatedValues.AccumulatedReject as float))/CAST(AccumulatedValues.AccumulatedTotalOutput as float)*100 
end as Quality
FROM AccumulatedValues
left join latestOEEinfoShiftB
on latestOEEinfoShiftB.MachineName=AccumulatedValues.machinename
and latestOEEinfoShiftB.timestamp=AccumulatedValues.timestamp
) ,
Shift_B_Finalized_OEE as (
Select 'B' as "Shift",
cast(ShiftBALLDuration.Availability as float) as Availability,
CAST(ShiftBALLDuration.total_duration as int) as total_duration,
CAST(ShiftBALLDuration.TotalRuntime as int) as TotalRuntime,
(CAST(ShiftBALLDuration.availability as float)*CAST(ShiftBFinalized_P_Q.Performance as float)*CAST(ShiftBFinalized_P_Q.Quality as float)/1000000)*100 as OEE,
ShiftBFinalized_P_Q.AccumulatedCavity,
ShiftBFinalized_P_Q.AccumulatedReject,
ShiftBFinalized_P_Q.AccumulatedShotCount,
ShiftBFinalized_P_Q.AccumulatedTargetOutput,
ShiftBFinalized_P_Q.AccumulatedTotalOutput,
ShiftBFinalized_P_Q.AccumulatedOrderQuantity,
CONVERT(varchar(10),ShiftBFinalized_P_Q.timestamp,20) as timestamp,
ShiftBFinalized_P_Q.CurrentOrderQty,
CAST(ShiftBFinalized_P_Q.CurrentOrderNumber as varchar) as CurrentOrderNumber,
ShiftBFinalized_P_Q.machinename,
CAST(ShiftBFinalized_P_Q.CurrentPartNumber as varchar) as CurrentPartNumber,
CAST(ShiftBFinalized_P_Q.CurrentPartName as varchar) as CurrentPartName,
CAST(ShiftBFinalized_P_Q.CurrentToolLetter as varchar) as CurrentToolLetter,
ShiftBFinalized_P_Q.CurrentCavity,
ShiftBFinalized_P_Q.CurrentIdealCycleTime,
ShiftBFinalized_P_Q.CurrentReject,
ShiftBFinalized_P_Q.CurrentShotCount,
ShiftBFinalized_P_Q.CurrentTargetOutput,
ShiftBFinalized_P_Q.CurrentTotalOutput,
ShiftBFinalized_P_Q.Quality,
ShiftBFinalized_P_Q.Performance
FROM ShiftBALLDuration
LEFT JOIN ShiftBFinalized_P_Q
on ShiftBFinalized_P_Q.MachineName=ShiftBALLDuration.MachineName
and ShiftBFinalized_P_Q.timestamp=ShiftBALLDuration.timestamp
),
Shift_A_Duration_Draft_Haitian as (
Select 
max(TimeStamp) as TimeStamp,
SUM(duration) as Total_Duration,
CAST(RIGHT(CONVERT(varchar(13),timestamp,20),2) as int) as hour,
machinename
FROM View_System_Haitian
where 
CAST(RIGHT(CONVERT(varchar(13),timestamp,20),2) as int) between 8 and 19 
and CAST(value as int)!=0 
and TimeStamp<CONCAT(CONVERT(Varchar(13),getdate(),20),':00:00') 
group by machinename,CAST(RIGHT(CONVERT(varchar(13),timestamp,20),2) as int), CONVERT(varchar(10),timestamp,23)
),
Shift_A_Duration_Draft_B_Haitian as (
Select 
max(TimeStamp) as TimeStamp,
SUM(duration) as Total_Duration,
CAST(RIGHT(CONVERT(varchar(13),timestamp,20),2) as int) as hour,
machinename
FROM View_System_Haitian
where 
CAST(RIGHT(CONVERT(varchar(13),timestamp,20),2) as int) between 8 and 19 
and CAST(value as int)!=0 
and CONVERT(varchar(10),timestamp,20)= CONVERT(varchar(10),getdate(),20)
and CAST(RIGHT(CONVERT(varchar(13),timestamp,20),2) as int)=CAST(RIGHT(CONVERT(varchar(13),getdate(),20),2) as int)
group by machinename,CAST(RIGHT(CONVERT(varchar(13),timestamp,20),2) as int), CONVERT(varchar(10),timestamp,23)
),
--view to combine all the durations--
ShiftA_Combine_Haitian as (
Select * FROM Shift_A_Duration_Draft_Haitian
UNION
Select * FROm Shift_A_Duration_Draft_B_Haitian
),
RealTime_Haitian as (
Select 
CONVERT(varchar(10),TimeStamp,23) as timestamp,
machinename,
sum(Total_Duration) as total_duration
FROM ShiftA_Combine_Haitian
group by CONVERT(varchar(10),TimeStamp,23),machinename
),
running_historical_Haitian as (
Select 
max(TimeStamp) as TimeStamp,
SUM(duration) as Total_Duration,
CAST(RIGHT(CONVERT(varchar(13),timestamp,20),2) as int) as hour,
machinename
FROM View_System_Haitian
where 
CAST(RIGHT(CONVERT(varchar(13),timestamp,20),2) as int) between 8 and 19 
and CAST(value as int)!=0  and CAST(value as int)!=1
and TimeStamp<CONCAT(CONVERT(Varchar(13),getdate(),20),':00:00') 
group by machinename,CAST(RIGHT(CONVERT(varchar(13),timestamp,20),2) as int), CONVERT(varchar(10),timestamp,23)
),
running_real_time_Haitian as (
Select 
max(TimeStamp) as TimeStamp,
SUM(duration) as Total_Duration,
CAST(RIGHT(CONVERT(varchar(13),timestamp,20),2) as int) as hour,
machinename
FROM View_System_Haitian
where 
CAST(RIGHT(CONVERT(varchar(13),timestamp,20),2) as int) between 8 and 19 
and CAST(value as int)!=0  and CAST(value as int)!=1
and CONVERT(varchar(10),timestamp,20)= CONVERT(varchar(10),getdate(),20)
and CAST(RIGHT(CONVERT(varchar(13),timestamp,20),2) as int)=CAST(RIGHT(CONVERT(varchar(13),getdate(),20),2) as int)
group by machinename,CAST(RIGHT(CONVERT(varchar(13),timestamp,20),2) as int), CONVERT(varchar(10),timestamp,23)
),
--view to combine all the durations--
ShiftA_Combine_runtime_Haitian as (
Select * FROM running_historical_Haitian
UNION
Select * FROm running_real_time_Haitian
),
RealTime_runtime_Haitian as (
Select 
CONVERT(varchar(10),TimeStamp,23) as timestamp,
machinename,
sum(Total_Duration) as total_duration
FROM ShiftA_Combine_runtime_Haitian
group by CONVERT(varchar(10),TimeStamp,23),machinename
),
All_Duration_Shift_A_Haitian as (
Select  
RealTime_Haitian.*,
ISNULL(RealTime_runtime_Haitian.total_duration,0) as "TotalRuntime",
CAST(RealTime_runtime_Haitian.total_duration as float)/CAST(RealTime_Haitian.total_duration as float)*100 as Availability
FROm RealTime_Haitian
LEFT JOIN RealTime_runtime_Haitian
on RealTime_runtime_Haitian.timestamp=RealTime_Haitian.timestamp
and RealTime_runtime_Haitian.machinename=RealTime_Haitian.machinename
),
Shift_A_Duration_Draft as (
Select 
max(TimeStamp) as TimeStamp,
SUM(duration) as Total_Duration,
CAST(RIGHT(CONVERT(varchar(13),timestamp,20),2) as int) as hour,
machinename
FROM View_System_Bole
where 
CAST(RIGHT(CONVERT(varchar(13),timestamp,20),2) as int) between 8 and 19 
and CAST(value as int)!=0 
and TimeStamp<CONCAT(CONVERT(Varchar(13),getdate(),20),':00:00') 
group by machinename,CAST(RIGHT(CONVERT(varchar(13),timestamp,20),2) as int), CONVERT(varchar(10),timestamp,23)
),
Shift_A_Duration_Draft_B as (
Select 
max(TimeStamp) as TimeStamp,
SUM(duration) as Total_Duration,
CAST(RIGHT(CONVERT(varchar(13),timestamp,20),2) as int) as hour,
machinename
FROM View_System_Bole
where 
CAST(RIGHT(CONVERT(varchar(13),timestamp,20),2) as int) between 8 and 19 
and CAST(value as int)!=0 
and CONVERT(varchar(10),timestamp,20)= CONVERT(varchar(10),getdate(),20)
and CAST(RIGHT(CONVERT(varchar(13),timestamp,20),2) as int)=CAST(RIGHT(CONVERT(varchar(13),getdate(),20),2) as int)
group by machinename,CAST(RIGHT(CONVERT(varchar(13),timestamp,20),2) as int), CONVERT(varchar(10),timestamp,23)
),
--view to combine all the durations--
ShiftA_Combine as (
Select * FROM Shift_A_Duration_Draft
UNION
Select * FROm Shift_A_Duration_Draft_B
),
Bole_RealTime as (
Select 
CONVERT(varchar(10),TimeStamp,23) as timestamp,
machinename,
sum(Total_Duration) as total_duration
FROM ShiftA_Combine
group by CONVERT(varchar(10),TimeStamp,23),machinename
),
bole_running_historical as (
Select 
max(TimeStamp) as TimeStamp,
SUM(duration) as Total_Duration,
CAST(RIGHT(CONVERT(varchar(13),timestamp,20),2) as int) as hour,
machinename
FROM View_System_Bole
where 
CAST(RIGHT(CONVERT(varchar(13),timestamp,20),2) as int) between 8 and 19 
and CAST(value as int)!=0  and CAST(value as int)!=1
and TimeStamp<CONCAT(CONVERT(Varchar(13),getdate(),20),':00:00') 
group by machinename,CAST(RIGHT(CONVERT(varchar(13),timestamp,20),2) as int), CONVERT(varchar(10),timestamp,23)
),
bole_running_real_time as (
Select 
max(TimeStamp) as TimeStamp,
SUM(duration) as Total_Duration,
CAST(RIGHT(CONVERT(varchar(13),timestamp,20),2) as int) as hour,
machinename
FROM View_System_Bole
where 
CAST(RIGHT(CONVERT(varchar(13),timestamp,20),2) as int) between 8 and 19 
and CAST(value as int)!=0  and CAST(value as int)!=1
and CONVERT(varchar(10),timestamp,20)= CONVERT(varchar(10),getdate(),20)
and CAST(RIGHT(CONVERT(varchar(13),timestamp,20),2) as int)=CAST(RIGHT(CONVERT(varchar(13),getdate(),20),2) as int)
group by machinename,CAST(RIGHT(CONVERT(varchar(13),timestamp,20),2) as int), CONVERT(varchar(10),timestamp,23)
),
--view to combine all the durations--
ShiftA_Combine_runtime as (
Select * FROM bole_running_historical
UNION
Select * FROm bole_running_real_time
),
Bole_RealTime_runtime as (
Select 
CONVERT(varchar(10),TimeStamp,23) as timestamp,
machinename,
sum(Total_Duration) as total_duration
FROM ShiftA_Combine_runtime
group by CONVERT(varchar(10),TimeStamp,23),machinename
),
Bole_All_Duration_Shift_A as (
Select  
Bole_RealTime.*,
ISNULL(Bole_RealTime_runtime.total_duration,0) as "TotalRuntime",
CAST(Bole_RealTime_runtime.total_duration as float)/CAST(Bole_RealTime.total_duration as float)*100 as Availability
FROm Bole_RealTime
LEFT JOIN Bole_RealTime_runtime
on Bole_RealTime_runtime.timestamp=Bole_RealTime.timestamp
and Bole_RealTime_runtime.machinename=Bole_RealTime.machinename
),
latesthaitian as (
Select TOP 2 * FROM All_Duration_Shift_A_Haitian order by timestamp desc
),
latestbole as (
Select TOP 2 * FROM Bole_All_Duration_Shift_A order by timestamp desc
),
combine_Shift_A_Availability as (
Select * FROm latesthaitian
union
Select * FROM latestbole
),
ShotCount_History_Shift_A as (
Select 
max(TimeStamp) as TimeStamp,
ISNULL(SUM(output),0) as Total_ShotCount,
CAST(RIGHT(CONVERT(varchar(13),timestamp,20),2) as int) as hour,
machinename
FROM P_MachineOutputMin
where 
CAST(RIGHT(CONVERT(varchar(13),timestamp,20),2) as int) between 8 and 19
and TimeStamp<CONCAT(CONVERT(Varchar(13),getdate(),20),':00:00') 
group by machinename,CAST(RIGHT(CONVERT(varchar(13),timestamp,20),2) as int), CONVERT(varchar(10),timestamp,23)
),
latest_shotcount_shift_A as (
Select 
max(TimeStamp) as TimeStamp,
ISNULL(SUM(output),0) as Total_ShotCount,
CAST(RIGHT(CONVERT(varchar(13),timestamp,20),2) as int) as hour,
machinename
FROM P_MachineOutputMin
where 
CAST(RIGHT(CONVERT(varchar(13),timestamp,20),2) as int) between 8 and 19
and CONVERT(varchar(10),timestamp,20)= CONVERT(varchar(10),getdate(),20)
and CAST(RIGHT(CONVERT(varchar(13),timestamp,20),2) as int)=CAST(RIGHT(CONVERT(varchar(13),getdate(),20),2) as int)
group by machinename,CAST(RIGHT(CONVERT(varchar(13),timestamp,20),2) as int), CONVERT(varchar(10),timestamp,23)
),
Shift_A_ShotCount AS (
Select * FROM ShotCount_History_Shift_A
UNION 
Select * FROM latest_shotcount_shift_A
),
SHift_A_Order_input as(
Select 
OperationDate,
CAST(RIGHT(convert(varchar(13),processtime,20),2)as int) as "hr",
Order_Quantity,
OrderNumber,
machinename,
partnumber,
partname,
toolletter,
ActualCAVRun,
MachineCycleTime
FROM P_MachineOrderHourly
where CAST(RIGHT(convert(varchar(13),processtime,20),2)as int) between 8 and 19
),
shift_A_combine as (
Select 
CONVERT(varchar(10),timestamp,20) as date,
SUM(Total_ShotCount) as totalshotcount,
hour,
MachineName
FROM Shift_A_ShotCount
group by machinename,CONVERT(varchar(10),timestamp,20),hour
),
Quality_A (reject,mac,date,hr) AS 
(
Select SUM(RejectCount),
machinename,
convert(varchar(10),Timestamp,20) as OperationDate,
CAST(substring(convert(varchar,Timestamp,20),12,2)as INT) as OperationHour
FROM
R_ProductionOutputInput
Group by machinename,convert(varchar(10),Timestamp,20),CAST(substring(convert(varchar,Timestamp,20),12,2)as INT)
),
Shift_A_P_Q_DATAS as (
Select 
row_number() OVER(partition by shift_A_combine.MachineName order by shift_A_combine.date desc) as rn,
SHift_A_Order_input.*,
ISNULL(Quality_A.reject,0) as reject,
shift_A_combine.date as timestamp,
ISNULL(shift_A_combine.totalshotcount,0) as shotcount,
CAST(3600/SHift_A_Order_input.machinecycletime as int) as targetoutput,
CAST(shift_A_combine.totalshotcount as float)*SHift_A_Order_input.ActualCAVRun as totalOutput
FROM shift_A_combine
LEFT JOIN SHift_A_Order_input
ON shift_A_combine.machinename=SHift_A_Order_input.machinename
and shift_A_combine.hour=SHift_A_Order_input.hr
and shift_A_combine.date=SHift_A_Order_input.OperationDate
LEFT JOIN Quality_A
ON shift_A_combine.machinename=Quality_A.mac
and shift_A_combine.hour=Quality_A.hr
and shift_A_combine.date=Quality_A.date
),
AccumulateTemp_A as(
Select machinename, timestamp,
SUM (Order_Quantity) as "AccumulatedOrderQuantity",
SUM(actualCAVRUN) as "AccumulatedCavity",
SUM(machinecycletime) as "AccumulatedIdealCycleTime",
SUM(reject) as "AccumulatedReject",
SUM(shotcount) as "AccumulatedShotCount",
SUM(targetoutput) as "AccumulatedTargetOutput",
SUM(totalOutput) as "AccumulatedTotalOutput"
FROM Shift_A_P_Q_DATAS
group by MachineName,timestamp
),
AccumulatedValues_A as(
select * FROM (Select TOP 4 * FROM AccumulateTemp_A ORDER BY timestamp DESC)a
),
MaxRowIdentifier_A as (
Select max(rn) as maxrow,MachineName FROM Shift_A_P_Q_DATAS group by MachineName,timestamp
),
latestOEEinfoShiftA as (
Select 
Convert(varchar(10),timestamp,20) as timestamp,
CAST(Shift_A_P_Q_DATAS.Order_Quantity as int) as "CurrentOrderQty", 
CAST(Shift_A_P_Q_DATAS.OrderNumber as varchar) as "CurrentOrderNumber",  
CAST(Shift_A_P_Q_DATAS.MachineName as varchar) as machinename, 
CAST(Shift_A_P_Q_DATAS.partnumber as varchar) as "CurrentPartNumber",  
CAST(Shift_A_P_Q_DATAS.partname as varchar) as "CurrentPartName", 
CAST(Shift_A_P_Q_DATAS.ToolLetter as varchar) as "CurrentToolLetter",
CAST(Shift_A_P_Q_DATAS.ActualCavRun as int) as "CurrentCavity",
CAST(Shift_A_P_Q_DATAS.MachineCycleTime as int) as "CurrentIdealCycleTime", 
CAST(Shift_A_P_Q_DATAS.Reject as int) as "CurrentReject", 
CAST(Shift_A_P_Q_DATAS.ShotCount as int) as "CurrentShotCount",
CAST(Shift_A_P_Q_DATAS.targetoutput as int) as "CurrentTargetOutput", 
CAST(Shift_A_P_Q_DATAS.totalOutput as int) as "CurrentTotalOutput" 
FROM MaxRowIdentifier_A
left join Shift_A_P_Q_DATAS
on Shift_A_P_Q_DATAS.rn=MaxRowIdentifier_A.maxrow
and Shift_A_P_Q_DATAS.MachineName=MaxRowIdentifier_A.MachineName
)
,
ShiftAFinalized_P_Q as (
Select 
CAST(AccumulatedValues_A.AccumulatedOrderQuantity as int) as AccumulatedOrderQuantity,
CAST(AccumulatedValues_A.AccumulatedCavity as int) as AccumulatedCavity,
CAST(AccumulatedValues_A.AccumulatedReject as int) as AccumulatedReject ,
CAST(AccumulatedValues_A.AccumulatedShotCount as int) as AccumulatedShotCount,
CAST(AccumulatedValues_A.AccumulatedTargetOutput as int) as AccumulatedTargetOutput,
CAST(AccumulatedValues_A.AccumulatedTotalOutput as int) as AccumulatedTotalOutput,
latestOEEinfoShiftA.timestamp,
latestOEEinfoShiftA.CurrentOrderQty,
latestOEEinfoShiftA.CurrentOrderNumber,
latestOEEinfoShiftA.machinename,
latestOEEinfoShiftA.CurrentPartNumber,
latestOEEinfoShiftA.CurrentPartName,
latestOEEinfoShiftA.CurrentToolLetter,
latestOEEinfoShiftA.CurrentCavity,
latestOEEinfoShiftA.CurrentIdealCycleTime,
latestOEEinfoShiftA.CurrentReject,
latestOEEinfoShiftA.CurrentShotCount,
latestOEEinfoShiftA.CurrentTargetOutput,
latestOEEinfoShiftA.CurrentTotalOutput,
case when CAST(AccumulatedValues_A.AccumulatedTotalOutput as int)<1
then 0
else CAST(AccumulatedValues_A.AccumulatedShotCount as float)/CAST(AccumulatedValues_A.AccumulatedTargetOutput as float)*100 
end as Performance,
case when CAST(AccumulatedValues_A.AccumulatedTotalOutput as int)<1
then 0
else (CAST(AccumulatedValues_A.AccumulatedTotalOutput as float)-CAST(AccumulatedValues_A.AccumulatedReject as float))/CAST(AccumulatedValues_A.AccumulatedTotalOutput as float)*100 
end as Quality
FROM AccumulatedValues_A
left join latestOEEinfoShiftA
on latestOEEinfoShiftA.MachineName=AccumulatedValues_A.machinename
and latestOEEinfoShiftA.timestamp=AccumulatedValues_A.timestamp
),
Shift_A_OEE_FINALIZED AS (
Select 'A' as "Shift",
ISNULL(cast(combine_Shift_A_Availability.Availability as float),0) as Availability,
CAST(combine_Shift_A_Availability.total_duration as int) as total_duration,
CAST(combine_Shift_A_Availability.TotalRuntime as int) as TotalRuntime,
ISNULL((CAST(combine_Shift_A_Availability.availability as float)*CAST(ShiftAFinalized_P_Q.Performance as float)*CAST(ShiftAFinalized_P_Q.Quality as float)/1000000)*100,0) as OEE,
ShiftAFinalized_P_Q.AccumulatedCavity,
ShiftAFinalized_P_Q.AccumulatedReject,
ShiftAFinalized_P_Q.AccumulatedShotCount,
ShiftAFinalized_P_Q.AccumulatedTargetOutput,
ShiftAFinalized_P_Q.AccumulatedTotalOutput,
ShiftAFinalized_P_Q.AccumulatedOrderQuantity,
CONVERT(varchar(10),ShiftAFinalized_P_Q.timestamp,20) as timestamp,
ShiftAFinalized_P_Q.CurrentOrderQty,
CAST(ShiftAFinalized_P_Q.CurrentOrderNumber as varchar) as CurrentOrderNumber,
ShiftAFinalized_P_Q.machinename,
CAST(ShiftAFinalized_P_Q.CurrentPartNumber as varchar) as CurrentPartNumber,
CAST(ShiftAFinalized_P_Q.CurrentPartName as varchar) as CurrentPartName,
CAST(ShiftAFinalized_P_Q.CurrentToolLetter as varchar) as CurrentToolLetter,
ShiftAFinalized_P_Q.CurrentCavity,
ShiftAFinalized_P_Q.CurrentIdealCycleTime,
ShiftAFinalized_P_Q.CurrentReject,
ShiftAFinalized_P_Q.CurrentShotCount,
ShiftAFinalized_P_Q.CurrentTargetOutput,
ShiftAFinalized_P_Q.CurrentTotalOutput,
ShiftAFinalized_P_Q.Quality,
ShiftAFinalized_P_Q.Performance
FROm combine_Shift_A_Availability
LEFT JOIN ShiftAFinalized_P_Q
ON ShiftAFinalized_P_Q.timestamp=combine_Shift_A_Availability.timestamp
and ShiftAFinalized_P_Q.MachineName=combine_Shift_A_Availability.MachineName
),
twentyfourhoursDETAILS AS (
Select *,'today' as status FROM Shift_A_OEE_FINALIZED
UNION 
Select *, 
case 
when CAST(RIGHT(CONVERT(varchar(13),getdate(),20),2) as int) between 8 and 19
then 'yesterday'
when CAST(RIGHT(CONVERT(varchar(13),getdate(),20),2) as int) not between 8 and 19      
then 'today' 
end as status      
FROM Shift_B_Finalized_OEE
),
AssignRow24 as (
Select *,row_number() OVER(partition by MachineName order by timestamp desc) as rn FROM twentyfourhoursDETAILS
),
identifymaxAssignRow24 as (
Select max(rn) as maxvalue,machinename FROM AssignRow24 where status='today' group by machinename
),
OEE_Accumulated_Val_24 as (
Select
SUM(performance) as Performance,
SUM(quality) as Quality,
SUM(availability) as Availability,
SUM(OEE) as OEE,
SUM(total_duration) as TotalDuration,
SUM(totalruntime) as TotalRuntime,
SUM(accumulatedCavity) as AccumulatedCavity,
SUM(accumulatedReject) as AccumulatedReject,
SUM(AccumulatedShotCount) as AccumulatedShotCount,
SUM(AccumulatedTargetOutput) as AccumulatedTargetOutput,
SUM(AccumulatedTotalOutput) as AccumulatedTotalOutput,
SUM(AccumulatedOrderQuantity) as AccumulatedOrderQuantity,
machinename
FROM AssignRow24
where status='today'
group by machinename
),
OEE_Current_Detail_24 as (
Select 
AssignRow24.CurrentShotCount,
AssignRow24.CurrentTargetOutput,
AssignRow24.timestamp,
AssignRow24.CurrentOrderQty,
AssignRow24.CurrentOrderNumber,
AssignRow24.machinename,
AssignRow24.CurrentPartNumber,
AssignRow24.CurrentPartName,
AssignRow24.CurrentToolLetter,
AssignRow24.CurrentCavity,
AssignRow24.CurrentIdealCycleTime,
AssignRow24.CurrentReject,
AssignRow24.CurrentTotalOutput,
identifymaxAssignRow24.maxvalue
FROM identifymaxAssignRow24
inner join AssignRow24
on AssignRow24.rn=identifymaxAssignRow24.maxvalue
and AssignRow24.machinename=identifymaxAssignRow24.machinename
),
OEE_Paling_latest_Value as (
Select 
CAST(OEE_Accumulated_Val_24.Performance as float)/CAST(OEE_Current_Detail_24.maxvalue as float) as Performance,
CAST(OEE_Accumulated_Val_24.Quality as float)/CAST(OEE_Current_Detail_24.maxvalue as float) as Quality,
CAST(OEE_Accumulated_Val_24.Availability as float)/CAST(OEE_Current_Detail_24.maxvalue as float) as Availability,
CAST(OEE_Accumulated_Val_24.OEE as float)/CAST(OEE_Current_Detail_24.maxvalue as float) as OEE,
OEE_Accumulated_Val_24.TotalDuration,
OEE_Accumulated_Val_24.TotalRuntime,
OEE_Accumulated_Val_24.AccumulatedCavity,
OEE_Accumulated_Val_24.AccumulatedReject,
OEE_Accumulated_Val_24.AccumulatedShotCount,
OEE_Accumulated_Val_24.AccumulatedOrderQuantity,
OEE_Accumulated_Val_24.AccumulatedTargetOutput,
OEE_Accumulated_Val_24.AccumulatedTotalOutput,
OEE_Current_Detail_24.*
FROM OEE_Accumulated_Val_24
LEFT JOIN OEE_Current_Detail_24
on OEE_Accumulated_Val_24.machinename=OEE_Current_Detail_24.machinename
)
Select * FROM OEE_Paling_latest_Value
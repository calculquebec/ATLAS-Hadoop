REGISTER '/usr/lib/pig/piggybank.jar' ;
REGISTER '/usr/lib/pig/lib/avro-*.jar';
REGISTER '/usr/lib/pig/lib/jackson-*.jar';
REGISTER '/usr/lib/pig/lib/json-*.jar';
REGISTER '/usr/lib/pig/lib/jython-*.jar';
REGISTER '/usr/lib/pig/lib/snappy-*.jar';

REGISTER '/usr/lib/pig/lib/elasticsearch-hadoop-*.jar';

REGISTER 'myudfs.py' using jython as myfuncs;

define EsStorage org.elasticsearch.hadoop.pig.EsStorage('es.nodes=http://aianalytics01.cern.ch:9200');


PAN = LOAD '/atlas/analytics/panda/JOBSARCHIVED/jobs.$INPD/part-m-00000.avro' USING AvroStorage();
DESCRIBE PAN;

L = LIMIT PAN 10000; -- dump L;

REC = FOREACH L GENERATE PANDAID,JOBDEFINITIONID,SCHEDULERID,PILOTID,CREATIONTIME,CREATIONHOST,MODIFICATIONTIME,MODIFICATIONHOST,ATLASRELEASE,TRANSFORMATION,HOMEPACKAGE,PRODSERIESLABEL,PRODSOURCELABEL,PRODUSERID,ASSIGNEDPRIORITY,CURRENTPRIORITY,ATTEMPTNR,MAXATTEMPT,JOBSTATUS,JOBNAME,MAXCPUCOUNT,MAXCPUUNIT,MAXDISKCOUNT,MAXDISKUNIT,IPCONNECTIVITY,MINRAMCOUNT,MINRAMUNIT,STARTTIME,ENDTIME,CPUCONSUMPTIONTIME,CPUCONSUMPTIONUNIT,COMMANDTOPILOT,TRANSEXITCODE,PILOTERRORCODE,PILOTERRORDIAG,EXEERRORCODE,EXEERRORDIAG,SUPERRORCODE,SUPERRORDIAG,DDMERRORCODE,DDMERRORDIAG,BROKERAGEERRORCODE,BROKERAGEERRORDIAG,JOBDISPATCHERERRORCODE,JOBDISPATCHERERRORDIAG,TASKBUFFERERRORCODE,TASKBUFFERERRORDIAG,COMPUTINGSITE,COMPUTINGELEMENT,PRODDBLOCK,DISPATCHDBLOCK,DESTINATIONDBLOCK,DESTINATIONSE,NEVENTS,GRID,CLOUD,CPUCONVERSION,SOURCESITE,DESTINATIONSITE,TRANSFERTYPE,TASKID,CMTCONFIG,STATECHANGETIME,PRODDBUPDATETIME,LOCKEDBY,RELOCATIONFLAG,JOBEXECUTIONID,VO,PILOTTIMING,WORKINGGROUP,PROCESSINGTYPE,PRODUSERNAME,NINPUTFILES,COUNTRYGROUP,BATCHID,PARENTID,SPECIALHANDLING,JOBSETID,CORECOUNT,NINPUTDATAFILES,INPUTFILETYPE,INPUTFILEPROJECT,INPUTFILEBYTES,NOUTPUTDATAFILES,OUTPUTFILEBYTES,JOBMETRICS,WORKQUEUE_ID,JEDITASKID,JOBSUBSTATUS,ACTUALCORECOUNT,FLATTEN(myfuncs.deriveDurationAndCPUeff(CREATIONTIME,STARTTIME,ENDTIME,CPUCONSUMPTIONTIME)),FLATTEN(myfuncs.deriveTimes(PILOTTIMING));

STORE REC INTO 'job_archive/jobdata-$INPD' USING EsStorage();

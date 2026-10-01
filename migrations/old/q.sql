.mode column
.headers on
SELECT DISTINCT subj.ent_uid 
FROM e01_222_01_tb r 
JOIN e01_202_01_tb rt ON rt.reltype_id=r.reltype_id 
JOIN e01_200_03_tb subj ON subj.ent_id=r.subj_ent_id 
WHERE rt.type_uid='plays_role_in' 
  AND subj.ent_uid NOT LIKE '%sensor%' 
  AND subj.ent_uid NOT LIKE '%ecu%' 
  AND subj.ent_uid NOT LIKE '%dcu%' 
  AND subj.ent_uid NOT LIKE '%module%' 
  AND subj.ent_uid NOT LIKE '%bus%' 
  AND subj.ent_uid NOT LIKE '%ethernet%' 
  AND subj.ent_uid NOT LIKE '%relay%' 
  AND subj.ent_uid NOT LIKE '%fuse%' 
  AND subj.ent_uid NOT LIKE '%battery%' 
  AND subj.ent_uid NOT LIKE '%alternator%' 
  AND subj.ent_uid NOT LIKE '%motor%' 
  AND subj.ent_uid NOT LIKE '%pump%' 
  AND subj.ent_uid NOT LIKE '%valve%' 
  AND subj.ent_uid NOT LIKE '%camera%' 
  AND subj.ent_uid NOT LIKE '%radar%' 
  AND subj.ent_uid NOT LIKE '%lidar%' 
  AND subj.ent_uid NOT LIKE 'fn:%' 
ORDER BY subj.ent_uid;

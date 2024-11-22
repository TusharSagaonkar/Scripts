SELECT s.sid, s.serial#, s.username, s.program, q.sql_text
FROM v$session s
JOIN v$sql q ON s.sql_id = q.sql_id
WHERE LOWER(q.sql_text) LIKE '%table_name%';

SELECT * FROM activity_log GROUP BY subject_type;
;-- -. . -..- - / . -. - .-. -.--
SELECT * FROM activity_log WHERE subject_type = "App\Models\EventCategory";
;-- -. . -..- - / . -. - .-. -.--
SELECT * FROM activity_log WHERE subject_type LIKE "App\Models\EventCategory";
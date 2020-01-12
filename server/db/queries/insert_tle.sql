INSERT INTO tle (threelinetle , fetchTime) VALUES (
  $1,
  $2,
) RETURNING noradNumber;

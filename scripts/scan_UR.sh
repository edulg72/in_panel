#!/bin/bash

LOG_FILE=/home/ubuntu/scan_PU.log

cd /var/www/in_panel/scripts

echo "Start: $(date '+%d/%m/%Y %H:%M:%S')"

psql -h $POSTGRESQL_DB_HOST -d in_panel -U $POSTGRESQL_DB_USERNAME -c 'delete from ur; delete from mp;'
ruby scan_UR.rb $1 $2 73.18 35.51 79.18 34.51 1.0
ruby scan_UR.rb $1 $2 73.18 34.51 79.18 33.51 1.0
ruby scan_UR.rb $1 $2 73.18 33.51 80.18 32.51 1.0
ruby scan_UR.rb $1 $2 74.18 32.51 80.18 31.51 1.0
ruby scan_UR.rb $1 $2 73.18 31.51 81.18 30.51 1.0
ruby scan_UR.rb $1 $2 73.18 30.51 81.18 29.51 1.0
ruby scan_UR.rb $1 $2 72.18 29.51 81.18 28.51 1.0
ruby scan_UR.rb $1 $2 93.18 29.51 97.18 28.51 1.0
ruby scan_UR.rb $1 $2 69.18 28.51 84.18 27.51 1.0
ruby scan_UR.rb $1 $2 87.18 28.51 89.18 27.51 1.0
ruby scan_UR.rb $1 $2 69.18 27.51 97.18 26.51 1.0
ruby scan_UR.rb $1 $2 69.18 26.51 96.18 25.51 1.0
ruby scan_UR.rb $1 $2 70.18 25.51 95.18 24.51 1.0
ruby scan_UR.rb $1 $2 68.18 24.51 89.18 23.51 1.0
ruby scan_UR.rb $1 $2 90.18 24.51 95.18 23.51 1.0
ruby scan_UR.rb $1 $2 68.18 23.51 89.18 22.51 1.0
ruby scan_UR.rb $1 $2 91.18 23.51 94.18 22.51 1.0
ruby scan_UR.rb $1 $2 68.18 22.51 89.18 21.51 1.0
ruby scan_UR.rb $1 $2 92.18 22.51 94.18 21.51 1.0
ruby scan_UR.rb $1 $2 69.18 21.51 87.18 20.51 1.0
ruby scan_UR.rb $1 $2 72.18 20.51 87.18 19.51 1.0
ruby scan_UR.rb $1 $2 72.18 19.51 86.18 18.51 1.0
ruby scan_UR.rb $1 $2 72.18 18.51 85.18 17.51 1.0
ruby scan_UR.rb $1 $2 72.18 17.51 83.18 16.51 1.0
ruby scan_UR.rb $1 $2 73.18 16.51 82.18 15.51 1.0
ruby scan_UR.rb $1 $2 73.18 15.51 81.18 14.51 1.0
ruby scan_UR.rb $1 $2 93.18 15.51 94.18 14.51 1.0
ruby scan_UR.rb $1 $2 74.18 14.51 81.18 13.51 1.0
ruby scan_UR.rb $1 $2 92.18 14.51 94.18 13.51 1.0
ruby scan_UR.rb $1 $2 74.18 13.51 81.18 12.51 1.0
ruby scan_UR.rb $1 $2 92.18 13.51 93.18 12.51 1.0
ruby scan_UR.rb $1 $2 94.18 13.51 95.18 12.51 1.0
ruby scan_UR.rb $1 $2 72.18 12.51 73.18 11.51 1.0
ruby scan_UR.rb $1 $2 74.18 12.51 80.18 11.51 1.0
ruby scan_UR.rb $1 $2 92.18 12.51 94.18 11.51 1.0
ruby scan_UR.rb $1 $2 71.18 11.51 74.18 10.51 1.0
ruby scan_UR.rb $1 $2 75.18 11.51 80.18 10.51 1.0
ruby scan_UR.rb $1 $2 92.18 11.51 93.18 10.51 1.0
ruby scan_UR.rb $1 $2 72.18 10.51 74.18 9.51 1.0
ruby scan_UR.rb $1 $2 75.18 10.51 80.18 9.51 1.0
ruby scan_UR.rb $1 $2 76.18 9.51 80.18 8.51 1.0
ruby scan_UR.rb $1 $2 92.18 9.51 94.18 8.51 1.0
ruby scan_UR.rb $1 $2 72.18 8.51 73.18 7.51 1.0
ruby scan_UR.rb $1 $2 76.18 8.51 78.18 7.51 1.0
ruby scan_UR.rb $1 $2 92.18 8.51 94.18 7.51 1.0
ruby scan_UR.rb $1 $2 93.18 7.51 94.18 6.51 1.0

psql -h $POSTGRESQL_DB_HOST -d in_panel -U $POSTGRESQL_DB_USERNAME -c 'update ur set city_id = (select id from cities where ST_Contains(geom, ur.position) limit 1) where city_id is null;'
psql -h $POSTGRESQL_DB_HOST -d in_panel -U $POSTGRESQL_DB_USERNAME -c 'update mp set city_id = (select id from cities where ST_Contains(geom, mp.position) limit 1) where city_id is null;'
psql -h $POSTGRESQL_DB_HOST -d in_panel -U $POSTGRESQL_DB_USERNAME -c 'update ur set comments = 0 where comments is null;'
psql -h $POSTGRESQL_DB_HOST -d in_panel -U $POSTGRESQL_DB_USERNAME -c 'update mp set weight = 0 where weight is null;'
psql -h $POSTGRESQL_DB_HOST -d in_panel -U $POSTGRESQL_DB_USERNAME -c 'refresh materialized view vw_ur;'
psql -h $POSTGRESQL_DB_HOST -d in_panel -U $POSTGRESQL_DB_USERNAME -c 'refresh materialized view vw_mp;'
psql -h $POSTGRESQL_DB_HOST -d in_panel -U $POSTGRESQL_DB_USERNAME -c "update updates set updated_at = current_timestamp where object = 'ur';"
psql -h $POSTGRESQL_DB_HOST -d in_panel -U $POSTGRESQL_DB_USERNAME -c 'vacuum analyze;'

echo "End: $(date '+%d/%m/%Y %H:%M:%S')"

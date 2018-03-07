COPY (SELECT * FROM contract) TO '/tmp/contracts.csv' WITH CSV header;
COPY (SELECT * FROM department) TO '/tmp/departments.csv' WITH CSV header;
COPY (SELECT * FROM contractor) TO '/tmp/contractors.csv' WITH CSV header;

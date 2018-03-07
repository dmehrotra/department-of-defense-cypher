// Create Contracts

USING PERIODIC COMMIT
LOAD CSV WITH HEADERS FROM "file:/dod/contracts.csv" AS row
CREATE (c:Contract {psql_id: row.id, contract_number: row.contract_number, description: row.for_what, contractor_id: row.contractor_id, department_id: row.department_id,location: row.place_of_work, amount: row.amount,contracting_activity: row.contracting_activity,date: row.contract_date})
MERGE(w:Place {name: row.place_of_work})
MERGE(ca:ContractingActivity {name: row.contracting_activity})
CREATE (c)-[:Activity {date:row.contract_date,contract_id:id(c),activity_id:id(ca) }]->(ca)
MERGE (c)-[:Work_Performed {contract_id:id(c),place_of_work_id: id(w)}]->(w);

// Create Department
USING PERIODIC COMMIT
LOAD CSV WITH HEADERS FROM "file:/dod/department.csv" AS row
CREATE (:Department {name: row.name,psql_id: row.id});

// Create Department
USING PERIODIC COMMIT
LOAD CSV WITH HEADERS FROM "file:/dod/contractor.csv" AS row
CREATE (:Contractor {name: row.name,psql_id: row.id});


CREATE INDEX ON :Contract(contract_number);
CREATE INDEX ON :Contractor(name);
CREATE INDEX ON :Department(name);

USING PERIODIC COMMIT
LOAD CSV WITH HEADERS FROM "file:/dod/contracts.csv" AS row
MATCH (c:Contract {psql_id: row.id})
MATCH (d:Department {psql_id: row.department_id})
CREATE (d)-[:Issued {date:row.contract_date, department_id:id(d), contract_id:id(c)}]->(c);


USING PERIODIC COMMIT
LOAD CSV WITH HEADERS FROM "file:/dod/contracts.csv" AS row
MATCH (c:Contract {psql_id: row.id})
MATCH (d:Contractor {psql_id: row.contractor_id})
CREATE (c)-[:Awarded_To {date:row.contract_date contractor_id:id(d), contract_id:id(c)}}]->(d);

LOAD CSV WITH HEADERS FROM "file:/dod/contracts.csv" AS row
MATCH(d:Department) 
MATCH(c:Contractor) where c.psql_id = row.contractor_id and d.psql_id = row.department_id
CREATE (d)-[:Works_With {contract:row.contract_number,department_id:id(d), contractor_id:id(c)}]->(c)

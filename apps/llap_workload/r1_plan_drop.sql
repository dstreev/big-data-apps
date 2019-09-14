
disable workload management;

ALTER RESOURCE PLAN finance DISABLE;

DROP RESOURCE PLAN finance;
DROP RESOURCE PLAN logistics;

-- Doesn't work, sometimes...  Maybe there needs to be an 'active' resource plan...
-- Because it stalls out when it's run a second time.

-- DISABLE WORKLOAD MANAGEMENT;


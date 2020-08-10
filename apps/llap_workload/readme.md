# LLAP Workload Management

Build a sample resource plan for LLAP using the internall LLAP Workload Management System.

Note: Docs are improving all the time.  These references are for a specific version and may be out of date.  Always check for later documentation.
- [Workload Management Reference](https://docs.cloudera.com/HDPDocuments/HDP3/HDP-3.1.5/hive-workload/content/hive_workload_management.html)
- [Setting Up Workload Management](https://docs.cloudera.com/HDPDocuments/HDP3/HDP-3.1.5/hive-workload/content/hive_setting_up_and_using_a_resource_plan.html)
- [Workload Management YARN Queue Requirements](https://docs.cloudera.com/HDPDocuments/HDP3/HDP-3.1.5/hive-workload/content/hive_interactive_queue.html)
- [Inspecting Workload Management via Hive Tables](https://docs.cloudera.com/HDPDocuments/HDP3/HDP-3.1.5/hive-workload/content/hive_workload_management_entity_data_in_sys.html)
- [Workload Management Command Summary](https://docs.cloudera.com/HDPDocuments/HDP3/HDP-3.1.5/hive-workload-commands/content/hive_workload_management_command_summary.html)

## Guidance
Use the [LLAP Configuration Calculator](https://github.com/dstreev/hive_llap_calculator) for guidance to establish a working LLAP configuration.

LLAP should be setup so it is NOT sharing YARN resources with other YARN tasks.
- Use YARN Node Labels and a special LLAP queue, mapped to the Node labels, to secure specific hosts for this effort.
- Do NOT co-locate LLAP Daemons with other HDP/CDP resources like: HBase Region Servers, Druid components, or other master services.
- Disable yarn `pmem` checks on LLAP daemon containers to avoid aggresive YARN resource management from killing LLAP daemons.  This recommendation is identified in the latest version of the LLAP calculator, above.

LLAP daemons share a memory pool, unlike Tez on YARN, with other running processes in LLAP.  Cartesian joins or large map joins can skew this memory model and eventual cause vertez issues.  These behavior of map joins that cause these issues should be altered to lower the map join size and/or the inflation rate allowed before the vertez is killed. This adjustment should be done at the query level, in most cases, not at the system level.  Defaults are generally best for the collective execution of jobs.  But there's always the exception.

There is a relationship between the total number of parallelism and how large you make the Workload Management Queue in YARN. If not properly sized, it can prevent the proper startup of LLAP.

## Setting a Hive Tez Query Name
### Pre-Requisites
Setup HiveServer2 so the property can be used in the session\*
Add the following property to 'Custom hiveserver2-site':
`hive.security.authorization.sqlstd.confwhitelist.append`
This setting will extend the included whitelist for properties that can be changed at runtime. This value is a regex of the patterns that it will accept.
Add the following to the pattern:
`hive\.query\.name`
Use '|' as an OR in the regex to specify additional properties.
I've seen an issue where the last entry is NOT picked up.
**For example:**
`mylocal\..*|metastore\.catalog\.default|hive\.query\.name|.*|newvar\..*`

### Setting the Query Name
In the Hive session:
set hive.query.name="my name";
Spaces in the name are ok. But consider where you'll use these. The one point in Hive that they can be used is with the Hive LLAP Workload Management system. The name can be used to "map" applications to pools.


## Using TPCDS for Testing

NOTE:
Query57 killed LLAP daemons.



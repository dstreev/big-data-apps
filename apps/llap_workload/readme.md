# LLAP Workload Management

Build a sample resource plan for LLAP using the internall LLAP Workload Management System.

Note: Docs are improving all the time.  These references are for a specific version and may be out of date.  Always check for later documentation.
[Workload Management Reference](https://docs.cloudera.com/HDPDocuments/HDP3/HDP-3.1.4/hive-workload/content/hive_workload_management.html)
[Setting Up Workload Management](https://docs.cloudera.com/HDPDocuments/HDP3/HDP-3.1.4/hive-workload/content/hive_setting_up_and_using_a_resource_plan.html)
[Workload Management YARN Queue Requirements](https://docs.cloudera.com/HDPDocuments/HDP3/HDP-3.1.4/hive-workload/content/hive_interactive_queue.html)
[Inspecting Workload Management via Hive Tables](https://docs.cloudera.com/HDPDocuments/HDP3/HDP-3.1.4/hive-workload/content/hive_workload_management_entity_data_in_sys.html)
[Workload Management Command Summary](https://docs.cloudera.com/HDPDocuments/HDP3/HDP-3.1.4/hive-workload-commands/content/hive_workload_management_command_summary.html)

## Guidance
There is a relationship between the total number of parallelism and how large you make the Workload Management Queue in YARN. If not properly sized, it can prevent the proper startup of LLAP.

## Using TPCDS for Testing

NOTE:
Query57 killed LLAP daemons.


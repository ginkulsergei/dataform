-- This is an example SQLX file to help you learn the basics of Dataform.
-- Visit https://cloud.google.com/dataform/docs/sql-workflows for more information on how to configure your SQL workflow.

-- You can delete this file, then commit and push your changes to your repository when you are ready.

-- Config blocks allow you to configure, document, and test your data assets.


config {
  type: "operations", // Creates a view in BigQuery. Try changing to "table" instead.
  dependencies : ["dataformtraining2024.prepared_ua.staging_1_ghost",
                  "dataformtraining2024.prepared_ua.staging_2_ghost"] // mention all dependencies
}

-- The rest of a SQLX file contains your SELECT statement used to create the table.

INSERT INTO `dataformtraining2024.enterprise_ua.final_1`
SELECT * 
  FROM `dataformtraining2024.prepared_ua.staging_1`
UNION ALL 

SELECT * 
  FROM `dataformtraining2024.prepared_ua.staging_2`

post_operations {
DROP `dataformtraining2024.prepared_ua.staging_1_ghost`

}
-- ${when(incremental(), ```(SELECT COUNT(DATE(TIMESTAMP_MILLIS(last_modified_time))) AS number_of_updates
--                             FROM `dataformtraining2024.dataform`.__TABLES__
--                            WHERE table_id = "staging_1"
--                              AND DATE(TIMESTAMP_MILLIS(last_modified_time)) = current_date
--                              AND row_count > 0) = 1```)}

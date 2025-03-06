Folder created on 2025-01-30
For project: project_regioninnovation
For the delivery of opportunity: OPP:20250101
Review python script "/project_regioninnovation/input/input_project_regioninnovation.py" in the Git repository to identify data input and output
# ============================================================================
Pipeline execution details for project_regioninnovation:
# ============================================================================
List the actual steps in the pipeline that have been run (See example below):
All project variables are saved in ./config/project_variables.yaml
p1 = DataPipeLine(
        project_name=project_name,
        ror_version=ror_version,
        project_start_year=project_start_year,
        project_end_year=project_end_year,
        root_dir=main_directory,
        data_dir=data_directory,
        project_dir=project_dir,
        configfile=configfile,
        baseline_table=baseline_table,
        project_variant=project_variant
)
p1.pipeline_bas()  # on 01/11/2024 to create a new baselines database
p1.pipeline_ddb()  # 02/11/2024 to set up the database (duckdb)


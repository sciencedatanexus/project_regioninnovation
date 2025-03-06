# coding=utf-8

# =============================================================================
# """
# .. module:: project_regioninnovation.input.input_project_regioninnovation.py
# .. moduleauthor:: Jean-Francois Desvignes <contact@sciencedatanexus.com>
# .. version:: 1.1.0
# .. description:: data pipeline for projects (developed for project: OPP:20250101).
# :Copyright: Jean-Francois Desvignes for Science Data Nexus
# :Science Data Nexus, 2025
# :Contact: Jean-Francois Desvignes <contact@sciencedatanexus.com>
# :Updated: 2025-01-30
# """
# =============================================================================
"""
HOWTO
1) Setup steps:
    - Make sure you have the latest version from the git repository https://github.com/sciencedatanexus/nexus
    - Run "pipeline_setup_new_folder.py" after selecting project_name and module version
2) copy the folder with the latest version of the module (eg. nexus/pipeline_input_1_0_0)
3) Change the "Global variables" in the config/project_variables.yaml file, *project_name* is the most important variable
4) start setting up the pipeline by adapting the Pipeline setup. The pipeline will run sequentially each step in the steps list.
5) run the script
6) To re-run the script some intermediary files in the "tempdir" folders need to be removed
7) Specifics:
    - Run well with an EC2 16Gb.
"""
# =============================================================================
# START Input Pipeline setup
# =============================================================================
def print_hi(name):
    print(f'>>> {name}')


if __name__ == '__main__':
    print_hi('START INPUT pipeline SETUP')
# =============================================================================
# Python modules to import
# =============================================================================
import sys
import warnings
import logging
import yaml
import os
from pathlib import Path
import importlib
"""
Add modules when needed when custom pipelines are run such as:
import pandas as pd
import os
import matplotlib.pyplot as plt
from matplotlib_venn import venn3, venn3_circles
"""
# =============================================================================
# Global Project variables
# =============================================================================
project_config =os.path.join(Path(__file__).parent.parent, "config", "project_variables.yaml")
with open(project_config, 'r') as f:
    project_variables = yaml.safe_load(f)
# =============================================================================
# Nexus modules   
# Science Data Nexus modules - version control
# module version to use
# ============================================================================= 
"""
Replace by the version of the module that was used at the time (eg. 1_0_0)
As a first step, check if the project is in development (project_variables['project_dev'] = True)
"""
if project_variables['project_dev']:
    new_path = os.path.join(Path(__file__).parent.parent.parent, project_variables['dev_lib_dir'])
    input_module = "nexus.pipeline_input.pipeline_{}".format(project_variables['dev_input_pipeline_version'])
    config_file = os.path.join(Path(__file__).parent.parent.parent.parent.parent, project_variables['configfile'])
else:
    new_path = Path(__file__).parent.parent
    input_module = "nexus.pipeline_input.pipeline_{}".format(project_variables['project_input_pipeline_version'])
    config_file = os.path.join(Path(__file__).parent.parent.parent, project_variables['project_name'], project_variables['configfile'])
sys.path.append(new_path)  ## to ensure the local modules are imported correctly
pl = importlib.import_module(input_module)
sys.modules["nexus.pipeline_input.pipeline"] = pl
# Load Data Input pipeline module
from nexus.pipeline_input.pipeline.datapipeline import *

# =============================================================================
# Final setup step
# =============================================================================
if __name__ == '__main__':
    print_hi('END INPUT pipeline SETUP')
# =============================================================================
# END Input Pipeline setup
# =============================================================================

# =============================================================================
# Functions and classes
# =============================================================================

def pipeline_cus(pipeline_object):
    """
    cus = final step, generally used to customise the standard deliverable, by default empty
    Project specific customised code
    """
    print("\t >>> Custom project")
    print("\t >>> start custom project here")
    print("\t\t An example of a customised function: extract a sample n=1000 uids")
    # df = pd.read_csv(os.path.join(pipeline_object.outdir, 'records.txt'), sep='|')
    # df = df.sample(1000)
    # return df
    print("\t >>> completion of custom project")

# =============================================================================
# Variables
# =============================================================================

# =============================================================================
# Start of script
# ============================================================================
warnings.simplefilter(action='ignore', category=FutureWarning)  # remove FutureWarning notifications
log_file = os.path.join(Path(__file__).parent, '_{0}.log'.format(project_variables["project_dir_name"]))
logging.basicConfig(level=logging.DEBUG, filename=log_file, filemode='w')
try:
    """
    # ============================================================================
    Creation of the ConsultingDataPipeLine() object (p1)
    # ============================================================================
    """
    p1 = DataPipeLine(
        project_name=project_variables["project_name"],
        ror_version=project_variables["ror_version"],
        project_start_year=project_variables["project_start_year"],
        project_end_year=project_variables["project_end_year"],
        project_dir_name=project_variables["project_dir_name"],
        root_dir=project_variables["main_directory"],
        data_dir=project_variables["data_directory"],
        configfile=project_variables["configfile"],
        baseline_version=project_variables["baseline_version"],
        project_variant=project_variables["project_variant"]
    )
    """
    # ============================================================================
    Setup of specific variables for the project (not all variables are relevant)
    # ============================================================================
    """
    ## Baselines variables:
    p1.baselines_start = 2000
    ## S3 export
    p1.s3_bucket = "sciencedatanexus"
    """
    # ============================================================================
    Details in ./pipeline_input/pipeline_VERSION/README.txt
    Run individual steps in the pipeline
    Steps to run (order is very important as dependencies exist between steps)
    Usage: 
    1) add as many pipeline step as needed, for instance p1.pipeline_end()
    2) run the script
    3) log of results is saved in the app_project_name.log file
    steps:
    p1.pipeline_bas()
    p1.pipeline_len()
    p1.pipeline_ddb()
    # Examples of methods with options
    p1.project_variant = None  # set to another value (eg 'sub1' to create sub-project data
    p1.pipeline_inc('api/rec_id')
    # ============================================================================
    Pipeline execution details need to be listed in /project_regioninnovation/README.txt
    # ============================================================================
    """
    # p1.pipeline_bas()
    # p1.pipeline_len()
    # p1.pipeline_ddb()
    """
    # ============================================================================
    Run new custom steps in the pipeline, including customised versions of the pipeline
    # ============================================================================
    """
    pipeline_cus()
except Exception as e:
    logging.exception("Exception occurred", exc_info=True)
finally:
    logging.exception("No exception occurred", exc_info=True)
# =============================================================================
# End of script
# =============================================================================

if __name__ == '__main__':
    print_hi('Python completed')

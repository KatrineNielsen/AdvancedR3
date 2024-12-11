# Created by use_targets().
# Follow the comments below to fill in this target script.
# Then follow the manual to check and run the pipeline:
#   https://books.ropensci.org/targets/walkthrough.html#inspect-the-pipeline

# Load packages required to define the pipeline:
library(targets)
library(tarchetypes) # Load other packages as needed.
library(quarto)

# Set target options:
tar_option_set(
  packages = c("tibble") # Packages that your targets need for their tasks.
  # format = "qs", # Optionally set the default storage format. qs is fast.
  #
  # Pipelines that take a long time to run may benefit from
  # optional distributed computing. To use this capability
  # in tar_make(), supply a {crew} controller
  # as discussed at https://books.ropensci.org/targets/crew.html.
  # Choose a controller that suits your needs. For example, the following
  # sets a controller that scales up to a maximum of two workers
  # which run as local R processes. Each worker launches when there is work
  # to do and exits if 60 seconds pass with no tasks to run.
  #
  #   controller = crew::crew_controller_local(workers = 2, seconds_idle = 60)
  #
  # Alternatively, if you want workers to run on a high-performance computing
  # cluster, select a controller from the {crew.cluster} package.
  # For the cloud, see plugin packages like {crew.aws.batch}.
  # The following example is a controller for Sun Grid Engine (SGE).
  #
  #   controller = crew.cluster::crew_controller_sge(
  #     # Number of workers that the pipeline can scale up to:
  #     workers = 10,
  #     # It is recommended to set an idle time so workers can shut themselves
  #     # down if they are not running tasks.
  #     seconds_idle = 120,
  #     # Many clusters install R as an environment module, and you can load it
  #     # with the script_lines argument. To select a specific verison of R,
  #     # you may need to include a version string, e.g. "module load R/4.3.2".
  #     # Check with your system administrator if you are unsure.
  #     script_lines = "module load R"
  #   )
  #
  # Set other options as needed.
)

# Run the R scripts in the R/ folder with your custom functions:
tar_source()
# tar_source("other_functions.R") # Source other scripts as needed.

# Replace the target list below with your own:
list(
  # 0. But the actual first step is to keep track of our file
  tar_target(
    name = file,
    command = "data/lipidomics.csv",
    format = "file"
  ),
  # 1. First step of our pipeline is to read the data
  tar_target(
    name = lipidomics,
    # command = readr::read_csv(here::here("data/lipidomics.csv")) # old version before adding step 0
    command = readr::read_csv(file, show_col_types = FALSE)
    # Since added step 0 refer to the file name defined in that step instead
  ),
  # 2. The next step of our pipeline is to use our descriptive statistics function
  tar_target(
    name = df_stats_by_metabolite,
    command = descriptive_stats(lipidomics) # Note that the name "lipidomics" here refers to the name
    # created in the previous step of the pipeline and not the name used in the function in learning.qmd
  ),
  # 3. Add histograms to pipeline
  tar_target(
    name = fig_metabolite_distribution,
    command = plot_distributions(lipidomics)
  ),
  # Add a new pipeline step
  tar_quarto(
      name = quarto_doc,
      path = "doc/learning.qmd"
  )
)


# Set this value so the Spark Master is accessible from the Spark Workers.
# Apparently this allows spark to listen to the correct interface and makes it visble outside of the local host
# This file is picked up automatically when spark starts
SPARK_MASTER_HOST=$(hostname -I)

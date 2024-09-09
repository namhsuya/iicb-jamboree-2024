#!/bin/bash

# Check if number of arguments is only 2
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <query>"
    exit 1
fi

# Assign input arguments to variables
query=$1
outdir=$(echo "$query" | sed 's/ /_/g')

# Create the output directory if it not present
if [ ! -d "$outdir" ]; then
    echo "Creating output directory: $outdir"
    mkdir -p "$outdir"
fi

# Check if the query starts with GCF_ or GCA_
if [[ "$query" == GCF_* || "$query" == GCA_* ]]; then
    echo "Executing esearch pipeline for query: $query"

    # Run the esearch, elink, efetch, and xtract commands and store the result
    result=$(esearch -db assembly -query "$query" | elink -target biosample | efetch -format docsum | xtract -pattern DocumentSummary -element Accession)

    if [ -n "$result" ]; then

        # If result is non-empty, execute the second command and store output in temp.csv
        echo "Fetching SRA data for accession(s): $result"
        esearch -db sra -query "$result" | efetch -format runinfo | cut -d',' -f1 > "$outdir/temp.csv"
        echo "SRA run info saved to $outdir/temp.csv"

        # Check if temp.csv is not empty
        if [ -s "$outdir/temp.csv" ]; then
            echo "Processing temp.csv for fasterq-dump"

            # Loop through each line of temp.csv and execute fasterq-dump
            while IFS=, read -r run_id; do
                echo "Dumping data for Run ID: $run_id"
                fasterq-dump "$run_id" -q -O "$outdir"
            done < <(tail -n +2 "$outdir/temp.csv")

            echo "Data fetching completed."
        else
            echo "temp.csv is empty. No data to process."
        fi
    else
        echo "No accession found for query: $query"
    fi
else
    # Directly execute the command if the query does not start with GCF_ or GCA_
    echo "Executing esearch directly for query: $query"

    # Directly fetch SRA data for the query and store in temp.csv
    esearch -db sra -query "$query" | efetch -format runinfo | cut -d',' -f1 > "$outdir/temp.csv"
    echo "SRA run info saved to $outdir/temp.csv"

    # Check if temp.csv is not empty
    if [ -s "$outdir/temp.csv" ]; then
        echo "Processing temp.csv for fasterq-dump"

        # Loop through each line of temp.csv and execute fasterq-dump
        while IFS=, read -r run_id; do
            echo "Dumping data for Run ID: $run_id"
            fasterq-dump "$run_id" -q -O "$outdir"
        done < <(tail -n +2 "$outdir/temp.csv")

        echo "Data fetching completed."
    else
        echo "temp.csv is empty. No data to process."
    fi
fi

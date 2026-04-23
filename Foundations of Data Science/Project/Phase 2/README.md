# Phase 2 Pipeline Execution Report

This document describes each script in the Phase 2 folder, how they fit together, how to run them, and what outputs to expect.
---

## 1. import_to_db.py  

Purpose:  
Read the cleaned CSV (`Loan Prediction.csv`), split it into four logical tables (`applicants`, `assets`, `locations`, `finances`), and write them into dataset.db via SQLAlchemy.

What happens:  
- The script reads `../Loan Prediction.csv` into a DataFrame.  
- It renames and selects columns, drops duplicate IDs, and writes each table with `to_sql(..., if_exists="replace")`.  
- On success you’ll see:
  ```
  Successfully normalized and loaded
  ```
- Check dataset.db now contains four tables.

---

## 2. database_connection.py  

Purpose:  
Provide a single `get_connection()` function that opens a SQLite connection to dataset.db with row‐factory enabled.

Behavior:  
- When imported or run directly, it prints:
  ```
  Connected to <sqlite3.Connection object at ...>
  ```

Usage:  
Other scripts import `get_connection` to execute SQL queries or read tables.

---

## 3. load_data.py  

Purpose:  
Load each normalized table from SQLite, pickle it for downstream steps, and execute a set of meaningful SQL queries for reporting.

What happens:  
1. For each table in `["applicants","assets","locations","finances"]`, the script:  
   - Calls `get_connection()`, runs `SELECT *`, closes the connection.  
   - Saves the DataFrame to `./database/{table}.pkl`.  
   - Prints `Loaded {table}: (rows, cols)`.  
2. Re‐opens a connection and runs five queries:  
   - Defaulters vs Non-defaulters  
   - Average income by house ownership  
   - Default rate by profession  
   - Top 5 cities by number of defaults  
   - Average experience by default flag  
   Each query prints its title and result DataFrame.

---

## 4. preprocess.py  

Purpose:  
Merge `applicants.pkl` and `finances.pkl` on `applicant_id`, lowercase all column names, impute missing numeric values with the median, standard-scale the numeric columns, and pickle the result as `preprocessed.pkl`.

What happens:  
- Loads `applicants.pkl` and `finances.pkl` from database.  
- Merges on `applicant_id`.  
- Renames columns to lowercase so that `Age` → `age`, etc.  
- Fills missing values in `age`, `experience`, `income` with the column medians.  
- Scales those three columns to zero mean/unit variance.  
- Pickles the processed DataFrame to preprocessed.pkl.  

---

## 5. feature_engineering.py  

Purpose:  
Load `preprocessed.pkl`, `assets.pkl`, and `locations.pkl`; merge them on `applicant_id`; create new features (`JobStability`, `AgeExpRatio`, `OwnBoth`); one-hot encode `profession`; and pickle the final table.

What happens:  
- Loads `preprocessed.pkl`, `assets.pkl`, and `locations.pkl`.  
- Merges all three DataFrames on `applicant_id`.  
- Calculates:
  - `JobStability = current_job_yrs / experience`
  - `AgeExpRatio = experience / age`
  - `OwnBoth = 1 if house_ownership == "owned" AND car_ownership == "yes"`
- Applies one-hot encoding to `profession`, dropping the first category.  
- Pickles the result to feature_engineered.pkl. 

---

## 6. pipeline.py 

Purpose:  
Tie together the data‐loading, preprocessing, and feature‐engineering scripts into a single automated run.

What happens:  
- For each script in `["scripts/load_data.py","scripts/preprocess.py","scripts/feature_engineering.py"]`, it prints `Running {script}` and executes it with `python3`.  

---

## Verification & Next Steps

After running pipeline.py, the directory database contains:

- `applicants.pkl`, `assets.pkl`, `locations.pkl`, `finances.pkl`  
- `preprocessed.pkl`  
- `feature_engineered.pkl`
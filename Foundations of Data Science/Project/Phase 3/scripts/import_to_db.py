import os
import pandas as pd
from sqlalchemy import create_engine

df = pd.read_csv("../Loan Prediction.csv")
engine = create_engine(f"sqlite:///./database/dataset.db", echo=False)

app_df = df[[
    "Id","Age","Experience",
    "CURRENT_JOB_YRS","CURRENT_HOUSE_YRS",
    "Married/Single","Profession"
]].rename(columns={
    "Id": "applicant_id",
    "CURRENT_JOB_YRS": "current_job_yrs",
    "CURRENT_HOUSE_YRS": "current_house_yrs",
    "Married/Single": "married_single"
})
app_df.drop_duplicates(subset=["applicant_id"], inplace=True)
app_df.to_sql("applicants", engine, if_exists="replace", index=False)

assets_df = df[[
    "Id","House_Ownership","Car_Ownership"
]].rename(columns={
    "Id": "applicant_id",
    "House_Ownership": "house_ownership",
    "Car_Ownership": "car_ownership"
})
assets_df.drop_duplicates(subset=["applicant_id"], inplace=True)
assets_df.to_sql("assets", engine, if_exists="replace", index=False)

loc_df = df[[
    "Id","CITY","STATE"
]].rename(columns={
    "Id": "applicant_id",
    "CITY": "city",
    "STATE": "state"
})
loc_df.drop_duplicates(subset=["applicant_id"], inplace=True)
loc_df.to_sql("locations", engine, if_exists="replace", index=False)

fin_df = df[[
    "Id","Income","Risk_Flag"
]].rename(columns={
    "Id": "applicant_id",
    "Income": "income",
    "Risk_Flag": "risk_flag"
})
fin_df.drop_duplicates(subset=["applicant_id"], inplace=True)
fin_df.to_sql("finances", engine, if_exists="replace", index=False)

print("Successfully normalized and loaded")
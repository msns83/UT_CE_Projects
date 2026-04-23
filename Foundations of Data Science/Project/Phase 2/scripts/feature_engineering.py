import pandas as pd
import numpy as np

def engineer(df: pd.DataFrame) -> pd.DataFrame:
    df["JobStability"] = df["current_job_yrs"] / df["experience"].replace(0, np.nan)
    df["AgeExpRatio"] = df["experience"] / df["age"]
    df["OwnBoth"] = ((df["house_ownership"] == "owned") & (df["car_ownership"] == "yes")).astype(int)

    df = pd.get_dummies(df, columns=["profession"], drop_first=True)
    return df

df_pre = pd.read_pickle("./database/preprocessed.pkl")

df_assets = pd.read_pickle("./database/assets.pkl")
df_loc    = pd.read_pickle("./database/locations.pkl")

df = df_pre.merge(df_assets, on="applicant_id") \
.merge(df_loc, on="applicant_id")

df_fe = engineer(df)

df_fe.to_pickle("./database/feature_engineered.pkl")

print("Feature engineering done:", df_fe.shape)
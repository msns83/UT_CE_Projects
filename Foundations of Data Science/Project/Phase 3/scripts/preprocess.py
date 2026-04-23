import pandas as pd
from sklearn.impute import SimpleImputer
from sklearn.preprocessing import StandardScaler

def preprocess(df):
    num_cols = ["age", "experience", "income"]
    imputer = SimpleImputer(strategy="median")
    df[num_cols] = imputer.fit_transform(df[num_cols])
    scaler = StandardScaler()
    df[num_cols] = scaler.fit_transform(df[num_cols])
    return df

df_app = pd.read_pickle("./database/applicants.pkl")
df_fin = pd.read_pickle("./database/finances.pkl")

df = df_app.merge(df_fin, on="applicant_id")
df.columns = [col.lower() for col in df.columns]

df_proc = preprocess(df)
df_proc.to_pickle("./database/preprocessed.pkl")

print("Preprocessing done:", df_proc.shape)
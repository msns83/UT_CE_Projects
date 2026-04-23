import pandas as pd
import joblib
import sqlite3
from database_connection import get_connection
from sklearn.metrics import accuracy_score
from tensorflow.keras.models import load_model


def load_data_for_prediction():
    df = pd.read_pickle("./database/feature_engineered.pkl")
    return df


def preprocess_data(df):
    target_column = 'risk_flag'
    X = df.drop(columns=[target_column, 'applicant_id'])
    categorical_cols = ['married_single', 'house_ownership', 'car_ownership', 'city', 'state']
    X = pd.get_dummies(X, columns=categorical_cols, drop_first=True)
    X.columns = X.columns.str.replace(r"[\[\]<>]", "", regex=True)
    return X


def save_predictions_to_db(df_preds):
    conn = get_connection()
    df_preds.to_sql('predictions', conn, if_exists='replace', index=False)
    conn.close()


def main():
    print("Loading data for prediction...")
    df = load_data_for_prediction()
    y_true = df['risk_flag']

    print("Preprocessing data...")
    X = preprocess_data(df)

    print("Loading Random Forest model...")
    rf_model = joblib.load("./trained_models/random_forest.pkl")
    print("Predicting with Random Forest...")
    rf_preds = rf_model.predict(X)
    rf_acc = accuracy_score(y_true, rf_preds)
    print(f"Random Forest accuracy: {rf_acc:.4f}")

    print("Loading Neural Network model...")
    nn_model = load_model("./trained_models/nn_model.h5")
    print("Predicting with Neural Network...")
    nn_probs = nn_model.predict(X, verbose=0)
    nn_preds = (nn_probs > 0.5).astype(int).flatten()
    nn_acc = accuracy_score(y_true, nn_preds)
    print(f"Neural Network accuracy: {nn_acc:.4f}")

    if rf_acc >= nn_acc:
        best_name = "Random Forest"
        best_preds = rf_preds
    else:
        best_name = "Neural Network"
        best_preds = nn_preds

    print(f"Saving predictions from best model: {best_name}")
    df_out = pd.DataFrame({
        'applicant_id': df['applicant_id'],
        'prediction': best_preds
    })
    save_predictions_to_db(df_out)

    print("Verifying saved predictions...")
    conn = sqlite3.connect('./database/dataset.db')
    df_check = pd.read_sql_query('SELECT * FROM predictions LIMIT 100', conn)
    print(df_check)
    conn.close()


if __name__ == "__main__":
    main()